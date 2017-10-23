object frmWeightParams: TfrmWeightParams
  Left = 381
  Top = 174
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
  ClientHeight = 380
  ClientWidth = 596
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
    596
    380)
  PixelsPerInch = 96
  TextHeight = 18
  object BevelBottom: TBevel
    Left = 8
    Top = 329
    Width = 580
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 396
    Top = 339
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 494
    Top = 339
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object rgLoco: TRadioGroup
    Left = 448
    Top = 8
    Width = 138
    Height = 81
    Caption = #1058#1077#1087#1083#1086#1074#1086#1079
    ItemIndex = 0
    Items.Strings = (
      '4-'#1093' '#1086#1089#1085#1099#1081
      '6-'#1090#1080' '#1086#1089#1085#1099#1081)
    TabOrder = 2
    OnClick = rgDirectionClick
  end
  object rgPosition: TRadioGroup
    Left = 244
    Top = 8
    Width = 198
    Height = 81
    Caption = #1055#1086#1079#1080#1094#1080#1103' '#1090#1077#1087#1083#1086#1074#1086#1079#1072
    ItemIndex = 0
    Items.Strings = (
      #1042' '#1085#1072#1095#1072#1083#1077' '#1089#1086#1089#1090#1072#1074#1072
      #1042' '#1082#1086#1085#1094#1077' '#1089#1086#1089#1090#1072#1074#1072)
    TabOrder = 1
    OnClick = rgDirectionClick
  end
  object rgDirection: TRadioGroup
    Left = 8
    Top = 8
    Width = 230
    Height = 81
    Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1076#1074#1080#1078#1077#1085#1080#1103
    ItemIndex = 0
    Items.Strings = (
      #1057#1083#1077#1074#1072' '#1085#1072#1087#1088#1072#1074#1086
      #1057#1087#1088#1072#1074#1072' '#1085#1072#1083#1077#1074#1086)
    TabOrder = 0
    OnClick = rgDirectionClick
  end
  object PanelPreview: TPanel
    Left = 8
    Top = 96
    Width = 579
    Height = 225
    BevelOuter = bvNone
    TabOrder = 5
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 579
      Height = 225
      Align = alClient
      OnPaint = PaintBoxPaint
    end
    object imgVanScoop: TImage
      Left = 13
      Top = 14
      Width = 245
      Height = 126
      Cursor = crHandPoint
      Transparent = True
      Visible = False
      OnClick = imgVanScoopClick
      OnDblClick = imgVanScoopClick
    end
    object imgLoco6: TImage
      Left = 261
      Top = 21
      Width = 312
      Height = 119
      Cursor = crHandPoint
      Transparent = True
      OnClick = imgLoco4Click
      OnDblClick = imgLoco4Click
    end
    object imgLeftToRight: TImage
      Left = 246
      Top = 168
      Width = 322
      Height = 54
      Cursor = crHandPoint
      Transparent = True
      OnClick = imgRightToLeftClick
      OnDblClick = imgRightToLeftClick
    end
    object imgRightToLeft: TImage
      Left = 26
      Top = 168
      Width = 322
      Height = 54
      Cursor = crHandPoint
      Transparent = True
      OnClick = imgRightToLeftClick
      OnDblClick = imgRightToLeftClick
    end
    object imgLoco4: TImage
      Left = 317
      Top = 21
      Width = 244
      Height = 119
      Cursor = crHandPoint
      Transparent = True
      OnClick = imgLoco4Click
      OnDblClick = imgLoco4Click
    end
    object imgVanTrolley1: TImage
      Left = 109
      Top = 14
      Width = 245
      Height = 126
      Cursor = crHandPoint
      Transparent = True
      Visible = False
      OnClick = imgVanScoopClick
      OnDblClick = imgVanScoopClick
    end
    object imgVanTrolley2: TImage
      Left = 177
      Top = 14
      Width = 245
      Height = 126
      Cursor = crHandPoint
      Transparent = True
      Visible = False
      OnClick = imgVanScoopClick
      OnDblClick = imgVanScoopClick
    end
    object imgRails: TImage
      Left = 2
      Top = 139
      Width = 575
      Height = 24
      AutoSize = True
      Transparent = True
    end
  end
end
