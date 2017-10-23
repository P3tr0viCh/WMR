unit WMRAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Utils_FileIni, Dialogs, ComCtrls, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc,
  Utils_Files, Utils_Date, DateUtils, StrUtils, DB, ADODB, Utils_Log;

const
  IDH_LOGIN  = 10201;
  IDH_MAIN   = 10202;
  IDH_MANUAL = 10203;
  IDH_AUTO   = 10204;
  IDH_VESCOM = 10205;
  IDH_EDIT   = 10206;
  IDH_TARE   = 10207;
  IDH_TRAINS = 10208;
  IDH_TARES  = 10209;
  IDH_BAKES  = 10210;

  IDH_OPTIONS               = 10400;
  IDH_OPTIONS_PROG          = 10401;
  IDH_OPTIONS_SCALES        = 10402;
  IDH_OPTIONS_MYSQL         = 10403;
  IDH_OPTIONS_MYSQL_OPTIONS = 10404;
  IDH_OPTIONS_AVITEK        = 10405;
  IDH_OPTIONS_BAKES         = 10406;
  IDH_OPTIONS_VANTYPES      = 10407;
  IDH_OPTIONS_CARGOTYPES    = 10408;
  IDH_OPTIONS_TERMINALS     = 10409;
  IDH_OPTIONS_VANMODES      = 10410;
  IDH_OPTIONS_USERS         = 10411;
  IDH_OPTIONS_RECEIVERS     = 10412;

  CFGKEY      = 28510;
  SCALES_TYPE = 1981;
  CFGOK       = 'P3tr0viCh777';
  CFGEndUser  = '@EnD@UserS#';
  CFGEndRecev = '@EnD@ReceiverS#';
  CFGEndBakes = '@EnD@BakeS#';
  CFGEndVans  = '@EnD@VanS#';
  CFGEndCargo = '@EnD@CargoS#';

  LocoWheels: array[Boolean] of Integer = (6, 4);
  ColorsRO: array[Boolean] of TColor = (clWindow, clBtnFace);

type
  TListTable        = (alTares, alBakes);
  TEditForm         = (efUsers, efReceivers, efBakes, efVanTypes, efCargoTypes);
  TProcessAction    = (acLoad, acSave, acDelete);
  TSend             = (sdNo, sdUnknown, sdYes);
  TTrainState       = (tsManual, tsAuto, tsEditData, tsVescom);
  TTerminal         = (tCAS, tVescom);
  TConnectionType   = (ctLocal, ctServer, ctVescom);
  TAvitekMessage    = (amNewData, amOpenSession, amCloseSession, amCloseServer);
  TVescomMessage    = (vmGetWindowHandle, vmDynamicStart,
                       vmDynamicStop, vmGetDynamicState);
  TVescomState      = (vsNoModule, vsNoTerminal, vsWaiting,
                       vsWeight, vsWorkingEnd);

  TDates  = (dtAll, dtSelected);
  TFilter = record
    Apply: Boolean;
    DateFrom,
    DateTo: TDateTime;
    Dates: TDates;
  end;

  TSettings = record
    Scales:        SmallInt;    // Номер весов
    Place:         String;      // Место установки
    TypeS:         String;      // Тип весов
    SClass:        String;      // Точность в статике
    DClass:        String;      // Точность в динамике
    CanManualAdd,
    CanAutoAdd,
    CanEdit,
    CanDelete:     Boolean;     // Разрешения для пользователей
    AutoIssue:     Boolean;     // Автоинкремент номера выпуска
    VanLength:     Double;      // Расстояние между осями одного вагона
    VanNumDef:     String;      // Номер вагона по умолчанию

    ComNumber:     Integer;     // Номер порта COM

    Terminal:      TTerminal;   // Тип прибора
    VescomPath:    String;      // Каталог базы данных "Веском"
    AxisOneVan:    Integer;     // Количество осей в одном вагоне
    VanProtect:    Integer;     // Количество осей в тележке прикрытия

    MySQLIP:        String;     // IP сервера MySQL
    MySQLPort:      String;     // Порт сервера MySQL
    MySQLUser:      String;     // Пользователь на сервере
    MySQLPass:      String;     // Пароль пользователя на сервере

    MySQLBruttoSave:  Boolean;  // Сохранять брутто на сервер MySQL
    MySQLTareSave:    Boolean;  // Сохранять и загружать тару с сервера MySQL
    MySQLIssueSave:   Boolean;  // Сохранять и загружать номер выпуска с сервера MySQL
    MySQLBruttoAdd:   String;   // Дополнительно отображать данные со следующих весов

    AvitekUse: Boolean;         // Сохранение на сервер посредством модуля "Авитек"
    AvitekPath: String;         // Расположение модуля "Авитек"
  end;

var
  Settings: TSettings;
  VansFilter: TFilter;
  cFloatFmt: String  = ',0.00';

  UsersAndPasswords,
  Receivers,
  Bakes,
  VanTypes,
  CargoTypes: TStringList;

  CurrentUserName: String;
  IsAdministrator: Boolean;
  UserDateTime: TDateTime;

function  CanServer: Boolean;
function  OpenConnections: Boolean;
procedure SelectConnection(AConnectionType: TConnectionType);

procedure SetQuerySQL(ASQLString: String);

function  GetTimerCount(AFirstTick: LongWord): String;

procedure SQLOpen(AConnectionType: TConnectionType; AProgressDataRead: Boolean = True);
procedure SQLExec(ASQLString: String);
function  SQLFormatValue(AValue: Variant): String;
function  SQLFormatValues(AValues: array of Variant): String;
function  SQLInsert(ATableName, AFields, AValues: String): String;
function  SQLUpdate(ATableName: String; AColumns: array of String; AValues: array of Variant; AWhere: String): String;
function  SQLDelete(ATableName, AWhere: String): String;
function  SQLSelect(ATableName, AWhat, AWhere: String): String;
function  SQLWhere(AWhere: String): String;
function  SQLOrderBy(AOrderBy: array of String; AOrderDesc: array of Boolean): String;
function  SQLLocateIndex(ATableName: String; ANameOfIndex: array of String; AIndex: array of Variant): Boolean;
function  SQLGetNewIndex(ATableName, ANameOfIndex: String): Variant;
function  SQLNameEqualValue(AName: String; AValue: Variant): String;
function  SQLNamesEqualValues(AColumns: array of String; AValues: array of Variant): String;

procedure ClearFilter(var AFilter: TFilter);
function  FilterToSQL(AConnectionType: TConnectionType; ATableName: String): String;

function  WhereScalesIndex(AScales: SmallInt; ATableName: String = ''): String;
function  WhereScalesIndexIn(AScales: String; ATableName: String = ''): String;
function  WhereTrainIndex(ATrainIndex: LongWord; ATableName: String = ''): String;
function  WhereTrainAndScalesIndex(ATrainIndex: LongWord; AScales: SmallInt; ATableName: String = ''): String;

function  DTToSQLStr  (ADateTime: TDateTime): String;
function  SQLStrToDT(ASQLDateTime: String): TDateTime;
function  DTToWTime(ADateTime: TDateTime): Integer;
function  DTToWTimeStr(ADateTime: TDateTime): String;
function  DTToStr     (ADateTime: TDateTime; WithSec: Boolean): String;

procedure TerminateApplication;

procedure ShowMsgBox(AMessage: String);
procedure ErrorSaveLoad(ProcessAction: TProcessAction; AWhat, AError: String; CloseConnections: Boolean = True);

function  FmtFloat(Value: Double): String;
function  SToF(Value: String): Double;
function  FmtStrFloatAsStr(Value: String): String; // TfrmTrain.ExtractNumber

procedure SetEditReadOnly(AEdit: TLabeledEdit; AReadOnly: Boolean); overload;
procedure SetEditReadOnly(AEdit: TEdit; AReadOnly: Boolean); overload;
procedure SetComboBoxReadOnly(AComboBox: TComboBox; AReadOnly: Boolean);
function  CheckedFirst(ARadioGroup: TRadioGroup): Boolean;
procedure CheckDataListKeyDown(DataList: TListView; Key: Word; Shift: TShiftState);

function  CalcTotal(DataList: TListView; What: Integer; OnlySelected: Boolean): String;
function  CalcDiff(X1, X2: String): String;
function  CalcSum(X1, X2: String): String;

implementation

uses WMRStrings, WMRMain, WMRProgress;

function CanConnectServer: Boolean;
begin
  with Settings do
    Result := (MySQLBruttoSave or MySQLTareSave or MySQLIssueSave or
      (MySQLBruttoAdd <> '')) and
      (Scales <> 0) and (MySQLIP <> '');
end;

function CanServer: Boolean;
begin
  Result := CanConnectServer;
  if Result then Result := Main.ConnectionServer.Connected;
  Main.UpdateStatusBar;
end;

function OpenConnections: Boolean;
const
  cLocalPassword = '96Allianc-E35';
var
  LocalDB, VescomDB, sError, sErrorE: String;
begin
  Result := False;
  sError := '';
  try
    frmProgress.ProgressCaption := rsProgressConnection;
    frmProgress.ConnectionType := ctLocal;

    LocalDB := ChangeFileExt(Application.ExeName, '.mdb');
    if not FileExists(LocalDB) then
      begin
        sError := rsErrorLocalNotExists + rsErrorCloseApp;
        Exit;
      end;

    if not Main.ConnectionLocal.Connected then
      begin
        Main.ConnectionLocal.ConnectionString := Format(rsConnectionLocal, [LocalDB, cLocalPassword]);
        try
          Main.ConnectionLocal.Open;
        except
          on E: Exception do sErrorE := E.Message;
        end;
        if not Main.ConnectionLocal.Connected then
          begin
            sError := Format(rsErrorLocalOpen, [sErrorE]) + rsErrorCloseApp;
            Exit;
          end;
      end;

    Result := sError = '';

    if Result and (Settings.Terminal = tVescom) then
      begin
        VescomDB := SlashSep(Settings.VescomPath, rsVescomDataBase);
        if FileExists(VescomDB) then
          begin
            if not Main.ConnectionVescom.Connected then
              begin
                Main.ConnectionVescom.ConnectionString := Format(rsConnectionVescom, [VescomDB]);
                try
                  Main.ConnectionVescom.Open;
                except
                  on E: Exception do sErrorE := E.Message;
                end;
                if not Main.ConnectionVescom.Connected then
                  begin
                    sError := Format(rsErrorVescomOpen, [sErrorE]);
                  end;
              end;
          end
        else
          begin
            sError := Format(rsErrorVescomDBNotExists, [VescomDB]);
          end;
      end;

    Result := sError = '';

    if Result and CanConnectServer then
      begin
        frmProgress.ConnectionType := ctServer;
        if not Main.ConnectionServer.Connected then
          begin
            with Settings do
              Main.ConnectionServer.ConnectionString := Format(rsConnectionServer,
                [MySQLIP, MySQLPort, MySQLUser, MySQLPass]);
            try
              WriteToLog('connect to server');
              Main.ConnectionServer.Open;
            except
              on E: Exception do sErrorE := E.Message;
            end;
            if not Main.ConnectionServer.Connected then
              sError := Format(rsErrorServerNotExists, [sErrorE]);
          end;
      end;
  finally
    if sError <> '' then
      begin
        WriteToLog('ERROR: ' + sError);
        MsgBoxErr(sError);
        if not Main.ConnectionLocal.Connected then TerminateApplication;
      end;
  end;
end;

procedure SelectConnection(AConnectionType: TConnectionType);
var
  ADOConnection: TADOConnection;
begin
  case AConnectionType of
  ctServer:   ADOConnection := Main.ConnectionServer;
  ctLocal:    ADOConnection := Main.ConnectionLocal;
  ctVescom:   ADOConnection := Main.ConnectionVescom;
  else        ADOConnection := nil;
  end;
  Main.Query.Connection := ADOConnection;
  frmProgress.ConnectionType := AConnectionType;
end;

procedure SetQuerySQL(ASQLString: String);
begin
  Main.Query.SQL[0] := ASQLString;
end;

procedure TerminateApplication;
begin
  Main.SetBounds(-1, -1, 0, 0);
  Application.Terminate;
end;

procedure ShowMsgBox(AMessage: String);
var
  MsgHandle: HWND;
begin
  if frmProgress.Visible then MsgHandle := frmProgress.Handle else MsgHandle := 1;
  MsgBox(AMessage, MB_OK or MB_ICONINFORMATION, '', MsgHandle);
end;

procedure ErrorSaveLoad(ProcessAction: TProcessAction; AWhat, AError: String; CloseConnections: Boolean = True);
var
  S, SAction, SDB: String;
  MsgHandle: HWND;
begin
  if CloseConnections then
    begin
      Main.ConnectionLocal.Close;
      Main.ConnectionServer.Close;
      Main.ConnectionVescom.Close;
      CanServer;
    end;
  if frmProgress.Visible then MsgHandle := frmProgress.Handle else MsgHandle := 1;
  case frmProgress.ConnectionType of
  ctLocal:    SDB := rsErrorLocalDB;
  ctServer:   SDB := rsErrorServerDB;
  ctVescom:   SDB := rsErrorVescomDB;
  end;
  case ProcessAction of
  acLoad:     SAction := rsErrorLoad;
  acSave:     SAction := rsErrorSave;
  acDelete:   SAction := rsErrorDelete;
  end;
  S := Format(rsErrorSaveLoad, [Format(SAction, [AWhat, SDB]), AError]);
  WriteToLog(rsLOGError + S);
  MsgBoxErr(S, MsgHandle);
end;

function FmtFloat(Value: Double): String;
begin
  Result := FormatFloat(cFloatFmt, Value);
end;

function  SToF(Value: String): Double;
begin
  if Value = '' then Result := 0 else Result := StrToFloat(Value);
end;

function FmtStrFloatAsStr(Value: String): String;
var
  TempValue: Extended;
begin
  try
    TempValue := StrToFloat(Value);
    Result := FmtFloat(TempValue);
  except
    Result := '';
  end;
end;

procedure ClearFilter(var AFilter: TFilter);
begin
  with AFilter do
    begin
      Apply := False;
      DateFrom := Yesterday;
      DateTo := Today;
      Dates := dtAll;
    end;
end;

function FilterToSQL(AConnectionType: TConnectionType; ATableName: String): String;
var
  sDates, ADateFrom, ADateTo: String;
begin
  Result := '';
  with VansFilter do
    begin
      case Dates of
      dtAll:      sDates := '';
      else
        begin
          DateFrom := StartOfTheDay(DateFrom);
          DateTo := EndOfTheDay(DateTo);
          case AConnectionType of
          ctServer:
            begin
              ADateFrom := SQLFormatValue(DTToSQLStr(DateFrom));
              ADateTo :=   SQLFormatValue(DTToSQLStr(DateTo));
            end;
          ctLocal:
            begin
              ADateFrom := SQLFormatValue(Double(DateFrom));
              ADateTo :=   SQLFormatValue(Double(DateTo));
            end;
          end;
          if DateTo > Now then
            sDates := Format(rsFilterDate1, [ATableName, ADateFrom])
          else
            sDates := Format(rsFilterDate2, [ATableName, ADateFrom, ADateTo]);
        end;
      end; // case Dates of
      Result := sDates;
    end;
end;

function  SQLFormatValue(AValue: Variant): String;
begin
  Result := VarToStr(AValue);
  case VarType(AValue) of
  varUString,
  varString:
    Result := AddQuotes(
      StringReplace(StringReplace(StringReplace(Result, '\',  '\\',  [rfReplaceAll]),
        '"',  '\"',  [rfReplaceAll]),
        '''', '\''', [rfReplaceAll]));
  varDouble:  Result := StringReplace(Result, COMMA, DOT, []);
  end;
end;

function  SQLFormatValues(AValues: array of Variant): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(AValues) to High(AValues) do
    Result := ConcatStrings(Result, SQLFormatValue(AValues[i]), ', ');
end;

function  SQLInsert(ATableName, AFields, AValues: String): String;
begin
  Result := Format(rsSQLInsert, [ATableName, AFields, AValues]);
end;

function  SQLUpdate(ATableName: String; AColumns: array of String; AValues: array of Variant; AWhere: String): String;
begin
  Result := Format(rsSQLUpdate, [ATableName, SQLNamesEqualValues(AColumns, AValues), AWhere]);
end;

function  SQLWhere(AWhere: String): String;
begin
  Result := rsSQLWhere + AWhere;
end;

function  SQLDelete(ATableName, AWhere: String): String;
begin
  Result := Format(rsSQLDelete, [ATableName]) + SQLWhere(AWhere);
end;

function  SQLSelect(ATableName, AWhat, AWhere: String): String;
begin
  Result := Format(rsSQLSelect, [AWhat, ATableName]);
  if AWhere <> '' then Result := Result + SQLWhere(AWhere);
end;

function  SQLNameEqualValue(AName: String; AValue: Variant): String;
begin
  Result := Format(rsNameEqualValue, [AName, SQLFormatValue(AValue)]);
end;

function  SQLNamesEqualValues(AColumns: array of String; AValues: array of Variant): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(AColumns) to High(AColumns) do
    Result := ConcatStrings(Result, SQLNameEqualValue(AColumns[i], AValues[i]), ', ');
end;

function  SQLLocateIndex(ATableName: String; ANameOfIndex: array of String; AIndex: array of Variant): Boolean;
var
  i: Integer;
  ANamesOfIndex, AIndexes: String;
begin
  for i := Low(ANameOfIndex) to High(ANameOfIndex) do
    begin
      ANamesOfIndex := ConcatStrings(ANamesOfIndex, ANameOfIndex[i], COMMA);
      AIndexes := ConcatStrings(AIndexes, SQLNameEqualValue(ANameOfIndex[i], AIndex[i]), rsFilterAnd);
    end;
  SetQuerySQL(SQLSelect(ATableName, ANamesOfIndex, AIndexes));
//   MsgBox(Main.Query.SQL[0]);
  SQLOpen(ctLocal);
  try
    Result := Main.Query.RecordCount <> 0;
  finally
    Main.Query.Close;
  end;
end;

function  SQLGetNewIndex(ATableName, ANameOfIndex: String): Variant;
begin
  Randomize;
  repeat
    Result := Random(MAXLONG - 1) + 1;
  until not SQLLocateIndex(ATableName, ANameOfIndex, Result);
end;

function  SQLOrderBy(AOrderBy: array of String; AOrderDesc: array of Boolean): String;
var
  i: Integer;
  S: String;
begin
  for i := Low(AOrderBy) to High(AOrderBy) do
    begin
      S := AOrderBy[i];
      if i in [Low(AOrderDesc)..High(AOrderDesc)] then
        begin
          if AOrderDesc[i] then S := S + rsSQLOrderDesc;
        end;
      Result := ConcatStrings(Result, S, ', ');
    end;
  Result := rsSQLOrder + Result;
end;

type
  TSQLOpenThread = class(TThread)
  protected
    FErrorMessage: String;
    FQuery: TADOQuery;
    procedure Execute; override;
  public
    constructor Create(AQuery: TADOQuery);
  end;

constructor TSQLOpenThread.Create(AQuery: TADOQuery);
begin
  FQuery := AQuery;
  FreeOnTerminate := False;
  inherited Create(True);
end;

procedure TSQLOpenThread.Execute;
begin
  try
    try
      FQuery.Open;
    except
      on E: Exception do
        begin
          FErrorMessage := E.Message;
        end;
    end;
  finally
    Terminate;
  end;
end;

function GetLOGOpenExecServer(AOpen, AServer: Boolean): String;
begin
  Result := 'SQL ';
  if AOpen then Result := Result + 'OPEN' else Result := Result + 'EXEC';
  Result := Result + ' (';
  if AServer then Result := Result + 'server' else Result := Result + 'local';
  Result := Result + '): ';
end;

function GetTimerCount(AFirstTick: LongWord): String;
begin
  Result := ' (' + MyFormatTime(ExtractHMSFromMS(GetTickCount - AFirstTick), True) + ')';
end;

procedure SQLOpen(AConnectionType: TConnectionType; AProgressDataRead: Boolean = True);
var
//   FirstTick: LongWord;
  ErrorMessage: String;
begin
//   StartTimer(FirstTick);
  ErrorMessage := '';
  if AProgressDataRead then frmProgress.ProgressDataRead := True;
  with TSQLOpenThread.Create(Main.Query) do
    try
      ShowWaitCursor;
      {$WARNINGS OFF}
      Resume;
      {$WARNINGS ON}
      while not Terminated do ProcMess;
    finally
      ErrorMessage := FErrorMessage;
      Free;
      {         if ALOGString <> '' then
      WriteToLog(GetLOGOpenExecServer(True, AServer) + ALOGString + GetTimerCount(FirstTick));}
      if AProgressDataRead then frmProgress.ProgressDataRead := False;
      RestoreCursor;
    end;
  if ErrorMessage <> '' then raise Exception.Create(ErrorMessage);
end;

procedure SQLExec(ASQLString: String);
begin
  SetQuerySQL(ASQLString);
  Main.Query.ExecSQL;
end;

function  WhereScalesIndex(AScales: SmallInt; ATableName: String = ''): String;
begin
  if ATableName <> '' then ATableName := ATableName + '.';
  Result := SQLNameEqualValue(ATableName + rsScalesIndex, AScales);
end;

function  WhereScalesIndexIn(AScales: String; ATableName: String = ''): String;
begin
  if ATableName <> '' then ATableName := ATableName + '.';
  Result := '(' + ATableName + rsScalesIndex + ' in (' + AScales + '))';
end;

function  WhereTrainIndex(ATrainIndex: LongWord; ATableName: String = ''): String;
begin
  if ATableName <> '' then ATableName := ATableName + '.';
  Result := SQLNameEqualValue(ATableName + rsTrainIndex, ATrainIndex);
end;

function  WhereTrainAndScalesIndex(ATrainIndex: LongWord; AScales: SmallInt; ATableName: String = ''): String;
begin
  Result := WhereTrainIndex(ATrainIndex, ATableName) + rsFilterAnd + WhereScalesIndex(AScales, ATableName);
end;

function  DTToSQLStr(ADateTime: TDateTime): String;
begin
   Result := FormatDateTime(rsDateTimeFormatSQL, ADateTime);
end;

function  SQLStrToDT(ASQLDateTime: String): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec: String;
begin
  SplitStr(ASQLDateTime, '-', 0, Year,  ASQLDateTime);
  SplitStr(ASQLDateTime, '-', 0, Month, ASQLDateTime);
  SplitStr(ASQLDateTime, ' ', 0, Day,   ASQLDateTime);
  SplitStr(ASQLDateTime, ':', 0, Hour,  ASQLDateTime);
  SplitStr(ASQLDateTime, ':', 0, Min,   Sec);
  Result := EncodeDateTime(SToI(Year), SToI(Month), SToI(Day), SToI(Hour), SToI(Min), SToI(Sec), 0);
end;

function  DTToWTime(ADateTime: TDateTime): Integer;
begin
  Result := Integer(DateTimeToUnix(IncHour(ADateTime, -4)));
end;

function  DTToWTimeStr(ADateTime: TDateTime): String;
begin
  Result := IToS(DTToWTime(ADateTime));
end;

function  DTToStr(ADateTime: TDateTime; WithSec: Boolean): String;
begin
  if WithSec then Result := FormatDateTime(rsDateTimeFormat1, ADateTime)
             else Result := FormatDateTime(rsDateTimeFormat2, ADateTime);
end;

procedure SetEditReadOnly(AEdit: TLabeledEdit; AReadOnly: Boolean);
begin
  with AEdit do
    begin
      ReadOnly := AReadOnly;
      Color := ColorsRO[AReadOnly];
    end;
end;

procedure SetEditReadOnly(AEdit: TEdit; AReadOnly: Boolean);
begin
  with AEdit do
    begin
      ReadOnly := AReadOnly;
      Color := ColorsRO[AReadOnly];
    end;
end;

procedure SetComboBoxReadOnly(AComboBox: TComboBox; AReadOnly: Boolean);
begin
  with AComboBox do
    begin
      Enabled := not AReadOnly;
      Color := ColorsRO[AReadOnly];
    end;
end;

function CheckedFirst(ARadioGroup: TRadioGroup): Boolean;
begin
  Result := ARadioGroup.ItemIndex = 0
end;

procedure CheckDataListKeyDown(DataList: TListView; Key: Word; Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
    case Key of
    {A} 65:  DataList.SelectAll;
    {U} 85:  DataList.Selected := nil;
    end;
end;

function CalcTotal(DataList: TListView; What: Integer; OnlySelected: Boolean): String;
var
  W: Extended;
  I: Integer;
begin
  W := 0;
  if OnlySelected then OnlySelected := DataList.SelCount <> 0;
  for I := 0 to DataList.Items.Count - 1 do
    try
      if OnlySelected then
        begin
          if DataList.Items[i].Selected then
            W := W + StrToFloat(DataList.Items[i].SubItems[What]);
        end
      else
        W := W + StrToFloat(DataList.Items[i].SubItems[What]);
    except
    end;
  Result := FmtFloat(W);
end;

function CalcDiffOrSum(X1, X2: String; CalcSum: Boolean): String;
begin
  if (X1 = '') or (X2 = '') then Result := rsError
  else
    try
      if CalcSum then
        Result := FmtFloat(StrToFloat(X1) + StrToFloat(X2))
      else
        Result := FmtFloat(StrToFloat(X1) - StrToFloat(X2));
    except
      Result := rsError;
    end;
end;

function CalcDiff(X1, X2: String): String;
begin
  Result := CalcDiffOrSum(X1, X2, False);
end;

function CalcSum(X1, X2: String): String;
begin
  Result := CalcDiffOrSum(X1, X2, True);
end;

initialization
  UsersAndPasswords := TStringList.Create;
  Receivers := TStringList.Create;
  Bakes := TStringList.Create;
  VanTypes := TStringList.Create;
  CargoTypes := TStringList.Create;

finalization
  CargoTypes.Free;
  VanTypes.Free;
  Receivers.Free;
  Bakes.Free;
  UsersAndPasswords.Free;

end.
