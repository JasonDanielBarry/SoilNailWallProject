object LoadCaseEditor: TLoadCaseEditor
  Left = 0
  Top = 0
  Caption = 'Load Case Editor'
  ClientHeight = 769
  ClientWidth = 1446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GridPanelMain: TGridPanel
    Left = 395
    Top = 0
    Width = 1051
    Height = 769
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 85.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 85.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 3
        Control = JDBGraphic2D
        Row = 0
      end
      item
        Column = 2
        Control = ButtonCancel
        Row = 1
      end
      item
        Column = 1
        Control = ButtonOK
        Row = 1
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end>
    TabOrder = 0
    object JDBGraphic2D: TJDBGraphic2D
      Left = 0
      Top = 0
      Width = 1051
      Height = 734
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      ParentColor = True
      ParentShowHint = False
      ShowCaption = False
      ShowHint = True
      TabOrder = 0
    end
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 971
      Top = 739
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object ButtonOK: TButton
      AlignWithMargins = True
      Left = 886
      Top = 739
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 2
    end
  end
  object GridPanelControls: TGridPanel
    Left = 0
    Top = 0
    Width = 395
    Height = 769
    Margins.Right = 5
    Align = alLeft
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 95.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = ComboBoxLoadCase
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = PanelInputGrid
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = ListBoxErrors
        Row = 2
      end
      item
        Column = 1
        Control = SpeedButtonNewLC
        Row = 0
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 33.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 135.000000000000000000
      end>
    TabOrder = 1
    object ComboBoxLoadCase: TComboBox
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 175
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 6
    end
    object PanelInputGrid: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 38
      Width = 383
      Height = 589
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 6
      ExplicitTop = 39
      object LCInputGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 353
        Height = 145
        Margins.Bottom = 5
        TabOrder = 0
      end
    end
    object ListBoxErrors: TListBox
      AlignWithMargins = True
      Left = 5
      Top = 637
      Width = 383
      Height = 125
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ItemHeight = 15
      TabOrder = 2
      ExplicitLeft = 6
      ExplicitTop = 638
    end
    object SpeedButtonNewLC: TSpeedButton
      AlignWithMargins = True
      Left = 303
      Top = 5
      Width = 85
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'Add Load Case'
      ExplicitLeft = 336
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
end
