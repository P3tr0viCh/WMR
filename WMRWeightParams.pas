unit WMRWeightParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_Date,
  Utils_Graf, Utils_FileIni, Utils_KAndM, jpeg;

type
  TfrmWeightParams = class(TForm)
    BevelBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    rgLoco: TRadioGroup;
    rgPosition: TRadioGroup;
    rgDirection: TRadioGroup;
    PanelPreview: TPanel;
    imgLeftToRight: TImage;
    PaintBox: TPaintBox;
    imgRightToLeft: TImage;
    imgVanScoop: TImage;
    imgLoco4: TImage;
    imgLoco6: TImage;
    imgRails: TImage;
    imgVanTrolley1: TImage;
    imgVanTrolley2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure rgDirectionClick(Sender: TObject);
    procedure imgRightToLeftClick(Sender: TObject);
    procedure imgLoco4Click(Sender: TObject);
    procedure imgVanScoopClick(Sender: TObject);
  private
    ImageVan: TImage;
    procedure UpdatePreview;
  public
  end;

implementation

uses WMRAdd;

{$R *.dfm}

procedure TfrmWeightParams.FormCreate(Sender: TObject);
begin
  HelpContext := IDH_AUTO;
  LoadJPEGFromResource(imgLeftToRight.Picture, HInstance, 'LEFTTORIGHT');
  LoadJPEGFromResource(imgRightToLeft.Picture, HInstance, 'RIGHTTOLEFT');
  LoadJPEGFromResource(imgLoco4.Picture,       HInstance, 'LOCO4');
  LoadJPEGFromResource(imgLoco6.Picture,       HInstance, 'LOCO6');
  LoadJPEGFromResource(imgVanScoop.Picture,    HInstance, 'VANSCOOP');
  LoadJPEGFromResource(imgVanTrolley1.Picture, HInstance, 'VANTROLLEY1');
  LoadJPEGFromResource(imgVanTrolley2.Picture, HInstance, 'VANTROLLEY2');
  LoadJPEGFromResource(imgRails.Picture,       HInstance, 'RAILS');
  with CreateINIFile do
    try
      ReadFormPosition(Self);
    finally
      Free;
    end;
  UpdatePreview;
end;

procedure TfrmWeightParams.FormDestroy(Sender: TObject);
begin
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmWeightParams.PaintBoxPaint(Sender: TObject);
var
  Rect: TRect;
begin
  Rect := PaintBox.ClientRect;
  with PaintBox.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(Rect);
      Brush.Color := clBlack;
      FrameRect(Rect);
      Brush.Color := AverageColor(clBlack, clWhite);
      InflateRect(Rect, -1, -1);
      FrameRect(Rect);
    end;
end;

procedure TfrmWeightParams.rgDirectionClick(Sender: TObject);
begin
  if Sender = rgDirection then
    begin
      if CheckedFirst(rgPosition) then rgPosition.ItemIndex := 1
                                  else rgPosition.ItemIndex := 0;
    end;
  UpdatePreview;
end;

procedure TfrmWeightParams.UpdatePreview;

  procedure CheckVisible(AImage1, AImage2: TImage; ACheck: Boolean);
  begin
    if ACheck then
      begin
        AImage1.Visible := True;
        AImage2.Visible := False;
      end
    else
      begin
        AImage1.Visible := False;
        AImage2.Visible := True;
      end;
  end;
var
  ImageLoco, Image1, Image2: TImage;
begin
  if (Settings.AxisOneVan = 2) and (Settings.VanProtect = 4) then
    begin
      if CheckedFirst(rgDirection) then
        begin
          if CheckedFirst(rgPosition) then ImageVan := imgVanTrolley1
                                      else ImageVan := imgVanTrolley2;
        end
      else
        begin
          if CheckedFirst(rgPosition) then ImageVan := imgVanTrolley2
                                      else ImageVan := imgVanTrolley1;
        end;
    end
  else
    ImageVan := imgVanScoop;

  imgVanTrolley1.Visible := False;
  imgVanTrolley2.Visible := False;
  ImageVan.Visible := True;

  CheckVisible(imgLeftToRight,  imgRightToLeft,   CheckedFirst(rgDirection));
  CheckVisible(imgLoco4,        imgLoco6,         CheckedFirst(rgLoco));

  imgLeftToRight.Left := (PanelPreview.ClientWidth - imgLeftToRight.Width) div 2;
  imgRightToLeft.Left := imgLeftToRight.Left;

  if CheckedFirst(rgLoco) then ImageLoco := imgLoco4 else ImageLoco := imgLoco6;
  if CheckedFirst(rgDirection) then
    begin
      if CheckedFirst(rgPosition) then
        begin Image1 := ImageVan; Image2 := ImageLoco; end
      else
        begin Image2 := ImageVan; Image1 := ImageLoco; end;
    end
  else
    begin
      if CheckedFirst(rgPosition) then
        begin Image2 := ImageVan; Image1 := ImageLoco; end
      else
        begin Image1 := ImageVan; Image2 := ImageLoco; end;
    end;
  Image1.Left := (PanelPreview.ClientWidth - (ImageVan.Width + 6 + ImageLoco.Width)) div 2;
  Image2.Left := Image1.Left + Image1.Width + 6;
end;

procedure TfrmWeightParams.imgRightToLeftClick(Sender: TObject);
begin
  if CheckedFirst(rgDirection) then rgDirection.ItemIndex := 1
                               else rgDirection.ItemIndex := 0;
end;

procedure TfrmWeightParams.imgLoco4Click(Sender: TObject);
begin
  if CheckedFirst(rgLoco) then rgLoco.ItemIndex := 1 else rgLoco.ItemIndex := 0;
end;

procedure TfrmWeightParams.imgVanScoopClick(Sender: TObject);
begin
  if CheckedFirst(rgPosition) then rgPosition.ItemIndex := 1
                              else rgPosition.ItemIndex := 0;
  SetCurPosToCenter(ImageVan);
end;

end.
