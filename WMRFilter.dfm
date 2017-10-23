object frmFilter: TfrmFilter
  Left = 480
  Top = 240
  AlphaBlendValue = 180
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1060#1080#1083#1100#1090#1088
  ClientHeight = 190
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 18
  object btnOK: TButton
    Left = 184
    Top = 12
    Width = 96
    Height = 32
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnHide: TButton
    Left = 184
    Top = 152
    Width = 96
    Height = 32
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 3
    OnClick = btnHideClick
  end
  object btnClear: TButton
    Left = 184
    Top = 48
    Width = 96
    Height = 32
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    ModalResult = 1
    TabOrder = 2
    OnClick = btnClearClick
  end
  object gbDate: TGroupBox
    Left = 8
    Top = 4
    Width = 168
    Height = 178
    Caption = #1044#1072#1090#1072
    TabOrder = 0
    object lblDateFrom: TLabel
      Left = 8
      Top = 72
      Width = 62
      Height = 18
      Caption = #1053#1072#1095#1080#1085#1072#1103
      FocusControl = pckDateFrom
    end
    object lblDateTo: TLabel
      Left = 8
      Top = 124
      Width = 86
      Height = 18
      Caption = #1047#1072#1082#1072#1085#1095#1080#1074#1072#1103
      FocusControl = pckDateTo
    end
    object pckDateFrom: TDateTimePicker
      Left = 8
      Top = 92
      Width = 150
      Height = 26
      Date = 29674.471759247690000000
      Time = 29674.471759247690000000
      Enabled = False
      PopupMenu = pmDate
      TabOrder = 2
    end
    object rbtnDateAll: TRadioButton
      Left = 8
      Top = 24
      Width = 150
      Height = 18
      Caption = #1042#1089#1077' '#1079#1072#1087#1080#1089#1080
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbtnDateAllClick
    end
    object rbtnDateFromTo: TRadioButton
      Left = 8
      Top = 48
      Width = 150
      Height = 18
      Caption = #1054#1090#1088#1077#1079#1086#1082' '#1074#1088#1077#1084#1077#1085#1080
      TabOrder = 1
      OnClick = rbtnDateAllClick
    end
    object pckDateTo: TDateTimePicker
      Left = 8
      Top = 144
      Width = 150
      Height = 26
      Date = 29674.471759247690000000
      Time = 29674.471759247690000000
      Enabled = False
      PopupMenu = pmDate
      TabOrder = 3
    end
  end
  object pmDate: TPopupMenu
    Left = 200
    Top = 104
    object miDateFirstDay: TMenuItem
      Tag = 1
      Caption = #1053#1072#1095#1072#1083#1086' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      OnClick = miDateYesterdayClick
    end
    object miDateLastDay: TMenuItem
      Tag = 2
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      OnClick = miDateYesterdayClick
    end
    object miSeparator01: TMenuItem
      Caption = '-'
    end
    object miDateYesterday: TMenuItem
      Tag = 3
      Caption = #1042#1095#1077#1088#1072#1096#1085#1103#1103' '#1076#1072#1090#1072
      OnClick = miDateYesterdayClick
    end
    object miDateCurrent: TMenuItem
      Tag = 4
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      OnClick = miDateYesterdayClick
    end
  end
end
