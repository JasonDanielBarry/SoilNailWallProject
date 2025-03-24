object NailLayoutGenForm: TNailLayoutGenForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nail Layout Generator'
  ClientHeight = 700
  ClientWidth = 1400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object GridPanelMain: TGridPanel
    Left = 0
    Top = 0
    Width = 1400
    Height = 700
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 250.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = PanelLeft
        Row = 0
        RowSpan = 2
      end
      item
        Column = 1
        Control = JDBGraphic2DDrawing
        Row = 0
      end
      item
        Column = 1
        Control = GridPanelCancelOK
        Row = 1
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end>
    TabOrder = 0
    object PanelLeft: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 700
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object GridPanelInputs: TGridPanel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 240
        Height = 150
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 110.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 60.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = LabelTopSpace
            Row = 0
          end
          item
            Column = 0
            Control = LabelNailSpacing
            Row = 1
          end
          item
            Column = 0
            Control = LabelTopLength
            Row = 2
          end
          item
            Column = 0
            Control = LabelBottomLength
            Row = 3
          end
          item
            Column = 1
            Control = ComboBoxTopSpace
            Row = 0
          end
          item
            Column = 1
            Control = ComboBoxNailSpacing
            Row = 1
          end
          item
            Column = 1
            Control = ComboBoxTopLength
            Row = 2
          end
          item
            Column = 1
            Control = ComboBoxBottomLength
            Row = 3
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 25.000000000000000000
          end
          item
            Value = 25.000000000000000000
          end
          item
            Value = 25.000000000000000000
          end
          item
            Value = 25.000000000000000000
          end>
        TabOrder = 0
        object LabelTopSpace: TLabel
          Left = 0
          Top = 0
          Width = 110
          Height = 38
          Align = alClient
          Caption = 'Top Space (m)'
          ExplicitWidth = 76
          ExplicitHeight = 15
        end
        object LabelNailSpacing: TLabel
          Left = 0
          Top = 38
          Width = 110
          Height = 37
          Align = alClient
          Caption = 'Nail Spacing (m)'
          ExplicitWidth = 88
          ExplicitHeight = 15
        end
        object LabelTopLength: TLabel
          Left = 0
          Top = 75
          Width = 110
          Height = 38
          Align = alClient
          Caption = 'Top Length (m)'
          ExplicitWidth = 82
          ExplicitHeight = 15
        end
        object LabelBottomLength: TLabel
          Left = 0
          Top = 113
          Width = 110
          Height = 37
          Align = alClient
          Caption = 'Bottom Length (m)'
          ExplicitWidth = 102
          ExplicitHeight = 15
        end
        object ComboBoxTopSpace: TComboBox
          Left = 110
          Top = 0
          Width = 60
          Height = 23
          Align = alTop
          TabOrder = 0
          OnChange = ComboBoxChange
          Items.Strings = (
            '0.5'
            '1.0'
            '1.5'
            '2.0')
        end
        object ComboBoxNailSpacing: TComboBox
          Left = 110
          Top = 38
          Width = 60
          Height = 23
          Align = alTop
          TabOrder = 1
          OnChange = ComboBoxChange
          Items.Strings = (
            '0.5'
            '1.0'
            '1.5'
            '2.0'
            '2.5')
        end
        object ComboBoxTopLength: TComboBox
          Left = 110
          Top = 75
          Width = 60
          Height = 23
          Align = alTop
          TabOrder = 2
          OnChange = ComboBoxChange
        end
        object ComboBoxBottomLength: TComboBox
          Left = 110
          Top = 113
          Width = 60
          Height = 23
          Align = alTop
          TabOrder = 3
          OnChange = ComboBoxChange
        end
      end
      object ListBoxErrors: TListBox
        AlignWithMargins = True
        Left = 5
        Top = 570
        Width = 240
        Height = 125
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        ItemHeight = 15
        TabOrder = 1
      end
    end
    object JDBGraphic2DDrawing: TJDBGraphic2D
      Left = 250
      Top = 0
      Width = 1150
      Height = 665
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      ParentColor = True
      ParentShowHint = False
      ShowCaption = False
      ShowHint = True
      TabOrder = 1
      OnUpdateGeometry = JDBGraphic2DDrawingUpdateGeometry
    end
    object GridPanelCancelOK: TGridPanel
      Left = 250
      Top = 665
      Width = 1150
      Height = 35
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
          Column = 2
          Control = ButtonCancel
          Row = 0
        end
        item
          Column = 1
          Control = ButtonOK
          Row = 0
        end>
      ParentColor = True
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 2
      object ButtonCancel: TButton
        AlignWithMargins = True
        Left = 1070
        Top = 5
        Width = 75
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 0
      end
      object ButtonOK: TButton
        AlignWithMargins = True
        Left = 985
        Top = 5
        Width = 75
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 1
      end
    end
  end
end
