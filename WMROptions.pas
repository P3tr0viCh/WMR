unit WMROptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_Date,
  Registry, ComCtrls, PathEdit, Grids, DB, ADODB, ValEdit, ExtSpin, Utils_Base64,
  Utils_FileIni, WMRAdd, Utils_Log, Vcl.Samples.Spin;

type
  TfrmOptions = class(TForm)
    BevelBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    PanelMain: TPanel;
    PageControl: TPageControl;
    tsProgram: TTabSheet;
    gbVanLength: TGroupBox;
    lblVanLength: TLabel;
    eVanLength: TEdit;
    tsVanMode: TTabSheet;
    gbVanMode: TGroupBox;
    lblScoops: TLabel;
    lblTrolleys: TLabel;
    rbtnScoops: TRadioButton;
    rbtnTrolleys: TRadioButton;
    rbtnOtherVans: TRadioButton;
    gbOtherVans: TGroupBox;
    eVanProtect: TLabeledEdit;
    eAxisOneVan: TLabeledEdit;
    tsUsers: TTabSheet;
    lvUsers: TListView;
    btnUserAdd: TButton;
    btnUserDelete: TButton;
    gbComPort: TGroupBox;
    cboxComPort: TComboBox;
    tsScales: TTabSheet;
    gbPlace: TGroupBox;
    ePlace: TEdit;
    gbScales: TGroupBox;
    eScales: TSpinEdit;
    gbType: TGroupBox;
    eType: TEdit;
    gbSClass: TGroupBox;
    gbDClass: TGroupBox;
    gbWorkMode: TGroupBox;
    cboxAutoIssue: TCheckBox;
    cboxCanManualAdd: TCheckBox;
    cboxCanAutoAdd: TCheckBox;
    cboxCanEdit: TCheckBox;
    cboxCanDelete: TCheckBox;
    tsMySQL: TTabSheet;
    tsReceivers: TTabSheet;
    lvReceivers: TListView;
    btnReceiverAdd: TButton;
    btnReceiverDelete: TButton;
    tsBakes: TTabSheet;
    lvBakes: TListView;
    btnBakeAdd: TButton;
    btnBakeDelete: TButton;
    gbMySQLBruttoAdd: TGroupBox;
    eMySQLBruttoAdd: TEdit;
    btnUserChange: TButton;
    btnReceiverChange: TButton;
    btnBakeChange: TButton;
    cboxSClass: TComboBox;
    cboxDClass: TComboBox;
    cboxMySQLBruttoSave: TCheckBox;
    tsVanTypes: TTabSheet;
    tsCargoTypes: TTabSheet;
    lvVanTypes: TListView;
    lvCargoTypes: TListView;
    btnVanTypeAdd: TButton;
    btnVanTypeChange: TButton;
    btnVanTypeDelete: TButton;
    btnCargoTypeAdd: TButton;
    btnCargoTypeChange: TButton;
    btnCargoTypeDelete: TButton;
    gbVanNumDefault: TGroupBox;
    eVanNumDefault: TEdit;
    btnLoad: TButton;
    btnSave: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    tsTerminal: TTabSheet;
    gbTerminal: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rbtnCAS: TRadioButton;
    rbtnVescom: TRadioButton;
    gbVescomPath: TGroupBox;
    peVescomPath: TPathEdit;
    tsAvitek: TTabSheet;
    cboxAvitekUse: TCheckBox;
    gbAvitekPath: TGroupBox;
    peAvitekPath: TPathEdit;
    tsMySQLOptions: TTabSheet;
    gbMySQLIP: TGroupBox;
    eMySQLIP: TEdit;
    gbMySQLPort: TGroupBox;
    eMySQLPort: TEdit;
    gbMySQLUser: TGroupBox;
    eMySQLUser: TEdit;
    gbMySQLPass: TGroupBox;
    eMySQLPass: TEdit;
    cboxMySQLTareSave: TCheckBox;
    cboxMySQLIssueSave: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure eVanLengthKeyPress(Sender: TObject; var Key: Char);
    procedure rbtnScoopsClick(Sender: TObject);
    procedure eVanProtectKeyPress(Sender: TObject; var Key: Char);
    procedure lvUsersChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnUserDeleteClick(Sender: TObject);
    procedure btnUserAddClick(Sender: TObject);
    procedure lvUsersCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvReceiversChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvReceiversCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure eMySQLPortKeyPress(Sender: TObject; var Key: Char);
    procedure cboxCanEditClick(Sender: TObject);
    procedure lvBakesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure eMySQLBruttoAddKeyPress(Sender: TObject; var Key: Char);
    procedure btnUserChangeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvVanTypesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvCargoTypesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure rbtnCASClick(Sender: TObject);
    procedure lblScoopsClick(Sender: TObject);
    procedure cboxAvitekUseClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    function  SetUsersItem(AIndex: Integer; AUserName, APassword: String): TListItem;
    function  SetReceiversBakesItem(AIndex: Integer; S: String; What: Byte): TListItem;
    function  GetTerminalType: TTerminal;
    procedure SetTerminalType(ATerminal: TTerminal);
    procedure LoadSettings;
    function  SaveSettings: Boolean;
    function  GetListView(AListView: Byte): TListView;
    procedure SaveSettingsToINI(const AFileName: String);
    procedure LoadSettingsFromINI(const AFileName: String);
  public
  end;

function ShowOptions: Boolean;

implementation

uses WMRStrings, WMRMain, WMREdits, WMRProgress;

{$R *.dfm}

function ShowOptions: Boolean;
begin
  with TfrmOptions.Create(Application) do
    try
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  HelpContext := IDH_OPTIONS;
  tsProgram.HelpContext := IDH_OPTIONS_PROG;
  tsVanMode.HelpContext := IDH_OPTIONS_VANMODES;
  tsUsers.HelpContext := IDH_OPTIONS_USERS;
  tsScales.HelpContext := IDH_OPTIONS_SCALES;
  tsMySQL.HelpContext := IDH_OPTIONS_MYSQL;
  tsMySQLOptions.HelpContext := IDH_OPTIONS_MYSQL_OPTIONS;
  tsReceivers.HelpContext := IDH_OPTIONS_RECEIVERS;
  tsBakes.HelpContext := IDH_OPTIONS_BAKES;
  tsVanTypes.HelpContext := IDH_OPTIONS_VANTYPES;
  tsCargoTypes.HelpContext := IDH_OPTIONS_CARGOTYPES;
  tsTerminal.HelpContext := IDH_OPTIONS_TERMINALS;
  tsAvitek.HelpContext := IDH_OPTIONS_AVITEK;

  for i := 1 to 9 do
    cboxComPort.Items.Add('COM ' + IToS(i));
  WriteToLogForm(True, rsLOGFormOptions);
  LoadSettings;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  WriteToLogForm(False, rsLOGFormOptions);
end;

procedure TfrmOptions.LoadSettings;
var
  i: Integer;
begin
  with Settings do
    begin
      eScales.Value := Scales;
      ePlace.Text := Place;
      eType.Text := TypeS;
      cboxSClass.Text := SClass;
      cboxDClass.Text := DClass;

      cboxCanManualAdd.Checked := CanManualAdd;
      cboxCanAutoAdd.Checked := CanAutoAdd;
      cboxCanEdit.Checked := CanEdit;
      cboxCanDelete.Checked := CanDelete;
      cboxAutoIssue.Checked := AutoIssue;
      cboxCanEditClick(Self);
      eVanLength.Text := FmtFloat(VanLength);
      eVanNumDefault.Text := VanNumDef;

      cboxComPort.ItemIndex := ComNumber - 1;

      SetTerminalType(Terminal);
      peVescomPath.Text := VescomPath;

      eMySQLIP.Text := MySQLIP;
      eMySQLPort.Text := MySQLPort;
      eMySQLUser.Text := MySQLUser;
      eMySQLPass.Text := MySQLPass;

      cboxMySQLBruttoSave.Checked := MySQLBruttoSave;
      cboxMySQLTareSave.Checked := MySQLTareSave;
      cboxMySQLIssueSave.Checked := MySQLIssueSave;
      eMySQLBruttoAdd.Text := MySQLBruttoAdd;

      cboxAvitekUse.Checked := AvitekUse;
      cboxAvitekUseClick(Self);
      peAvitekPath.Text := AvitekPath;

      if (AxisOneVan = 4) and (VanProtect = 0) then rbtnScoops.Checked := True
      else
        if (AxisOneVan = 2) and (VanProtect = 4) then rbtnTrolleys.Checked := True
        else rbtnOtherVans.Checked := True;
      eVanProtect.Text := IToS(VanProtect);
      eAxisOneVan.Text := IToS(AxisOneVan);
  end;

  for i := 0 to UsersAndPasswords.Count - 1 do
    SetUsersItem(-1, UsersAndPasswords.Names[i], UsersAndPasswords.ValueFromIndex[i]);
  for i := 0 to Receivers.Count - 1 do
    SetReceiversBakesItem(-1, Receivers[i],  2);
  for i := 0 to Bakes.Count - 1 do
    SetReceiversBakesItem(-1, Bakes[i],      3);
  for i := 0 to VanTypes.Count - 1 do
    SetReceiversBakesItem(-1, VanTypes[i],   4);
  for i := 0 to CargoTypes.Count - 1 do
    SetReceiversBakesItem(-1, CargoTypes[i], 5);
end;

function TfrmOptions.SaveSettings: Boolean;
var
  i: Integer;
  TempSettings: TSettings;
  SettingsList, TempBakes, TempReceivers, TempUsersAndPasswords, TempVanTypes, TempCargoTypes: TStringList;

  function CheckForErrors: Boolean;
  var
    VescomDB: String;

    procedure GotoEdit(PageIndex: Integer; AControl: TWinControl; AError: String);
    begin
      PageControl.ActivePageIndex := PageIndex;
      AControl.SetFocus;
      MsgBoxErr(AError);
    end;

    function CheckInteger(Edit: TCustomEdit; PageIndex: Integer; CanFloat: Boolean): Boolean;
    begin
      Result := IsNumber(Edit.Text, False, CanFloat);
      if not Result then GotoEdit(PageIndex, Edit, rsErrorNumber);
    end;

    function CheckServerRead: Boolean;
    var
      FirstHalf, SecondHalf: String;
    begin
      Result := True;
      if eMySQLBruttoAdd.Text = '' then Exit;
      try
        SecondHalf := eMySQLBruttoAdd.Text;
        repeat
          SplitStr(SecondHalf, COMMA, 0, FirstHalf, SecondHalf);
          if SToI(FirstHalf) = eScales.Value then raise Exception.Create('');
        until SecondHalf = '';
      except
        Result := False;
      end;
      if not Result then
        GotoEdit(tsMySQLOptions.TabIndex, eMySQLBruttoAdd, rsErrorServerRead);
    end;

    function CheckPath(APath: String; PageIndex: Integer; AControl: TWinControl): Boolean;
    begin
      Result := APath = '';
      if not Result then
        Result := DirectoryExists(APath);
      if not Result then
        GotoEdit(PageIndex, AControl, Format(rsErrorCheckPath, [APath]));
    end;
    begin
      Result := CheckInteger(eVanLength, 0, True);
      if Result then
        Result := CheckInteger(eVanProtect, 3, False);
      if Result then
        Result := CheckInteger(eAxisOneVan, 3, False);
      if Result then
        Result := CheckServerRead;
      if Result then
        begin
          if cboxAvitekUse.Checked then
            begin
              Result := FileExists(peAvitekPath.Text);
              if not Result then
                GotoEdit(tsAvitek.TabIndex, peAvitekPath,
                  Format(rsErrorAvitekNotExists, [peAvitekPath.Text]));
            end;
        end;
      if Result then
        begin
          if rbtnVescom.Checked then
            begin
              VescomDB := SlashSep(peVescomPath.Text, rsVescomDataBase);
              Result := FileExists(VescomDB);
              if not Result then
                GotoEdit(tsTerminal.TabIndex, peVescomPath,
                  Format(rsErrorVescomDBNotExists, [VescomDB]));
            end;
        end;
    end;
begin
  WriteToLog(rsLOGSettingsSave);
  if eVanLength.Text  = '' then eVanLength.Text := '0';
  if eVanProtect.Text = '' then eVanProtect.Text := '0';
  if eAxisOneVan.Text = '' then eAxisOneVan.Text := '4';

  Result := CheckForErrors;
  if not Result then Exit;

  SettingsList := TStringList.Create;
  TempBakes := TStringList.Create;
  TempReceivers := TStringList.Create;
  TempUsersAndPasswords := TStringList.Create;
  TempVanTypes := TStringList.Create;
  TempCargoTypes := TStringList.Create;
  try // finally
    try // except
      with TempSettings do
        begin
          Scales := eScales.Value;
          Place := ePlace.Text;
          TypeS := eType.Text;
          SClass := cboxSClass.Text;
          DClass := cboxDClass.Text;

          CanManualAdd := cboxCanManualAdd.Checked;
          CanAutoAdd := cboxCanAutoAdd.Checked;
          CanEdit := cboxCanEdit.Checked;
          CanDelete := cboxCanDelete.Checked;
          AutoIssue := cboxAutoIssue.Checked;
          VanLength := StrToFloat(eVanLength.Text);
          VanNumDef := eVanNumDefault.Text;

          ComNumber := cboxComPort.ItemIndex + 1;

          Terminal := GetTerminalType;
          VescomPath := peVescomPath.Text;

          AxisOneVan := SToI(eAxisOneVan.Text);
          VanProtect := SToI(eVanProtect.Text);

          MySQLIP := eMySQLIP.Text;
          MySQLPort := eMySQLPort.Text;
          MySQLUser := eMySQLUser.Text;
          MySQLPass := eMySQLPass.Text;

          MySQLBruttoSave := cboxMySQLBruttoSave.Checked;
          MySQLTareSave := cboxMySQLTareSave.Checked;
          MySQLIssueSave := cboxMySQLIssueSave.Checked;
          MySQLBruttoAdd := eMySQLBruttoAdd.Text;

          AvitekUse := cboxAvitekUse.Checked;
          AvitekPath := peAvitekPath.Text;
        end;

      for i := 0 to lvUsers.Items.Count - 1 do
        TempUsersAndPasswords.Add(ConcatNameAndValue(lvUsers.Items[i].Caption,
          lvUsers.Items[i].SubItems[1]));
      for i := 0 to lvReceivers.Items.Count - 1 do
        TempReceivers.Add(lvReceivers.Items[i].Caption);
      for i := 0 to lvBakes.Items.Count - 1 do
        TempBakes.Add(lvBakes.Items[i].Caption);
      for i := 0 to lvVanTypes.Items.Count - 1 do
        TempVanTypes.Add(lvVanTypes.Items[i].Caption);
      for i := 0 to lvCargoTypes.Items.Count - 1 do
        TempCargoTypes.Add(lvCargoTypes.Items[i].Caption);

      with TempSettings do
        begin
          SettingsList.Add(IToS(Scales));
          SettingsList.Add(Place);
          SettingsList.Add(TypeS);
          SettingsList.Add(SClass);
          SettingsList.Add(DClass);

          SettingsList.Add(BoolToS(CanManualAdd, '1', '0'));
          SettingsList.Add(BoolToS(CanAutoAdd, '1', '0'));
          SettingsList.Add(BoolToS(CanEdit, '1', '0'));
          SettingsList.Add(BoolToS(CanDelete, '1', '0'));
          SettingsList.Add(BoolToS(AutoIssue, '1', '0'));
          SettingsList.Add(FloatToStr(VanLength));
          SettingsList.Add(VanNumDef);

          SettingsList.Add(IToS(ComNumber));

          SettingsList.Add(IToS(Integer(Terminal)));
          SettingsList.Add(VescomPath);

          SettingsList.Add(IToS(AxisOneVan));
          SettingsList.Add(IToS(VanProtect));

          SettingsList.Add(MySQLIP);
          SettingsList.Add(MySQLPort);
          SettingsList.Add(MySQLUser);
          SettingsList.Add(MySQLPass);

          SettingsList.Add(BoolToS(MySQLBruttoSave));
          SettingsList.Add(BoolToS(MySQLTareSave));
          SettingsList.Add(BoolToS(MySQLIssueSave));
          SettingsList.Add(MySQLBruttoAdd);

          SettingsList.Add(BoolToS(AvitekUse));
          SettingsList.Add(AvitekPath);
        end;
      for i := 0 to TempUsersAndPasswords.Count - 1 do
        begin
          SettingsList.Add(TempUsersAndPasswords.Names[i]);
          SettingsList.Add(TempUsersAndPasswords.ValueFromIndex[i]);
        end;
      SettingsList.Add(CFGEndUser);
      for i := 0 to TempReceivers.Count - 1 do
        SettingsList.Add(TempReceivers[i]);
      SettingsList.Add(CFGEndRecev);
      for i := 0 to TempBakes.Count - 1 do
        SettingsList.Add(TempBakes[i]);
      SettingsList.Add(CFGEndBakes);
      for i := 0 to TempVanTypes.Count - 1 do
        SettingsList.Add(TempVanTypes[i]);
      SettingsList.Add(CFGEndVans);
      for i := 0 to TempCargoTypes.Count - 1 do
        SettingsList.Add(TempCargoTypes[i]);
      SettingsList.Add(CFGEndCargo);

      SettingsList.Add(CFGOK);

      SettingsList.Text := String(Encrypt(AnsiString(SettingsList.Text), CFGKEY));
      SettingsList.SaveToFile(ChangeFileExt(Application.ExeName, '.cfg'));

      UsersAndPasswords.Assign(TempUsersAndPasswords);
      Receivers.Assign(TempReceivers);
      Bakes.Assign(TempBakes);
      VanTypes.Assign(TempVanTypes);
      CargoTypes.Assign(TempCargoTypes);

      Main.ConnectionServer.Connected := False;

      Settings := TempSettings;
      CurrentUserName := UsersAndPasswords.Names[0];
      UserDateTime := Now;
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acSave, rsErrorSLSettings, E.Message);
        end;
    end;
  finally
    TempCargoTypes.Free;
    TempVanTypes.Free;
    TempUsersAndPasswords.Free;
    TempReceivers.Free;
    TempBakes.Free;
    SettingsList.Free;
  end;
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
  if SaveSettings then ModalResult := mrOk;
end;

procedure TfrmOptions.rbtnScoopsClick(Sender: TObject);
begin
  eVanProtect.Enabled := rbtnOtherVans.Checked;
  eAxisOneVan.Enabled := eVanProtect.Enabled;
  if rbtnTrolleys.Checked then
    begin
      eAxisOneVan.Text := '2';
      eVanProtect.Text := '4';
    end
  else
    begin
      eAxisOneVan.Text := '4';
      eVanProtect.Text := '0';
    end;
end;

procedure TfrmOptions.eVanLengthKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, True, False, []);
end;

procedure TfrmOptions.eVanProtectKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, False, False, []);
end;

procedure TfrmOptions.eMySQLPortKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, False, False, []);
end;

function TfrmOptions.SetUsersItem(AIndex: Integer; AUserName, APassword: String): TListItem;
begin
  if AIndex < 0 then
    begin
      Result := lvUsers.Items.Add;
      AddSubItemsToListItem(Result, lvUsers.Columns.Count + 1);
    end
  else
    Result := lvUsers.Items[AIndex];
  with Result do
    begin
      if AUserName <> #0 then Caption := AUserName;
      if APassword <> #0 then
        begin
          SubItems[1] := APassword;
          if APassword = '' then SubItems[0] := 'Нет' else SubItems[0] := 'Есть';
        end;
    end;
end;

function TfrmOptions.GetListView(AListView: Byte): TListView;
begin
  case AListView of
  1: Result := lvUsers;
  2: Result := lvReceivers;
  3: Result := lvBakes;
  4: Result := lvVanTypes;
  5: Result := lvCargoTypes;
  else Result := nil;
  end;
end;

function TfrmOptions.SetReceiversBakesItem(AIndex: Integer; S: String; What: Byte): TListItem;
begin
  with GetListView(What) do
    begin
      if AIndex < 0 then
        begin
          Result := Items.Add;
          AddSubItemsToListItem(Result, Columns.Count);
        end
      else
        Result := Items[AIndex];
    end;
  with Result do
    begin
      if S <> #0 then Caption := S;
    end;
end;

procedure TfrmOptions.lvUsersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnUserDelete.Enabled := Assigned(lvUsers.Selected);
  btnUserChange.Enabled := Assigned(lvUsers.ItemFocused);
  if btnUserDelete.Enabled then btnUserDelete.Enabled := lvUsers.Selected.Index > 0;
end;

procedure TfrmOptions.lvReceiversChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnReceiverDelete.Enabled := Assigned(lvReceivers.Selected);
  btnReceiverChange.Enabled := btnReceiverDelete.Enabled;
end;

procedure TfrmOptions.lvBakesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnBakeDelete.Enabled := Assigned(lvBakes.Selected);
  btnBakeChange.Enabled := btnBakeDelete.Enabled;
end;

procedure TfrmOptions.lvVanTypesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnVanTypeDelete.Enabled := Assigned(lvVanTypes.Selected);
  btnVanTypeChange.Enabled := btnVanTypeDelete.Enabled;
end;

procedure TfrmOptions.PageControlChange(Sender: TObject);
begin
  HelpContext := PageControl.ActivePage.HelpContext;
end;

procedure TfrmOptions.lvCargoTypesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnCargoTypeDelete.Enabled := Assigned(lvCargoTypes.Selected);
  btnCargoTypeChange.Enabled := btnCargoTypeDelete.Enabled;
end;

procedure TfrmOptions.btnUserDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  with GetListView(TButton(Sender).Tag) do
    begin
      if MsgBoxYesNo(Format(rsQuestionDelete, [rsRecords])) then
        for i := Items.Count - 1 downto 0 do
          if Items[i].Selected then Items[i].Delete;
    end;
end;

procedure TfrmOptions.btnUserAddClick(Sender: TObject);
begin
  with GetListView(TControl(Sender).Tag) do
    begin
      Selected := nil;
      ItemFocused := nil;
    end;
  btnUserChangeClick(Sender);
end;

procedure TfrmOptions.btnUserChangeClick(Sender: TObject);
var
  Index: Integer;
  ListItem: TListItem;
  AEditForm: TEditForm;
  S1, S2: String;
begin
  with GetListView(TControl(Sender).Tag) do
    begin
      S1 := '';
      S2 := '';
      if Assigned(Selected) then
        begin
          ItemFocused := Selected;
          Selected := nil;
          Selected := ItemFocused;
        end;
      case TControl(Sender).Tag of
      1: begin
        AEditForm := efUsers;
        if Assigned(Selected) then S2 := Selected.SubItems[1];
      end;
      2: begin
        AEditForm := efReceivers;
      end;
      3: begin
        AEditForm := efBakes;
      end;
      4: begin
        AEditForm := efVanTypes;
      end;
      5: begin
        AEditForm := efCargoTypes;
      end;
      else Exit;
      end;
      if Assigned(Selected) then S1 := Selected.Caption;

      if ShowEdit(Self, AEditForm, S1, S2, S2) then
        begin
          ListItem := FindCaption(0, S1, False, True, False);
          if Assigned(ListItem) then Index := ListItem.Index
          else
            begin
              if Assigned(Selected) then Index := Selected.Index
              else Index := -1;
            end;
          case TControl(Sender).Tag of
          1:    ListItem := SetUsersItem(Index, S1, S2);
          2, 3, 4, 5: ListItem := SetReceiversBakesItem(Index, S1, TControl(Sender).Tag);
          end;
          AlphaSort;
          Selected := nil;
          SelectListItem(ListItem);
        end;
    end;
end;

procedure TfrmOptions.lvUsersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Item1.Index = 0 then Compare := -1
  else
    if Item2.Index = 0 then Compare := 1
    else
      Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
end;

procedure TfrmOptions.lvReceiversCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
end;

procedure TfrmOptions.cboxAvitekUseClick(Sender: TObject);
begin
  peAvitekPath.Enabled := cboxAvitekUse.Checked;
end;

procedure TfrmOptions.cboxCanEditClick(Sender: TObject);
  procedure UpdateCheckBox(CheckBox: TCheckBox);
  begin
    CheckBox.Enabled := cboxCanEdit.Checked;
    if not CheckBox.Enabled then CheckBox.Checked := False;
  end;
begin
  UpdateCheckBox(cboxCanManualAdd);
  UpdateCheckBox(cboxCanAutoAdd);
  UpdateCheckBox(cboxCanDelete);
  UpdateCheckBox(cboxAutoIssue);
end;

procedure TfrmOptions.eMySQLBruttoAddKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, False, False, [COMMA]);
end;

procedure TfrmOptions.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not Assigned(ActiveControl) then Exit;
  if (Shift = []) and (Key = VK_INSERT) then
    case ActiveControl.Tag of
    0:;
    end;
end;

procedure TfrmOptions.LoadSettingsFromINI(const AFileName: String);
var
  i: Integer;
  TempList: TStringList;
begin
  ShowWaitCursor;
  TempList := TStringList.Create;
  with CreateINIFile(AFileName) do
    try
      eScales.Value :=             ReadInteger('Settings', 'Scales',         eScales.Value);
      ePlace.Text :=               ReadString ('Settings', 'Place',          ePlace.Text);
      eType.Text :=                ReadString ('Settings', 'TypeS',          eType.Text);
      cboxSClass.Text :=           ReadString ('Settings', 'SClass',         cboxSClass.Text);
      cboxDClass.Text :=           ReadString ('Settings', 'DClass',         cboxDClass.Text);

      cboxCanManualAdd.Checked :=  ReadBool   ('Settings', 'CanManualAdd',   cboxCanManualAdd.Checked);
      cboxCanAutoAdd.Checked :=    ReadBool   ('Settings', 'CanAutoAdd',     cboxCanAutoAdd.Checked);
      cboxCanEdit.Checked :=       ReadBool   ('Settings', 'CanEdit',        cboxCanEdit.Checked);
      cboxCanDelete.Checked :=     ReadBool   ('Settings', 'CanDelete',      cboxCanDelete.Checked);
      cboxCanEditClick(Self);

      cboxAutoIssue.Checked :=     ReadBool   ('Settings', 'AutoIssue',      cboxAutoIssue.Checked);
      eVanLength.Text :=           ReadString ('Settings', 'VanLength',      eVanLength.Text);
      eVanNumDefault.Text :=       ReadString ('Settings', 'VanNumDef',      eVanNumDefault.Text);

      cboxComPort.ItemIndex :=     ReadInteger('Settings', 'ComNumber',      cboxComPort.ItemIndex);
      SetTerminalType(TTerminal(ReadInteger('Settings', 'Terminal',       Integer(GetTerminalType))));

      eAxisOneVan.Text :=          ReadString('Settings', 'AxisOneVan',     eAxisOneVan.Text);
      eVanProtect.Text :=          ReadString('Settings', 'VanProtect',     eVanProtect.Text);

      peVescomPath.Text :=         ReadString ('Vescom', 'Path',             peVescomPath.Text);

      eMySQLIP.Text :=             ReadString ('MySQL',  'IP',               eMySQLIP.Text);
      eMySQLPort.Text :=           ReadString ('MySQL',  'Port',             eMySQLPort.Text);
      eMySQLUser.Text :=           ReadString ('MySQL',  'User',             eMySQLUser.Text);

      cboxMySQLBruttoSave.Checked := ReadBool   ('MySQL', 'BruttoSave', cboxMySQLBruttoSave.Checked);
      cboxMySQLTareSave.Checked :=   ReadBool   ('MySQL', 'TareSave',   cboxMySQLTareSave.Checked);
      cboxMySQLIssueSave.Checked :=  ReadBool   ('MySQL', 'IssueSave',  cboxMySQLIssueSave.Checked);
      eMySQLBruttoAdd.Text :=        ReadString ('MySQL', 'BruttoAdd',  eMySQLBruttoAdd.Text);

      cboxAvitekUse.Checked :=     ReadBool   ('Avitek', 'Use',    cboxAvitekUse.Checked);
      peAvitekPath.Text :=         ReadString ('Avitek', 'Path',   peAvitekPath.Text);

      ReadSectionValues('Users', TempList);
      lvUsers.Clear;
      for i := 0 to TempList.Count - 1 do
        SetUsersItem(-1, TempList.ValueFromIndex[i], '');
      ReadSectionValues('Receivers', TempList);
      lvReceivers.Clear;
      for i := 0 to TempList.Count - 1 do
        SetReceiversBakesItem(-1, TempList.ValueFromIndex[i], 2);
      ReadSectionValues('Bakes', TempList);
      lvBakes.Clear;
      for i := 0 to TempList.Count - 1 do
        SetReceiversBakesItem(-1, TempList.ValueFromIndex[i], 3);
      ReadSectionValues('VanTypes', TempList);
      lvVanTypes.Clear;
      for i := 0 to TempList.Count - 1 do
        SetReceiversBakesItem(-1, TempList.ValueFromIndex[i], 4);
      ReadSectionValues('CargoTypes', TempList);
      lvCargoTypes.Clear;
      for i := 0 to TempList.Count - 1 do
        SetReceiversBakesItem(-1, TempList.ValueFromIndex[i], 5);
    finally
      TempList.Free;
      Free;
      RestoreCursor;
    end;
end;

procedure TfrmOptions.SaveSettingsToINI(const AFileName: String);
var
  i: Integer;
begin
  ShowWaitCursor;
  with CreateINIFile(AFileName), Settings do
    try
      WriteInteger('Settings', 'Scales',     eScales.Value);
      WriteString ('Settings', 'Place',      ePlace.Text);
      WriteString ('Settings', 'TypeS',      eType.Text);
      WriteString ('Settings', 'SClass',     cboxSClass.Text);
      WriteString ('Settings', 'DClass',     cboxDClass.Text);

      WriteBool   ('Settings', 'CanManualAdd',  cboxCanManualAdd.Checked);
      WriteBool   ('Settings', 'CanAutoAdd',    cboxCanAutoAdd.Checked);
      WriteBool   ('Settings', 'CanEdit',       cboxCanEdit.Checked);
      WriteBool   ('Settings', 'CanDelete',     cboxCanDelete.Checked);

      WriteBool   ('Settings', 'AutoIssue',      cboxAutoIssue.Checked);
      WriteString ('Settings', 'VanLength',      eVanLength.Text);
      WriteString ('Settings', 'VanNumDef',      eVanNumDefault.Text);

      WriteInteger('Settings', 'ComNumber',     cboxComPort.ItemIndex);
      WriteInteger('Settings', 'Terminal',      Integer(GetTerminalType));

      WriteString('Settings', 'AxisOneVan',     eAxisOneVan.Text);
      WriteString('Settings', 'VanProtect',     eVanProtect.Text);

      WriteString ('Vescom', 'Path',   peVescomPath.Text);

      WriteString ('MySQL', 'IP',     eMySQLIP.Text);
      WriteString ('MySQL', 'Port',   eMySQLPort.Text);
      WriteString ('MySQL', 'User',   eMySQLUser.Text);

      WriteBool   ('MySQL', 'BruttoSave', cboxMySQLBruttoSave.Checked);
      WriteBool   ('MySQL', 'TareSave',   cboxMySQLTareSave.Checked);
      WriteBool   ('MySQL', 'IssueSave',  cboxMySQLIssueSave.Checked);
      WriteString ('MySQL', 'BruttoAdd',  eMySQLBruttoAdd.Text);

      WriteBool   ('Avitek', 'Use',    cboxAvitekUse.Checked);
      WriteString ('Avitek', 'Path',   peAvitekPath.Text);

      for i := 0 to lvUsers.Items.Count - 1 do
        WriteString('Users', IToS(i), lvUsers.Items[i].Caption);
      for i := 0 to lvReceivers.Items.Count - 1 do
        WriteString('Receivers', IToS(i), lvReceivers.Items[i].Caption);
      for i := 0 to lvBakes.Items.Count - 1 do
        WriteString('Bakes', IToS(i), lvBakes.Items[i].Caption);
      for i := 0 to lvVanTypes.Items.Count - 1 do
        WriteString('VanTypes', IToS(i), lvVanTypes.Items[i].Caption);
      for i := 0 to lvCargoTypes.Items.Count - 1 do
        WriteString('CargoTypes', IToS(i), lvCargoTypes.Items[i].Caption);
    finally
      Free;
      RestoreCursor;
    end;
end;

procedure TfrmOptions.btnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then SaveSettingsToINI(SaveDialog.FileName);
end;

procedure TfrmOptions.btnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then LoadSettingsFromINI(OpenDialog.FileName);
end;

function TfrmOptions.GetTerminalType: TTerminal;
begin
  if rbtnCAS.Checked then Result := tCAS
  else
    if rbtnVescom.Checked then Result := tVescom
    else
      Result := tCAS;
end;

procedure TfrmOptions.SetTerminalType(ATerminal: TTerminal);
begin
  case ATerminal of
  tCAS:    rbtnCAS.Checked := True;
  tVescom: rbtnVescom.Checked := True;
  end;
end;

procedure TfrmOptions.rbtnCASClick(Sender: TObject);
begin
  peVescomPath.Enabled := rbtnVescom.Checked;
end;

procedure TfrmOptions.lblScoopsClick(Sender: TObject);
begin
  TRadioButton(TLabel(Sender).FocusControl).Checked := True;
end;

end.

