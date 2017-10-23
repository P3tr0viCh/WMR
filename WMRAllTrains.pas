unit WMRAllTrains;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Utils_FileIni, Dialogs, ComCtrls, StdCtrls, ExtCtrls, DateUtils, Utils_Str,
  Utils_Misc, Utils_Files, Utils_Date, Utils_Graf, WMRAdd, ToolWin, Utils_Log;

type
  TfrmAllTrains = class(TForm)
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    tbtnClose: TToolButton;
    tbtnEdit: TToolButton;
    tbtnDelete: TToolButton;
    tbtnSeparatorEnd: TToolButton;
    tbtnSeparator01: TToolButton;
    tbtnFilter: TToolButton;
    PanelBottom: TPanel;
    SelTimer: TTimer;
    gbFilter: TGroupBox;
    eFilterDate: TLabeledEdit;
    gbAll: TGroupBox;
    eAllGross: TLabeledEdit;
    eAllTareBefore: TLabeledEdit;
    eAllTareAfter: TLabeledEdit;
    eAllLosses: TLabeledEdit;
    eAllNetto: TLabeledEdit;
    eAllClean: TLabeledEdit;
    PanelMain: TPanel;
    DataList: TListView;
    tbtnUpdate: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DataListDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DataListKeyPress(Sender: TObject; var Key: Char);
    procedure DataListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure tbtnEditClick(Sender: TObject);
    procedure tbtnDeleteClick(Sender: TObject);
    procedure tbtnCloseClick(Sender: TObject);
    procedure tbtnFilterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SelTimerTimer(Sender: TObject);
    procedure DataListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure DataListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure DataListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure tbtnUpdateClick(Sender: TObject);
  private
    SelfChange: Boolean;

    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;

    function  GetDataItem(AIndex: Integer): TListItem;
    function  GetDataItemSend(AIndex: Integer): Boolean;

    function  SetDataItemVans(AIndex: Integer;   ANum: Integer; ADateTime, ABake, AIssue, AVanNum, AVanType, ACargoType,
                                                 AGross, ATareBefore, ATareAfter, AReceiver, APlace, AOperator: String;
                                                 ASpeed: Boolean; ASend: TSend): TListItem;

    function  LoadData(AScalesIndex: SmallInt; ATrainIndex: LongWord): Boolean;
    procedure UpdateColors;
    procedure SortData;
    procedure DataListSelect(AScalesIndex: SmallInt; ATrainIndex: LongWord);

    procedure UpdateTotal;
    procedure UpdateCount;
    procedure UpdateSelCount;
    procedure UpdateFilter;
    function  CalcTotal(What: Byte): String;

    procedure CreateColumns;
  public
  end;

procedure ShowAllVans;

implementation

uses WMRMain, WMRTrain, WMRStrings, WMRLogin, WMRProgress, WMRFilter, DB, ADODB, Math;

{$R *.dfm}

const
  SI_NUMBER      = -1;
  SI_DATETIME    = 0;

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
  SI_PLACE       = 13;
  SI_VELOCITY    = 14;
  SI_OPERATOR    = 15;
  SI_SEND        = 16;
  SI_SCALESINDEX = 17;
  SI_NUM         = 18;
  SI_STARTWEIGHT = 19;
  SI_MAXINDEX    = 20;

var
  SI_TRAININDEX: Integer;

procedure ShowAllVans;
begin
  with TfrmAllTrains.Create(Application) do
    try
      if LoadData(0, 0) then ShowModal;
    finally
      Free;
    end;
end;

function TfrmAllTrains.GetDataItem(AIndex: Integer): TListItem;
var
  ColumnCount: Integer;
begin
  ColumnCount := DataList.Columns.Count;
  if not IsAdministrator then Inc(ColumnCount, 3);
  if AIndex < 0 then
    begin
      Result := DataList.Items.Add;
      AddSubItemsToListItem(Result, ColumnCount);
    end
  else
    Result := DataList.Items[AIndex];
end;

function TfrmAllTrains.SetDataItemVans(AIndex: Integer; ANum: Integer; ADateTime, ABake,
  AIssue, AVanNum, AVanType, ACargoType, AGross, ATareBefore, ATareAfter,
  AReceiver, APlace, AOperator: String;
  ASpeed: Boolean; ASend: TSend): TListItem;
begin
  Result := GetDataItem(AIndex);
  with Result do
    begin
      Caption := IToS(Index + 1);
      if ANum <> 0 then SubItems[SI_NUM] := IToS(ANum);
      if ATareBefore = '' then ATareBefore := '0';
      if ATareAfter  = '' then ATareAfter := '0';
      if ADateTime   <> #0 then SubItems[SI_DATETIME] := ADateTime;
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
      if AVanType    <> #0 then SubItems[SI_VANTYPE] := AVanType;
      if ACargoType  <> #0 then SubItems[SI_CARGOTYPE] := ACargoType;
      if AReceiver   <> #0 then SubItems[SI_RECEIVER] := AReceiver;
      if APlace      <> #0 then SubItems[SI_PLACE] := APlace;
      if ASpeed            then SubItems[SI_VELOCITY] := '>>>'
                           else SubItems[SI_VELOCITY] := '<<<';
      if AOperator   <> #0 then SubItems[SI_OPERATOR] := AOperator;
      case ASend of
      sdNo:  SubItems[SI_SEND] := rsSendNo;
      sdYes: SubItems[SI_SEND] := rsSendYes;
      end;
    end;
end;

function TfrmAllTrains.GetDataItemSend(AIndex: Integer): Boolean;
begin
  Result := DataList.Items[AIndex].SubItems[SI_SEND] = rsSendYes;
end;

procedure TfrmAllTrains.FormCreate(Sender: TObject);
var
  i: Integer;
  S1, S2: String;
begin
  HelpContext := IDH_TRAINS;
  WriteToLogForm(True, rsLOGFormBrutto);
  ToolBar.Images := Main.ImageList32;
  SI_TRAININDEX := SI_MAXINDEX;
  Caption := rsProgressVans;
  CreateColumns;
  tbtnDelete.Visible := False; //Settings.CanDelete or IsAdministrator;
  tbtnSeparator01.Visible := tbtnEdit.Visible or tbtnDelete.Visible;
  if Settings.CanEdit or IsAdministrator then tbtnEdit.Caption := rsTrainsEdit
                                         else tbtnEdit.Caption := rsTrainsView;
  with CreateINIFile do
    try
      ReadFormBounds(Self);
      S1 := ReadString(Name, 'Columns Vans', '');
      if S1 <> '' then
        try
          for i := 0 to DataList.Columns.Count - 1 do
            begin
              SplitStr(S1, COMMA, 0, S2, S1);
              DataList.Columns[i].Width := SToI(S2);
            end;
        except
        end;
    finally
      Free;
    end;
  DataListChange(Self, nil, ctState);
end;

procedure TfrmAllTrains.FormDestroy(Sender: TObject);
var
  i: Integer;
  S1: String;
begin
  WriteToLogForm(False, rsLOGFormBrutto);
  with CreateINIFile do
    try
      WriteFormBounds(Self);
      S1 := '';
      if DataList.Columns.Count > 2 then
        for i := 0 to DataList.Columns.Count - 1 do
          S1 := ConcatStrings(S1, IToS(DataList.Columns[i].Width), COMMA);
      WriteString(Name, 'Columns Vans', S1);
    finally
      Free;
    end;
end;

procedure TfrmAllTrains.UpdateColors;
var
  i: Integer;
  CurrentIndex: String;
  CurrentColor: TColor;
begin
  CurrentIndex := '';
  CurrentColor := clWindow;
  for i := 0 to DataList.Items.Count - 1 do
    with DataList.Items[i] do
      begin
        if CurrentIndex <> SubItems[SI_TRAININDEX] then
          begin
            CurrentIndex := SubItems[SI_TRAININDEX];
            if CurrentColor = clMoneyGreen then CurrentColor := clWindow
                                           else CurrentColor := clMoneyGreen;
          end;
        ImageIndex := CurrentColor;
      end;
  Repaint;
end;

procedure TfrmAllTrains.FormShow(Sender: TObject);
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

procedure TfrmAllTrains.DataListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  try
    Compare := CompareBool(GetDataItemSend(Item1.Index), GetDataItemSend(Item2.Index));
    if Compare = 0 then
      begin
        Compare := CompareValue(SToI(Item2.SubItems[SI_STARTWEIGHT]),
                                SToI(Item1.SubItems[SI_STARTWEIGHT]));
        if Compare = 0 then
          Compare := CompareDateTime(StrToDateTime(Item2.SubItems[SI_DATETIME]),
        StrToDateTime(Item1.SubItems[SI_DATETIME]));
      end;
  except
    Compare := 0;
  end;
end;

procedure TfrmAllTrains.SortData;
begin
  DataList.Items.BeginUpdate;
  try
    DataList.AlphaSort;
    RethinkNumbers(DataList);
    UpdateColors;
  finally
    DataList.Items.EndUpdate;
  end;
end;

procedure TfrmAllTrains.DataListDblClick(Sender: TObject);
begin
  if tbtnEdit.Visible and tbtnEdit.Enabled then tbtnEdit.Click;
end;

procedure TfrmAllTrains.tbtnEditClick(Sender: TObject);
var
  ScalesIndex: SmallInt;
  TrainIndex: LongWord;
  AConnectionType: TConnectionType;
begin
  DataList.Selected := nil;
  DataList.ItemFocused.Selected := True;
  ScalesIndex := SToI(DataList.ItemFocused.SubItems[SI_SCALESINDEX]);
  TrainIndex := SToI(DataList.ItemFocused.SubItems[SI_TRAININDEX]);
  if ScalesIndex <> Settings.Scales then
    begin
      DataListSelect(ScalesIndex, TrainIndex);
      Exit;
    end;
  AConnectionType := ctLocal;
  if ShowEdit(ScalesIndex, TrainIndex, AConnectionType) then
    LoadData(ScalesIndex, TrainIndex);
end;

procedure TfrmAllTrains.tbtnDeleteClick(Sender: TObject);
  function PerformDeleteVan(AConnectionType: TConnectionType; AIndex: Integer): Boolean;
  var
    ATableName, AWhere, AVanNumber: String;
    FirstTick: LongWord;
  begin
    Result := True;

    StartTimer(FirstTick);

    with DataList.Items[AIndex] do
      begin
        AVanNumber := SubItems[SI_VANNUM];
        case AConnectionType of
        ctServer: begin
          ATableName := rsTableServerVans;
          AWhere := WhereTrainAndScalesIndex(SToI(SubItems[SI_TRAININDEX]),
            SToI(SubItems[SI_SCALESINDEX]));
        end;
        ctLocal: begin
          ATableName := rsTableLocalVans;
          AWhere := WhereTrainIndex(SToI(SubItems[SI_TRAININDEX]));
        end;
        end;
        AWhere := AWhere + rsFilterAnd +
          SQLNameEqualValue(rsVanNumIndex, AVanNumber);
      end;
    SelectConnection(AConnectionType);
    try
      SQLExec(SQLDelete(ATableName, AWhere));
//      MsgBox(SQLDelete(ATableName, AWhere)); Exit;
      WriteToLog(rsLOGVanDelete + SPACE + AVanNumber + GetTimerCount(FirstTick));
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acDelete, rsErrorSLTares, E.Message);
        end;
    end;
  end;
var
  i: Integer;
  Result: Boolean;
begin
  if not MsgBoxYesNo(Format(rsQuestionDelete, [rsErrorSLVans])) then Exit;
  frmProgress.Show;
  DataList.Items.BeginUpdate;
  try
    if not OpenConnections then Exit;
    frmProgress.ProgressCaption := rsProgressDelVans;
    frmProgress.MaxProgress(DataList.SelCount, False);
    for i := DataList.Items.Count - 1 downto 0 do
      begin
        with DataList.Items[i] do
          if Selected then
            begin
              if GetDataItemSend(i) and CanServer then
                Result := PerformDeleteVan(ctServer, i)
              else
                Result := True;
              if Result and (SToI(SubItems[SI_SCALESINDEX]) = Settings.Scales) then
                Result := PerformDeleteVan(ctLocal,  i);
              if Result then Delete else Break;
              if frmProgress.StepProgress then Break;
            end;
      end;
  finally
    SortData;
    DataListChange(Self, nil, ctState);
    UpdateCount;
    DataList.Items.EndUpdate;
    frmProgress.Hide;
    UpdateTotal;
  end;
end;

procedure TfrmAllTrains.tbtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAllTrains.tbtnFilterClick(Sender: TObject);
begin
  if ShowFilter then LoadData(0, 0);
end;

procedure TfrmAllTrains.tbtnUpdateClick(Sender: TObject);
begin
  LoadData(0, 0);
end;

procedure TfrmAllTrains.UpdateTotal;
begin
  if SelfChange then Exit;
  eAllGross.Text :=      CalcTotal(SI_GROSS);
  eAllTareBefore.Text := CalcTotal(SI_TAREBEF);
  eAllTareAfter.Text :=  CalcTotal(SI_TAREAFT);
  eAllLosses.Text :=     CalcTotal(SI_LOSSES);
  eAllNetto.Text :=      CalcTotal(SI_NETTO);
  eAllClean.Text :=      CalcTotal(SI_CLEAN);
end;

procedure TfrmAllTrains.DataListKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then DataListDblClick(Self);
end;

procedure TfrmAllTrains.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_F5:      LoadData(0, 0);
    VK_ESCAPE:  tbtnClose.Click;
    end;
end;

procedure TfrmAllTrains.DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CheckDataListKeyDown(DataList, Key, Shift);
end;

procedure TfrmAllTrains.SelTimerTimer(Sender: TObject);
begin
  SelTimer.Enabled := False;
  UpdateTotal;
end;

procedure TfrmAllTrains.UpdateSelCount;
begin
  StatusBar.Panels[0].Text := Format(rsRecordCountSel, [DataList.SelCount]);
end;

procedure TfrmAllTrains.UpdateCount;
begin
  StatusBar.Panels[1].Text := Format(rsRecordCount, [DataList.Items.Count]);
end;

function TfrmAllTrains.CalcTotal(What: Byte): String;
begin
  Result := WMRAdd.CalcTotal(DataList, What, True);
end;

procedure TfrmAllTrains.DataListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if SelfChange then Exit;
  if Change <> ctState then Exit;
  tbtnEdit.Enabled := DataList.ItemFocused <> nil;
  tbtnDelete.Enabled := DataList.SelCount <> 0;
  UpdateSelCount;
  RestartTimer(SelTimer);
end;

procedure TfrmAllTrains.CreateColumns;
const
  ColumnsMax:       array[Boolean] of Integer = (SI_MAXINDEX   - 4, SI_MAXINDEX);
  ColumnsCaption:   array[-1..SI_MAXINDEX] of String = (
    '№ п/п',      'Дата и время',
    '№ печи',     '№ выпуска',   '№ вагона',
    'Брутто',     'Тара до',     'Тара после',
    'Потери',     'Нетто',       'Чистый вес',
    'Тип вагона', 'Род груза',   'Получатель',
    'Весовая',    'Направление', 'Оператор',
    'Сеть', 'SCALES', 'NUM', 'START', 'TRNUM');
  ColumnsAlignment: array[-1..SI_MAXINDEX] of TAlignment = (
  taLeftJustify,  taLeftJustify,
  taLeftJustify,  taLeftJustify,  taLeftJustify,
  taRightJustify, taRightJustify, taRightJustify,
  taRightJustify, taRightJustify, taRightJustify,
  taLeftJustify,  taLeftJustify,  taLeftJustify,
  taLeftJustify,  taCenter,       taLeftJustify,
  taCenter,       taCenter,       taCenter,
  taLeftJustify,  taCenter);
var
  i: Integer;
begin
  for i := -1 to ColumnsMax[IsAdministrator] do
    with DataList.Columns.Add do
      begin
        Caption := ColumnsCaption[i];
        Alignment := ColumnsAlignment[i];
        Width := 80;
      end;
end;

procedure TfrmAllTrains.DataListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  DataList.Canvas.Brush.Color := Item.ImageIndex;
end;

var
  C: Boolean;

procedure TfrmAllTrains.DataListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  Dec(SubItem);
  C := SubItem in [SI_NETTO, SI_CLEAN];
  DataList.Canvas.Brush.Color := Item.ImageIndex;
  if C then
    DataList.Canvas.Font.Style := [fsBold]
  else
    DataList.Canvas.Font.Style := [];
  if CanServer or Settings.AvitekUse then
    begin
      if GetDataItemSend(Item.Index) then
        DataList.Canvas.Font.Color := clBlack
      else
        DataList.Canvas.Font.Color := clRed;
    end
  else
    DataList.Canvas.Font.Color := clBlack;
end;

procedure TfrmAllTrains.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAllTrains.FormHide(Sender: TObject);
begin
  DataList.Clear;
end;

procedure TfrmAllTrains.UpdateFilter;
begin
  with VansFilter do
    begin
      if Apply then
        begin
          if Dates = dtAll then
            eFilterDate.Text := rsShowFilterAllDate
          else
            begin
              if SameDate(DateFrom, DateTo) then
                eFilterDate.Text := DateToStr(DateFrom)
              else
                eFilterDate.Text := Format(rsShowFilterDate,
                  [DateToStr(DateFrom), DateToStr(DateTo)]);
            end;
          StatusBar.Panels[2].Text := rsFilterApply;
        end
      else
        begin
          eFilterDate.Text := rsShowFilterAllDate;
          StatusBar.Panels[2].Text := rsAllRecords;
        end;
    end;
end;

procedure TfrmAllTrains.DataListSelect(AScalesIndex: SmallInt; ATrainIndex: LongWord);
var
  i: Integer;
begin
  for i := 0 to DataList.Items.Count - 1 do
    if (SToI(DataList.Items[i].SubItems[SI_SCALESINDEX]) = AScalesIndex) and
       (LongWord(SToI(DataList.Items[i].SubItems[SI_TRAININDEX])) = ATrainIndex) then
      DataList.Items[i].Selected := True;
  if Assigned(DataList.Selected) then
    begin
      DataList.Selected.Focused := True;
      DataList.Selected.MakeVisible(False);
    end;
end;

function TfrmAllTrains.LoadData(AScalesIndex: SmallInt; ATrainIndex: LongWord): Boolean;
  function LoadOnlyEdited: Boolean;
  begin
    Result := ATrainIndex <> 0;
  end;

  procedure DataListClear;
  var
    i: Integer;
  begin
    if LoadOnlyEdited then
      begin
        DataList.Items.BeginUpdate;
        for i := DataList.Items.Count - 1 downto 0 do
          if (SToI(DataList.Items[i].SubItems[SI_SCALESINDEX]) = AScalesIndex) and
             (LongWord(SToI(DataList.Items[i].SubItems[SI_TRAININDEX])) = ATrainIndex) then
            DataList.Items[i].Delete;
        DataList.Items.EndUpdate;
      end
    else
      DataList.Clear;
  end;

  function PerformLoadData(AConnectionType: TConnectionType): Boolean;
  var
    ATableName, AFields, AWhere, AScales, AScalesName: String;
    ASend: TSend;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    with Main.Query do
      try // except
        case AConnectionType of
        ctServer: begin
          ATableName := rsTableServerVans;
          AFields := Format(rsSQLServerAllVansLoad,
            [ATableName, rsTableServerScalesInfo]);

          AWhere := WhereScalesIndexIn(Settings.MySQLBruttoAdd, ATableName);
          AWhere := AWhere + rsFilterAnd +
            Format(rsSQLScalesPlace, [rsTableServerScalesInfo, ATableName]);
        end;
        ctLocal: begin
          ATableName := rsTableLocalVans;
          AFields := rsSQLLocalVans;
          if LoadOnlyEdited then AWhere := WhereTrainIndex(ATrainIndex)
                            else AWhere := '';
          AScales := IToS(Settings.Scales);
          AScalesName := Settings.Place;
        end;
        end;
        ASend := sdYes;

        if VansFilter.Apply then
          begin
            if AWhere <> '' then AWhere := AWhere + rsFilterAnd;
            AWhere := AWhere + FilterToSQL(AConnectionType, ATableName);
          end;

        if AConnectionType = ctServer then
          ATableName := ATableName + COMMA + rsTableServerScalesInfo;

        SetQuerySQL(SQLSelect(ATableName, AFields, AWhere));

//        MsgBox(SQL.Text, 64, '', frmProgress.Handle); Exit;

        SQLOpen(AConnectionType);
        try // finally
          frmProgress.MaxProgress(RecordCount, False);
          while not Eof do
            begin
              case AConnectionType of
              ctServer: begin
                AScalesName := Fields[15].AsString;
                AScales := Fields[16].AsString
              end;
              ctLocal: begin
                if Settings.AvitekUse and LoadOnlyEdited then ASend := sdYes
                else
                  if Fields[15].AsBoolean then ASend := sdYes else ASend := sdNo;
              end;
              end;

              with SetDataItemVans(-1,
                Fields[1].AsInteger,                  // № вагона пп (NUM)
                DTToStr(Fields[3].AsDateTime, True),  // Дата и время начала взвешивания (BDATETIME)
                Fields[4].AsString,                   // Номер печи (BAKE, INVOICE_SUPPLIER)
                Fields[5].AsString,                   // Номер выпуска (ISSUE, INVOICE_NUM)
                Fields[6].AsString,                   // Номер вагона (VANNUM)
                Fields[7].AsString,                   // Род вагона (VANTYPE)
                Fields[8].AsString,                   // Род груза (CARGOTYPE)
                FmtFloat(Fields[9].AsFloat),          // Брутто (BRUTTO)
                FmtFloat(Fields[10].AsFloat),         // Тара ДО (TAREBEFORE, TARE)
                FmtFloat(Fields[11].AsFloat),         // Тара ПОСЛЕ (TAREAFTER, INVOICE_TARE)
                Fields[12].AsString,                  // Получатель (RECEIVER, INVOICE_RECEPIENT)
                AScalesName,                          // Весовая (Settings.Place, PLACE from SCALESINFO)
                Fields[14].AsString,                  // Оператор (OPERATOR)
                Fields[13].AsFloat >= 0,              // Скорость (VELOCITY)
                ASend) do                             // Сохранено на сервере (SEND, всегда)
                begin
                  SubItems[SI_SCALESINDEX] := AScales;            // Номер весов (Settings.Scales, SCALES)
                  SubItems[SI_STARTWEIGHT] := Fields[2].AsString; // Дата и время начала взвешивания поезда
                  SubItems[SI_TRAININDEX] :=  Fields[0].AsString; // Системный номер поезда (TRNUM)
                end;
              if frmProgress.StepProgress then Break;
              Next;
            end; // while not Eof do
        finally
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
  FirstTick: LongWord;
begin
  StartTimer(FirstTick);

  Result := False;
  frmProgress.Show;
  try
    Result := OpenConnections;
    if not Result then Exit;

    frmProgress.ProgressCaption := rsProgressVans;

    DataListClear;

    UpdateTotal;
    SelfChange := True;
    UpdateFilter;
    UpdateSelCount;
    UpdateCount;

    DataList.Items.BeginUpdate;

    Result := PerformLoadData(ctLocal);
    if (not LoadOnlyEdited) and CanServer and (Settings.MySQLBruttoAdd <> '') then
      Result := PerformLoadData(ctServer);
  finally
    SortData;
    if LoadOnlyEdited then DataListSelect(AScalesIndex, ATrainIndex);
    DataList.Items.EndUpdate;
    frmProgress.Hide;
    SelfChange := False;
    DataListChange(Self, nil, ctState);
    UpdateCount;
    if Result then WriteToLog(rsLOGBruttoLoad + GetTimerCount(FirstTick));
  end;
end;

procedure TfrmAllTrains.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

end.
