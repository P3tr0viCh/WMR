unit WMRProgress;

interface

//{$DEFINE DELAYPROGRESS}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Utils_Misc, Utils_Files, Utils_Str, Utils_FileIni,
  WMRAdd, ExtCtrls, Buttons, Utils_KAndM;

type
  TfrmProgress = class(TForm)
    ProgressBar: TProgressBar;
    Animate: TAnimate;
    btnCancel: TBitBtn;
    procedure FormHide(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ParentForm: TForm;
    FCanceled: Boolean;
    FProgressCaption: String;
    FProgressDataRead: Boolean;
    FConnectionType: TConnectionType;

    function  GetCanceled: Boolean;
    procedure SetProgressCaption(const Value: String);
    function  GetProgressCaption: String;
    procedure SetProgressDataRead(const Value: Boolean);
    procedure SetConnectionType(const Value: TConnectionType);
  public
    property ProgressCaption: String read GetProgressCaption write SetProgressCaption;
    property ProgressDataRead: Boolean read FProgressDataRead write SetProgressDataRead;
    property ConnectionType: TConnectionType read FConnectionType write SetConnectionType;
    property Canceled: Boolean read GetCanceled;

    function  StepProgress: Boolean;
    procedure MaxProgress(Value: Integer; ADisableCancel: Boolean);
  end;

var
  frmProgress: TfrmProgress;

implementation

uses WMRMain, WMRStrings;

{$R *.dfm}

function TfrmProgress.GetCanceled: Boolean;
begin
  ProcMess;
  Result := FCanceled;
end;

procedure TfrmProgress.btnCancelClick(Sender: TObject);
begin
  FCanceled := True;
  btnCancel.Enabled := False;
end;

procedure TfrmProgress.FormShow(Sender: TObject);
begin
  Animate.Active := True;
  ParentForm := Screen.ActiveForm;
  if Assigned(ParentForm) then
    begin
      ParentForm.Enabled := False;
      SetBounds(ParentForm.Left + (ParentForm.Width  - Width)  div 2,
      ParentForm.Top  + (ParentForm.Height - Height) div 2, Width, Height);
    end
  else
    begin
      SetBounds((Screen.Width  - Width)  div 2, (Screen.Height - Height) div 2, Width, Height);
    end;

  Caption := '...';
  FCanceled := False;
  btnCancel.Enabled := False;
  ProgressBar.Position := 0;
  ProgressDataRead := False;
end;

procedure TfrmProgress.FormHide(Sender: TObject);
begin
  Animate.Active := False;
  ProcMess;
  {$IFDEF DELAYPROGRESS}
  if not IsShift then Delay(1000);
  {$ENDIF}
  if Assigned(ParentForm) then ParentForm.Enabled := True;
  ProgressBar.Position := ProgressBar.Max;
end;

function TfrmProgress.StepProgress: Boolean;
var
  S: String;
begin
  ProgressBar.StepIt;
  S := FProgressCaption;
  if FConnectionType = ctServer then S := S + rsProgressInLAN;
  Caption := S + ' - ' + IToS(Trunc(Percent(ProgressBar.Position, ProgressBar.Max))) + ' %';
  ProcMess;
  {$IFDEF DELAYPROGRESS}
  if Main.Visible then
    if not IsShift then Delay(1000);
  {$ENDIF}
  Result := Canceled;
end;

procedure TfrmProgress.MaxProgress(Value: Integer; ADisableCancel: Boolean);
begin
  ProgressBar.Position := 0;
  ProgressBar.Max := Value;
  btnCancel.Enabled := not ADisableCancel;
end;

procedure TfrmProgress.SetProgressCaption(const Value: String);
begin
  FProgressCaption := Value;
  Caption := Value + '...';
end;

function TfrmProgress.GetProgressCaption: String;
begin
  Result := FProgressCaption;
end;

procedure TfrmProgress.SetProgressDataRead(const Value: Boolean);
var
  S: String;
begin
  FProgressDataRead := Value;
  S := FProgressCaption;
  if FProgressDataRead then S := S + rsProgressDataRead;
  Caption := S + '...';
  {$IFDEF DELAYPROGRESS}
  if not IsShift then Delay(1000);
  {$ENDIF}
end;

procedure TfrmProgress.SetConnectionType(const Value: TConnectionType);
var
  S: String;
begin
  if Value = FConnectionType then Exit;
  FConnectionType := Value;
  S := FProgressCaption;
  if FConnectionType = ctServer then S := S + rsProgressInLAN;
  Caption := S + '...';
  ProgressBar.Position := 0;
  {$IFDEF DELAYPROGRESS}
  if not IsShift then Delay(1000);
  {$ENDIF}
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Animate.ResName := 'PROGRESS';
end;

end.
