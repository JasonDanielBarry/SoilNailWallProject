unit MainSNWForm;

//Copyright Jason Barry 2024

interface

    uses
        //Delphi
            Winapi.Windows, Winapi.Messages,
            System.SysUtils, System.Variants, System.Classes, system.Types, system.UITypes,
            Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
            Vcl.StdCtrls, Vcl.Buttons,
            System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
            Vcl.ActnMan, Vcl.Themes, Vcl.WinXCtrls, Vcl.Menus, Vcl.TitleBarCtrls,
        //custom
            GeneralComponentHelperMethods,
            StringGridHelperClass,
            PageControlHelperClass,
            SoilNailWallMasterClass,
            UISetupMethods,
            SNWUITypes,
            InputParametersTabManagement, WallGeometryTabManagement, NailPropertiesTabManagement, NailLayoutGenerator,
            SoilNailWallExampleMethods, CustomComponentPanelClass,
            Graphic2DComponent, GraphicDrawerObjectAdderClass
            ;

    type
        TSNWForm = class(TForm)
            PageControlProgrammeFlow: TPageControl;
            PageWallGeometry: TTabSheet;
            GridWallProperties: TStringGrid;
            GridNailProperties: TStringGrid;
            PageNailProperties: TTabSheet;
            PageInputParameters: TTabSheet;
            GridPanelInputHeadings: TGridPanel;
            LabelAveVal: TLabel;
            LabelVarCoef: TLabel;
            LabelDowngFact: TLabel;
            LabelCauEst: TLabel;
            LabelParFac: TLabel;
            LabelDesVal: TLabel;
            GridSoilParInput: TStringGrid;
            GridSteelParInput: TStringGrid;
            GridConcreteParInput: TStringGrid;
            PageControlRibbon: TPageControl;
            PageFile: TTabSheet;
            PageInput: TTabSheet;
            PageComputation: TTabSheet;
            PageOutput: TTabSheet;
            SpeedButtonInputParameters: TSpeedButton;
            SpeedButtonWallGeometry: TSpeedButton;
            GridPanelInputType: TGridPanel;
            PanelInputTypeSeparator: TPanel;
            SpeedButtonNailLayout: TSpeedButton;
            GridNailLayout: TStringGrid;
            GridPanelInputParOptions: TGridPanel;
            SpeedButtonLimitStateFactors: TSpeedButton;
            SpeedButtonAverageValues: TSpeedButton;
            SpeedButtonClearFactors: TSpeedButton;
            PanelInputFactorSeparator: TPanel;
            GridSlopeProperties: TStringGrid;
            GridPanelNailLayoutOptions: TGridPanel;
            SpeedButtonGenerateLayout: TSpeedButton;
            PanelNailLayoutSeparator: TPanel;
            SpeedButtonClearLayout: TSpeedButton;
            ActionManager1: TActionManager;
            ActionWallGeometry: TAction;
            ActionNailProperties: TAction;
            ActionLimitStateFactors: TAction;
            ActionAverageValues: TAction;
            ActionClearFactors: TAction;
            ActionGenerateLayout: TAction;
            ActionClearLayout: TAction;
            GridPanelComputationType: TGridPanel;
            SpeedButtonAnalysis: TSpeedButton;
            SpeedButtonDesign: TSpeedButton;
            GridPanelExamples: TGridPanel;
            PanelExamplesSeparator: TPanel;
            SpeedButton1: TSpeedButton;
            ActionExampleVerticalWallFlatSlope: TAction;
            ActionAnalysis: TAction;
            GridPanelTheme: TGridPanel;
            LabelTheme: TLabel;
            ComboBoxTheme: TComboBox;
            LabelInputType: TLabel;
            LabelFactorOptions: TLabel;
            LabelNailLayoutOptions: TLabel;
            LabelExamples: TLabel;
            ActionInputType: TAction;
            LabelComputationType: TLabel;
            PanelComputationTypeSeparator: TPanel;
            PopupMenuFile: TPopupMenu;
            FMNew: TMenuItem;
            FMOpen: TMenuItem;
            FMSave: TMenuItem;
            FMSaveAs: TMenuItem;
            N1: TMenuItem;
            FMTheme: TMenuItem;
            FMLightTheme: TMenuItem;
            FMDarkTheme: TMenuItem;
            ActionDarkTheme: TAction;
            ActionLightTheme: TAction;
            ActionNew: TAction;
    JDBGraphic2D1: TJDBGraphic2D;
        //main form
            //creation
                procedure FormCreate(Sender: TObject);
            //destruction
                procedure FormClose(Sender: TObject; var Action: TCloseAction);
        //actions
            //file menu
                procedure ActionNewExecute(Sender: TObject);
            //input tab
                //input parameters
                    procedure ActionInputParametersExecute(Sender: TObject);
                    procedure ActionLimitStateFactorsExecute(Sender: TObject);
                    procedure ActionAverageValuesExecute(Sender: TObject);
                    procedure ActionClearFactorsExecute(Sender: TObject);
                //wall geometry
                    procedure ActionWallGeometryExecute(Sender: TObject);
                //nail properties
                    procedure ActionNailPropertiesExecute(Sender: TObject);
                    procedure ActionGenerateLayoutExecute(Sender: TObject);
                    procedure ActionClearLayoutExecute(Sender: TObject);
                //examples
                    procedure ActionExampleVerticalWallFlatSlopeExecute(Sender: TObject);
            //analysis & design tab
                procedure ActionAnalysisExecute(Sender: TObject);
            //theme
                procedure ActionLightThemeExecute(Sender: TObject);
                procedure ActionDarkThemeExecute(Sender: TObject);
        //general events
            //drawing
                
            //input tab
                //parameters
                    procedure GridInputSelectCell(  Sender          : TObject;
                                                    ACol, ARow      : Integer;
                                                    var CanSelect   : Boolean);
                    procedure GridInputKeyPress(Sender  : TObject;
                                                var Key : Char  );
                //nail properties
                    procedure GridNailLayoutKeyPress(   Sender  : TObject;
                                                        var Key : Char  );
                    procedure GridNailLayoutSelectCell( Sender          : TObject;
                                                        ACol, ARow      : Integer;
                                                        var CanSelect   : Boolean);
            //theme
                procedure ComboBoxThemeChange(Sender: TObject);
            //ribbon
                procedure PageControlRibbonChange(Sender: TObject);
                procedure JDBGraphic2D1UpdateGeometry(  ASender: TObject;
                                                        var AGeomDrawer: TGraphicDrawerObjectAdder  );
        private
            var
                mustRedrawImage         : boolean;
                activeInputPage         : EActiveInputPage;
                activeComputationPage   : EActiveComputationPage;
                activeRibbonTab         : EActiveRibbonTab;
                activeUITheme           : EUITheme;
                SoilNailWallDesign      : TSoilNailWall;
            //helper methods
                //enter pressed on grid
                    procedure gridCellEnterPressed();
            //set up form
                procedure setupForm();
            //UI management
                //popup menu
                    procedure showFilePopupMenu();
                //ribbon management
                    procedure sortInputRibbon();
                    procedure sortComputationRibbon();
                    procedure sortRibbon();
                //page management
                    procedure sortInputPage();
//                    procedure sortComputationPage();
                    procedure PageControlProgammeFlowChanged();
                    procedure sortPage();
                //theme menu
                    procedure setUITheme(const themeIn : EUITheme);
                    procedure activateLightTheme();
                    procedure activateDarkTheme();
                    procedure positionThemeDropMenu();
                procedure sortUI();
            //check if grids are populated
                function readFromAllInputGrids() : boolean;
                procedure writeToAllInputGrids(const updateEmptyCellsIn : boolean);
                function readFromAndWriteToInputGrids() : boolean;
                procedure writeToAndReadFromInputGrids();
        protected
            procedure wndproc(var messageInOut : TMessage); override;
        public
            //
    end;

    var
      SNWForm: TSNWForm;

implementation

{$R *.dfm}

    //helper methods
        

    //published
        //main form
            //creation
                procedure TSNWForm.FormCreate(Sender: TObject);
                    begin
                        setupForm();

                        self.Refresh();
                    end;

            //destruction
                procedure TSNWForm.FormClose(Sender: TObject; var Action: TCloseAction);
                    begin
                        FreeAndNil(SoilNailWallDesign);

                        Action := TCloseAction.caFree;
                    end;

        //actions
            //file menu
                procedure TSNWForm.ActionNewExecute(Sender: TObject);
                    var
                        strGrd      : TStringGrid;
                        arrStrGrd   : TArray<TStringGrid>;
                    begin
                        ActionClearLayoutExecute(nil);

                        FreeAndNil(SoilNailWallDesign);

                        arrStrGrd := [  GridSoilParInput, GridSteelParInput, GridConcreteParInput,
                                        GridWallProperties, GridSlopeProperties,
                                        GridNailProperties, GridNailLayout                          ];

                        for strGrd in arrStrGrd do
                            strGrd.clearColumns(1);

                        SoilNailWallDesign := TSoilNailWall.create();

//                        PBSNWDrawing.Redraw();
                    end;

            //input tab
                //input parameters
                    procedure TSNWForm.ActionInputParametersExecute(Sender: TObject);
                        begin
                            activeInputPage := EActiveInputPage.aipMaterials;

                            sortUI();
                        end;

                    procedure TSNWForm.ActionLimitStateFactorsExecute(Sender: TObject);
                        begin
                            InputParlimitStateFactors(GridSoilParInput, GridSteelParInput, GridConcreteParInput);

                            readFromAndWriteToInputGrids();
                        end;

                    procedure TSNWForm.ActionAverageValuesExecute(Sender: TObject);
                        begin
                            useAverageInputValuesForDesign(GridSoilParInput, GridSteelParInput, GridConcreteParInput);

                            readFromAndWriteToInputGrids();
                        end;

                    procedure TSNWForm.ActionClearFactorsExecute(Sender: TObject);
                        begin
                            clearInputFactors(GridSoilParInput, GridSteelParInput, GridConcreteParInput);

                            readFromAndWriteToInputGrids();
                        end;

                //wall geometry
                    procedure TSNWForm.ActionWallGeometryExecute(Sender: TObject);
                        begin
                            activeInputPage := EActiveInputPage.aipWallGeom;

                            sortUI();
                        end;

                //nail properties
                    procedure TSNWForm.ActionNailPropertiesExecute(Sender: TObject);
                        begin
                            activeInputPage := EActiveInputPage.aipNailProperties;

                            sortUI();
                        end;

                    procedure TSNWForm.ActionGenerateLayoutExecute(Sender: TObject);
                        var
                            formResult          : TModalResult;
                            generateLayoutForm  : TNailLayoutGenForm;
                        begin
                            generateLayoutForm := TNailLayoutGenForm.create(SoilNailWallDesign);

                            generateLayoutForm.ShowModal();

                            formResult := generateLayoutForm.ModalResult;

                            case formResult of
                                mrOk:
                                    begin
                                        var newSNW : TSoilNailWall := generateLayoutForm.getSNW();

                                        SoilNailWallDesign.copySNW( newSNW );

                                        writeToAllInputGrids(False);
                                    end;
                            end;

                            FreeAndNil(generateLayoutForm);

                            sortUI();
                        end;

                    procedure TSNWForm.ActionClearLayoutExecute(Sender: TObject);
                        begin
                            SoilNailWallDesign.clearNailLayout();

                            writeToAndReadFromInputGrids();
                        end;

                //examples
                    procedure TSNWForm.ActionExampleVerticalWallFlatSlopeExecute(Sender: TObject);
                        begin
                            loadExample( ESNWExample.seVerticalWallFlatSlope, SoilNailWallDesign );

                            writeToAndReadFromInputGrids();
                        end;

            //analysis & design tab
                procedure TSNWForm.ActionAnalysisExecute(Sender: TObject);
                    begin
                        setSpeedButtonDown(2, SpeedButtonAnalysis);
                    end;

            //theme
                procedure TSNWForm.ActionDarkThemeExecute(Sender: TObject);
                    begin
                        activateDarkTheme();
                    end;

                procedure TSNWForm.ActionLightThemeExecute(Sender: TObject);
                    begin
                        activateLightTheme();
                    end;


        //general events
            //drawing
                

            //input
                //parameters
                    procedure TSNWForm.GridInputSelectCell( Sender          : TObject;
                                                            ACol, ARow      : Integer;
                                                            var CanSelect   : Boolean);
                        begin
                            if (PageControlProgrammeFlow.ActivePageIndex = PageInputParameters.PageIndex) then
                                begin
                                    //fixed rows are 4 and 6 for parameters grids
                                        if (ACol in [4, 6]) then
                                            CanSelect := false;
                                end;

                            readFromAndWriteToInputGrids();
                        end;

                    procedure TSNWForm.GridInputKeyPress(   Sender  : TObject;
                                                            var Key : Char      );
                        begin
                            if (ord(Key) in [VK_RETURN]) then
                                gridCellEnterPressed();
                        end;

                //nail properties
                    procedure TSNWForm.GridNailLayoutKeyPress(Sender: TObject; var Key: Char);
                        begin
                            if (ord(key) = VK_RETURN) then
                                gridCellEnterPressed();
                        end;

                    procedure TSNWForm.GridNailLayoutSelectCell(Sender          : TObject;
                                                                ACol, ARow      : Integer;
                                                                var CanSelect   : Boolean);
                        begin
                            readFromAndWriteToInputGrids()
                        end;

            procedure TSNWForm.JDBGraphic2D1UpdateGeometry( ASender         : TObject;
                                                            var AGeomDrawer : TGraphicDrawerObjectAdder );
                begin
                    SoilNailWallDesign.drawSoilNailWall
                end;

            //theme
                procedure TSNWForm.ComboBoxThemeChange(Sender: TObject);
                    var
                        styleIndex  : integer;
                    begin
                        styleIndex := ComboBoxTheme.ItemIndex;

                        activeUITheme := EUITheme(styleIndex);

                        case (activeUITheme) of
                            EUITheme.uitLight:
                                activateLightTheme();
                            EUITheme.uitDark:
                                activateDarkTheme();
                        end;

                        ComboBoxTheme.Refresh();
                    end;

            //ribbon
                procedure TSNWForm.PageControlRibbonChange(Sender: TObject);
                    begin
                        case (PageControlRibbon.ActivePageIndex) of
                            0:
                                begin
                                    showFilePopupMenu();
                                    exit();
                                end;
                            1:
                                activeRibbonTab := EActiveRibbonTab.artInput;
                            2:
                                activeRibbonTab := EActiveRibbonTab.artComputation;
                            3:
                                activeRibbonTab := EActiveRibbonTab.artOutput;
                        end;

                        sortUI();
                    end;

    //private
        //helper methods
            //enter pressed on grid
                procedure TSNWForm.gridCellEnterPressed();
                    begin
                        readFromAndWriteToInputGrids();
                    end;

        //set up form
            procedure TSNWForm.setupForm();
                procedure
                    _pageConTabsVisiblity();
                        var
                            i : integer;
                        begin
                            //input tabs
                                PageControlProgrammeFlow.hideAllPageTabs();

                            //design page
                                PageControlRibbon.Pages[PageComputation.PageIndex].TabVisible := False;

                            //output page
                                PageControlRibbon.Pages[PageOutput.PageIndex].TabVisible := False;
                        end;
                begin
                    SoilNailWallDesign := TSoilNailWall.create();

                    _pageConTabsVisiblity();

                    ComboBoxTheme.ItemIndex := 0;
                    ComboBoxThemeChange(nil);

                    activeInputPage         := EActiveInputPage.aipMaterials;
                    activeComputationPage   := EActiveComputationPage.aapAnalysis;
                    activeRibbonTab         := EActiveRibbonTab.artInput;

                    setupInputTab(  GridPanelInputHeadings,
                                    GridSoilParInput,       GridSteelParInput,      GridConcreteParInput,
                                    GridWallProperties,     GridSlopeProperties,
                                    GridNailProperties,     GridNailLayout                              );

                    sortUI();

                    readFromAndWriteToInputGrids();
                end;

        //UI management
            //popup menu
                procedure TSNWForm.showFilePopupMenu();
                    var
                        x, y                : integer;
                        popupPointOnRibbon,
                        popupPointOnScreen  : TPoint;
                    begin
                        sortUI();

                        popupPointOnRibbon := Point(PageControlRibbon.Left, PageControlRibbon.top + round(20 * self.ScaleFactor));

                        popupPointOnScreen := PageControlRibbon.ClientToScreen(popupPointOnRibbon);

                        x := popupPointOnScreen.X;
                        y := popupPointOnScreen.Y;

                        PopupMenuFile.Popup(x, y);
                    end;

            //ribbon management
                procedure TSNWForm.sortInputRibbon();
                    var
                        gridPanel : TGridPanel;
                    begin
                        //hide dependent input grid panels
                            for gridPanel in [GridPanelInputParOptions, GridPanelNailLayoutOptions] do
                                gridPanel.Visible := False;

                        //show elevant grid panels
                            case (activeInputPage) of
                                EActiveInputPage.aipMaterials:
                                    begin
                                        setSpeedButtonDown(1, SpeedButtonInputParameters);
                                        GridPanelInputParOptions.Visible := True;
                                    end;
                                EActiveInputPage.aipWallGeom:
                                    begin
                                        setSpeedButtonDown(1, SpeedButtonWallGeometry);
                                    end;
                                EActiveInputPage.aipNailProperties:
                                    begin
                                        setSpeedButtonDown(1, SpeedButtonNailLayout);
                                        GridPanelNailLayoutOptions.Visible  := True;
                                    end;
                            end;

                        //order panels
                            orderComponentsLeftToRight( [GridPanelInputType, GridPanelInputParOptions, GridPanelNailLayoutOptions, GridPanelExamples] );
                    end;

                procedure TSNWForm.sortComputationRibbon();
                    begin
                        case (activeComputationPage) of
                            EActiveComputationPage.aapAnalysis:
                                setSpeedButtonDown(2, SpeedButtonAnalysis);

                            EActiveComputationPage.aapDesign:
                                setSpeedButtonDown(2, SpeedButtonDesign);
                        end;
                    end;

                procedure TSNWForm.sortRibbon();
                    begin
                        case (activeRibbonTab) of
                            EActiveRibbonTab.artInput:
                                begin
                                    PageControlRibbon.ActivePage := PageInput;
                                    sortInputRibbon();
                                end;
                            EActiveRibbonTab.artComputation:
                                begin
                                    PageControlRibbon.ActivePage := PageComputation;
                                    sortComputationRibbon();
                                end;
                            EActiveRibbonTab.artOutput:
                                begin
                                    PageControlRibbon.ActivePage := PageOutput;
                                end;
                        end;

                        positionThemeDropMenu();
                    end;

            //page management
                procedure TSNWForm.sortInputPage();
                    begin
                        case (activeInputPage) of
                            EActiveInputPage.aipMaterials:
                                PageControlProgrammeFlow.ActivePage := PageInputParameters;

                            EActiveInputPage.aipWallGeom:
                                PageControlProgrammeFlow.ActivePage := PageWallGeometry;

                            EActiveInputPage.aipNailProperties:
                                PageControlProgrammeFlow.ActivePage := PageNailProperties;
                        end;
                    end;

                procedure TSNWForm.PageControlProgammeFlowChanged();
                    procedure
                        _calculatePageWidth(const widestStringGridIn : TStringGrid);
                            begin
                                PageControlProgrammeFlow.Width := widestStringGridIn.Width + (4 * widestStringGridIn.Left);
                            end;
                    begin
                        case (PageControlProgrammeFlow.ActivePageIndex) of
                            0: //input parameters
                                _calculatePageWidth(GridSoilParInput);
                            1: //wall geometry
                                _calculatePageWidth(GridWallProperties);
                            2: //nail properties
                                _calculatePageWidth(GridNailLayout);
                        end;
                    end;

                procedure TSNWForm.sortPage();
                    begin
                        case (activeRibbonTab) of
                            EActiveRibbonTab.artInput:
                                sortInputPage();
                        end;

                        PageControlProgammeFlowChanged();
                    end;

            //theme menu
                procedure TSNWForm.setUITheme(const themeIn : EUITheme);
                    var
                        styleName   : string;
                    begin
                        activeUITheme := themeIn;
                        ComboBoxTheme.ItemIndex := integer(activeUITheme);

                        case (activeUITheme) of
                            EUITheme.uitLight:
                                TStyleManager.SetStyle(WINDOWS11_THEME_LIGHT);

                            EUITheme.uitDark:
                                TStyleManager.SetStyle(WINDOWS11_THEME_DARK);
                        end;
                    end;

                procedure TSNWForm.activateLightTheme();
                    begin
                        setUITheme(EUITheme.uitLight);
                    end;

                procedure TSNWForm.activateDarkTheme();
                    begin
                        setUITheme(EUITheme.uitDark);
                    end;

                procedure TSNWForm.positionThemeDropMenu();
                    begin
                        GridPanelTheme.Parent := PageControlRibbon.ActivePage;

                        GridPanelTheme.top := 0;
                            GridPanelTheme.left := GridPanelTheme.parent.Width - GridPanelTheme.width - round(1 * self.ScaleFactor);
                    end;

            procedure TSNWForm.sortUI();
                begin
                    try
                        self.LockDrawing();

                        sortRibbon();

                        sortPage();
                    finally
                        self.UnlockDrawing();
                    end;
                end;

        //check if grids are populated
            function TSNWForm.readFromAllInputGrids() : boolean;
                var
                    inputParPop, wallGeomPop, nailsPop, allInputPopulated : boolean;
                begin
                    inputParPop := readInputParGrids( GridSoilParInput, GridSteelParInput, GridConcreteParInput, SoilNailWallDesign );
                    wallGeomPop := readWallGeomGrids( GridWallProperties, GridSlopeProperties, SoilNailWallDesign );
                    nailsPop    := readNailPropGrids( GridNailProperties, GridNailLayout, SoilNailWallDesign );

                    allInputPopulated := (inputParPop AND wallGeomPop AND nailsPop);

                    {$ifdef DEBUG}
                        PageControlRibbon.Pages[PageComputation.PageIndex].TabVisible := True;
                    {$else}
                        PageControlRibbon.Pages[PageComputation.PageIndex].TabVisible := allInputPopulated;
                    {$endif}

                    result := allInputPopulated;
                end;

            procedure TSNWForm.writeToAllInputGrids(const updateEmptyCellsIn : boolean);
                begin
                    writeToInputParGrids( updateEmptyCellsIn, GridSoilParInput, GridSteelParInput, GridConcreteParInput, SoilNailWallDesign );
                    writeToWallGeomGrids( updateEmptyCellsIn, GridWallProperties, GridSlopeProperties, SoilNailWallDesign );
                    writeToNailPropGrids( updateEmptyCellsIn, GridNailProperties, GridNailLayout, SoilNailWallDesign );

//                    PBSNWDrawing.Redraw();
                end;

            function TSNWForm.readFromAndWriteToInputGrids() : boolean;
                var
                    inputIsPopulated : boolean;
                begin
                    inputIsPopulated := readFromAllInputGrids();

                    writeToAllInputGrids(False);

                    result := inputIsPopulated;
                end;

            procedure TSNWForm.writeToAndReadFromInputGrids();
                begin
                    writeToAllInputGrids(True);

                    readFromAllInputGrids();
                end;

    //protected
        procedure TSNWForm.wndproc(var messageInOut : TMessage);
            begin
                inherited wndProc(messageInOut);
            end;

end.
