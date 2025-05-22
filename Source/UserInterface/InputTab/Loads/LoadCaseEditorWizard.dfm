object LoadCaseEditor: TLoadCaseEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Load Case Editor'
  ClientHeight = 711
  ClientWidth = 1484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object GridPanelMain: TGridPanel
    Left = 395
    Top = 0
    Width = 1089
    Height = 711
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
      Width = 1089
      Height = 676
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      ParentColor = True
      ParentShowHint = False
      ShowCaption = False
      ShowHint = True
      TabOrder = 0
      OnUpdateGraphics = JDBGraphic2DUpdateGraphics
    end
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 1009
      Top = 681
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
      Left = 924
      Top = 681
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
    Height = 711
    Margins.Right = 5
    Align = alLeft
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 105.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 110.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = ComboBoxLoadCase
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = PanelInputGrid
        Row = 2
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = ListBoxErrors
        Row = 3
      end
      item
        Column = 0
        Control = ButtonNewLoadCase
        Row = 0
      end
      item
        Column = 0
        Control = LabelCurrentLoadCase
        Row = 1
      end
      item
        Column = 2
        Control = ButtonDeleteLoadCase
        Row = 1
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
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
      Left = 110
      Top = 40
      Width = 170
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBoxLoadCaseChange
    end
    object PanelInputGrid: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 75
      Width = 385
      Height = 496
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LCInputGrid: TJDBStringGrid
        Left = 16
        Top = 40
        Width = 337
        Height = 137
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goFixedRowDefAlign]
        TabOrder = 0
        OnCellChanged = LCInputGridCellChanged
      end
    end
    object ListBoxErrors: TListBox
      AlignWithMargins = True
      Left = 5
      Top = 581
      Width = 385
      Height = 125
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ItemHeight = 15
      TabOrder = 2
    end
    object ButtonNewLoadCase: TButton
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 95
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'New Load Case'
      TabOrder = 3
      OnClick = ButtonNewLCClick
    end
    object LabelCurrentLoadCase: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 40
      Width = 100
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alTop
      AutoSize = False
      Caption = 'Current Load Case'
      Layout = tlCenter
      ExplicitTop = 5
      ExplicitWidth = 90
    end
    object ButtonDeleteLoadCase: TButton
      AlignWithMargins = True
      Left = 290
      Top = 40
      Width = 100
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Caption = 'Delete Load Case'
      TabOrder = 4
      OnClick = ButtonDeleteLoadCaseClick
    end
  end
end
