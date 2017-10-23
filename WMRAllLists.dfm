object frmAllLists: TfrmAllLists
  Left = 414
  Top = 253
  Caption = 'Caption'
  ClientHeight = 339
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object DataList: TListView
    Left = 0
    Top = 42
    Width = 433
    Height = 278
    Align = alClient
    Columns = <
      item
        Caption = 'Caption'
        Width = 100
      end>
    Constraints.MinHeight = 180
    Constraints.MinWidth = 260
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = DataListColumnClick
    OnCompare = DataListCompare
    OnCustomDrawItem = DataListCustomDrawItem
    OnCustomDrawSubItem = DataListCustomDrawSubItem
    OnKeyDown = DataListKeyDown
    OnSelectItem = DataListSelectItem
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 320
    Width = 433
    Height = 19
    Panels = <>
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 433
    Height = 42
    AutoSize = True
    Bands = <
      item
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 38
        Width = 429
      end>
    FixedSize = True
    FixedOrder = True
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 429
      Height = 38
      AutoSize = True
      ButtonHeight = 38
      ButtonWidth = 92
      Images = Main.ImageList32
      List = True
      ShowCaptions = True
      TabOrder = 0
      object tbtnDelete: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = #1059#1076#1072#1083#1080#1090#1100
        ImageIndex = 3
        Visible = False
        OnClick = tbtnDeleteClick
      end
      object tbtnSeparator01: TToolButton
        Left = 95
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 3
        Style = tbsSeparator
        Visible = False
      end
      object tbtnClose: TToolButton
        Left = 103
        Top = 0
        AutoSize = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ImageIndex = 2
        OnClick = tbtnCloseClick
      end
    end
  end
end
