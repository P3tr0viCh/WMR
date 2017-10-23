object frmVescom: TfrmVescom
  Left = 429
  Top = 327
  BorderIcons = [biMinimize]
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'. '#1052#1086#1076#1091#1083#1100' "'#1044#1080#1085#1072#1084#1080#1082#1072'"'
  ClientHeight = 124
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    374
    124)
  PixelsPerInch = 96
  TextHeight = 18
  object BevelBottom: TBevel
    Left = 8
    Top = 73
    Width = 358
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnCancel: TButton
    Left = 272
    Top = 83
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object pnlState: TPanel
    Left = 12
    Top = 20
    Width = 350
    Height = 42
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
  end
  object TimerState: TTimer
    Enabled = False
    OnTimer = TimerStateTimer
    Left = 24
    Top = 82
  end
end
