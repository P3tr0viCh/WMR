object frmTaresLoad: TfrmTaresLoad
  Left = 421
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Caption'
  ClientHeight = 164
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    396
    164)
  PixelsPerInch = 96
  TextHeight = 18
  object BevelBottom: TBevel
    Left = 8
    Top = 108
    Width = 380
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object lblLoadTares: TLabel
    Left = 66
    Top = 80
    Width = 149
    Height = 18
    Caption = 'rsQuestionLoadTares'
    WordWrap = True
  end
  object imgIcon: TImage
    Left = 16
    Top = 16
    Width = 32
    Height = 32
  end
  object btnOK: TButton
    Left = 192
    Top = 120
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = #1044#1072
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 290
    Top = 120
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1053#1077#1090
    ModalResult = 2
    TabOrder = 0
  end
  object rgTareSelect: TRadioGroup
    Left = 66
    Top = 8
    Width = 312
    Height = 64
    Caption = #1042#1099#1073#1086#1088' '#1090#1072#1088#1099
    Columns = 2
    Items.Strings = (
      #1058#1072#1088#1072' "&'#1044#1054'"'
      #1058#1072#1088#1072' "&'#1055#1054#1057#1051#1045'"')
    TabOrder = 1
  end
end
