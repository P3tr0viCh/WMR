unit WMRVescom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_FileIni, Utils_Misc, Utils_Str, WMRAdd,
  Utils_Log;

type
  TfrmVescom = class(TForm)
    BevelBottom: TBevel;
    btnCancel: TButton;
    pnlState: TPanel;
    TimerState: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerStateTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    DynamicHandle: HWND;
    GetRWSDynamicWindowHandles,
    SetRWSDynamicMode,
    GetRWSDynamicState,
    RWSWorkingEnded: UINT;
    AVescomState: TVescomState;

    procedure UpdateHandles;
    procedure SendMessageVescom(AMessage: TVescomMessage);
    procedure SetState(Value: TVescomState);
  public
    TrainIndex: LongWord;
    procedure DefaultHandler(var Message); override;
  end;

implementation

uses WMRStrings;

{$R *.dfm}

procedure TfrmVescom.FormCreate(Sender: TObject);
begin
  HelpContext := IDH_VESCOM;
  DynamicHandle := 0;
  with CreateINIFile do
    try
      ReadFormPosition(Self);
    finally
      Free;
    end;
  GetRWSDynamicWindowHandles := RegisterWindowMessage('GetRWSDynamicWindowHandles');
  SetRWSDynamicMode          := RegisterWindowMessage('SetRWSDynamicMode');
  GetRWSDynamicState         := RegisterWindowMessage('GetRWSDynamicState');
  RWSWorkingEnded            := RegisterWindowMessage('RWSWorkingEnded');
  AVescomState := vsNoModule;
  SetState(vsWaiting);
  UpdateHandles;
  TimerState.Enabled := True;
end;

procedure TfrmVescom.FormDestroy(Sender: TObject);
begin
  SendMessageVescom(vmDynamicStop);
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmVescom.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    begin
      if Msg = GetRWSDynamicWindowHandles then
        begin
          if LParam <> Longint(Handle) then
            begin
              DynamicHandle := LParam;
            end;
        end
      else
        if Msg = SetRWSDynamicMode then
          begin
            //
          end
        else
          if Msg = GetRWSDynamicState then
            begin
              if not IsValueInWord(LParam, 1) then SetState(vsNoTerminal)
              else
                if IsValueInWord(LParam, 64) then SetState(vsWeight)
                else SetState(vsWaiting);
            end
          else
            if Msg = RWSWorkingEnded then
              begin
                TrainIndex := WParam;
                SetState(vsWorkingEnd);
                ModalResult := mrOk;
              end
            else
              inherited DefaultHandler(Message);
    end;
end;

procedure TfrmVescom.SendMessageVescom(AMessage: TVescomMessage);
// AMessage: 0 - GetRWSDynamicWindowHandles, 1 - SetRWSDynamicMode (вкл. весы),
//           2 - SetRWSDynamicMode (выкл. весы), 3 - GetRWSDynamicState
var
  hWnd, Msg, wParam, lParam: Longint;
begin
  lParam := Longint(Handle);
  case AMessage of
  vmGetWindowHandle: begin
    hWnd := HWND_BROADCAST;
    Msg := GetRWSDynamicWindowHandles;
    wParam := 0;
  end;
  vmDynamicStart: begin
    hWnd := DynamicHandle;
    Msg := SetRWSDynamicMode;
    wParam := $0002;
  end;
  vmDynamicStop: begin
    hWnd := DynamicHandle;
    Msg := SetRWSDynamicMode;
    wParam := $0001;
  end;
  vmGetDynamicState: begin
    hWnd := DynamicHandle;
    Msg := GetRWSDynamicState;
    wParam := 0;
  end;
  else begin hWnd := 0; Msg := 0; wParam := 0; end;
  end;
  SendMessage(hWnd, Msg, wParam, lParam);
end;

procedure TfrmVescom.UpdateHandles;
begin
  SendMessageVescom(vmGetWindowHandle);
  SendMessageVescom(vmDynamicStart);
end;

procedure TfrmVescom.SetState(Value: TVescomState);
// 0 - no module, 1 - no terminal, 2 - waiting, 3 - weight, 4 - working end
var
  ALog, AStateCaption: String;
begin
  if AVescomState = Value then Exit;
  AVescomState := Value;
  case AVescomState of
    vsNoModule: begin
      ALog := rsLOGVescomStateNoConnect;
      AStateCaption := rsVescomStateNoConnect;
    end;
    vsNoTerminal: begin
      ALog := rsLOGVescomStateNoTerminal;
      AStateCaption := rsVescomStateNoTerminal;
    end;
    vsWaiting: begin
      ALog := rsLOGVescomStateWait;
      AStateCaption := rsVescomStateWait;
    end;
    vsWeight: begin
      ALog := rsLOGVescomStateWeight;
      AStateCaption := rsVescomStateWeight;
    end;
    vsWorkingEnd: begin
      ALog := rsLOGVescomEndWork + IToS(TrainIndex);
      AStateCaption := rsVescomStateEndWork;
    end;
  end;
  WriteToLog(ALog);
  pnlState.Caption := AStateCaption;
end;

procedure TfrmVescom.TimerStateTimer(Sender: TObject);
begin
  if IsWindow(DynamicHandle) then
    SendMessageVescom(vmGetDynamicState)
  else
    begin
      SetState(vsNoModule);
      UpdateHandles;
    end;
end;

procedure TfrmVescom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    begin
      btnCancel.Enabled := False;
      Delay(5000);
    end;
end;

procedure TfrmVescom.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
    begin
      MessageBeep(0);
      Key := 0;
    end;
end;

end.
