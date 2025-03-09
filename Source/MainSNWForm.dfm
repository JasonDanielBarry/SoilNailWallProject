object SNWForm: TSNWForm
  Left = 0
  Top = 0
  Caption = 'Soil Nail Wall'
  ClientHeight = 804
  ClientWidth = 1751
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    1751
    804)
  TextHeight = 15
  object PageControlRibbon: TPageControl
    AlignWithMargins = True
    Left = 0
    Top = 2
    Width = 1751
    Height = 125
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = PageInput
    Align = alTop
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnChange = PageControlRibbonChange
    object PageFile: TTabSheet
      Caption = 'File'
      Enabled = False
    end
    object PageInput: TTabSheet
      Caption = 'Input'
      DoubleBuffered = True
      ImageIndex = 1
      ParentDoubleBuffered = False
      object GridPanelInputParOptions: TGridPanel
        Left = 225
        Top = 0
        Width = 225
        Height = 95
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alLeft
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            SizeStyle = ssAbsolute
            Value = 1.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = SpeedButtonLimitStateFactors
            Row = 0
          end
          item
            Column = 1
            Control = SpeedButtonAverageValues
            Row = 0
          end
          item
            Column = 2
            Control = SpeedButtonClearFactors
            Row = 0
          end
          item
            Column = 3
            Control = PanelInputFactorSeparator
            Row = 0
            RowSpan = 2
          end
          item
            Column = 0
            ColumnSpan = 3
            Control = LabelFactorOptions
            Row = 1
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        TabOrder = 0
        object SpeedButtonLimitStateFactors: TSpeedButton
          Left = 0
          Top = 0
          Width = 75
          Height = 75
          Action = ActionLimitStateFactors
          Align = alClient
          Flat = True
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          ExplicitLeft = 4
          ExplicitTop = -6
          ExplicitWidth = 74
          ExplicitHeight = 65
        end
        object SpeedButtonAverageValues: TSpeedButton
          Left = 75
          Top = 0
          Width = 74
          Height = 75
          Action = ActionAverageValues
          Align = alClient
          Flat = True
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          ExplicitLeft = 68
          ExplicitTop = -6
          ExplicitWidth = 75
          ExplicitHeight = 65
        end
        object SpeedButtonClearFactors: TSpeedButton
          Left = 149
          Top = 0
          Width = 75
          Height = 75
          Action = ActionClearFactors
          Align = alClient
          Flat = True
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          ExplicitLeft = 145
          ExplicitTop = -6
          ExplicitWidth = 74
          ExplicitHeight = 65
        end
        object PanelInputFactorSeparator: TPanel
          Left = 224
          Top = 0
          Width = 1
          Height = 95
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
        object LabelFactorOptions: TLabel
          Left = 0
          Top = 75
          Width = 224
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Material Factor Options'
          Layout = tlCenter
          ExplicitWidth = 124
          ExplicitHeight = 15
        end
      end
      object GridPanelInputType: TGridPanel
        Left = 0
        Top = 0
        Width = 225
        Height = 95
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alLeft
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            SizeStyle = ssAbsolute
            Value = 1.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 3
            Control = PanelInputTypeSeparator
            Row = 0
            RowSpan = 2
          end
          item
            Column = 0
            Control = SpeedButtonInputParameters
            Row = 0
          end
          item
            Column = 1
            Control = SpeedButtonWallGeometry
            Row = 0
          end
          item
            Column = 2
            Control = SpeedButtonNailLayout
            Row = 0
          end
          item
            Column = 0
            ColumnSpan = 3
            Control = LabelInputType
            Row = 1
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        TabOrder = 1
        object PanelInputTypeSeparator: TPanel
          Left = 224
          Top = 0
          Width = 1
          Height = 95
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          Color = clSilver
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
        object SpeedButtonInputParameters: TSpeedButton
          Left = 0
          Top = 0
          Width = 75
          Height = 75
          Action = ActionMaterialParameters
          Align = alClient
          AllowAllUp = True
          Caption = 'Material'#13#10'Parameters'
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = -6
          ExplicitTop = -6
        end
        object SpeedButtonWallGeometry: TSpeedButton
          Tag = 1
          Left = 75
          Top = 0
          Width = 74
          Height = 75
          Action = ActionWallGeometry
          Align = alClient
          AllowAllUp = True
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = 81
          ExplicitTop = -6
        end
        object SpeedButtonNailLayout: TSpeedButton
          Tag = 2
          Left = 149
          Top = 0
          Width = 75
          Height = 75
          Action = ActionNailProperties
          Align = alClient
          AllowAllUp = True
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = 147
          ExplicitTop = -6
        end
        object LabelInputType: TLabel
          Left = 0
          Top = 75
          Width = 224
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Input Type'
          Layout = tlCenter
          ExplicitWidth = 56
          ExplicitHeight = 15
        end
      end
      object GridPanelNailLayoutOptions: TGridPanel
        Left = 450
        Top = 0
        Width = 150
        Height = 95
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alLeft
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 1.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = SpeedButtonGenerateLayout
            Row = 0
          end
          item
            Column = 2
            Control = PanelNailLayoutSeparator
            Row = 0
            RowSpan = 2
          end
          item
            Column = 1
            Control = SpeedButtonClearLayout
            Row = 0
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = LabelNailLayoutOptions
            Row = 1
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        TabOrder = 2
        object SpeedButtonGenerateLayout: TSpeedButton
          Left = 0
          Top = 0
          Width = 74
          Height = 75
          Action = ActionGenerateLayout
          Align = alClient
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = -3
          ExplicitTop = -6
          ExplicitWidth = 75
          ExplicitHeight = 65
        end
        object PanelNailLayoutSeparator: TPanel
          Left = 149
          Top = 0
          Width = 1
          Height = 95
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
        object SpeedButtonClearLayout: TSpeedButton
          Left = 74
          Top = 0
          Width = 75
          Height = 75
          Margins.Top = 0
          Action = ActionClearLayout
          Align = alClient
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = 71
          ExplicitTop = -6
        end
        object LabelNailLayoutOptions: TLabel
          Left = 0
          Top = 75
          Width = 149
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Layout Options'
          Layout = tlCenter
          ExplicitWidth = 81
          ExplicitHeight = 15
        end
      end
      object GridPanelExamples: TGridPanel
        Left = 600
        Top = 0
        Width = 75
        Height = 95
        Align = alLeft
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 1.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = PanelExamplesSeparator
            Row = 0
            RowSpan = 2
          end
          item
            Column = 0
            Control = SpeedButton1
            Row = 0
          end
          item
            Column = 0
            Control = LabelExamples
            Row = 1
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        TabOrder = 3
        object PanelExamplesSeparator: TPanel
          Left = 74
          Top = 0
          Width = 1
          Height = 95
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
        object SpeedButton1: TSpeedButton
          Left = 0
          Top = 0
          Width = 74
          Height = 75
          Action = ActionExampleVerticalWallFlatSlope
          Align = alClient
          Caption = 'Vertical Wall'#13'Flat Slope'
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = -3
          ExplicitTop = -6
        end
        object LabelExamples: TLabel
          Left = 0
          Top = 75
          Width = 74
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Examples'
          Layout = tlCenter
          ExplicitWidth = 49
          ExplicitHeight = 15
        end
      end
    end
    object PageComputation: TTabSheet
      Caption = 'Compute'
      ImageIndex = 2
      object GridPanelComputationType: TGridPanel
        Left = 0
        Top = 0
        Width = 150
        Height = 95
        Align = alLeft
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 1.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = SpeedButtonAnalysis
            Row = 0
          end
          item
            Column = 1
            Control = SpeedButtonDesign
            Row = 0
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = LabelComputationType
            Row = 1
          end
          item
            Column = 2
            Control = PanelComputationTypeSeparator
            Row = 0
            RowSpan = 2
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        TabOrder = 0
        object SpeedButtonAnalysis: TSpeedButton
          Left = 0
          Top = 0
          Width = 74
          Height = 75
          Align = alClient
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Analysis'
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = -6
          ExplicitTop = -6
          ExplicitWidth = 75
        end
        object SpeedButtonDesign: TSpeedButton
          Left = 74
          Top = 0
          Width = 75
          Height = 75
          Align = alClient
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Design'
          Flat = True
          Layout = blGlyphTop
          ExplicitLeft = 81
          ExplicitTop = -6
        end
        object LabelComputationType: TLabel
          Left = 0
          Top = 75
          Width = 149
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Computation Type'
          Layout = tlCenter
          ExplicitWidth = 99
          ExplicitHeight = 15
        end
        object PanelComputationTypeSeparator: TPanel
          Left = 149
          Top = 0
          Width = 1
          Height = 95
          Align = alClient
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
      end
    end
    object PageOutput: TTabSheet
      Caption = 'Output'
      ImageIndex = 3
    end
  end
  object PageControlProgrammeFlow: TPageControl
    Left = 0
    Top = 127
    Width = 857
    Height = 677
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = PageWallGeometry
    Align = alLeft
    TabOrder = 1
    object PageMaterialParameters: TTabSheet
      Caption = 'Material Parameters'
      ImageIndex = 2
      DesignSize = (
        849
        647)
      object GridPanelInputHeadings: TGridPanel
        Left = 154
        Top = 0
        Width = 450
        Height = 40
        Margins.Left = 250
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        BevelOuter = bvNone
        Caption = 'GridPanelInputHeadings'
        ColumnCollection = <
          item
            Value = 16.666666666666670000
          end
          item
            Value = 16.666666666666670000
          end
          item
            Value = 16.666666666666670000
          end
          item
            Value = 16.666666666666670000
          end
          item
            Value = 16.666666666666670000
          end
          item
            Value = 16.666666666666650000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = LabelAveVal
            Row = 0
          end
          item
            Column = 1
            Control = LabelVarCoef
            Row = 0
          end
          item
            Column = 2
            Control = LabelDowngFact
            Row = 0
          end
          item
            Column = 3
            Control = LabelCauEst
            Row = 0
          end
          item
            Column = 4
            Control = LabelParFac
            Row = 0
          end
          item
            Column = 5
            Control = LabelDesVal
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        ShowCaption = False
        TabOrder = 0
        object LabelAveVal: TLabel
          Left = 0
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Average'#13#10'Value'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 43
          ExplicitHeight = 30
        end
        object LabelVarCoef: TLabel
          Left = 75
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Variation Coefficient'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 58
          ExplicitHeight = 30
        end
        object LabelDowngFact: TLabel
          Left = 150
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Downgrade Factor'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 64
          ExplicitHeight = 30
        end
        object LabelCauEst: TLabel
          Left = 225
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Cautious Estimate'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 50
          ExplicitHeight = 30
        end
        object LabelParFac: TLabel
          Left = 300
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Partial'#13#10'Factor'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 33
          ExplicitHeight = 30
        end
        object LabelDesVal: TLabel
          Left = 375
          Top = 0
          Width = 75
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Alignment = taCenter
          Caption = 'Design'#13#10'Value'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 36
          ExplicitHeight = 30
        end
      end
      object GridSoilParInput: TStringGrid
        Left = 23
        Top = 61
        Width = 593
        Height = 81
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 7
        DefaultColWidth = 74
        DefaultRowHeight = 19
        RowCount = 3
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs, goFixedRowDefAlign]
        ParentColor = True
        TabOrder = 1
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object GridSteelParInput: TStringGrid
        Left = 23
        Top = 201
        Width = 593
        Height = 62
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 7
        DefaultColWidth = 74
        DefaultRowHeight = 19
        RowCount = 2
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs, goFixedRowDefAlign]
        ParentColor = True
        TabOrder = 2
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object GridConcreteParInput: TStringGrid
        Left = 23
        Top = 345
        Width = 593
        Height = 57
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 7
        DefaultColWidth = 74
        DefaultRowHeight = 19
        RowCount = 2
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs, goFixedRowDefAlign]
        ParentColor = True
        TabOrder = 3
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object ListBoxMaterialProperties: TListBox
        Left = 5
        Top = 492
        Width = 350
        Height = 150
        Anchors = [akLeft, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 15
        TabOrder = 4
      end
    end
    object PageWallGeometry: TTabSheet
      Caption = 'Wall Geometry'
      DesignSize = (
        849
        647)
      object GridSlopeProperties: TStringGrid
        Left = 7
        Top = 146
        Width = 250
        Height = 89
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 2
        DefaultRowHeight = 19
        RowCount = 2
        FixedRows = 0
        GradientEndColor = clDefault
        GradientStartColor = clDefault
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
        ParentColor = True
        ScrollBars = ssNone
        TabOrder = 0
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object GridWallProperties: TStringGrid
        Left = 7
        Top = 30
        Width = 250
        Height = 89
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 2
        DefaultRowHeight = 19
        RowCount = 2
        FixedRows = 0
        GradientEndColor = clDefault
        GradientStartColor = clDefault
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
        ParentColor = True
        ScrollBars = ssNone
        TabOrder = 1
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object ListBoxWallGeom: TListBox
        Left = 3
        Top = 494
        Width = 250
        Height = 150
        Anchors = [akLeft, akBottom]
        ItemHeight = 15
        TabOrder = 2
      end
    end
    object PageNailProperties: TTabSheet
      Caption = 'Nail Properties'
      ImageIndex = 1
      DesignSize = (
        849
        647)
      object GridNailLayout: TStringGrid
        AlignWithMargins = True
        Left = 6
        Top = 104
        Width = 289
        Height = 105
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 4
        FixedCols = 2
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
        ParentColor = True
        TabOrder = 0
        OnKeyPress = GridNailLayoutKeyPress
        OnSelectCell = GridNailLayoutSelectCell
      end
      object GridNailProperties: TStringGrid
        Left = 7
        Top = 32
        Width = 250
        Height = 21
        Margins.Left = 0
        Margins.Right = 5
        BevelInner = bvNone
        BevelOuter = bvNone
        ColCount = 2
        DefaultRowHeight = 19
        RowCount = 1
        FixedRows = 0
        GradientEndColor = clDefault
        GradientStartColor = clDefault
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
        ParentColor = True
        ScrollBars = ssNone
        TabOrder = 1
        OnKeyPress = GridInputKeyPress
        OnSelectCell = GridInputSelectCell
      end
      object ListBoxNailProperties: TListBox
        Left = 3
        Top = 494
        Width = 250
        Height = 150
        Anchors = [akLeft, akBottom]
        ItemHeight = 15
        TabOrder = 2
      end
    end
  end
  object JDBGraphic2DDiagram: TJDBGraphic2D
    Left = 857
    Top = 127
    Width = 894
    Height = 677
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    ParentColor = True
    ParentShowHint = False
    ShowCaption = False
    ShowHint = True
    TabOrder = 2
    OnUpdateGeometry = JDBGraphic2DDiagramUpdateGeometry
  end
  object GridPanelTheme: TGridPanel
    Left = 1648
    Top = -1
    Width = 95
    Height = 23
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = LabelTheme
        Row = 0
      end
      item
        Column = 1
        Control = ComboBoxTheme
        Row = 0
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 3
    object LabelTheme: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 40
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 2
      Align = alClient
      Caption = 'Theme'
      Color = clBtnFace
      ParentColor = False
      Transparent = True
      Layout = tlCenter
      ExplicitWidth = 37
      ExplicitHeight = 15
    end
    object ComboBoxTheme: TComboBox
      Left = 40
      Top = 0
      Width = 55
      Height = 23
      Align = alClient
      Style = csDropDownList
      Color = clWhite
      TabOrder = 0
      OnChange = ComboBoxThemeChange
      Items.Strings = (
        'Light'
        'Dark')
    end
  end
  object ActionManager1: TActionManager
    Left = 1344
    Top = 170
    StyleName = 'Platform Default'
    object ActionWallGeometry: TAction
      Category = 'Input'
      Caption = 'Wall'#13'Geometry'
      OnExecute = ActionWallGeometryExecute
    end
    object ActionNailProperties: TAction
      Category = 'Input'
      Caption = 'Nail'#13'Properties'
      OnExecute = ActionNailPropertiesExecute
    end
    object ActionLimitStateFactors: TAction
      Category = 'InputParameters'
      Caption = 'Limit State'#13'Factors'
      OnExecute = ActionLimitStateFactorsExecute
    end
    object ActionAverageValues: TAction
      Category = 'InputParameters'
      Caption = 'Average'#13'Values'
      OnExecute = ActionAverageValuesExecute
    end
    object ActionClearFactors: TAction
      Category = 'InputParameters'
      Caption = 'Clear'#13'Factors'
      OnExecute = ActionClearFactorsExecute
    end
    object ActionGenerateLayout: TAction
      Category = 'InputNailProp'
      Caption = 'Generate'#13'Layout'
      OnExecute = ActionGenerateLayoutExecute
    end
    object ActionClearLayout: TAction
      Category = 'InputNailProp'
      Caption = 'Clear'#13'Layout'
      OnExecute = ActionClearLayoutExecute
    end
    object ActionExampleVerticalWallFlatSlope: TAction
      Category = 'Examples'
      Caption = 'Examples'
      OnExecute = ActionExampleVerticalWallFlatSlopeExecute
    end
    object ActionAnalysis: TAction
      Category = 'Analysis/Design'
      Caption = 'ActionAnalysis'
      OnExecute = ActionAnalysisExecute
    end
    object ActionMaterialParameters: TAction
      Category = 'Input'
      Caption = 'MaterialParameters'
      OnExecute = ActionMaterialParametersExecute
    end
    object ActionDarkTheme: TAction
      Category = 'Theme'
      Caption = 'Dark'
      OnExecute = ActionDarkThemeExecute
    end
    object ActionLightTheme: TAction
      Category = 'Theme'
      Caption = 'Light'
      OnExecute = ActionLightThemeExecute
    end
    object ActionNew: TAction
      Category = 'File'
      Caption = '&New'
      OnExecute = ActionNewExecute
    end
    object ActionOpen: TAction
      Category = 'File'
      Caption = '&Open'
      OnExecute = ActionOpenExecute
    end
    object ActionSave: TAction
      Category = 'File'
      Caption = '&Save'
    end
    object ActionSaveAs: TAction
      Category = 'File'
      Caption = 'Save &As'
      OnExecute = ActionSaveAsExecute
    end
  end
  object PopupMenuFile: TPopupMenu
    Left = 1248
    Top = 168
    object FMNew: TMenuItem
      Action = ActionNew
    end
    object FMOpen: TMenuItem
      Action = ActionOpen
    end
    object FMSave: TMenuItem
      Action = ActionSave
    end
    object FMSaveAs: TMenuItem
      Action = ActionSaveAs
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object FMTheme: TMenuItem
      Caption = '&Theme'
      object FMLightTheme: TMenuItem
        Action = ActionLightTheme
      end
      object FMDarkTheme: TMenuItem
        Action = ActionDarkTheme
      end
    end
  end
  object OpenFileDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 
      'C:\Users\jason\Documents\Embarcadero\Studio\Projects\DummyFile.s' +
      'nw'
    FileTypes = <
      item
        DisplayName = 'Soil Nail Wall File'
        FileMask = '*.snw'
      end>
    Options = []
    Left = 1249
    Top = 229
  end
  object SaveFileDialog: TFileSaveDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Soil Nail Wall File'
        FileMask = '*.snw'
      end>
    Options = []
    Left = 1337
    Top = 229
  end
end
