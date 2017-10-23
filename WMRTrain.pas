unit WMRTrain;

interface

{$INCLUDE WMR.inc}

uses
  Windows, Messages, SysUtils, Types, Variants, Classes, Graphics, Controls,
  Forms, Utils_FileIni, Dialogs, StdCtrls, ComCtrls, ExtCtrls, Utils_Str,
  Utils_Misc, Utils_Files, Utils_Date, Utils_KAndM, OoMisc, AdPort, Math,
  ToolWin, DB, DateUtils, OleServer, ADODB, WMRAdd, Utils_Log;

type
  TfrmTrain = class(TForm)
    DataList: TListView;
    PanelTop: TPanel;
    StatusBar: TStatusBar;
    PanelBottom: TPanel;
    eDate: TLabeledEdit;
    eIssue: TLabeledEdit;
    eScoop: TLabeledEdit;
    eTareBefore: TLabeledEdit;
    ComPort: TApdComPort;
    eTareAfter: TLabeledEdit;
    eGross: TLabeledEdit;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    tbtnAdd: TToolButton;
    tbtnDelete: TToolButton;
    tbtnSeparatorEnd: TToolButton;
    tbtnClose: TToolButton;
    tbtnStop: TToolButton;
    tbtnTaresLoad: TToolButton;
    tbtnTaresSave: TToolButton;
    tbtnSeparator01: TToolButton;
    cboxReceiver: TComboBox;
    lblReceiver: TLabel;
    cboxBake: TComboBox;
    lblBake: TLabel;
    gbAll: TGroupBox;
    eAllGross: TLabeledEdit;
    eAllTareBefore: TLabeledEdit;
    eAllTareAfter: TLabeledEdit;
    eAllLosses: TLabeledEdit;
    eAllNetto: TLabeledEdit;
    eAllClean: TLabeledEdit;
    gbSpeed: TGroupBox;
    eSpeed: TEdit;
    cboxVanType: TComboBox;
    lblVanType: TLabel;
    cboxCargoType: TComboBox;
    lblCargoType: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DataListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure eBakeChange(Sender: TObject);
    procedure eBakeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComPortTriggerAvail(CP: TObject; Count: Word);
    procedure ComPortTriggerData(CP: TObject; TriggerHandle: Word);
    procedure tbtnDeleteClick(Sender: TObject);
    procedure tbtnTaresLoadClick(Sender: TObject);
    procedure eTareBeforeExit(Sender: TObject);
    procedure DataListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbtnAddClick(Sender: TObject);
    procedure tbtnCloseClick(Sender: TObject);
    procedure tbtnStopClick(Sender: TObject);
    procedure eSpeedChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eBakeKeyPress(Sender: TObject; var Key: Char);
    procedure DataListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure StatusBarResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eTareBeforeKeyPress(Sender: TObject; var Key: Char);
  private
    SelfChange,
    DataChanged: Boolean;
    State: TTrainState;

    DataTrigger: Word;
    DataString: AnsiString;

    ScalesIndex: SmallInt;
    TrainIndex:  LongWord;

    autoDirection, autoPosition, autoLoco: Boolean;
    VanAxisCount: Integer;

    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;

    procedure ExtractNumber(S: AnsiString; var Value, Count: String);
    procedure AddData(Data: AnsiString);
    procedure DeleteLocoData;
    procedure UpdateCountData(ACount: String);

    function  SetDataItem(AIndex: Integer; ADateTime: TDateTime; ABake, AIssue,
      AVanNum, AVanType, ACargoType, AGross, ATareBefore, ATareAfter,
      AReceiver: String; ASend: TSend): TListItem;
    function  GetDataItemSend(AIndex: Integer): Boolean;

    function  ChangeState(NewState: TTrainState): Boolean;

    function  CalcSpeed: Double;

    procedure UpdateItems(AItem: Integer);
    procedure UpdateEdits;

    function  CalcTotal(What: Integer): String;
    procedure UpdateTotal;
    procedure UpdateSpeed;

    procedure UpdateUserName(AUserName: String);

    function  CheckVanNums: Boolean;
    function  SaveData:   Boolean;
    function  LoadData(AConnectionType: TConnectionType): Boolean;
    procedure SaveLoadTares(DoSave: Boolean);

    function  LoadIssue(ABake: String): String;
  public
  end;

function ShowAutoWeight: Boolean;
function ShowManualWeight: Boolean;
function ShowVescomWeight: Boolean;
function ShowVescomEdit(ATrainIndex: LongWord): Boolean;
function ShowEdit(AScalesIndex: SmallInt; ATrainIndex: LongWord;
  AConnectionType: TConnectionType): Boolean;

implementation

uses WMRMain, WMRStrings, WMRLogin, WMRProgress, WMRWeightParams, WMRTaresLoad, WMRVescom;

{$R *.dfm}

const
  SI_NUMBER      = -1;
  SI_TIME        = 0;
  SI_BAKE        = 1;
  SI_ISSUE       = 2;
  SI_VANNUM      = 3;
  SI_GROSS       = 4;
  SI_TAREBEF     = 5;
  SI_TAREAFT     = 6;
  SI_LOSSES      = 7;
  SI_NETTO       = 8;
  SI_CLEAN       = 9;
  SI_VANTYPE     = 10;
  SI_CARGOTYPE   = 11;
  SI_RECEIVER    = 12;
  SI_SEND        = 13;
  SI_DATETIME    = 14;
  SI_MAXINDEX    = 15;

function ShowForm(ATrainState: TTrainState; AScalesIndex: SmallInt;
  ATrainIndex: LongWord; AConnectionType: TConnectionType; AautoDirection,
  AautoPosition, AautoLoco: Boolean): Boolean;
var
  S: String;
begin
  case ATrainState of
  tsManual: S := 'manual';
  tsAuto: begin
    S := 'auto ';
    if AautoDirection then S := S + '>>>>'  else S := S + '<<<<';
    S := S + ', loco ';
    if AautoLoco      then S := S + '4' else S := S + '6';
    S := S + ' ';
    if AautoPosition  then S := S + 'first' else S := S + 'last';
  end;
  tsEditData: S := 'edit';
  tsVescom:   S := 'vescom';
  end;
  WriteToLogForm(True, rsLOGFormTrain + SPACE + S);

  with TfrmTrain.Create(Application) do
    try // finally
      autoDirection := AautoDirection;
      autoPosition := AautoPosition;
      autoLoco := AautoLoco;

      cboxBake.Items := Bakes;
      cboxBake.Items.Insert(0, rsNo);
      cboxVanType.Items := VanTypes;
      cboxVanType.Items.Insert(0, rsUnknownReceiver);
      cboxCargoType.Items := CargoTypes;
      cboxCargoType.Items.Insert(0, rsUnknownReceiver);
      cboxReceiver.Items := Receivers;
      cboxReceiver.Items.Insert(0, rsUnknownReceiver);

      if AScalesIndex = 0 then ScalesIndex := Settings.Scales
                          else ScalesIndex := AScalesIndex;
      TrainIndex := ATrainIndex;

      State := tsEditData;
      Result := ChangeState(ATrainState);
      if not Result then Exit;

      case ATrainState of
      tsManual, tsAuto: begin
        eDate.Text := DateToStr(Date);
        UpdateUserName(CurrentUserName);
        DataChanged := False;
      end;
      tsEditData: begin
        Result := LoadData(AConnectionType);
      end;
      tsVescom: begin
        Result := LoadData(ctVescom);
        TrainIndex := 0;
        if Result then ChangeState(tsEditData);
      end;
      end;
      if Result then Result := ShowModal = mrOk;
      if Result then Result := DataChanged;
    finally
      WriteToLogForm(False, rsLOGFormTrain);
      Free;
    end;
end;

function ShowManualWeight: Boolean;
begin
  Result := ShowForm(tsManual, 0, 0, ctServer, True, True, True);
end;

function ShowAutoWeight: Boolean;
var
  S: String;
  autoDirection, autoPosition, autoLoco: Boolean;
begin
  Result := False;
  WriteToLogForm(True, rsLOGFormAuto);
  with TfrmWeightParams.Create(Application) do
    try
      Result := ShowModal = mrOk;
      if Result then
        begin
          autoDirection := CheckedFirst(rgDirection);
          autoPosition := CheckedFirst(rgPosition);
          autoLoco := CheckedFirst(rgLoco);
        end
      else
        begin
          autoDirection := True;
          autoPosition := True;
          autoLoco := True;
        end;
    finally
      if Result then S := '' else S := SPACE + rsLOGCancel;
      WriteToLogForm(False, rsLOGFormAuto + S);
      Free;
    end;
  if Result then
    Result := ShowForm(tsAuto, 0, 0, ctServer,
      autoDirection, autoPosition, autoLoco);
end;

function ShowVescomEdit(ATrainIndex: LongWord): Boolean;
begin
  Result := ShowForm(tsVescom, 0, ATrainIndex, ctServer, True, True, True);
end;

function ShowVescomWeight: Boolean;
var
  Inst: HINST;
  ATrainIndex: Integer;
  FileName, S: String;
begin
  ATrainIndex := 0;
  Result := EXEIsRunning(rsVescomDynModule, False);
  if not Result then
    begin
      WriteToLog(rsLOGVescomRunModule);
      FileName := SlashSep(Settings.VescomPath, rsVescomLoadModule);
      Inst := ShellExecEx(FileName, '');
      Result := Inst > 32;
      if not Result then
        begin
          if Inst = ERROR_FILE_NOT_FOUND then
            S := Format(rsErrorVescomNotExists, [FileName])
          else
            S := SysErrorMessage(GetLastError);
          MsgBoxErr(S);
          WriteToLog(rsLOGError + S);
        end;
    end;

  if Result then
    begin
      WriteToLogForm(True, rsLOGFormVescom);
      with TfrmVescom.Create(Application) do
        try
          Result := ShowModal = mrOk;
          ATrainIndex := TrainIndex;
        finally
          if Result then S := '' else S := SPACE + rsLOGCancel;
          WriteToLogForm(False, rsLOGFormVescom + S);
          Free;
        end;
    end;
  if Result then
    begin
//      Delay(5000);
      Result := ShowVescomEdit(ATrainIndex);
    end;
end;

function ShowEdit(AScalesIndex: SmallInt; ATrainIndex: LongWord; AConnectionType: TConnectionType): Boolean;
begin
  Result := ShowForm(tsEditData, AScalesIndex, ATrainIndex, AConnectionType, True, True, True)
end;

procedure TfrmTrain.FormCreate(Sender: TObject);
var
  i, ColCount: Integer;
  S1, S2: String;
begin
  ToolBar.Images := Main.ImageList32;

  SetSaverActive(False);

  DataTrigger := 0;
  DataString := '';

  ActiveControl := eScoop;
  cboxBake.Tag := SI_BAKE;
  eIssue.Tag := SI_ISSUE;
  eScoop.Tag := SI_VANNUM;
  eGross.Tag := SI_GROSS;
  eTareBefore.Tag := SI_TAREBEF;
  eTareAfter.Tag := SI_TAREAFT;
  cboxVanType.Tag := SI_VANTYPE;
  cboxCargoType.Tag := SI_CARGOTYPE;
  cboxReceiver.Tag := SI_RECEIVER;

  tbtnAdd.Visible := IsAdministrator;

  SetEditReadOnly(eDate, not IsAdministrator);
  SetEditReadOnly(eSpeed, not IsAdministrator);

  ColCount := DataList.Columns.Count - 1;
  if IsAdministrator then
    begin
      with DataList.Columns.Add do
        begin
          Caption := 'DATETIME';
          Width := 180;
        end;
      Inc(ColCount);
    end;

  DataListSelectItem(Self, nil, False);
  with CreateINIFile do
    try
      S1 := ReadString(Name, 'Columns', '');
      if S1 <> '' then
        try
          for i := 0 to ColCount do
            begin
              SplitStr(S1, COMMA, 0, S2, S1);
              DataList.Columns[i].Width := SToI(S2);
            end;
        except
        end;
      ReadFormBounds(Self);
    finally
      Free;
    end;
end;

procedure TfrmTrain.FormDestroy(Sender: TObject);
var
  i, ColCount: Integer;
  S: String;
begin
  SetSaverActive(True);

  ColCount := DataList.Columns.Count - 1;
  if IsAdministrator then Dec(ColCount);

  with CreateINIFile do
    try
      WriteFormBounds(Self);
      S := '';
      for i := 0 to ColCount do
        S := ConcatStrings(S, IToS(DataList.Columns[i].Width), COMMA);
      WriteString(Name, 'Columns', S);
    finally
      Free;
    end;
end;

procedure TfrmTrain.UpdateCountData(ACount: String);
begin
  try
    StatusBar.Panels[2].Text := IToS(999 - SToI(ACount));
  except
    StatusBar.Panels[2].Text := rsError;
  end;
  StatusBar.Panels[2].Text := rsCountData + StatusBar.Panels[2].Text;
end;

function FormatComString(ComString: AnsiString): AnsiString;
var
  i: Integer;
begin
  if ComString = '' then Result := 'empty'
  else
    begin
      Result := '';
      for i := 1 to Length(ComString) do
        case ComString[i] of
        #0..#31: Result := Result + '#' + AnsiString(IToS(Ord(ComString[i])));
        ' ':     Result := Result + '+';
        else
          Result := Result + ComString[i];
        end;
    end;
end;

procedure TfrmTrain.ComPortTriggerAvail(CP: TObject; Count: Word);
var
  i: Word;
  S, RS: AnsiString;
begin
  S := '';
  try
    for i := 1 to Count do S := S + ComPort.GetChar;
  except
    DataString := '';
    Exit;
  end;
  DataString := DataString + S;
end;

procedure TfrmTrain.ComPortTriggerData(CP: TObject; TriggerHandle: Word);
var
  SplitData: AnsiString;
begin
  if TriggerHandle = DataTrigger then
    begin
      WriteToLog(FormatComString(DataString));

      DataString := TrimLeft(DataString); // #17#17

      if (Length(DataString) <= 44) then AddData(DataString)
      else
        begin
          WriteToLog(rsLogSplit);

          SplitData := Copy(DataString, 1, 44);
          WriteToLog(FormatComString(SplitData));

          AddData(SplitData);

          SplitData := Copy(DataString, 45, MaxInt);
          SplitData := TrimLeft(SplitData); // #0#0#0#0
          WriteToLog(FormatComString(SplitData));

          AddData(SplitData);
        end;

      DataString := '';

      ComPort.FlushInBuffer;
    end;
end;

procedure TfrmTrain.ExtractNumber(S: AnsiString; var Value, Count: String);
// Format: '2004,!!9,!10!!!49:19!#13#10!004,!!!!!!!!0,00!t!!'
begin
  Value := FmtStrFloatAsStr(StringReplace(Trim(String(Copy(S, 29, 12))), '.',
    FormatSettings.DecimalSeparator, []));
  Count := String(Copy(S, 25, 3));
end;

procedure TfrmTrain.AddData(Data: AnsiString);
var
  AddOK: Boolean;
  AGross, ACount: String;
begin
  ExtractNumber(Data, AGross, ACount);

  WriteToLog(rsLogGross + AGross);

  if not IsNumber(AGross, False, True) then Exit;

  UpdateCountData(ACount);

  if State = tsAuto then
    begin
      with Settings do
        begin
          if autoDirection then
            begin
              if autoPosition then
                begin
                  AddOK := (VanAxisCount >= AxisOneVan + LocoWheels[autoLoco] +
                    VanProtect) and
                    ((VanAxisCount - LocoWheels[autoLoco]) mod AxisOneVan = 0);
                end
              else
                begin
                  AddOK := (VanAxisCount - AxisOneVan) mod AxisOneVan = 0;
                end;
            end
          else
            begin
              if autoPosition then
                begin
                  AddOK := (VanAxisCount >= LocoWheels[autoLoco] + VanProtect + 1) and
                    ((VanAxisCount - LocoWheels[autoLoco] - VanProtect - 1) mod AxisOneVan = 0);
                end
              else
                begin
                  AddOK := (VanAxisCount - 1) mod AxisOneVan = 0;
                end;
            end;
          Inc(VanAxisCount);
        end; // with Settings do
    end // if State = tsAuto
  else
    AddOK := True;
  if not AddOK then Exit;

  WriteToLog(rsLogAddGross);

  DataList.Selected := nil;
  SelectListItem(SetDataItem(-1, Now, '', '',
    Settings.VanNumDef, '', '', AGross, '', '', '', sdNo), True);
  UpdateTotal;
  UpdateSpeed;
end;

procedure TfrmTrain.DeleteLocoData;
var
  i, DelCount: Integer;
begin
  if (State = tsAuto) and (not autoPosition) and (DataList.Items.Count > 0) then
    begin
      case Settings.AxisOneVan of
      2: begin
        if autoLoco then DelCount := 2 else DelCount := 3;
        case Settings.VanProtect of
        4: Inc(DelCount, 2);
        end;
      end;
      4: begin
        if (not autoDirection) and (not autoLoco) then DelCount := 2
                                                  else DelCount := 1;
        case Settings.VanProtect of
        4: Inc(DelCount, 1);
        end;
      end;
      else
        DelCount := 0;
      end;
      DataList.Items.BeginUpdate;
      for i := 1 to DelCount do
        DataList.Items[DataList.Items.Count - 1].Delete;
      DataList.Items.EndUpdate;
      UpdateTotal;
    end;
end;

function TfrmTrain.SetDataItem(AIndex: Integer; ADateTime: TDateTime;
  ABake, AIssue, AVanNum, AVanType, ACargoType, AGross,
  ATareBefore, ATareAfter, AReceiver: String; ASend: TSend): TListItem;
begin
  DataChanged := True;
  if AIndex < 0 then
    begin
      Result := DataList.Items.Add;
      AddSubItemsToListItem(Result, SI_MAXINDEX);
    end
  else
    Result := DataList.Items[AIndex];

  with Result do
    begin
      Caption := IToS(Index + 1);
      if ATareBefore = '' then ATareBefore := '0';
      if ATareAfter  = '' then ATareAfter := '0';
      if ADateTime   <> 0 then
        begin
          SubItems[SI_TIME] := TimeToStr(ADateTime);
          SubItems[SI_DATETIME] := DTToSQLStr(ADateTime);
        end;
      if ABake       <> #0 then SubItems[SI_BAKE] := ABake;
      if AIssue      <> #0 then SubItems[SI_ISSUE] := AIssue;
      if AVanNum     <> #0 then SubItems[SI_VANNUM] := AVanNum;
      if AGross      <> #0 then SubItems[SI_GROSS] := AGross;
      if ATareBefore <> #0 then SubItems[SI_TAREBEF] := ATareBefore;
      if ATareAfter  <> #0 then SubItems[SI_TAREAFT] := ATareAfter;
      if (AGross <> #0) or (ATareBefore <> #0) or (ATareAfter <> #0) then
        begin
          SubItems[SI_LOSSES] := CalcDiff(SubItems[SI_TAREBEF], SubItems[SI_TAREAFT]);
          SubItems[SI_NETTO] := CalcDiff(SubItems[SI_GROSS], SubItems[SI_TAREBEF]);
          SubItems[SI_CLEAN] := CalcDiff(SubItems[SI_GROSS], SubItems[SI_TAREAFT]);
        end;
      if AVanType   <> #0 then SubItems[SI_VANTYPE] := AVanType;
      if ACargoType <> #0 then SubItems[SI_CARGOTYPE] := ACargoType;
      if AReceiver  <> #0 then SubItems[SI_RECEIVER] := AReceiver;
      case ASend of
      sdUnknown,
      sdNo:  SubItems[SI_SEND] := rsSendNo;
      sdYes: SubItems[SI_SEND] := rsSendYes;
      end;
    end;
end;

function TfrmTrain.GetDataItemSend(AIndex: Integer): Boolean;
begin
  Result := DataList.Items[AIndex].SubItems[SI_SEND] = rsSendYes;
end;

procedure TfrmTrain.UpdateTotal;
begin                                             
  eAllGross.Text :=      CalcTotal(SI_GROSS);
  eAllTareBefore.Text := CalcTotal(SI_TAREBEF);
  eAllTareAfter.Text :=  CalcTotal(SI_TAREAFT);
  eAllLosses.Text :=     CalcTotal(SI_LOSSES);
  eAllNetto.Text :=      CalcTotal(SI_NETTO);
  eAllClean.Text :=      CalcTotal(SI_CLEAN);
end;

procedure TfrmTrain.UpdateUserName(AUserName: String);
begin
  StatusBar.Panels[0].Text := rsUserName + AUserName;
end;

function TfrmTrain.ChangeState(NewState: TTrainState): Boolean;
var
  S: String;
begin
  Result := True;

  {$IFNDEF NOCOMPORT}
  try
    if NewState in [tsManual, tsAuto] then
      begin
        ComPort.ComNumber := Settings.ComNumber;
        ComPort.Open := True;
        if DataTrigger = 0 then
          DataTrigger := ComPort.AddDataTrigger(#13#10#13#10, True);
      end
    else
      ComPort.Open := False;
  except
    S := Format(rsErrorOpenPort, [Settings.ComNumber]);
    WriteToLog('ERROR: ' + S);
    MsgBoxErr(S);
    Result := False;
  end;
  {$ENDIF}

  DeleteLocoData;
  VanAxisCount := 1;

  State := NewState;

  case State of
  tsManual: HelpContext := IDH_MANUAL;
  tsAuto:   HelpContext := IDH_AUTO;
  tsVescom: HelpContext := IDH_VESCOM;
  else      HelpContext := IDH_EDIT;
  end;

  tbtnStop.Visible := State in [tsManual, tsAuto];

  tbtnTaresLoad.Visible := (State = tsEditData) and
    (Settings.CanEdit or IsAdministrator);
  tbtnTaresSave.Visible := tbtnTaresLoad.Visible;

  if IsAdministrator then
    begin
      tbtnAdd.Visible := tbtnTaresLoad.Visible;
    end;
  tbtnDelete.Visible := (State = tsEditData) and
    (Settings.CanDelete or IsAdministrator);
  tbtnSeparator01.Visible := tbtnTaresLoad.Visible;
  tbtnSeparatorEnd.Visible := tbtnStop.Visible or tbtnAdd.Visible or tbtnDelete.Visible;

  case State of
  tsManual: Caption := rsStateManual;
  tsAuto: begin
    if autoDirection then S := rsStateLtR else S := rsStateRtL;
    Caption := rsStateAuto + ', ' + S;
  end;
  tsEditData: if Settings.CanEdit then Caption := rsStateEdit
                                  else Caption := rsStateView;
  end;
  UpdateEdits;
end;

function TfrmTrain.CheckVanNums: Boolean;
var
  i, NoVanNum: Integer;
begin
  NoVanNum := 0;
  Result := True;
  for i := 0 to DataList.Items.Count - 1 do
    begin
      Result := DataList.Items[i].SubItems[SI_VANNUM] <> '';

      if Result then
        Result := FindSubItemByText(DataList, SI_VANNUM,
          DataList.Items[i].SubItems[SI_VANNUM], i) = -1;
      if not Result then
        begin
          NoVanNum := i;
          Break;
        end;
    end;
  if not Result then
    begin
      DataList.Selected := nil;
      DataList.Items[NoVanNum].Selected := True;
      eScoop.SetFocus;
      ErrorSaveLoad(acSave, rsErrorSLVans, rsErrorCheckVanNums, False);
    end;
end;

function TfrmTrain.SaveData: Boolean;
  function PerformDeleteData(AConnectionType: TConnectionType): Boolean;
  var
    ATableName, AWhere: String;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    with Main.Query  do
      try // except
        case AConnectionType of
        ctServer: begin
          ATableName := rsTableServerVans;
          AWhere := WhereTrainAndScalesIndex(TrainIndex, ScalesIndex);
        end;
        ctLocal: begin
          ATableName := rsTableLocalVans;
          AWhere := WhereTrainIndex(TrainIndex);
        end;
        end;

        SQLExec(SQLDelete(ATableName, AWhere));
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acSave, rsErrorSLVans, E.Message);
          end;
      end;
  end;

  function PerformSaveData(AConnectionType: TConnectionType): Boolean;
  var
    i: Integer;
    ASpeed: Double;
    ATableName, AFields, AValues: String;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    if TrainIndex = 0 then
      TrainIndex := DTToWTime(SQLStrToDT(DataList.Items[0].SubItems[SI_DATETIME]));

    case AConnectionType of
    ctServer: begin
      ATableName := rsTableServerVans;
      AFields := rsSQLServerVansSave;
    end;
    ctLocal: begin
      ATableName := rsTableLocalVans;
      AFields := rsSQLLocalVans;
    end;
    end;

    with DataList, Settings do
      try // except
        frmProgress.MaxProgress(Items.Count, True);

        for i := 0 to Items.Count - 1 do
          with Items[i] do
            begin
              ASpeed := SToF(eSpeed.Text);
              if not autoDirection then ASpeed := -ASpeed;
              case AConnectionType of
              ctServer: begin
                AValues := SQLFormatValues([
                  TrainIndex, // Системный номер поезда
                  ScalesIndex, // № весов
                  i + 1, // № вагона пп
                  DTToWTimeStr(
                    SQLStrToDT(
                      SubItems[SI_DATETIME])), // Системное время начала взвешивания
                  SubItems[SI_DATETIME], // Дата и время начала взвешивания
                  // Дата и время конца взвешивания, utime
                  SubItems[SI_VANNUM], // № вагона
                  SubItems[SI_VANTYPE], // Род вагона
                  // Грузоподъемность, норма загрузки, объем
                  SToF(SubItems[SI_TAREBEF]), // Тара (тара ДО)
                  // Тара по трафарету, динамическая, статическая
                  // Индекс тары
                  // № весов, где была записана (взвешена)
                  // Дата, время начала взвешивания используемой тары
                  SToF(SubItems[SI_GROSS]), // Брутто
                  // Брутто на ближний и дальний борт, на первую и вторую тележку
                  // Служебная масса
                  SToF(SubItems[SI_NETTO]), // Нетто
                  // Перегруз
                  ASpeed, // Скорость
                  // Ускорение
                  SubItems[SI_CARGOTYPE], // Род груза
                  // Код рода груза
                  AxisOneVan, // Число осей
                  // Принадлежность
                  CurrentUserName, // Оператор
                  // Таб. номер, № смены, литер смены
                  // Температуры рельсов
                  // Станция отправления, код станции отправления
                  // Станция назначения,  код станции назначения
                  // Дата отправки
                  SubItems[SI_ISSUE],           // № накладной        (№ выпуска)
                  SubItems[SI_BAKE],            // Грузоотправитель   (№ ковша)
                  SubItems[SI_RECEIVER],        // Грузополучатель    (получатель)
                  SToF(SubItems[SI_CLEAN]),     // Нетто по накладной (чистый вес)
                  SToF(SubItems[SI_TAREAFT]),   // Тара по накладной  (тара ПОСЛЕ)
                  SToF(SubItems[SI_LOSSES])     // Перегруз по накладной
                  // Номер группы вагонов, место погрузки
                  // Статус
                  ]);
              end;
              ctLocal: begin
                AValues := SQLFormatValues([
                  // Системный индекс вагона
                  TrainIndex,                   // Системный номер поезда
                  i + 1,                        // № вагона пп
                  DTToWTimeStr(
                    SQLStrToDT(
                      SubItems[SI_DATETIME])),  // Системное время начала взвешивания
                  Double(
                    SQLStrToDT(
                      SubItems[SI_DATETIME])),  // Дата и время начала взвешивания
                  SubItems[SI_BAKE],            // № ковша
                  SubItems[SI_ISSUE],           // № выпуска
                  SubItems[SI_VANNUM],          // № вагона
                  SubItems[SI_VANTYPE],         // Род вагона
                  SubItems[SI_CARGOTYPE],       // Род груза
                  SToF(SubItems[SI_GROSS]),     // Брутто
                  SToF(SubItems[SI_TAREBEF]),   // Тара ДО
                  SToF(SubItems[SI_TAREAFT]),   // Тара ПОСЛЕ
                  SubItems[SI_RECEIVER],        // Получатель
                  ASpeed,                       // Скорость
                  CurrentUserName,              // Оператор
                  GetDataItemSend(i)            // Сохранено на сервере
                  ]);
              end;
              end;

//              MsgBox(SQLInsert(ATableName, AFields, AValues), 64, '', frmProgress.Handle);
              SQLExec(SQLInsert(ATableName, AFields, AValues));
//              'ins van ' + SubItems[SI_VANNUM] + ' br ' + SubItems[SI_GROSS], AConnectionServer);

              if AConnectionType = ctServer then
                SetDataItem(i, 0, #0, #0, #0, #0, #0, #0, #0, #0, #0, sdYes);

              frmProgress.StepProgress;
            end; // with Items[i] do
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acSave, rsErrorSLVans, E.Message);
          end;
      end;
  end;

  function PerformSaveIssues(AConnectionType: TConnectionType): Boolean;
  var
    i, ABakeIndex: Integer;
    ABakeIssues: TStrings;
    ATableName, AFields, ABake, AIssue, ASQLSave: String;
  begin
    Result := True;

    ABakeIssues := TStringList.Create;
    try // finally
      with DataList do
        for i := 0 to Items.Count - 1 do
          begin
            ABake := Items[i].SubItems[SI_BAKE];
            AIssue := Items[i].SubItems[SI_ISSUE];
            if (ABake <> '') and (AIssue <> '') then
              try
                ABakeIndex := ABakeIssues.IndexOfName(ABake);
                if ABakeIndex <> -1 then
                  begin
                    if SToI(ABakeIssues.Values[ABake]) < SToI(AIssue) then
                      ABakeIssues.Values[ABake] := AIssue;
                  end
                else
                  begin
                    ABakeIssues.Add(ABake + '=' + AIssue);
                  end;
              except
              end;
          end;

//      MsgBox(ABakeIssues.Text, 64, '', frmProgress.Handle);

      SelectConnection(AConnectionType);

      ATableName := rsTableIssues;
      AFields := rsSQLIssues;
      frmProgress.MaxProgress(ABakeIssues.Count, True);

      try // except
        for i := 0 to ABakeIssues.Count - 1 do
          begin
            ABake := ABakeIssues.Names[i];
            AIssue := ABakeIssues.ValueFromIndex[i];
            if SQLLocateIndex(ATableName, [rsBakeIndex], [ABake]) then
              ASQLSave := SQLUpdate(ATableName, [rsIssueName], [AIssue],
                SQLNameEqualValue(rsBakeIndex, ABake))
            else
              ASQLSave := SQLInsert(ATableName, AFields,
                SQLFormatValues([ABake, AIssue]));

//            MsgBox(ASQLSave, 64, '', frmProgress.Handle); Continue;
            SQLExec(ASQLSave);

            frmProgress.StepProgress;
          end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acSave, rsErrorSLIssues, E.Message);
          end;
      end;
    finally
      ABakeIssues.Free;
    end;
  end;
var
  i: Integer;
  DoSaveIssues: Boolean;
  FirstTick: LongWord;
begin
  frmProgress.ConnectionType := ctLocal;
  Result := CheckVanNums;
  if not Result then Exit;

  StartTimer(FirstTick);

  frmProgress.Show;
  try
    Result := OpenConnections;
    WriteToLog(rsLOGTrainSave1 + GetTimerCount(FirstTick)); ProcMess;

    if not Result then Exit;
    frmProgress.ProgressCaption := rsProgressTrainSave;

    if Settings.AvitekUse then
      begin
        for i := 0 to DataList.Items.Count - 1 do
          SetDataItem(i, 0, #0, #0, #0, #0, #0, #0, #0, #0, #0, sdNo);
      end;

    if TrainIndex <> 0 then
      begin
        if CanServer and Settings.MySQLBruttoSave then
          Result := PerformDeleteData(ctServer) else Result := True;
        if Result then Result := PerformDeleteData(ctLocal);
        if not Result then Exit;
        WriteToLog(rsLOGTrainSave2 + GetTimerCount(FirstTick));
      end;

    if DataList.Items.Count = 0 then Exit;

    DoSaveIssues := TrainIndex = 0;

    if CanServer and Settings.MySQLBruttoSave then PerformSaveData(ctServer);
    Result := PerformSaveData(ctLocal);

    frmProgress.ProgressCaption := rsProgressIssueSave;
    if DoSaveIssues then
      begin
        PerformSaveIssues(ctLocal);
        if CanServer and Settings.MySQLIssueSave then PerformSaveIssues(ctServer);
      end;
    frmProgress.ProgressCaption := rsProgressTrainSave;
  finally
    if Settings.AvitekUse then Main.AvitekNewData;
    frmProgress.Hide;
    WriteToLog(rsLOGTrainSave + ' (' + IToS(DataList.Items.Count) +')' + GetTimerCount(FirstTick));
  end;
end;

function TfrmTrain.LoadData(AConnectionType: TConnectionType): Boolean;
var
  VescomTrainIndex, VanCount: Integer;
  VescomDTWeight, VescomVanDT: TDateTime;
  AWhere: String;

  function PerformLoadTrainFromVescom: Boolean;
  begin
    Result := True;
    SelectConnection(ctVescom);
    with Main.Query do
      try // except
        if TrainIndex <> 0 then
          AWhere := SQLNameEqualValue(rsVescomTrainIndex, TrainIndex) else AWhere := '';
        SetQuerySQL(SQLSelect(rsTableVescomTrains, rsSQLVescomTrain, AWhere) +
          SQLOrderBy(['DTWeigh'], [True]));
//        MsgBox(SQL[0]); Result := False; Exit;

        SQLOpen(ctVescom);
        try
          if RecordCount <> 0 then
            begin
              VescomTrainIndex := Fields[0].AsInteger;
              VescomDTWeight := Fields[1].AsDateTime;
              autoDirection := Fields[2].AsBoolean;
            end;
//        MsgBox(IToS(VescomTrainIndex) + sLineBreak + DTToSQLStr(VescomDTWeight) + sLineBreak + BoolToS(autoDirection));
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

  function PerformDeleteTrainFromVescom: Boolean;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    with Main.Query do
      try // except
        try
//        MsgBox(SQLDelete(rsTableVescomTrains, SQLNameEqualValue(rsVescomTrainIndex, VescomTrainIndex))); Exit;
          SQLExec(SQLDelete(rsTableVescomTrains, SQLNameEqualValue(rsVescomTrainIndex, VescomTrainIndex)));
          SQLExec(SQLDelete(rsTableVescomVans,   SQLNameEqualValue(rsVescomTrainIndex, VescomTrainIndex)));
        finally
          frmProgress.StepProgress;
          Close;
        end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acDelete, rsErrorSLTrain, E.Message);
          end;
      end;
  end;

  function PerformLoadData(AConnectionType: TConnectionType): Boolean;
    procedure ComboBoxAddString(AComboBox: TComboBox; AString: String);
    begin
      if AString <> '' then
        begin
          if AComboBox.Items.IndexOf(AString) = -1 then AComboBox.Items.Add(AString);
        end;
    end;
  var
    i: Integer;
    ATableName, AFields, AWhere, AOrderBy, AVanType, ACargoType, AReceiver: String;
    ASpeed: Double;
    ASend: TSend;
  begin
    SelectConnection(AConnectionType);
    case AConnectionType of
    ctServer: begin
      ATableName := rsTableServerVans;
      AFields := rsSQLServerVansLoad;
      AWhere := WhereTrainAndScalesIndex(TrainIndex, ScalesIndex);
      AOrderBy := SQLOrderBy(['num'], [False]);
    end;
    ctLocal: begin
      ATableName := rsTableLocalVans;
      AFields := rsSQLLocalVans;
      AWhere := WhereTrainIndex(TrainIndex);
      AOrderBy := SQLOrderBy(['num'], [False]);
    end;
    ctVescom: begin
      ATableName := rsTableVescomVans;
      AFields := rsSQLVescomVansLoad;
      AWhere := SQLNameEqualValue(rsVescomTrainIndex, VescomTrainIndex);
      AOrderBy := SQLOrderBy(['CarCode'], [False]);
    end;
    end;
    ASend := sdYes;

    SetQuerySQL(SQLSelect(ATableName, AFields, AWhere) + AOrderBy);

//    MsgBox(Main.Query.SQL[0], 64, '', frmProgress.Handle); Result := False; Exit;

    with Main.Query do
      try // except
        SQLOpen(AConnectionType);
        try // finally
          VanCount := RecordCount;
          Result := VanCount <> 0;
          if not Result then Exit;

          frmProgress.MaxProgress(RecordCount, False);

          case AConnectionType of
          ctLocal, ctServer: begin
            eDate.Text := DateToStr(Fields[3].AsDateTime);  // Дата и время начала взвешивания (BDATETIME)
            ASpeed := Fields[13].AsFloat;                   // Скорость (VELOCITY)
            autoDirection := ASpeed >= 0;
            if not autoDirection then ASpeed := -ASpeed;
            eSpeed.Text := FmtFloat(ASpeed);
            UpdateUserName(Fields[14].AsString);            // Пользователь (OPERATOR)
          end;
          ctVescom: begin
            eDate.Text := DateToStr(VescomDTWeight);
            VescomVanDT := VescomDTWeight;
            ASpeed := Fields[2].AsFloat;
            eSpeed.Text := FmtFloat(ASpeed);
            VanAxisCount := Fields[0].AsInteger;
          end;
          end;

          while not Eof do
            begin
              case AConnectionType of
              ctLocal, ctServer: begin
                if AConnectionType = ctLocal then
                  begin
                    if Fields[15].AsBoolean then ASend := sdYes else ASend := sdNo;
                  end;
                AVanType := Fields[7].AsString;   // Род вагона (VANTYPE)
                ACargoType := Fields[8].AsString; // Род груза (CARGOTYPE)
                AReceiver := Fields[12].AsString; // Получатель (RECEIVER, INVOICE_RECEPIENT)
                SetDataItem(-1,
                  Fields[3].AsDateTime,         // Дата и время начала взвешивания (BDATETIME)
                  Fields[4].AsString,           // Номер печи (BAKE, INVOICE_SUPPLIER)
                  Fields[5].AsString,           // Номер выпуска (ISSUE, INVOICE_NUM)
                  Fields[6].AsString,           // Номер вагона (VANNUM)
                  AVanType,
                  ACargoType,
                  FmtFloat(Fields[9].AsFloat),  // Брутто (BRUTTO)
                  FmtFloat(Fields[10].AsFloat), // Тара ДО (TAREBEFORE, TARE)
                  FmtFloat(Fields[11].AsFloat), // Тара ПОСЛЕ (TAREAFTER, INVOICE_TARE)
                  AReceiver,
                  ASend);                       // Сохранено на сервере (SEND, всегда)

                ComboBoxAddString(cboxVanType,   AVanType);
                ComboBoxAddString(cboxCargoType, ACargoType);
                ComboBoxAddString(cboxReceiver,  AReceiver);
              end;
              ctVescom: begin
                SetDataItem(-1,
                  VescomVanDT,
                  '', '',
                  Settings.VanNumDef,
                  '', '',
                  FmtFloat(Fields[1].AsFloat),
                  '', '', '', sdNo);
              end;
              end;
              if frmProgress.StepProgress then Break;
              Next;
            end; // while not Eof do
          finally
            if AConnectionType = ctVescom then
              begin
                VescomVanDT := IncSecond(VescomVanDT, -(DataList.Items.Count * 10));
                for i := 0 to DataList.Items.Count - 2 do
                  begin
                    VescomVanDT := IncSecond(VescomVanDT, 10);
                    SetDataItem(i, VescomVanDT, #0, #0, #0, #0, #0, #0, #0,
                      #0, #0, sdUnknown);
                  end;
              end;
            Close;
          end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acLoad, rsErrorSLVans, E.Message);
          end;
      end;
  end;
var
  SLog: String;
  FirstTick: LongWord;
begin
  StartTimer(FirstTick);
  frmProgress.Show;
  DataList.Items.BeginUpdate;
  try // finally
    Result := OpenConnections;
    if not Result then Exit;

    frmProgress.ProgressCaption := rsProgressTrainLoad;
    case AConnectionType of
    ctVescom: begin
      Result := PerformLoadTrainFromVescom;
      if Result then PerformLoadData(ctVescom);
      Result := PerformDeleteTrainFromVescom;
      if Result then DataChanged := True;
    end;
    else begin
      Result := PerformLoadData(AConnectionType);
      if Result and (CanServer or Settings.AvitekUse) then
        DataChanged := not GetDataItemSend(0)
      else DataChanged := False;
    end;
    end;
  finally
    Result := VanCount <> 0;
    case AConnectionType of
    ctVescom: SLog := rsLOGTrainLoadVescom + IToS(VescomTrainIndex);
    else      SLog := rsLOGTrainLoad;
  end;
  if not Result then
    begin
      SLog := rsLOGError + SLog;
      ShowMsgBox(rsNoRecords);
    end;
  DataList.Items.EndUpdate;
  UpdateTotal;
  frmProgress.Hide;
  WriteToLog(SLog + Format(rsLOGTrainLoadCount, [VanCount]) + GetTimerCount(FirstTick));
  end;
end;

procedure TfrmTrain.DataListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  tbtnDelete.Enabled := DataList.SelCount <> 0;
  UpdateEdits;
  UpdateTotal;
end;

procedure TfrmTrain.UpdateEdits;
var
  AReadOnly: Boolean;
begin
  if SelfChange then Exit;
  SelfChange := True;
  try
    AReadOnly := DataList.SelCount = 0;
    if AReadOnly then
      begin
        cboxBake.ItemIndex := 0;
        eIssue.Text := '';
        eScoop.Text := '';
        eGross.Text := '0';
        eTareBefore.Text := '0';
        eTareAfter.Text := '0';
        cboxVanType.ItemIndex := 0;
        cboxCargoType.ItemIndex := 0;
        cboxReceiver.ItemIndex := 0;
      end
    else
      begin
        with DataList.Selected do
          begin
            if SubItems[SI_BAKE] = '' then cboxBake.ItemIndex := 0
            else ComboBoxSelect(cboxBake, SubItems[SI_BAKE]);
            eIssue.Text := SubItems[SI_ISSUE];
            eScoop.Text := SubItems[SI_VANNUM];
            eGross.Text := SubItems[SI_GROSS];
            eTareBefore.Text := SubItems[SI_TAREBEF];
            eTareAfter.Text := SubItems[SI_TAREAFT];
            if SubItems[SI_VANTYPE]   = '' then cboxVanType.ItemIndex := 0
            else ComboBoxSelect(cboxVanType,  SubItems[SI_VANTYPE]);
            if SubItems[SI_CARGOTYPE] = '' then cboxCargoType.ItemIndex := 0
            else ComboBoxSelect(cboxCargoType, SubItems[SI_CARGOTYPE]);
            if SubItems[SI_RECEIVER]  = '' then cboxReceiver.ItemIndex := 0
            else ComboBoxSelect(cboxReceiver,  SubItems[SI_RECEIVER]);
          end;
        if ActiveControl is TLabeledEdit then
          with ActiveControl as TLabeledEdit do SelStart := MAXINT;
      end;

    if Settings.CanEdit then
      begin
        SetEditReadOnly(eScoop, AReadOnly);
        AReadOnly := AReadOnly or (State in [tsManual, tsAuto]);
      end
    else
      begin
        AReadOnly := True;
        SetEditReadOnly(eScoop, AReadOnly);
      end;
    SetComboBoxReadOnly(cboxBake,       AReadOnly);
    SetEditReadOnly(eIssue,             AReadOnly);
    SetEditReadOnly(eTareBefore,        AReadOnly);
    SetEditReadOnly(eTareAfter,         AReadOnly);
    SetComboBoxReadOnly(cboxVanType,    AReadOnly);
    SetComboBoxReadOnly(cboxCargoType,  AReadOnly);
    SetComboBoxReadOnly(cboxReceiver,   AReadOnly);

    if not IsAdministrator then AReadOnly := True;
    SetEditReadOnly(eGross, AReadOnly);
  finally
    SelfChange := False;
  end;
end;

procedure TfrmTrain.eBakeChange(Sender: TObject);
begin
  UpdateItems(TWinControl(Sender).Tag);
end;

procedure TfrmTrain.eBakeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;

  procedure UnselectAll;
  var
    Item: TListItem;
  begin
    with DataList do
      begin
        Item := Selected;
        while Assigned(Item) do
          begin
            Item.Selected := False;
            Item := GetNextItem(Item, sdAll, [isSelected]);
          end;
      end;
  end;
begin
  if (Shift = []) and (Key in [VK_UP, VK_DOWN]) then
    with DataList do
      begin
        if Items.Count = 0 then Exit;
        if SelfChange then Exit;
        SelfChange := True;
        try
          if Selected <> nil then
            begin
              Index := Selected.Index;
              UnselectAll;
            end
          else
          Index := TopItem.Index;
        finally
          SelfChange := False;
        end;
        case Key of
        VK_UP:   if Index > 0 then Selected := Items[Index - 1] else Selected := TopItem;
        VK_DOWN: if Index < Items.Count - 1 then Selected := Items[Index + 1] else Selected := Items[Items.Count - 1];
        end;
        ItemFocused := Selected;
        Key := 0;
        ActiveControl := Sender as TLabeledEdit;
      end;
end;

procedure TfrmTrain.eTareBeforeExit(Sender: TObject);
begin
  if TLabeledEdit(Sender).Text = '' then TLabeledEdit(Sender).Text := '0';
end;

procedure TfrmTrain.tbtnAddClick(Sender: TObject);
  function AddRandomData: TListItem;
  var
    ABake, AIssue, AVanNum, AGross, ATareBefore,
    ATareAfter, AVanType, ACargoType, AReceiver: String;
  begin
    ABake := cboxBake.Items[Random(cboxBake.Items.Count - 1) + 1];
    AIssue := IToS(Random(9999) + 1);
    AVanNum := IToS(Random(999999) + 1);
    AGross := FmtFloat((Random(10000) + 10) / 100);
    ATareBefore := FmtFloat(Random(5000) / 100);
    ATareAfter := FmtFloat(Random(5000) / 100);
    AVanType := cboxVanType.Items[Random(cboxVanType.Items.Count - 1) + 1];
    ACargoType := cboxCargoType.Items[Random(cboxCargoType.Items.Count - 1) + 1];
    AReceiver := cboxReceiver.Items[Random(cboxReceiver.Items.Count - 1) + 1];
    Result := SetDataItem(-1, Now, ABake, AIssue, AVanNum, AVanType, ACargoType,
    AGross, ATareBefore, ATareAfter, AReceiver, sdNo);
  end;
var
  ListItem: TListItem;
begin
  if IsShift and IsAdministrator then
    begin
      Randomize;
      ListItem := AddRandomData
    end
  else
    ListItem := SetDataItem(-1, Now, '', '', Settings.VanNumDef, '', '',
      '0', '', '', '', sdNo);
  SelectListItem(ListItem, True);
  UpdateTotal;
end;

procedure TfrmTrain.tbtnDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  if not MsgBoxYesNo(Format(rsQuestionDelete, [rsErrorSLVans])) then Exit;
  for i := DataList.Items.Count - 1 downto 0 do
    if DataList.Items[i].Selected then DataList.Items[i].Delete;
  RethinkNumbers(DataList);
  DataChanged := True;
  UpdateTotal;
end;

procedure TfrmTrain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  S: String;
begin
  if IsAdministrator and IsShift then DataChanged := True;
  if (not DataChanged) or ((TrainIndex = 0) and (DataList.Items.Count = 0)) then
    begin
      ModalResult := mrOk;
      Exit;
    end;
  if State in [tsAuto, tsManual] then ChangeState(tsEditData);
  if TrainIndex = 0 then S := rsQuestionSave1 else S := rsQuestionSave2;
  case MsgBox(S, MB_ICONQUESTION or MB_YESNOCANCEL, '', Handle) of
  ID_YES:     if SaveData then ModalResult := mrOk else CanClose := False;
  ID_CANCEL:  CanClose := False;
  else        CanClose := True;
  end;
end;

procedure TfrmTrain.tbtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTrain.tbtnStopClick(Sender: TObject);
begin
  ChangeState(tsEditData);
end;

procedure TfrmTrain.SaveLoadTares(DoSave: Boolean);
// Тара берётся со всех весовых
var
  S: String;
  InTareBefore: Boolean;
  VanCount: Integer;
  FirstTick: LongWord;

  function CheckSaveLoad: Boolean;
  begin
    Result := DataList.Items.Count > 0;
    if not Result then Exit;

    Result := CheckVanNums;
    if not Result then Exit;

    if DataList.SelCount = 0 then DataList.SelectAll;
    if Result then
      begin
        InTareBefore := TrainIndex <> 0;
        Result := ShowTaresLoad(DoSave, InTareBefore);
      end;
  end;

  function PerformSaveLoadTares(AConnectionType: TConnectionType): Boolean;
  var
    i: Integer;
    ATableName, AFieldsSave, AValues, AWTime, AWhere,
    AWhereVanNum, ASort, ATare: String;
    ProcessAction: TProcessAction;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    case AConnectionType of
    ctServer: begin
      ATableName := rsTableServerTares;
      if DoSave then AFieldsSave := rsSQLServerTaresSave;
      AWTime := DTToWTimeStr(SQLStrToDT(DataList.Items[0].SubItems[SI_DATETIME]));
      ASort := SQLOrderBy(['bdatetime'], [True]) + rsSQLLimitOne;
    end;
    ctLocal: begin
      ATableName := rsTableLocalTares;
      if DoSave then AFieldsSave := rsSQLLocalTaresSave;
      AWhere := '';
      ASort := SQLOrderBy(['bdatetime'], [True]);
    end;
    end;

    with Main.Query, DataList, Settings do
      try // except
        frmProgress.MaxProgress(SelCount, False);
        for i := 0 to Items.Count - 1 do
          with Items[i] do
            begin
              if not Items[i].Selected then Continue;

              if frmProgress.Canceled then Break;

              Inc(VanCount);

              AWhereVanNum := AWhere +
                SQLNameEqualValue(rsVanNumIndex, SubItems[SI_VANNUM]);

              SetQuerySQL(SQLSelect(ATableName, rsSQLTaresLoad,
                AWhereVanNum) + ASort);

//              MsgBox(SQL[0]);

              SQLOpen(AConnectionType);
              try
                if RecordCount <> 0 then ATare := FmtFloat(Fields[0].AsFloat)
                                    else ATare := #0;
              finally
                Close;
              end;

              if DoSave then
                begin
                  SetDataItem(i, 0, #0, #0, #0, #0, #0, #0,
                  (*Tare Before*) ATare,
                  (*Tare After*)  Items[i].SubItems[SI_GROSS], #0, sdUnknown);

                  if ATare <> #0 then
                    begin
                      SQLExec(SQLDelete(ATableName, AWhereVanNum));
//                      MsgBox(SQLDelete(ATableName, AWhereVanNum));
                    end;

                  case AConnectionType of
                  ctServer: begin
                    AValues := SQLFormatValues([
                      ScalesIndex,                // № весов
                      i + 1,                      // № вагона пп
                      AWTime,                     // Системное время начала взвешивания
                      SubItems[SI_DATETIME],      // Дата и время начала взвешивания
                      SubItems[SI_VANNUM],        // № вагона
                      SubItems[SI_VANTYPE],       // Род вагона
                      // Грузоподъемность, норма загрузки, объем
                      SToF(SubItems[SI_TAREAFT]), // Тара
                      // Тары на ближний и дальний борт, на первую и вторую тележку
                      // Служебная масса
                      SToF(eSpeed.Text),          // Скорость
                      // Ускорение
                      AxisOneVan,                 // Число осей
                      // Принадлежность
                      CurrentUserName             // Оператор
                      // Таб. номер, № смены, литер смены
                      // Температуры рельсов
                      // Статус
                      ]);
                  end;
                  ctLocal: begin
                    AValues := SQLFormatValues([
                      // Системный индекс вагона
                      Double(
                        SQLStrToDT(
                          SubItems[SI_DATETIME])),  // Дата и время начала взвешивания
                      SubItems[SI_VANNUM],          // № вагона
                      SToF(SubItems[SI_TAREAFT]),   // Тара
                      SToF(eSpeed.Text),            // Скорость
                      CurrentUserName               // Оператор
                    ]);
                  end;
                  end; // case AConnectionType of

                  SQLExec(SQLInsert(ATableName, AFieldsSave, AValues));
//                  MsgBox(SQLInsert(ATableName, AFieldsSave, AValues));
                end // if DoSave then
              else
                begin
                  if ATare <> #0 then
                    begin
                      if InTareBefore then
                        SetDataItem(i, 0, #0, #0, #0, #0, #0, #0,
                          (*Tare Before*) ATare,
                          (*Tare After*)  #0, #0, sdUnknown)
                      else
                        SetDataItem(i, 0, #0, #0, #0, #0, #0, #0,
                          (*Tare Before*) #0,
                          (*Tare After*)  ATare, #0, sdUnknown);
                    end;
                end;
              frmProgress.StepProgress;
            end; // for i := 0 to Items.Count - 1 do with Items[i] do
      except
        on E: Exception do
          begin
            Result := False;
            if DoSave then ProcessAction := acSave else ProcessAction := acLoad;
            ErrorSaveLoad(ProcessAction, rsErrorSLTares, E.Message);
          end;
      end;
  end;
begin
  if not CheckSaveLoad then Exit;

  VanCount := 0;
  StartTimer(FirstTick);

  frmProgress.Show;
  try
    if not OpenConnections then Exit;

    if DoSave then S := rsProgressTaresSave else S := rsProgressTaresLoad;
    frmProgress.ProgressCaption := S;

    if CanServer and Settings.MySQLTareSave then
      begin
        if not PerformSaveLoadTares(ctServer) then
          PerformSaveLoadTares(ctLocal);
      end
    else
      PerformSaveLoadTares(ctLocal);
  finally
    DataChanged := True;
    UpdateEdits;
    UpdateTotal;
    frmProgress.Hide;
    WriteToLog(rsLOGTareSave + ' (' + IToS(VanCount) + ')' + GetTimerCount(FirstTick));
  end;
end;

procedure TfrmTrain.tbtnTaresLoadClick(Sender: TObject);
begin
  SaveLoadTares(Sender = tbtnTaresSave);
end;

procedure TfrmTrain.eSpeedChange(Sender: TObject);
begin
  DataChanged := True;
end;

function TfrmTrain.CalcSpeed: Double;
var
  S, T: Double;
begin
  if DataList.Items.Count > 1 then
    try
      S := (DataList.Items.Count - 1) * Settings.VanLength;
      T := DTToMSec(StrToTime(
        DataList.Items[DataList.Items.Count - 1].SubItems[SI_TIME]) -
        StrToTime(DataList.Items[0].SubItems[SI_TIME])) / MSecsPerSec;
      Result := (S / T) * 3.6;
    except
      Result := 0;
    end
  else
    Result := 0;
end;

procedure TfrmTrain.UpdateSpeed;
begin
  eSpeed.Text := FmtFloat(CalcSpeed);
end;

procedure TfrmTrain.FormShow(Sender: TObject);
begin
  if IsWinXPOrGreat then Exit;
  if WindowState = wsMaximized then
    begin
      with Screen.WorkAreaRect do
        SetBounds(Left, Top, Right, Bottom);
      WindowState := wsNormal;
      WindowState := wsMaximized;
    end;
end;

procedure TfrmTrain.DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CheckDataListKeyDown(DataList, Key, Shift);
end;

procedure TfrmTrain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_ESCAPE:  tbtnClose.Click;
    end;
end;

function TfrmTrain.CalcTotal(What: Integer): String;
begin
  Result := WMRAdd.CalcTotal(DataList, What, True);
end;

procedure TfrmTrain.eBakeKeyPress(Sender: TObject; var Key: Char);
begin
//   CheckKeyIsNumeral(Key, False, False, []);
end;

procedure TfrmTrain.eTareBeforeKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, True, False, []);
end;

procedure TfrmTrain.DataListCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  Dec(SubItem);
  if SubItem in [SI_NETTO, SI_CLEAN] then
    DataList.Canvas.Font.Style := [fsBold]
  else
    DataList.Canvas.Font.Style := [];
  if Item.Cut then
    DataList.Canvas.Font.Color := clMedGray
  else
    DataList.Canvas.Font.Color := clBlack;
end;

procedure TfrmTrain.StatusBarResize(Sender: TObject);
begin
  with StatusBar do
    Panels[1].Width := ClientWidth - Panels[0].Width - Panels[2].Width;
end;

procedure TfrmTrain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfrmTrain.LoadIssue(ABake: String): String;
begin
  Result := '';
  frmProgress.Show;
  try
    if not OpenConnections then Exit;
    Main.LoadIssue(ABake, Result, nil);
  finally
    frmProgress.Hide;
  end;
end;

procedure TfrmTrain.UpdateItems(AItem: Integer);
var
  i: Integer;
  ABake, AIssue, AVanNum, AGross, ATareBefore, ATareAfter, AVanType, ACargoType, AReceiver: String;
begin
  if DataList.SelCount = 0 then Exit;
  if SelfChange then Exit;
  SelfChange := True;
  DataChanged := True;
  ABake := #0;
  AIssue := #0;
  AVanNum := #0;
  AGross := #0;
  ATareBefore := #0;
  ATareAfter := #0;
  AVanType := #0;
  ACargoType := #0;
  AReceiver := #0;
  try
    case AItem of
    SI_BAKE: begin
      eIssue.Text := '';
      AIssue := '';
      if cboxBake.ItemIndex = 0 then ABake := ''
                                else ABake := Bakes[cboxBake.ItemIndex - 1];
      if Settings.AutoIssue and (ABake <> '') and (TrainIndex = 0) then
        begin
          AIssue := LoadIssue(ABake);
          if AIssue <> '' then
          AIssue := IToS(SToI(AIssue) + 1);
          eIssue.Text := AIssue;
        end;
    end;
    SI_ISSUE: begin
      AIssue := eIssue.Text;
      if not IsNumber(AIssue, False, False) then
        begin
          cboxBake.ItemIndex := 0;
          ABake := '';
        end;
    end;
    SI_VANNUM:    AVanNum := eScoop.Text;
    SI_GROSS:     AGross := eGross.Text;
    SI_TAREBEF:   ATareBefore := eTareBefore.Text;
    SI_TAREAFT:   ATareAfter := eTareAfter.Text;
    SI_VANTYPE:   if cboxVanType.ItemIndex   = 0 then AVanType := ''
                  else AVanType := VanTypes[cboxVanType.ItemIndex - 1];
    SI_CARGOTYPE: if cboxCargoType.ItemIndex = 0 then ACargoType := ''
                  else ACargoType := CargoTypes[cboxCargoType.ItemIndex - 1];
    SI_RECEIVER:  if cboxReceiver.ItemIndex  = 0 then AReceiver := ''
                  else AReceiver := Receivers[cboxReceiver.ItemIndex - 1];
    else Exit;
    end;
    for i := 0 to DataList.Items.Count - 1 do
      if DataList.Items[i].Selected then
        SetDataItem(i, 0, ABake, AIssue, AVanNum, AVanType, ACargoType,
          AGross, ATareBefore, ATareAfter, AReceiver, sdUnknown);
    UpdateTotal;
  finally
    SelfChange := False;
  end;
end;

procedure TfrmTrain.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

end.

