unit WMRAllLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Utils_Str, Utils_Misc, Utils_Files,
  Utils_Date, WMRAdd, Utils_FileIni, DB, ADODB, ToolWin, Utils_Log;

type
  TfrmAllLists = class(TForm)
    DataList: TListView;
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    tbtnClose: TToolButton;
    tbtnDelete: TToolButton;
    tbtnSeparator01: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DataListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure tbtnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure DataListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListColumnClick(Sender: TObject; Column: TListColumn);
    procedure DataListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure tbtnDeleteClick(Sender: TObject);
  private
    AllList: TListTable;
    ASortBy: Integer;
    BoldColumns: set of Byte;

    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;

    function  SetListItem(Index: Integer; AValues: array of String): TListItem;

    function  LoadItems: Boolean;
    procedure UpdateColors;
    procedure SortData;
  public
    constructor Create(AAllList: TListTable); reintroduce;
  end;

function ShowItemsForm(AAllList: TListTable): Boolean;

implementation

uses WMREdits, WMRMain, WMRStrings, WMRProgress, DateUtils, Math;

{$R *.dfm}

constructor TfrmAllLists.Create(AAllList: TListTable);
begin
  AllList := AAllList;
  ASortBy := 0;
  inherited Create(Application);
end;

function ShowItemsForm(AAllList: TListTable): Boolean;
begin
  with TfrmAllLists.Create(AAllList) do
    try
      Result := LoadItems;
      if Result then ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmAllLists.FormCreate(Sender: TObject);
const
  FormCaption:      array[TListTable]       of String     = ('Тары', 'Печи');
  ColumnCount:      array[TListTable, Boolean] of Integer    = ((3, 5), (1, 1));
  ListCaptions:     array[TListTable, 0..5] of String     = (
    ('№ вагона', 'Тара', 'Дата провески', 'Весовая', 'SCALES', 'WTIME/INDEX'),
    ('№ печи', '№ выпуска', '', '', '', ''));
  ColumnsAlignment: array[TListTable, 0..5] of TAlignment = (
    (taLeftJustify, taRightJustify, taLeftJustify, taLeftJustify, taCenter, taCenter),
    (taLeftJustify, taLeftJustify,  taLeftJustify, taLeftJustify, taCenter, taCenter));
var
  i: Integer;
  S, S1, S2, Section: String;
begin
  ToolBar.Images := Main.ImageList32;
  case AllList of
  alTares: begin
    HelpContext := IDH_TARES;
    S := rsLOGFormTare;
    Section := 'frmTares';
    BoldColumns := [0];
  end;
  alBakes: begin
    HelpContext := IDH_BAKES;
    S := rsLOGFormIssue;
    Section := 'frmBakes';
    BoldColumns := [];
  end;
  end;
  Caption := FormCaption[AllList];

  WriteToLogForm(True, S);

  tbtnDelete.Visible := False; {(Settings.CanDelete or IsAdministrator) and
    (AllList in [alTares]);}
  tbtnSeparator01.Visible := tbtnDelete.Visible;

  for i := 0 to ColumnCount[AllList, IsAdministrator] - 1 do DataList.Columns.Add;
  for i := 0 to DataList.Columns.Count - 1 do
    with DataList.Columns[i] do
      if ListCaptions[AllList, i] <> '' then
        begin
          Caption := ListCaptions[AllList, i];
          Alignment := ColumnsAlignment[AllList, i];
        end;

  with CreateINIFile do
    try
      S1 := ReadString(Section, 'Columns', '');
      if S1 <> '' then
        try
          for i := 0 to DataList.Columns.Count - 1 do
            begin
              SplitStr(S1, COMMA, 0, S2, S1);
              DataList.Columns[i].Width := SToI(S2);
            end;
        except
        end;
      ReadFormBounds(Self, Section);
    finally
      Free;
    end;
  DataListSelectItem(Self, nil, True);
end;

procedure TfrmAllLists.FormDestroy(Sender: TObject);
var
  i: Integer;
  S, Section: String;
begin
  case AllList of
  alTares: begin S := rsLOGFormTare;  Section := 'frmTares'; end;
  alBakes: begin S := rsLOGFormIssue; Section := 'frmBakes'; end;
  end;

  WriteToLogForm(False, S);

  with CreateINIFile do
    try
      WriteFormBounds(Self, Section);
      S := '';
      for i := 0 to DataList.Columns.Count - 1 do
        S := ConcatStrings(S, IToS(DataList.Columns[i].Width), COMMA);
      WriteString(Section, 'Columns', S);
    finally
      Free;
    end;
end;

procedure TfrmAllLists.tbtnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfrmAllLists.SetListItem(Index: Integer; AValues: array of String): TListItem;
var
  i: Integer;
begin
  if Index = -1 then
    begin
      Result := DataList.Items.Add;
      AddSubItemsToListItem(Result, 5);
    end
  else
    Result := DataList.Items[Index];
    with Result do
      begin
        if AValues[0] <> #0 then Caption := AValues[0];
        for i := Low(AValues) + 1 to High(AValues) do
          if AValues[i] <> #0 then SubItems[i - 1] := AValues[i];
      end;
end;

function TfrmAllLists.LoadItems: Boolean;
  function PerformLoadTares(AConnectionType: TConnectionType): Boolean;
  var
    i: Integer;
    ATableName, AFields, AWhere, AOrderBy, AScalesName, AScales, ADateTime, S: String;
  begin
    Result := True;
    SelectConnection(AConnectionType);
    with Main.Query do
      try // except
        case AConnectionType of
        ctServer: begin
          ATableName := rsTableServerTares;
          AFields := Format(rsSQLServerAllTaresLoad,
            [ATableName, rsTableServerScalesInfo]);

          S := ConcatStrings(IToS(Settings.Scales), Settings.MySQLBruttoAdd, COMMA);
          AWhere := Format(rsSQLScalesPlace, [rsTableServerScalesInfo, ATableName]) +
            rsFilterAnd + WhereScalesIndexIn(S, ATableName);

          AOrderBy := SQLOrderBy([ATableName + '.vannum', ATableName + '.bdatetime'],
            [False, False]);
        end;
        ctLocal: begin
          ATableName := rsTableLocalTares;
          AFields := rsSQLLocalAllTaresLoad;
          AWhere := '';
          AOrderBy := SQLOrderBy(['vannum, bdatetime'], [False, False]);
          AScalesName := Settings.Place;
          AScales := '';
        end;
        end;

        if AConnectionType = ctServer then
          ATableName := ATableName + ', ' + rsTableServerScalesInfo;

        SetQuerySQL(SQLSelect(ATableName, AFields, AWhere) + AOrderBy);

//        MsgBox(SQL[0]); Exit;

        SQLOpen(AConnectionType);
        try
          frmProgress.MaxProgress(RecordCount, False);
//          msgbox(RecordCount);
          while not Eof do
            begin
              case AConnectionType of
              ctServer: begin
                AScalesName := Fields[3].AsString;
                AScales := Fields[4].AsString;
                ADateTime := Fields[5].AsString;
              end;
              ctLocal: begin
                ADateTime := Fields[3].AsString;
              end;
              end;
              SetListItem(-1, [
                Fields[0].AsString,                   // Номер вагона (VANNUM)
                FmtFloat(Fields[1].AsFloat),          // Тара (TARE)
                DTToStr(Fields[2].AsDateTime, False), // Дата и время начала взвешивания (BDATETIME)
                AScalesName,                          // Весовая (Settings.Place, PLACE from SCALESINFO)
                AScales,                              // Номер весов (нет, SCALES)
                ADateTime                             // Дата и время начала взвешивания (WTIME) или
                                                      // Системный индекс (INDEX)
              ]);

              if frmProgress.StepProgress then Break;
              Next;
            end;
        finally
          Close;
        end;

        if DataList.Items.Count > 1 then
          begin
            AWhere := DataList.Items[DataList.Items.Count - 1].Caption;
            for i := DataList.Items.Count - 2 downto 0 do
              if DataList.Items[i].Caption = AWhere then
                DataList.Items[i].Delete
              else
                AWhere := DataList.Items[i].Caption;
          end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acLoad, rsErrorSLTares, E.Message);
          end;
    end;
  end;

  function PerformLoadIssues: Boolean;
  var
    i: Integer;
    NU: String;
    AIssues: TStrings;
  begin
    AIssues := TStringList.Create;
    try
      Result := Main.LoadIssue('', NU, AIssues);
      if Result then
        for i := 0 to AIssues.Count - 1 do
          SetListItem(-1, [AIssues.Names[i], AIssues.ValueFromIndex[i]]);
    finally
      AIssues.Free;
    end;
  end;
var
  FirstTick: LongWord;
begin
  StartTimer(FirstTick);

  frmProgress.Show;
  DataList.Items.BeginUpdate;
  try
    Result := OpenConnections;
    if not Result then Exit;

    case AllList of
    alTares: begin
      frmProgress.ProgressCaption := rsProgressTaresLoad;
      if CanServer and Settings.MySQLTareSave then Result := PerformLoadTares(ctServer)
                                              else Result := PerformLoadTares(ctLocal);
    end;
    alBakes: begin
      Result := PerformLoadIssues;
    end;
    else Result := False;
    end;
  finally
    DataList.Items.EndUpdate;
    frmProgress.Hide;
  end;
  if Result then
    begin
      SortData;
      WriteToLog(rsLOGTareLoad + GetTimerCount(FirstTick));
    end;
end;

procedure TfrmAllLists.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_ESCAPE:  tbtnClose.Click;
    end;
end;

procedure TfrmAllLists.DataListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  DataList.Canvas.Brush.Color := Item.ImageIndex;
end;

procedure TfrmAllLists.DataListCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  Dec(SubItem);
  DataList.Canvas.Brush.Color := Item.ImageIndex;
  if SubItem in BoldColumns then
    DataList.Canvas.Font.Style := [fsBold]
  else
    DataList.Canvas.Font.Style := [];
end;

procedure TfrmAllLists.DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CheckDataListKeyDown(DataList, Key, Shift);
end;

procedure TfrmAllLists.UpdateColors;
var
  i: Integer;
  CurrentIndex: String;
  CurrentColor: TColor;
begin
  case AllList of
  alTares, alBakes: begin
    CurrentIndex := '';
    CurrentColor := clWindow;
    for i := 0 to DataList.Items.Count - 1 do
      with DataList.Items[i] do
        begin
          if CurrentIndex <> Caption then
            begin
              CurrentIndex := Caption;
              if CurrentColor = clMoneyGreen then CurrentColor := clWindow
                                             else CurrentColor := clMoneyGreen;
            end;
          ImageIndex := CurrentColor;
        end;
  end;
  end; // case
  Repaint;
end;

procedure TfrmAllLists.DataListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  function SortByInteger(S1, S2: String): Integer;
  begin
    Result := SToI(S1) - SToI(S2);
  end;

  function SortByFloat(S1, S2: String): Integer;
  begin
    Result := CompareValue(StrToFloat(S1), StrToFloat(S2));
  end;

  function SortByDateTime(S1, S2: String): Integer;
  begin
    Result := CompareDateTime(StrToDateTime(S2), StrToDateTime(S1));
  end;

  function PerformCompareTares(ASortBy: Integer): Integer;
  begin
    case ASortBy of
    0: begin
      Result := CompareStr(Item1.Caption, Item2.Caption);
      if Result = 0 then Result := SortByDateTime(Item1.SubItems[2], Item2.SubItems[2]);
    end;
    1:    Result := SortByFloat(Item1.SubItems[0], Item2.SubItems[0]);
    2:    Result := SortByDateTime(Item1.SubItems[1], Item2.SubItems[1]);
    3:    Result := CompareStr(Item1.SubItems[2], Item2.SubItems[2]);
    else  Result := CompareStr(Item1.SubItems[ASortBy - 1], Item2.SubItems[ASortBy - 1]);
    end;
  end;
begin
  case AllList of
  alTares: begin
    Compare := PerformCompareTares(ASortBy);
    if (Compare = 0) and (ASortBy <> 0) then Compare := PerformCompareTares(0);
  end;
  alBakes: Compare := CompareStr(Item1.Caption, Item2.Caption);
  end;
end;

procedure TfrmAllLists.SortData;
begin
  DataList.Items.BeginUpdate;
  try
    DataList.AlphaSort;
    UpdateColors;
  finally
    DataList.Items.EndUpdate;
  end;
end;

procedure TfrmAllLists.DataListColumnClick(Sender: TObject; Column: TListColumn);
begin
  ASortBy := Column.Index;
  SortData;
end;

procedure TfrmAllLists.DataListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  tbtnDelete.Enabled := DataList.SelCount <> 0;
end;

procedure TfrmAllLists.tbtnDeleteClick(Sender: TObject);
  function PerformDeleteTare(AConnectionType: TConnectionType; AIndex: Integer): Boolean;
  var
    AVanNumber, ATableName, AWhere: String;
    FirstTick: LongWord;
  begin
    Result := True;

    StartTimer(FirstTick);

    with DataList.Items[AIndex] do
      begin
        AVanNumber := Caption;
        case AConnectionType of
        ctServer: begin
          ATableName := rsTableServerTares;
          AWhere := WhereScalesIndex(SToI(SubItems[3])) + rsFilterAnd +
          SQLNameEqualValue(rsWTimeIndex,  SToI(SubItems[4])) + rsFilterAnd +
          SQLNameEqualValue(rsVanNumIndex, AVanNumber);
        end;
        ctLocal: begin
          ATableName := rsTableLocalTares;
          AWhere := SQLNameEqualValue(rsIndex, SToI(SubItems[4]));
        end;
        end;
      end;

    SelectConnection(AConnectionType);
    try
      SQLExec(SQLDelete(ATableName, AWhere));
//      MsgBox(SQLDelete(ATableName, AWhere));
      WriteToLog(rsLOGTareDelete + SPACE + AVanNumber + GetTimerCount(FirstTick));
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
  if not (AllList in [alTares]) then Exit;

  if not MsgBoxYesNo(Format(rsQuestionDelete, [rsErrorSLTares])) then Exit;

  frmProgress.Show;
  DataList.Items.BeginUpdate;
  try
    if not OpenConnections then Exit;
    frmProgress.ProgressCaption := rsProgressDelVans;
    frmProgress.MaxProgress(DataList.SelCount, False);
    for i := DataList.Items.Count - 1 downto 0 do
      with DataList.Items[i] do
        if Selected then
          begin
            if CanServer then Result := PerformDeleteTare(ctServer, i)
                         else Result := PerformDeleteTare(ctLocal,  i);
            if Result then Delete else Break;
            if frmProgress.StepProgress then Break;
          end;
  finally
    UpdateColors;
    DataList.Items.EndUpdate;
    frmProgress.Hide;
  end;
end;

procedure TfrmAllLists.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

end.
