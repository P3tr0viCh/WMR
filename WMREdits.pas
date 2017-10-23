unit WMREdits;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_Date, WMRAdd;

type
  TfrmValueEdit = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    BevelTop: TBevel;
    eCaption: TLabeledEdit;
    eString1: TLabeledEdit;
    eString2: TLabeledEdit;
    procedure btnOKClick(Sender: TObject);
  private
    EditForm: TEditForm;
  public
  end;

function ShowEdit(AOwner: TForm; AEditForm: TEditForm; var ACaption, AString1, AString2: String): Boolean;

implementation

uses WMRStrings;

{$R *.dfm}

function ShowEdit(AOwner: TForm; AEditForm: TEditForm; var ACaption, AString1, AString2: String): Boolean;
const
  EditCaptions:     array[TEditForm, 1..3] of String = (
    ('Имя:',        'Пароль:',  'Подтвеждение:'),
    ('Получатель:', '',         ''),
    ('№ печи:',     '',         ''),
    ('Тип вагона:', '',         ''),
    ('Род груза:',  '',         ''));
  EditMaxLengths:   array[TEditForm] of Integer = (24,  32,  32,  16,  32);
  FormWidth:        array[TEditForm] of Integer = (380, 226, 226, 226, 226);
begin
  with TfrmValueEdit.Create(AOwner) do
    try
      EditForm := AEditForm;
      eCaption.EditLabel.Caption := EditCaptions[EditForm, 1];
      eCaption.MaxLength := EditMaxLengths[EditForm];
      HelpContext := AOwner.HelpContext;
      case EditForm of
      efUsers: begin
        eString1.PasswordChar := '#';
        eString2.PasswordChar := '#';
        eCaption.Width := eCaption.Width + 50;
        eString1.Left := eString1.Left   + 50;
        eString2.Left := eString2.Left   + 50;
        end;
      else     eCaption.Width := 210;
      end;
      eString1.EditLabel.Caption := EditCaptions[EditForm, 2];
      eString2.EditLabel.Caption := EditCaptions[EditForm, 3];
      eString1.Visible := eString1.EditLabel.Caption <> '';
      eString2.Visible := eString2.EditLabel.Caption <> '';
      ClientWidth := FormWidth[EditForm];
      if ACaption <> '' then
        begin
          ActiveControl := eCaption;
          eCaption.Text := ACaption;
          eString1.Text := AString1;
          eString2.Text := AString2;
        end;
      Result := ShowModal = mrOk;
      if Result then
        begin
          ACaption := eCaption.Text;
          AString1 := eString1.Text;
          AString2 := eString2.Text;
        end;
    finally
      Free;
    end;
end;

procedure TfrmValueEdit.btnOKClick(Sender: TObject);
begin
  if eCaption.Text = '' then
    begin
      MsgBoxErr(rsErrorString, Handle);
      eCaption.SetFocus;
      Exit;
    end
  else
    if EditForm in [efReceivers, efBakes, efVanTypes, efCargoTypes] then
      ModalResult := mrOk;
    if EditForm = efUsers then
      begin
        if eString1.Text <> eString2.Text then
          begin
            MsgBoxErr(rsErrorCheckPass, Handle);
            eString2.SetFocus;
          end
        else
          ModalResult := mrOk;
        Exit;
      end;
end;

end.
