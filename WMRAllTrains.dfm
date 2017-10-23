object frmAllTrains: TfrmAllTrains
  Left = 255
  Top = 202
  Caption = #1041#1072#1079#1072' '#1087#1086' '#1087#1086#1077#1079#1076#1072#1084
  ClientHeight = 473
  ClientWidth = 812
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 820
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object StatusBar: TStatusBar
    Left = 0
    Top = 453
    Width = 812
    Height = 20
    Panels = <
      item
        Text = 'Select records'
        Width = 200
      end
      item
        Text = 'Count records'
        Width = 200
      end
      item
        Alignment = taCenter
        Text = 'Filter'
        Width = 150
      end
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 812
    Height = 42
    AutoSize = True
    Bands = <
      item
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 38
        Width = 808
      end>
    FixedSize = True
    FixedOrder = True
    Images = Main.ImageList32
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 808
      Height = 38
      AutoSize = True
      ButtonHeight = 38
      ButtonWidth = 100
      Images = Main.ImageList32
      List = True
      ShowCaptions = True
      TabOrder = 0
      object tbtnEdit: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        ImageIndex = 1
        OnClick = tbtnEditClick
      end
      object tbtnDelete: TToolButton
        Left = 104
        Top = 0
        AutoSize = True
        Caption = #1059#1076#1072#1083#1080#1090#1100
        ImageIndex = 3
        OnClick = tbtnDeleteClick
      end
      object tbtnSeparator01: TToolButton
        Left = 199
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object tbtnUpdate: TToolButton
        Left = 207
        Top = 0
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        ImageIndex = 12
        OnClick = tbtnUpdateClick
      end
      object tbtnFilter: TToolButton
        Left = 307
        Top = 0
        AutoSize = True
        Caption = #1060#1080#1083#1100#1090#1088
        ImageIndex = 0
        OnClick = tbtnFilterClick
      end
      object tbtnSeparatorEnd: TToolButton
        Left = 397
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbtnClose: TToolButton
        Left = 405
        Top = 0
        AutoSize = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ImageIndex = 2
        OnClick = tbtnCloseClick
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 361
    Width = 812
    Height = 92
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      812
      92)
    object gbFilter: TGroupBox
      Left = 4
      Top = 4
      Width = 244
      Height = 77
      Caption = #1060#1080#1083#1100#1090#1088':'
      TabOrder = 0
      object eFilterDate: TLabeledEdit
        Left = 12
        Top = 40
        Width = 220
        Height = 24
        Color = clBtnFace
        EditLabel.Width = 32
        EditLabel.Height = 16
        EditLabel.Caption = #1044#1072#1090#1072':'
        ReadOnly = True
        TabOrder = 0
      end
    end
    object gbAll: TGroupBox
      Left = 270
      Top = 4
      Width = 536
      Height = 77
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1097#1080#1081' '#1074#1077#1089' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1079#1072#1087#1080#1089#1077#1081':'
      TabOrder = 1
      object eAllGross: TLabeledEdit
        Left = 12
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 44
        EditLabel.Height = 16
        EditLabel.Caption = #1041#1088#1091#1090#1090#1086':'
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
      object eAllTareBefore: TLabeledEdit
        Left = 100
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 50
        EditLabel.Height = 16
        EditLabel.Caption = #1058#1072#1088#1072' '#1076#1086':'
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
      object eAllTareAfter: TLabeledEdit
        Left = 184
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 41
        EditLabel.Height = 16
        EditLabel.Caption = #1055#1086#1089#1083#1077':'
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 2
      end
      object eAllLosses: TLabeledEdit
        Left = 268
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 46
        EditLabel.Height = 16
        EditLabel.Caption = #1055#1086#1090#1077#1088#1080':'
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 3
      end
      object eAllNetto: TLabeledEdit
        Left = 356
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 41
        EditLabel.Height = 16
        EditLabel.Caption = #1053#1077#1090#1090#1086':'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -13
        EditLabel.Font.Name = 'Arial'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
      object eAllClean: TLabeledEdit
        Left = 440
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 80
        EditLabel.Height = 16
        EditLabel.Caption = #1063#1080#1089#1090#1099#1081' '#1074#1077#1089':'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -13
        EditLabel.Font.Name = 'Arial'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
      end
    end
  end
  object PanelMain: TPanel
    Left = 0
    Top = 42
    Width = 812
    Height = 319
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DataList: TListView
      Left = 0
      Top = 0
      Width = 808
      Height = 315
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      Columns = <>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = DataListChange
      OnCompare = DataListCompare
      OnCustomDrawItem = DataListCustomDrawItem
      OnCustomDrawSubItem = DataListCustomDrawSubItem
      OnDblClick = DataListDblClick
      OnKeyDown = DataListKeyDown
      OnKeyPress = DataListKeyPress
    end
  end
  object SelTimer: TTimer
    Interval = 100
    OnTimer = SelTimerTimer
    Left = 20
    Top = 164
  end
end
