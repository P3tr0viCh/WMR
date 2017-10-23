unit WMRFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Utils_Date, Utils_Misc, Utils_Files, Utils_Str, Utils_FileIni, StdCtrls,
  ExtCtrls, ComCtrls, Menus, Utils_Log;

type
  TfrmFilter = class(TForm)
    btnOK: TButton;
    btnHide: TButton;
    btnClear: TButton;
    gbDate: TGroupBox;
    pckDateFrom: TDateTimePicker;
    rbtnDateAll: TRadioButton;
    rbtnDateFromTo: TRadioButton;
    pckDateTo: TDateTimePicker;
    lblDateFrom: TLabel;
    lblDateTo: TLabel;
    pmDate: TPopupMenu;
    miDateCurrent: TMenuItem;
    miDateYesterday: TMenuItem;
    miDateLastDay: TMenuItem;
    miDateFirstDay: TMenuItem;
    miSeparator01: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure rbtnDateAllClick(Sender: TObject);
    procedure miDateYesterdayClick(Sender: TObject);
  private
    procedure ClearFormFilter;
  public
    procedure CheckFormFilter;
  end;

function ShowFilter: Boolean;

implementation

uses WMRAdd, WMRStrings, DateUtils;

{$R *.dfm}

function ShowFilter: Boolean;
begin
  with TfrmFilter.Create(Application) do
    try
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
end;

procedure TfrmFilter.FormCreate(Sender: TObject);
begin
  HelpContext := IDH_TRAINS;
  WriteToLogForm(True, rsLOGFormFilter);
  with CreateINIFile do
    try
      ReadFormPosition(Self);
    finally
      Free;
    end;
  CheckFormFilter;
end;

procedure TfrmFilter.FormDestroy(Sender: TObject);
begin
  WriteToLogForm(False, rsLOGFormFilter);
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmFilter.btnHideClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFilter.btnClearClick(Sender: TObject);
begin
  ClearFormFilter;
end;

procedure TfrmFilter.ClearFormFilter;
begin
  WriteToLog(rsLOGFilterClear);
  ClearFilter(VansFilter);
  CheckFormFilter;
end;

procedure TfrmFilter.btnOKClick(Sender: TObject);
var
  S: String;
begin
  if rbtnDateFromTo.Checked and (pckDateFrom.DateTime > pckDateTo.DateTime) then
    pckDateTo.DateTime := pckDateFrom.DateTime;
  ClearFilter(VansFilter);
  with VansFilter do
    begin
      if rbtnDateFromTo.Checked then Dates := dtSelected else Dates := dtAll;
      case Dates of
      dtSelected: begin
        DateFrom := pckDateFrom.Date;
        DateTo := pckDateTo.Date;
        S := DateToStr(DateFrom);
        if DateFrom <> DateTo then
          S := S + ' - ' + DateToStr(DateTo);
      end;
      else
        begin
          DateFrom := 0;
          DateTo := 0;
          S := rsLOGFilterAll;
        end;
      end;
      Apply := Dates <> dtAll;
    end;
  WriteToLog(rsLOGFilterApply + SPACE + '(' + S + ')');
  ModalResult := mrOk;
end;

procedure TfrmFilter.CheckFormFilter;
begin
  with VansFilter do
    begin
      if Dates = dtSelected then
        begin
          pckDateFrom.DateTime := DateFrom;
          pckDateTo.DateTime := DateTo;
        end
      else
        begin
          pckDateFrom.DateTime := Date - 1;
          pckDateTo.DateTime := Date;
        end;
      case Dates of
      dtSelected: rbtnDateFromTo.Checked := True;
      else        rbtnDateAll.Checked := True;
      end;
    end;
end;

procedure TfrmFilter.rbtnDateAllClick(Sender: TObject);
begin
  pckDateFrom.Enabled := rbtnDateFromTo.Checked;
  pckDateTo.Enabled := pckDateFrom.Enabled;
end;

procedure TfrmFilter.miDateYesterdayClick(Sender: TObject);
begin
  with TDateTimePicker(pmDate.PopupComponent) do
    case TMenuItem(Sender).Tag of
    1: DateTime := StartOfTheMonth(Now);
    2: DateTime := EndOfTheMonth(Now);
    3: DateTime := Yesterday;
    4: DateTime := Today;
    end;
end;

end.
