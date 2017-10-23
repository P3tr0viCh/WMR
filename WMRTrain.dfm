object frmTrain: TfrmTrain
  Left = 71
  Top = 173
  Caption = #1055#1086#1077#1079#1076
  ClientHeight = 473
  ClientWidth = 1016
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 676
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object DataList: TListView
    Left = 0
    Top = 95
    Width = 1016
    Height = 266
    Align = alClient
    Color = clWhite
    Columns = <
      item
        Caption = #8470' '#1087'/'#1087
        Width = 60
      end
      item
        Caption = #1042#1088#1077#1084#1103
        Width = 60
      end
      item
        Caption = #8470' '#1087#1077#1095#1080
        Width = 60
      end
      item
        Caption = #8470' '#1074#1099#1087#1091#1089#1082#1072
        Width = 60
      end
      item
        Caption = #8470' '#1074#1072#1075#1086#1085#1072
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1041#1088#1091#1090#1090#1086
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1058#1072#1088#1072' '#1076#1086
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1058#1072#1088#1072' '#1087#1086#1089#1083#1077
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1055#1086#1090#1077#1088#1080
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1053#1077#1090#1090#1086
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = #1063#1080#1089#1090#1099#1081' '#1074#1077#1089
        Width = 60
      end
      item
        Caption = #1058#1080#1087' '#1074#1072#1075#1086#1085#1072
      end
      item
        Caption = #1056#1086#1076' '#1075#1088#1091#1079#1072
      end
      item
        Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
        Width = 60
      end
      item
        Alignment = taCenter
        Caption = #1057#1077#1090#1100
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawSubItem = DataListCustomDrawSubItem
    OnKeyDown = DataListKeyDown
    OnSelectItem = DataListSelectItem
  end
  object PanelTop: TPanel
    Left = 0
    Top = 42
    Width = 1016
    Height = 53
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object lblReceiver: TLabel
      Left = 846
      Top = 5
      Width = 74
      Height = 16
      Caption = #1055#1086#1083#1091'&'#1095#1072#1090#1077#1083#1100':'
      FocusControl = cboxReceiver
    end
    object lblBake: TLabel
      Left = 108
      Top = 5
      Width = 50
      Height = 16
      Caption = #8470' &'#1087#1077#1095#1080':'
      FocusControl = cboxBake
    end
    object lblVanType: TLabel
      Left = 574
      Top = 5
      Width = 68
      Height = 16
      Caption = #1058'&'#1080#1087' '#1074#1072#1075#1086#1085#1072':'
      FocusControl = cboxVanType
    end
    object lblCargoType: TLabel
      Left = 700
      Top = 5
      Width = 63
      Height = 16
      Caption = #1056#1086#1076' '#1075#1088#1091'&'#1079#1072':'
      FocusControl = cboxCargoType
    end
    object eDate: TLabeledEdit
      Left = 12
      Top = 24
      Width = 90
      Height = 24
      Color = clBtnFace
      Ctl3D = True
      EditLabel.Width = 32
      EditLabel.Height = 16
      EditLabel.Caption = #1044#1072#1090#1072':'
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      OnChange = eSpeedChange
    end
    object eIssue: TLabeledEdit
      Left = 174
      Top = 24
      Width = 74
      Height = 24
      Ctl3D = True
      EditLabel.Width = 72
      EditLabel.Height = 16
      EditLabel.Caption = #8470' &'#1074#1099#1087#1091#1089#1082#1072':'
      MaxLength = 16
      ParentCtl3D = False
      TabOrder = 2
      OnChange = eBakeChange
      OnKeyDown = eBakeKeyDown
      OnKeyPress = eBakeKeyPress
    end
    object eScoop: TLabeledEdit
      Left = 254
      Top = 24
      Width = 74
      Height = 24
      Ctl3D = True
      EditLabel.Width = 62
      EditLabel.Height = 16
      EditLabel.Caption = #8470' '#1074#1072'&'#1075#1086#1085#1072':'
      MaxLength = 8
      ParentCtl3D = False
      TabOrder = 3
      OnChange = eBakeChange
      OnKeyDown = eBakeKeyDown
      OnKeyPress = eBakeKeyPress
    end
    object eTareBefore: TLabeledEdit
      Left = 414
      Top = 24
      Width = 74
      Height = 24
      Ctl3D = True
      EditLabel.Width = 50
      EditLabel.Height = 16
      EditLabel.Caption = #1058'&'#1072#1088#1072' '#1076#1086':'
      ParentCtl3D = False
      TabOrder = 5
      OnChange = eBakeChange
      OnExit = eTareBeforeExit
      OnKeyDown = eBakeKeyDown
      OnKeyPress = eTareBeforeKeyPress
    end
    object eTareAfter: TLabeledEdit
      Left = 494
      Top = 24
      Width = 74
      Height = 24
      Ctl3D = True
      EditLabel.Width = 41
      EditLabel.Height = 16
      EditLabel.Caption = #1055#1086#1089'&'#1083#1077':'
      ParentCtl3D = False
      TabOrder = 6
      OnChange = eBakeChange
      OnExit = eTareBeforeExit
      OnKeyDown = eBakeKeyDown
      OnKeyPress = eTareBeforeKeyPress
    end
    object eGross: TLabeledEdit
      Left = 334
      Top = 24
      Width = 74
      Height = 24
      Color = clBtnFace
      Ctl3D = True
      EditLabel.Width = 44
      EditLabel.Height = 16
      EditLabel.Caption = #1041#1088'&'#1091#1090#1090#1086':'
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 4
      OnChange = eBakeChange
      OnKeyDown = eBakeKeyDown
      OnKeyPress = eTareBeforeKeyPress
    end
    object cboxReceiver: TComboBox
      Left = 846
      Top = 24
      Width = 140
      Height = 24
      Style = csDropDownList
      DropDownCount = 20
      TabOrder = 9
      OnChange = eBakeChange
    end
    object cboxBake: TComboBox
      Left = 108
      Top = 24
      Width = 60
      Height = 24
      Style = csDropDownList
      DropDownCount = 10
      TabOrder = 1
      OnChange = eBakeChange
    end
    object cboxVanType: TComboBox
      Left = 574
      Top = 24
      Width = 120
      Height = 24
      Style = csDropDownList
      DropDownCount = 10
      TabOrder = 7
      OnChange = eBakeChange
    end
    object cboxCargoType: TComboBox
      Left = 700
      Top = 24
      Width = 140
      Height = 24
      Style = csDropDownList
      DropDownCount = 10
      TabOrder = 8
      OnChange = eBakeChange
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 453
    Width = 1016
    Height = 20
    Panels = <
      item
        Width = 200
      end
      item
        Width = 22
      end
      item
        Width = 350
      end>
    ParentFont = True
    UseSystemFont = False
    OnResize = StatusBarResize
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 361
    Width = 1016
    Height = 92
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      1016
      92)
    object gbAll: TGroupBox
      Left = 474
      Top = 4
      Width = 536
      Height = 77
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1097#1080#1081' '#1074#1077#1089' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1079#1072#1087#1080#1089#1077#1081':'
      TabOrder = 0
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
    object gbSpeed: TGroupBox
      Left = 4
      Top = 4
      Width = 108
      Height = 62
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100', '#1082#1084'/'#1095':'
      TabOrder = 1
      object eSpeed: TEdit
        Left = 12
        Top = 24
        Width = 84
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '0'
        OnChange = eSpeedChange
      end
    end
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 1016
    Height = 42
    AutoSize = True
    Bands = <
      item
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 38
        Width = 1010
      end>
    FixedSize = True
    FixedOrder = True
    object ToolBar: TToolBar
      Left = 2
      Top = 0
      Width = 1010
      Height = 38
      AutoSize = True
      ButtonHeight = 38
      ButtonWidth = 120
      Images = Main.ImageList32
      List = True
      ShowCaptions = True
      TabOrder = 0
      object tbtnStop: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
        ImageIndex = 5
        OnClick = tbtnStopClick
      end
      object tbtnTaresLoad: TToolButton
        Left = 116
        Top = 0
        AutoSize = True
        Caption = #1058#1072#1088#1072' '#1080#1079' '#1073#1072#1079#1099
        ImageIndex = 6
        OnClick = tbtnTaresLoadClick
      end
      object tbtnTaresSave: TToolButton
        Left = 240
        Top = 0
        AutoSize = True
        Caption = #1058#1072#1088#1091' '#1074' '#1073#1072#1079#1091
        ImageIndex = 7
        OnClick = tbtnTaresLoadClick
      end
      object tbtnSeparator01: TToolButton
        Left = 356
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbtnAdd: TToolButton
        Left = 364
        Top = 0
        AutoSize = True
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        ImageIndex = 1
        OnClick = tbtnAddClick
      end
      object tbtnDelete: TToolButton
        Left = 467
        Top = 0
        AutoSize = True
        Caption = #1059#1076#1072#1083#1080#1090#1100
        ImageIndex = 3
        OnClick = tbtnDeleteClick
      end
      object tbtnSeparatorEnd: TToolButton
        Left = 562
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbtnClose: TToolButton
        Left = 570
        Top = 0
        AutoSize = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ImageIndex = 2
        OnClick = tbtnCloseClick
      end
    end
  end
  object ComPort: TApdComPort
    Baud = 9600
    PromptForPort = False
    TraceName = 'APRO.TRC'
    LogName = 'APRO.LOG'
    LogHex = False
    OnTriggerAvail = ComPortTriggerAvail
    OnTriggerData = ComPortTriggerData
    Left = 44
    Top = 148
  end
end
