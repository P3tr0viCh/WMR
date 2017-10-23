unit WMRTaresLoad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Misc, Utils_FileIni, Utils_Str, MMSystem,
  Utils_Log;

type
  TfrmTaresLoad = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    rgTareSelect: TRadioGroup;
    BevelBottom: TBevel;
    lblLoadTares: TLabel;
    imgIcon: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

function ShowTaresLoad(DoSave: Boolean; var InTareBefore: Boolean): Boolean;

implementation

uses WMRStrings, WMRAdd;

{$R *.dfm}

function ShowTaresLoad(DoSave: Boolean; var InTareBefore: Boolean): Boolean;
var
  S: String;
begin
  Result := False;
  WriteToLogForm(True, rsLOGFormTareLoad);
  with TfrmTaresLoad.Create(Application) do
    try
      if DoSave then
        begin
          Caption := rsProgressTaresSave;
          lblLoadTares.Caption := rsQuestionTaresSave;
          rgTareSelect.Visible := False;
          lblLoadTares.Top := 16;
        end
      else
        begin
          Caption := rsProgressTaresLoad;
          lblLoadTares.Caption := rsQuestionTaresLoad;
        end;
      lblLoadTares.Width := 312;
      lblLoadTares.Caption := lblLoadTares.Caption + rsQuestionContinueTares;
      ClientHeight := lblLoadTares.Top + lblLoadTares.Height + 66;
      rgTareSelect.ItemIndex := Integer(InTareBefore);
      SetCurPosToCenter(btnCancel);
      Result := ShowModal = mrOk;
      InTareBefore := not Boolean(rgTareSelect.ItemIndex);
    finally
      if Result then
        begin
          if InTareBefore then S := rsLOGTareBefore else S := rsLOGTareAfter;
        end
      else
        S := rsLOGCancel;
      WriteToLogForm(False, rsLOGFormTareLoad + SPACE + S);
      Free;
    end;
end;

procedure TfrmTaresLoad.FormCreate(Sender: TObject);
begin
  HelpContext := IDH_TARE;
  sndPlaySound(nil, SND_NODEFAULT);
  sndPlaySound('SystemQuestion', SND_NOSTOP or SND_ASYNC or SND_NODEFAULT);
  imgIcon.Picture.Icon.Handle := LoadIcon(0, PChar(IDI_QUESTION));
  with CreateINIFile do
    try
      ReadFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmTaresLoad.FormDestroy(Sender: TObject);
begin
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

end.
