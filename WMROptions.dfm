object frmOptions: TfrmOptions
  Left = 379
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 402
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  DesignSize = (
    490
    402)
  PixelsPerInch = 96
  TextHeight = 18
  object BevelBottom: TBevel
    Left = 8
    Top = 350
    Width = 474
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 289
    Top = 360
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 387
    Top = 360
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object PanelMain: TPanel
    Left = 8
    Top = 8
    Width = 476
    Height = 334
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object PageControl: TPageControl
      Tag = 4
      Left = 0
      Top = 0
      Width = 472
      Height = 330
      ActivePage = tsProgram
      Align = alClient
      MultiLine = True
      TabOrder = 0
      OnChange = PageControlChange
      object tsProgram: TTabSheet
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072
        object gbVanLength: TGroupBox
          Left = 4
          Top = 150
          Width = 224
          Height = 60
          Caption = #1042#1099#1095#1080#1089#1083#1077#1085#1080#1077' '#1089#1082#1086#1088#1086#1089#1090#1080
          TabOrder = 2
          object lblVanLength: TLabel
            Left = 8
            Top = 28
            Width = 121
            Height = 18
            Caption = #1044#1083#1080#1085#1072' '#1074#1072#1075#1086#1085#1072', '#1084':'
            Layout = tlCenter
          end
          object eVanLength: TEdit
            Left = 136
            Top = 24
            Width = 80
            Height = 26
            TabOrder = 0
            OnKeyPress = eVanLengthKeyPress
          end
        end
        object gbComPort: TGroupBox
          Left = 302
          Top = 4
          Width = 146
          Height = 60
          Caption = #1055#1086#1088#1090' '#1080#1085#1076#1080#1082#1072#1090#1086#1088#1072
          TabOrder = 1
          object cboxComPort: TComboBox
            Left = 8
            Top = 24
            Width = 130
            Height = 26
            Style = csDropDownList
            DropDownCount = 2
            TabOrder = 0
          end
        end
        object gbWorkMode: TGroupBox
          Left = 4
          Top = 4
          Width = 281
          Height = 146
          Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
          TabOrder = 0
          object cboxAutoIssue: TCheckBox
            Left = 8
            Top = 120
            Width = 270
            Height = 18
            Caption = #1040#1074#1090#1086#1080#1085#1082#1088#1077#1084#1077#1085#1090' '#1085#1086#1084#1077#1088#1072' '#1074#1099#1087#1091#1089#1082#1072
            TabOrder = 4
            WordWrap = True
          end
          object cboxCanManualAdd: TCheckBox
            Left = 8
            Top = 48
            Width = 270
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1088#1091#1095#1085#1086#1081' '#1074#1074#1086#1076
            TabOrder = 1
          end
          object cboxCanAutoAdd: TCheckBox
            Left = 8
            Top = 72
            Width = 270
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1074#1074#1086#1076
            TabOrder = 2
          end
          object cboxCanEdit: TCheckBox
            Left = 8
            Top = 24
            Width = 270
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
            TabOrder = 0
            OnClick = cboxCanEditClick
          end
          object cboxCanDelete: TCheckBox
            Left = 8
            Top = 96
            Width = 270
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1087#1080#1089#1077#1081
            TabOrder = 3
          end
        end
        object gbVanNumDefault: TGroupBox
          Left = 234
          Top = 150
          Width = 224
          Height = 60
          Caption = #8470' '#1074#1072#1075#1086#1085#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          TabOrder = 3
          object eVanNumDefault: TEdit
            Left = 8
            Top = 24
            Width = 208
            Height = 26
            MaxLength = 8
            TabOrder = 0
            OnKeyPress = eVanProtectKeyPress
          end
        end
      end
      object tsScales: TTabSheet
        Caption = #1042#1077#1089#1099
        ImageIndex = 3
        object gbPlace: TGroupBox
          Left = 4
          Top = 64
          Width = 224
          Height = 60
          Caption = #1052#1077#1089#1090#1086' '#1091#1089#1090#1072#1085#1086#1074#1082#1080
          TabOrder = 1
          object ePlace: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 127
            TabOrder = 0
          end
        end
        object gbScales: TGroupBox
          Left = 4
          Top = 4
          Width = 120
          Height = 60
          Caption = #1053#1086#1084#1077#1088' '#1074#1077#1089#1086#1074
          TabOrder = 0
          object eScales: TSpinEdit
            Left = 8
            Top = 24
            Width = 104
            Height = 28
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object gbType: TGroupBox
          Left = 234
          Top = 64
          Width = 224
          Height = 60
          Caption = #1058#1080#1087
          TabOrder = 2
          object eType: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 15
            TabOrder = 0
          end
        end
        object gbSClass: TGroupBox
          Left = 4
          Top = 124
          Width = 224
          Height = 60
          Caption = #1050#1083#1072#1089#1089' '#1090#1086#1095#1085#1086#1089#1090#1080' '#1074' '#1089#1090#1072#1090#1080#1082#1077
          TabOrder = 3
          object cboxSClass: TComboBox
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            DropDownCount = 4
            MaxLength = 7
            TabOrder = 0
            Items.Strings = (
              #1057#1087#1077#1094#1080#1072#1083#1100#1085#1099#1081
              #1042#1099#1089#1086#1082#1080#1081
              #1057#1088#1077#1076#1085#1080#1081
              #1054#1073#1099#1095#1085#1099#1081)
          end
        end
        object gbDClass: TGroupBox
          Left = 234
          Top = 124
          Width = 224
          Height = 60
          Caption = #1050#1083#1072#1089#1089' '#1090#1086#1095#1085#1086#1089#1090#1080' '#1074' '#1076#1080#1085#1072#1084#1080#1082#1077
          TabOrder = 4
          object cboxDClass: TComboBox
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            DropDownCount = 4
            MaxLength = 7
            TabOrder = 0
            Items.Strings = (
              '0.2'
              '0.5'
              '1'
              '2')
          end
        end
      end
      object tsMySQL: TTabSheet
        Caption = 'MySQL'
        ImageIndex = 4
        object gbMySQLBruttoAdd: TGroupBox
          Left = 4
          Top = 88
          Width = 454
          Height = 60
          Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1086' '#1089#1083#1077#1076#1091#1102#1097#1080#1093' '#1074#1077#1089#1086#1074
          TabOrder = 1
          object eMySQLBruttoAdd: TEdit
            Left = 8
            Top = 24
            Width = 436
            Height = 26
            TabOrder = 0
            OnKeyPress = eMySQLBruttoAddKeyPress
          end
        end
        object cboxMySQLBruttoSave: TCheckBox
          Left = 4
          Top = 16
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1073#1088#1091#1090#1090#1086' '#1085#1072' '#1089#1077#1088#1074#1077#1088
          TabOrder = 0
        end
        object cboxMySQLTareSave: TCheckBox
          Left = 4
          Top = 40
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1090#1072#1088#1091' '#1089' '#1089#1077#1088#1074#1077#1088#1072
          TabOrder = 2
        end
        object cboxMySQLIssueSave: TCheckBox
          Left = 4
          Top = 64
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1085#1086#1084#1077#1088' '#1074#1099#1087#1091#1089#1082#1072' '#1089' '#1089#1077#1088#1074#1077#1088#1072
          TabOrder = 3
        end
      end
      object tsMySQLOptions: TTabSheet
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' MySQL'
        ImageIndex = 11
        object gbMySQLIP: TGroupBox
          Left = 4
          Top = 4
          Width = 224
          Height = 60
          Caption = 'IP-'#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
          TabOrder = 0
          object eMySQLIP: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 15
            TabOrder = 0
          end
        end
        object gbMySQLPort: TGroupBox
          Left = 234
          Top = 4
          Width = 224
          Height = 60
          Caption = #1055#1086#1088#1090
          TabOrder = 1
          object eMySQLPort: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 5
            TabOrder = 0
            Text = '3306'
            OnKeyPress = eMySQLPortKeyPress
          end
        end
        object gbMySQLUser: TGroupBox
          Left = 4
          Top = 64
          Width = 224
          Height = 60
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          TabOrder = 2
          object eMySQLUser: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 50
            TabOrder = 0
          end
        end
        object gbMySQLPass: TGroupBox
          Left = 234
          Top = 64
          Width = 224
          Height = 60
          Caption = #1055#1072#1088#1086#1083#1100
          TabOrder = 3
          object eMySQLPass: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 50
            PasswordChar = '#'
            TabOrder = 0
          end
        end
      end
      object tsAvitek: TTabSheet
        Caption = #1040#1074#1080#1090#1077#1082
        ImageIndex = 10
        object cboxAvitekUse: TCheckBox
          Left = 4
          Top = 16
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1085#1072' '#1089#1077#1088#1074#1077#1088', '#1080#1089#1087#1086#1083#1100#1079#1091#1103' '#1084#1086#1076#1091#1083#1100' "'#1040#1074#1080#1090#1077#1082'"'
          TabOrder = 0
          OnClick = cboxAvitekUseClick
        end
        object gbAvitekPath: TGroupBox
          Left = 4
          Top = 40
          Width = 454
          Height = 60
          Caption = #1055#1091#1090#1100' '#1082' '#1084#1086#1076#1091#1083#1102' "'#1040#1074#1080#1090#1077#1082'"'
          TabOrder = 1
          object peAvitekPath: TPathEdit
            Left = 8
            Top = 24
            Width = 412
            Height = 26
            TabOrder = 0
            Button.Left = 420
            Button.Top = 25
            Button.Width = 24
            Button.Height = 24
            Button.Caption = '...'
            Button.TabOrder = 1
            OpenFileDialog.Filter = 'EXE '#1092#1072#1081#1083#1099'|*.exe|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
            OpenFileDialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
            OpenFolderDialog.RootFolder = foMyComputer
            OpenFolderDialog.SyncCustomButton = False
            OpenFolderDialog.Position = bpCenter
            OpenFolderDialog.PositionLeft = 0
            OpenFolderDialog.PositionTop = 0
            RelativePath = False
          end
        end
      end
      object tsVanMode: TTabSheet
        Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1077' '#1074#1072#1075#1086#1085#1086#1074
        ImageIndex = 1
        object gbVanMode: TGroupBox
          Left = 4
          Top = 4
          Width = 456
          Height = 242
          Caption = #1042#1072#1075#1086#1085#1099
          TabOrder = 0
          object lblScoops: TLabel
            Left = 32
            Top = 48
            Width = 400
            Height = 21
            AutoSize = False
            Caption = #1058#1086#1083#1100#1082#1086' '#1095#1077#1090#1099#1088#1105#1093#1086#1089#1085#1099#1077' '#1074#1072#1075#1086#1085#1099' '#1087#1077#1088#1077#1076' '#1080#1083#1080' '#1087#1086#1089#1083#1077' '#1090#1077#1087#1083#1086#1074#1086#1079#1072
            FocusControl = rbtnScoops
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
            OnClick = lblScoopsClick
          end
          object lblTrolleys: TLabel
            Left = 32
            Top = 100
            Width = 400
            Height = 37
            AutoSize = False
            Caption = 
              #1044#1074#1091#1093#1086#1089#1085#1099#1077' '#1074#1072#1075#1086#1085#1099' '#1087#1077#1088#1077#1076' '#1080#1083#1080' '#1087#1086#1089#1083#1077' '#1090#1077#1087#1083#1086#1074#1086#1079#1072', '#1084#1077#1078#1076#1091' '#1090#1077#1087#1083#1086#1074#1086#1079#1086#1084' '#1080' '#1074 +
              #1072#1075#1086#1085#1072#1084#1080' '#1095#1077#1090#1099#1088#1105#1093#1086#1089#1085#1099#1081' '#1074#1072#1075#1086#1085' '#1087#1088#1080#1082#1088#1099#1090#1080#1103
            FocusControl = rbtnTrolleys
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
            OnClick = lblScoopsClick
          end
          object rbtnScoops: TRadioButton
            Left = 8
            Top = 28
            Width = 221
            Height = 18
            Caption = #1063#1091#1075#1091#1085#1086#1074#1086#1079#1085#1099#1077' '#1082#1086#1074#1096#1080
            TabOrder = 0
            OnClick = rbtnScoopsClick
          end
          object rbtnTrolleys: TRadioButton
            Left = 8
            Top = 80
            Width = 201
            Height = 18
            Caption = #1052#1091#1083#1100#1076#1086#1074#1099#1077' '#1090#1077#1083#1077#1078#1082#1080
            TabOrder = 1
            OnClick = rbtnScoopsClick
          end
          object rbtnOtherVans: TRadioButton
            Left = 8
            Top = 134
            Width = 201
            Height = 18
            Caption = #1044#1088#1091#1075#1086#1077
            TabOrder = 2
            OnClick = rbtnScoopsClick
          end
          object gbOtherVans: TGroupBox
            Left = 8
            Top = 156
            Width = 326
            Height = 78
            Caption = #1063#1080#1089#1083#1086' '#1086#1089#1077#1081
            TabOrder = 3
            object eVanProtect: TLabeledEdit
              Left = 8
              Top = 42
              Width = 150
              Height = 26
              EditLabel.Width = 128
              EditLabel.Height = 18
              EditLabel.Caption = #1042#1072#1075#1086#1085' '#1087#1088#1080#1082#1088#1099#1090#1080#1103':'
              TabOrder = 0
              OnKeyPress = eVanProtectKeyPress
            end
            object eAxisOneVan: TLabeledEdit
              Left = 166
              Top = 42
              Width = 150
              Height = 26
              EditLabel.Width = 143
              EditLabel.Height = 18
              EditLabel.Caption = #1054#1089#1090#1072#1083#1100#1085#1099#1077' '#1074#1072#1075#1086#1085#1099':'
              TabOrder = 1
              OnKeyPress = eVanProtectKeyPress
            end
          end
        end
      end
      object tsUsers: TTabSheet
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
        ImageIndex = 3
        object lvUsers: TListView
          Tag = 1
          Left = 4
          Top = 4
          Width = 456
          Height = 200
          Columns = <
            item
              Caption = #1048#1084#1103
              Width = 200
            end
            item
              Caption = #1055#1072#1088#1086#1083#1100
              Width = 200
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUsersChange
          OnCompare = lvUsersCompare
          OnDblClick = btnUserChangeClick
        end
        object btnUserAdd: TButton
          Tag = 1
          Left = 4
          Top = 212
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnUserDelete: TButton
          Tag = 1
          Left = 200
          Top = 212
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnUserChange: TButton
          Tag = 1
          Left = 102
          Top = 212
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
      object tsReceivers: TTabSheet
        Caption = #1043#1088#1091#1079#1086#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
        ImageIndex = 5
        object lvReceivers: TListView
          Tag = 2
          Left = 4
          Top = 4
          Width = 456
          Height = 200
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvReceiversChange
          OnCompare = lvReceiversCompare
          OnDblClick = btnUserChangeClick
        end
        object btnReceiverAdd: TButton
          Tag = 2
          Left = 4
          Top = 212
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnReceiverDelete: TButton
          Tag = 2
          Left = 200
          Top = 212
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnReceiverChange: TButton
          Tag = 2
          Left = 102
          Top = 212
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
      object tsBakes: TTabSheet
        Caption = #1053#1086#1084#1077#1088#1072' '#1087#1077#1095#1077#1081
        ImageIndex = 6
        object lvBakes: TListView
          Tag = 3
          Left = 4
          Top = 4
          Width = 456
          Height = 200
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvBakesChange
          OnCompare = lvReceiversCompare
          OnDblClick = btnUserChangeClick
        end
        object btnBakeAdd: TButton
          Tag = 3
          Left = 4
          Top = 212
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnBakeDelete: TButton
          Tag = 3
          Left = 200
          Top = 212
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnBakeChange: TButton
          Tag = 3
          Left = 102
          Top = 212
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
      object tsVanTypes: TTabSheet
        Caption = #1058#1080#1087#1099' '#1074#1072#1075#1086#1085#1086#1074
        ImageIndex = 7
        object lvVanTypes: TListView
          Tag = 4
          Left = 4
          Top = 4
          Width = 456
          Height = 200
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvVanTypesChange
          OnCompare = lvReceiversCompare
          OnDblClick = btnUserChangeClick
        end
        object btnVanTypeAdd: TButton
          Tag = 4
          Left = 4
          Top = 212
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnVanTypeChange: TButton
          Tag = 4
          Left = 102
          Top = 212
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
        object btnVanTypeDelete: TButton
          Tag = 4
          Left = 200
          Top = 212
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
      end
      object tsCargoTypes: TTabSheet
        Caption = #1056#1086#1076#1099' '#1075#1088#1091#1079#1086#1074
        ImageIndex = 8
        object lvCargoTypes: TListView
          Tag = 5
          Left = 4
          Top = 4
          Width = 456
          Height = 200
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvCargoTypesChange
          OnCompare = lvReceiversCompare
          OnDblClick = btnUserChangeClick
        end
        object btnCargoTypeAdd: TButton
          Tag = 5
          Left = 4
          Top = 212
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnCargoTypeChange: TButton
          Tag = 5
          Left = 102
          Top = 212
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
        object btnCargoTypeDelete: TButton
          Tag = 5
          Left = 200
          Top = 212
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
      end
      object tsTerminal: TTabSheet
        Caption = #1058#1080#1087' '#1087#1088#1080#1073#1086#1088#1072
        ImageIndex = 9
        object gbTerminal: TGroupBox
          Left = 4
          Top = 4
          Width = 456
          Height = 242
          Caption = #1055#1088#1080#1073#1086#1088#1099
          TabOrder = 0
          object Label1: TLabel
            Left = 32
            Top = 48
            Width = 420
            Height = 23
            AutoSize = False
            Caption = #1042#1077#1089#1086#1074#1086#1081' '#1080#1085#1076#1080#1082#1072#1090#1086#1088' CAS CI-6000A, '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1085#1099#1081' '#1095#1077#1088#1077#1079' COM-'#1087#1086#1088#1090
            FocusControl = rbtnCAS
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
            OnClick = lblScoopsClick
          end
          object Label2: TLabel
            Left = 32
            Top = 128
            Width = 400
            Height = 39
            AutoSize = False
            Caption = 
              #1055#1088#1086#1075#1088#1072#1084#1084#1085#1099#1081' '#1084#1086#1076#1091#1083#1100' "'#1044#1080#1085#1072#1084#1080#1082#1072'", '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082' '#1054#1054#1054' "'#1042#1077#1089#1082#1086#1084'", '#1074#1077#1088#1089#1080#1103' ' +
              '7.1.3.0'
            FocusControl = rbtnVescom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
            OnClick = lblScoopsClick
          end
          object rbtnCAS: TRadioButton
            Left = 8
            Top = 28
            Width = 221
            Height = 18
            Caption = 'CAS'
            TabOrder = 0
            OnClick = rbtnCASClick
          end
          object rbtnVescom: TRadioButton
            Left = 8
            Top = 108
            Width = 201
            Height = 18
            Caption = #1042#1077#1089#1082#1086#1084
            TabOrder = 1
            OnClick = rbtnCASClick
          end
          object gbVescomPath: TGroupBox
            Left = 8
            Top = 174
            Width = 440
            Height = 60
            Caption = #1050#1072#1090#1072#1083#1086#1075' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' "'#1042#1077#1089#1082#1086#1084'"'
            TabOrder = 2
            object peVescomPath: TPathEdit
              Left = 8
              Top = 24
              Width = 398
              Height = 26
              TabOrder = 0
              Button.Left = 406
              Button.Top = 25
              Button.Width = 24
              Button.Height = 24
              Button.Caption = '...'
              Button.TabOrder = 1
              OpenFileDialog.Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
              OpenFileDialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
              OpenFolderDialog.RootFolder = foMyComputer
              OpenFolderDialog.SyncCustomButton = False
              OpenFolderDialog.Position = bpCenter
              OpenFolderDialog.PositionLeft = 0
              OpenFolderDialog.PositionTop = 0
              WhatShow = wsOpenFolder
              RelativePath = False
            end
          end
        end
      end
    end
  end
  object btnLoad: TButton
    Left = 110
    Top = 360
    Width = 94
    Height = 32
    Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object btnSave: TButton
    Left = 8
    Top = 360
    Width = 94
    Height = 32
    Caption = #1042' '#1092#1072#1081#1083'...'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'INI-'#1092#1072#1081#1083#1099' (*.ini)|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofCreatePrompt, ofEnableSizing, ofDontAddToRecent]
    Left = 212
    Top = 362
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'INI-'#1092#1072#1081#1083#1099' (*.ini)|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 240
    Top = 362
  end
end
