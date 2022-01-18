unit WMRMain;

interface

{$INCLUDE WMR.inc}

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms, ShellAPI,
  DateUtils, Utils_KAndM, Dialogs, StdCtrls, Classes, Utils_Date, Utils_Str,
  Utils_Misc, Utils_Files, Utils_FileIni, Buttons, AboutFrm, ComCtrls, ExtCtrls,
  DB, ADODB, ImgList, OleServer, WMRAdd, Printers, Math,
  Utils_Graf, Menus, Utils_Base64, Utils_Log, HTMLHelpViewer, System.ImageList;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    ImageList32: TImageList;
    ConnectionLocal: TADOConnection;
    ConnectionServer: TADOConnection;
    gbWeight: TGroupBox;
    btnManualWeight: TBitBtn;
    btnAutoWeight: TBitBtn;
    gbBase: TGroupBox;
    btnBaseTares: TBitBtn;
    btnBaseBakeIssue: TBitBtn;
    btnBaseVans: TBitBtn;
    gbUserName: TGroupBox;
    pnlUserName: TPanel;
    btnChangeUser: TBitBtn;
    gbPrograms: TGroupBox;
    btnCalc: TBitBtn;
    gbOther: TGroupBox;
    btnOptions: TBitBtn;
    btnAbout: TBitBtn;
    btnClose: TBitBtn;
    Query: TADOQuery;
    ConnectionVescom: TADOConnection;
    btnHelp: TBitBtn;
    procedure btnCloseClick(Sender: TObject);
    procedure btnBaseVansClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnChangeUserClick(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnAutoWeightClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBaseBakeIssueClick(Sender: TObject);
    procedure btnBaseTaresClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    WM_AVITEK_NEW_WDATA,
    WM_AVITEK_OPEN_WSESSION,
    WM_AVITEK_CLOSE_WSESSION,
    WM_AVITEK_CLOSE_ISERVER: UINT;
    function  PerformOpenDataBase: Boolean;
    procedure AvitekMessage(AMessage: TAvitekMessage);
  public
    function  LoadSettings: Boolean;

    procedure ChangeUser;
    procedure SetWorkMode;
    procedure UpdateStatusBar;

    function  SaveToServer(AWhat: Byte; Values: array of String): Boolean;
    function  SaveScaleInfo: Boolean;
    function  SaveWeightStep(AStep, AMessage: String): Boolean;

    function  LoadIssue(ABake: String; var AIssue: String; AIssues: TStrings = nil): Boolean;
    function  ExistsTrainInVescom: Boolean;

    function  AvitekRun: Boolean;
    procedure AvitekStop;
    procedure AvitekNewData;
  end;

var
  Main: TMain;

implementation

uses WMRTrain, WMRAllTrains, WMRStrings, WMRLogin, WMROptions, WMRProgress, WMRAllLists, WMRTaresLoad;

{$R *.dfm}

procedure TMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.btnHelpClick(Sender: TObject);
begin
  Application.HelpShowTableOfContents;
end;

function TMain.PerformOpenDataBase: Boolean;
begin
  Result := LoadSettings;
  UpdateStatusBar;
  if Result then Result := ShowLogin;
  if Result and Settings.AvitekUse then AvitekRun;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  Application.HelpFile := FileInAppDir(rsHelpFile);
  HelpContext := IDH_MAIN;

  WM_AVITEK_NEW_WDATA      := RegisterWindowMessage('WM_AVITEK_NEW_WDATA');
  WM_AVITEK_OPEN_WSESSION  := RegisterWindowMessage('WM_AVITEK_OPEN_WSESSION');
  WM_AVITEK_CLOSE_WSESSION := RegisterWindowMessage('WM_AVITEK_CLOSE_WSESSION');
  WM_AVITEK_CLOSE_ISERVER  := RegisterWindowMessage('WM_AVITEK_CLOSE_ISERVER');

  WriteToLog(Format(rsLOGStartProgram, [GetFileVersion(Application.ExeName, False)]));

  Query.SQL.Add('');
  StatusBar.Panels[0].Text := Copy(rsCopyright, 1, Pos('|', rsCopyright) - 1);
  Caption := Application.Title + ' ' + GetFileVersion(Application.ExeName);
  {$IFDEF NOCOMPORT}
  Caption := Caption + ' *** Демонстрационный режим. COM-порт отключен.';
  {$ENDIF}

  frmProgress := TfrmProgress.Create(Self);

  with CreateINIFile do
    try
      with VansFilter do
        begin
          Apply := ReadBool(rsFilterTrains, 'Apply', False);
          Dates := TDates(ReadInteger(rsFilterTrains, 'Dates', 0));
          case Dates of
          dtAll:      begin DateFrom := 0; DateTo := 0; end;
          else        begin
            DateFrom := ReadDate(rsFilterTrains, 'DateFrom', StartOfTheDay(Date));
            DateTo :=   ReadDate(rsFilterTrains, 'DateTo',   EndOfTheDay(Date));
          end;
          end;
        end;
      ReadFormPosition(Self);
    finally
      Free;
    end;
  if not PerformOpenDataBase then Left := -1;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  frmProgress.Free;
  if Left <> -1 then
    begin
      with CreateINIFile do
        try
          with VansFilter do
            begin
              WriteBool(rsFilterTrains,     'Apply',    Apply);
              WriteInteger(rsFilterTrains,  'Dates',    Ord(Dates));
              WriteDate(rsFilterTrains,     'DateFrom', DateFrom);
              WriteDate(rsFilterTrains,     'DateTo',   DateTo);
            end;
          WriteFormPosition(Self);
        finally
          Free;
        end;
      if Settings.AvitekUse then AvitekStop;
    end;
  WriteToLog(rsLOGStopProgram);
end;

function  TMain.LoadSettings: Boolean;
var
  i: Integer;
  S1, S2: String;
  SettingsFile: String;
  SettingsList: TStringList;

  function GetSettingsList(var Index: Integer): String;
  begin
    Result := SettingsList[i]; Inc(i);
  end;
begin
  Result := False;
  SettingsFile := ChangeFileExt(Application.ExeName, '.cfg');
  SettingsList := TStringList.Create;
  try // finally
    try // except
      Result := FileExists(SettingsFile);
      if not Result then
        begin
          ErrorSaveLoad(acLoad, rsErrorSLSettings, 
            rsErrorSettingsNotExists + rsErrorCloseApp);
          Exit;
        end;

      SettingsList.LoadFromFile(SettingsFile);
      UsersAndPasswords.Clear;
      Receivers.Clear;
      Bakes.Clear;
      SettingsList.Text := String(Decrypt(AnsiString(SettingsList[0]), CFGKEY));
      if Result then
        Result := SettingsList[SettingsList.Count - 1] = CFGOK;
      if not Result then
        begin
          ErrorSaveLoad(acLoad, rsErrorSLSettings, 
            rsErrorSettingsBad + rsErrorCloseApp);
          Exit;
        end;

      with Settings do
        begin
          i := 0;
          Scales :=        SToI(GetSettingsList(i));
          Place :=         GetSettingsList(i);
          TypeS :=         GetSettingsList(i);
          SClass :=        GetSettingsList(i);
          DClass :=        GetSettingsList(i);
          CanManualAdd :=  SToBool(GetSettingsList(i), '1', '0');
          CanAutoAdd :=    SToBool(GetSettingsList(i), '1', '0');
          CanEdit :=       SToBool(GetSettingsList(i), '1', '0');
          CanDelete :=     SToBool(GetSettingsList(i), '1', '0');
          AutoIssue :=     SToBool(GetSettingsList(i), '1', '0');
          VanLength :=     StrToFloat(GetSettingsList(i));
          VanNumDef :=     GetSettingsList(i);

          ComNumber :=     SToI(GetSettingsList(i));

          Terminal :=      TTerminal(SToI(GetSettingsList(i)));
          VescomPath :=    GetSettingsList(i);

          AxisOneVan :=    SToI(GetSettingsList(i));
          VanProtect :=    SToI(GetSettingsList(i));

          MySQLIP :=      GetSettingsList(i);
          MySQLPort :=    GetSettingsList(i);
          MySQLUser :=    GetSettingsList(i);
          MySQLPass :=    GetSettingsList(i);

          MySQLBruttoSave :=  SToBool(GetSettingsList(i));
          MySQLTareSave :=    SToBool(GetSettingsList(i));
          MySQLIssueSave :=   SToBool(GetSettingsList(i));
          MySQLBruttoAdd :=   GetSettingsList(i);

          AvitekUse :=     SToBool(GetSettingsList(i));
          AvitekPath :=    GetSettingsList(i);
        end;
      while SettingsList[i] <> CFGEndUser do
        begin
          S1 := GetSettingsList(i);
          S2 := GetSettingsList(i);
          UsersAndPasswords.Add(ConcatNameAndValue(S1, S2));
        end;
      Inc(i);
      while SettingsList[i] <> CFGEndRecev do Receivers.Add(GetSettingsList(i));
      Inc(i);
      while SettingsList[i] <> CFGEndBakes do Bakes.Add(GetSettingsList(i));
      Inc(i);
      while SettingsList[i] <> CFGEndVans  do VanTypes.Add(GetSettingsList(i));
      Inc(i);
      while SettingsList[i] <> CFGEndCargo do CargoTypes.Add(GetSettingsList(i));
      Result := True;
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acLoad, rsErrorSLSettings, 
            rsErrorSettingsBad + rsErrorCloseApp);
        end;
    end;
  finally
    SettingsList.Free;
    if not Result then TerminateApplication;
  end;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {$IFNDEF FORCECLOSE}
  CanClose := MsgBoxYesNo(rsQuestionCloseProgram);
  {$ENDIF}
end;

procedure TMain.btnAboutClick(Sender: TObject);
begin
  WriteToLog('ABOUT');
  ShowAbout(13, 2, 1, #0, nil, rsAddComp, #0, #0, rsCopyright,
    rsEULA2 + sLineBreak + rsEULA3 + sLineBreak + rsEULA4);
end;

procedure TMain.ChangeUser;
begin
  pnlUserName.Caption := CurrentUserName;
  WriteToLog('user: ' + CurrentUserName);
  SetWorkMode;
  // SaveWeightStep('1', rsServerChangeUser);
end;

procedure TMain.SetWorkMode;
const
  AboutTops:     array[Boolean] of Integer = (24,  76);
  OtherHeights:  array[Boolean] of Integer = (100, 152);
  BaseTops:      array[Boolean] of Integer = (4,   136);
  FormHeights:   array[Boolean] of Integer = (398, 452);
begin
  with Settings do
    begin
      case Terminal of
      tCAS: begin
        btnManualWeight.Visible := True;
        btnManualWeight.Enabled := CanManualAdd or IsAdministrator;
        btnAutoWeight.Enabled := CanAutoAdd or IsAdministrator;
        btnAutoWeight.Top := 76;
      end;
      tVescom: begin
        btnManualWeight.Visible := False;
        btnManualWeight.Enabled := False;
        btnAutoWeight.Enabled := CanAutoAdd or IsAdministrator;
        btnAutoWeight.Top := 50;
      end;
      end;
      btnOptions.Visible := IsAdministrator;
      gbOther.Height := OtherHeights[IsAdministrator];
      btnAbout.Top := AboutTops[IsAdministrator];
      btnClose.Top := AboutTops[IsAdministrator];
      gbWeight.Visible := btnManualWeight.Enabled or btnAutoWeight.Enabled or 
        IsAdministrator;
      gbBase.Top := BaseTops[gbWeight.Visible];
      ClientHeight := FormHeights[gbWeight.Visible];
      gbOther.Top := ClientHeight - gbOther.Height - 32;
    end;
end;

procedure TMain.btnChangeUserClick(Sender: TObject);
begin
  ShowLogin;
end;

procedure TMain.btnCalcClick(Sender: TObject);
begin
  ShowWaitCursor;
  try
    ShellExec('Calc.exe');
  finally
    RestoreCursor;
  end;
end;

procedure TMain.btnAutoWeightClick(Sender: TObject);
begin
  if Settings.AvitekUse then AvitekRun;
  
  if IsAdministrator and IsShift then
    begin
      ShowManualWeight;
    end
  else
    begin
      if Sender = btnAutoWeight then
        begin
          case Settings.Terminal of
          tCAS:    ShowAutoWeight;
          tVescom: ShowVescomWeight;
          end;
        end
      else
        ShowManualWeight;
    end;
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_F4:   if btnManualWeight.Enabled then btnManualWeight.Click;
    VK_F5:   if btnAutoWeight.Enabled then btnAutoWeight.Click;
    VK_F6:   btnBaseVans.Click;
    VK_F7:   btnBaseTares.Click;
    VK_F10:  btnBaseBakeIssue.Click;
    VK_F12:  btnChangeUser.Click;
    end;
end;

procedure TMain.btnBaseBakeIssueClick(Sender: TObject);
begin
//   msgbox(ConnectionServer.ConnectionString);
  ShowItemsForm(alBakes);
end;

procedure TMain.btnBaseTaresClick(Sender: TObject);
begin
  ShowItemsForm(alTares);
end;

procedure TMain.btnBaseVansClick(Sender: TObject);
begin
  case Settings.Terminal of
  tCAS:    ShowAllVans;
  tVescom: begin
    if ExistsTrainInVescom then
      begin
        if MsgBox(rsQuestionVescomNewTrain, MB_ICONQUESTION or MB_YESNO) = ID_YES then
          ShowVescomEdit(0)
        else
          ShowAllVans;
      end
    else
      ShowAllVans;
  end;
  end;
end;

procedure TMain.btnOptionsClick(Sender: TObject);
begin
  if ShowOptions then
    begin
      if SaveScaleInfo then ChangeUser;
      if Settings.AvitekUse then AvitekRun else AvitekStop;
    end;
end;

function TMain.SaveToServer(AWhat: Byte; Values: array of String): Boolean;
// AWhat: 0 - scalesinfo, 1 - heap_weighstep
var
  ATableName, AFields, AValues, AError, ALog: String;
  FirstTick: LongWord;
begin
  StartTimer(FirstTick);

  frmProgress.Show;
  try // finally
    with Settings do
      try // except
        ALog := '';
        Result := OpenConnections;
        if not Result then Exit;
        if not CanServer then Exit;

        case AWhat of
        0: begin
          frmProgress.ProgressCaption := rsProgressScaleInfoSave;
          ATableName := rsTableServerScalesInfo;
          AFields := rsSQLServerScalesInfo;
          AValues := SQLFormatValues([
            Scales,             // Номер весов
            DTToWTimeStr(Now),  // Системное время начала связи
            DTToSQLStr(Now),    // Дата и время начала связи
                                // Системное время окончания связи
                                // Дата и время окончания связи
                                // Системное время окончания последнего взвешивания
            GetLocalIP,         // ИП-адрес весов
            TypeS,              // Тип весов
            SClass,             // Класс точности в статике
            DClass,             // Класс точности в динамике
            Place,              // Место установки весов
            SCALES_TYPE         // Признак весов с Тарой ДО и ПОСЛЕ (22, 26, Шихт-1, новая разливка)
            ]);
          AError := rsErrorSLScaleInfo;
          ALog := rsLOGScaleInfoSave;
        end;
        1: begin
          frmProgress.ProgressCaption := rsProgressUserNameSave;
          ATableName := rsTableServerWeightStep;
          AFields := rsSQLServerWeightStep;
          AValues := SQLFormatValues([
            0,                        // Порядковый номер шага взвешивания
            Scales,                   // Номер весов
            {TODO: DELETE}
            DTToWTimeStr(Now),        // Системное время перехода к шагу взвешивания
            DTToSQLStr(Now),          // Дата и время перехода к шагу взвешивания
            Values[0],                // Признак шага взвешивания
                                      // Дополнительная информация
            CurrentUserName,          // Оператор
                                      // Табельный номер
                                      // Номер смены
                                      // Литер смены
            DTToSQLStr(UserDateTime), // Дата и время начала смены опреатора
            Values[1]                 // Сообщение о шаге взвешивания
          ]);
          AError := rsErrorSLUserName;
          ALog := rsLOGUserNameSave;
        end;
        else Exit;
        end;

        SelectConnection(ctServer);

        frmProgress.MaxProgress(1, True);

        SQLExec(SQLDelete(ATableName, WhereScalesIndex(Scales)));
//        MsgBox(SQLInsert(ATableName, AFields, AValues)); Exit;
        SQLExec(SQLInsert(ATableName, AFields, AValues));

        frmProgress.StepProgress;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acSave, AError, E.Message);
          end;
      end;
  finally
    frmProgress.Hide;
    if ALog <> '' then WriteToLog(ALog + GetTimerCount(FirstTick));
  end;
end;

function TMain.SaveScaleInfo: Boolean;
begin
  Result := SaveToServer(0, []);
end;

function TMain.SaveWeightStep(AStep, AMessage: String): Boolean;
begin
  Result := SaveToServer(1, [AStep, AMessage]);
end;

function TMain.LoadIssue(ABake: String; var AIssue: String; AIssues: TStrings = nil): Boolean;
// ABake = '' - load all & show error
var
  AWhere: String;
  AConnectionType: TConnectionType;
  FirstTick: LongWord;
begin
  Result := True;

  StartTimer(FirstTick);

  if CanServer and Settings.MySQLIssueSave then AConnectionType := ctServer 
                                           else AConnectionType := ctLocal;
  SelectConnection(AConnectionType);

  frmProgress.ProgressCaption := rsProgressIssueLoad;
  frmProgress.MaxProgress(1, True);
  if ABake <> '' then
    AWhere := SQLNameEqualValue(rsBakeIndex, ABake)
  else
    AWhere := '';

  with Query do
    try // except
      SetQuerySQL(SQLSelect(rsTableIssues, rsSQLIssues, AWhere));
//      MsgBox(SQL[0]); Exit;

      SQLOpen(AConnectionType);
      try
        if ABake <> '' then
          begin
            if RecordCount <> 0 then AIssue := Fields[1].AsString else AIssue := '';
          end
        else
          while not Eof do
            begin
              AIssues.Add(Fields[0].AsString + AIssues.NameValueSeparator +
                Fields[1].AsString);
              Next;
            end;
      finally
        frmProgress.StepProgress;
        WriteToLog(rsLOGIssueLoad + ' (' + IToS(RecordCount) +')' + GetTimerCount(FirstTick));
        Close;
      end;
    except
      on E: Exception do
        begin
          Result := False;
          if ABake = '' then ErrorSaveLoad(acLoad, rsErrorSLIssues, E.Message);
        end;
    end;
end;

procedure TMain.UpdateStatusBar;
begin
  if ConnectionServer.Connected or Settings.AvitekUse then
    StatusBar.Panels[1].Text := ''
  else
    StatusBar.Panels[1].Text := rsServerOFF;
end;

function TMain.ExistsTrainInVescom: Boolean;
var
  FirstTick: LongWord;
begin
  StartTimer(FirstTick);
  Result := OpenConnections;
  if not Result then Exit;

  frmProgress.ProgressCaption := rsProgressTrainLoad;
  frmProgress.MaxProgress(1, False);
  SelectConnection(ctVescom);
  with Query do
    try // except
      SetQuerySQL(SQLSelect(rsTableVescomTrains, rsSQLCount, ''));
//      MsgBox(SQL[0]); Exit;

      SQLOpen(ctVescom);
      try
        Result := RecordCount <> 0;
        if Result then Result := Fields[0].AsInteger <> 0;
      finally
        frmProgress.StepProgress;
        Close;
      end;
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acLoad, rsErrorSLTrain, E.Message);
        end;
    end;
end;

procedure TMain.AvitekMessage(AMessage: TAvitekMessage);
var
  Msg: UINT;
  LogMsg: String;
begin
  Msg := 0;
  case AMessage of
  amNewData:        begin Msg := WM_AVITEK_NEW_WDATA;      LogMsg := rsLOGAvitekNewData;      end;
  amOpenSession:    begin Msg := WM_AVITEK_OPEN_WSESSION;  LogMsg := rsLOGAvitekOpenSession;  end;
  amCloseSession:   begin Msg := WM_AVITEK_CLOSE_WSESSION; LogMsg := rsLOGAvitekCloseSession; end;
  amCloseServer:    begin Msg := WM_AVITEK_CLOSE_ISERVER;  LogMsg := rsLOGAvitekCloseServer;  end;
  end;
  SendMessage(HWND_BROADCAST, Msg, 0, 0);
  WriteToLog(LogMsg);
end;

function TMain.AvitekRun: Boolean;
var
  Handle: HWND;
  Inst: HINST;
  S: String;
begin
  Result := EXEIsRunning(Settings.AvitekPath, True);
  if not Result then
    begin
      WriteToLog(rsLOGAvitekRunModule);
      Inst := ShellExecute(Application.Handle, nil,
        PChar(Settings.AvitekPath), nil, nil, SW_SHOWNORMAL);
      Result := Inst > 32;
      if Result then
        begin
          SetForegroundWindow(Application.Handle);
          AvitekMessage(amOpenSession);
          Handle := FindWindow(PChar('TWServerForm'), nil);
          if Handle <> 0 then
            PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
        end
      else
        begin
          if Inst = ERROR_FILE_NOT_FOUND then
            S := Format(rsErrorAvitekNotExists, [Settings.AvitekPath])
          else
            S := SysErrorMessage(GetLastError);
          MsgBoxErr(S);
          WriteToLog(rsLOGError + S);
        end;
    end;
end;

procedure TMain.AvitekStop;
begin
  if not EXEIsRunning(Settings.AvitekPath, True) then Exit;
  AvitekMessage(amCloseSession);
  Delay(1000);
  AvitekMessage(amCloseServer);
end;

procedure TMain.AvitekNewData;
begin
  if not EXEIsRunning(Settings.AvitekPath, True) then Exit;
  AvitekMessage(amNewData);
end;

end.
