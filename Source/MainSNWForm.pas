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
            Vcl.ActnMan, Vcl.Themes, Vcl.WinXCtrls, Vcl.Menus, Vcl.TitleBarCtrls, Vcl.StdActns,
            Vcl.ExtDlgs,
        //custom
            GeneralComponentHelperMethods,
            PageControlHelperClass,
            SoilNailWallMasterClass,
            SNWUITypes,
            InputManagerClass,
            MaterialParametersInputManagerClass, WallGeometryInputManagerClass, NailPropertiesInputManagerClass, LoadCasesInputManagerClass,
            SoilNailWallExampleMethods, CustomComponentPanelClass,
            Graphic2DComponent, Graphic2DListClass, SoilNailWallFileReaderWriterClass,
            CustomStringGridClass
            ;

    type
        TSNWForm = class(TForm)
            PageControlProgrammeFlow: TPageControl;
            PageWallGeometry: TTabSheet;
            PageNailProperties: TTabSheet;
            PageMaterialParameters: TTabSheet;
            GridPanelInputHeadings: TGridPanel;
            LabelAveVal: TLabel;
            LabelVarCoef: TLabel;
            LabelDowngFact: TLabel;
            LabelCauEst: TLabel;
            LabelParFac: TLabel;
            LabelDesVal: TLabel;
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
            GridPanelInputParOptions: TGridPanel;
            SpeedButtonLimitStateFactors: TSpeedButton;
            SpeedButtonAverageValues: TSpeedButton;
            SpeedButtonClearFactors: TSpeedButton;
            PanelInputFactorSeparator: TPanel;
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
            SpeedButtonExample1: TSpeedButton;
            ActionExampleVerticalWallFlatSlope: TAction;
            ActionAnalysis: TAction;
            GridPanelTheme: TGridPanel;
            LabelTheme: TLabel;
            ComboBoxTheme: TComboBox;
            LabelInputType: TLabel;
            LabelFactorOptions: TLabel;
            LabelNailLayoutOptions: TLabel;
            LabelExamples: TLabel;
            ActionMaterialParameters: TAction;
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
            ListBoxMaterialProperties: TListBox;
            ListBoxWallGeom: TListBox;
            ListBoxNailProperties: TListBox;
            ActionOpen: TAction;
            ActionSave: TAction;
            ActionSaveAs: TAction;
            OpenFileDialog: TFileOpenDialog;
            SaveFileDialog: TFileSaveDialog;
            SNWGraphic: TJDBGraphic2D;
            PageLoads: TTabSheet;
            SpeedButtonLoadCases: TSpeedButton;
            ActionLoads: TAction;
            ListBoxLoadCases: TListBox;
            GridPanelLoadCaseOptions: TGridPanel;
            SpeedButtonLCEditor: TSpeedButton;
            PanelLCSeparator: TPanel;
            LabelLCOptions: TLabel;
            ActionLoadCaseEditor: TAction;
            PageAnalysis: TTabSheet;
            PageDesign: TTabSheet;
            GridSoilParInput: TJDBStringGrid;
            GridSteelParInput: TJDBStringGrid;
            GridConcreteParInput: TJDBStringGrid;
            GridWallProperties: TJDBStringGrid;
            GridSlopeProperties: TJDBStringGrid;
            GridNailProperties: TJDBStringGrid;
            GridNailLayout: TJDBStringGrid;
            GridLoadCases: TJDBStringGrid;
        //main form
            //creation
                procedure FormCreate(Sender: TObject);
            //destruction
                procedure FormClose(Sender: TObject; var Action: TCloseAction);
            //on show
                procedure FormShow(Sender: TObject);
        //actions
            //file menu
                procedure ActionNewExecute(Sender: TObject);
                procedure ActionOpenExecute(Sender: TObject);
                procedure ActionSaveAsExecute(Sender: TObject);
            //input tab
                //input parameters
                    procedure ActionMaterialParametersExecute(Sender: TObject);
                    procedure ActionLimitStateFactorsExecute(Sender: TObject);
                    procedure ActionAverageValuesExecute(Sender: TObject);
                    procedure ActionClearFactorsExecute(Sender: TObject);
                //wall geometry
                    procedure ActionWallGeometryExecute(Sender: TObject);
                //nail properties
                    procedure ActionNailPropertiesExecute(Sender: TObject);
                    procedure ActionGenerateLayoutExecute(Sender: TObject);
                    procedure ActionClearLayoutExecute(Sender: TObject);
                //load cases
                    procedure ActionLoadsExecute(Sender: TObject);
                    procedure ActionLoadCaseEditorExecute(Sender: TObject);
                //examples
                    procedure ActionExampleVerticalWallFlatSlopeExecute(Sender: TObject);
            //analysis & design tab
                procedure ActionAnalysisExecute(Sender: TObject);
            //theme
                procedure ActionLightThemeExecute(Sender: TObject);
                procedure ActionDarkThemeExecute(Sender: TObject);
        //general events
            //input tab
                procedure GridMaterialInputSelectCell(  Sender          : TObject;
                                                        ACol, ARow      : Integer;
                                                        var CanSelect   : Boolean);
                procedure GridInputCellChanged(Sender: TObject);
                procedure GridLoadCasesSelectCell(  Sender          : TObject;
                                                    ACol, ARow      : LongInt;
                                                    var CanSelect   : Boolean   );
            //theme
                procedure ComboBoxThemeChange(Sender: TObject);
            //ribbon
                procedure PageControlRibbonChange(Sender: TObject);
            //update graphics
                procedure SNWGraphicUpdateGraphics(ASender: TObject; var AGraphic2DList: TGraphic2DList);

        private
            var
                activeInputPage             : EInputPage;
                activeComputationPage       : EComputationPage;
                activeRibbonTab             : ERibbonTab;
                activeUITheme               : EUITheme;
                SoilNailWallDesign          : TSoilNailWall;
                materialsInputManager       : TMaterialParametersInputManager;
                wallGeometryInputManager    : TWallGeometryInputManager;
                nailPropertiesInputManager  : TNailPropertiesInputManager;
                loadCasesInputManager       : TLoadCasesInputManager;
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
                    procedure sortComputationPage();
                    procedure sortPage();
                    procedure PageControlProgammeFlowChanged();
                //theme menu
                    procedure setUITheme(const themeIn : EUITheme);
                    procedure positionThemeDropMenu();
                procedure sortUI();
            //check if grids are populated
                function readFromAllInputControls() : boolean;
                procedure writeToAllInputControls(const updateEmptyCellsIn : boolean);
                function readFromAndWriteToInputControls() : boolean;
            //file management
                procedure loadSNWFile(const SNWFileNameIn : string);
                procedure saveSNWFile(SNWFileNameIn : string);
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
                    var
                        SNWFileName : string;
                    begin
                        setupForm();

                        self.Refresh();

                        //open a *.snw file from the file explorer
                            if ( ParamCount < 1 ) then
                                exit();

                            SNWFileName := ParamStr( 1 );

                            LoadSNWFile( SNWFileName );
                    end;

            //destruction
                procedure TSNWForm.FormClose(Sender: TObject; var Action: TCloseAction);
                    begin
                        FreeAndNil( SoilNailWallDesign );
                        FreeAndNil( materialsInputManager );
                        FreeAndNil( wallGeometryInputManager );
                        FreeAndNil( nailPropertiesInputManager );
                        FreeAndNil( loadCasesInputManager );

                        Action := TCloseAction.caFree;
                    end;

            //on show
                procedure TSNWForm.FormShow(Sender: TObject);
                    begin
                        //nothing here
                    end;

        //actions
            //file menu
                procedure TSNWForm.ActionNewExecute(Sender: TObject);
                    begin
                        SoilNailWallDesign.reset();

                        TInputManager.resetAllInputControls( [ materialsInputManager, wallGeometryInputManager, nailPropertiesInputManager, loadCasesInputManager ] );

                        SNWGraphic.updateGraphics();

                        writeToAllInputControls( False );
                    end;

                procedure TSNWForm.ActionOpenExecute(Sender: TObject);
                    var
                        openFileName : string;
                    begin
                        if NOT( OpenFileDialog.Execute() ) then
                            exit();

                        openFileName := OpenFileDialog.FileName;

                        LoadSNWFile( openFileName );
                    end;

                procedure TSNWForm.ActionSaveAsExecute(Sender: TObject);
                    var
                        saveFileName : string;
                    begin
                        if NOT( SaveFileDialog.Execute() ) then
                            exit();

                        saveFileName := SaveFileDialog.FileName;

                        saveSNWFile( saveFileName );
                    end;

            //input tab
                //input parameters
                    procedure TSNWForm.ActionMaterialParametersExecute(Sender: TObject);
                        begin
                            activeInputPage := EInputPage.ipMaterials;

                            sortUI();
                        end;

                    procedure TSNWForm.ActionLimitStateFactorsExecute(Sender: TObject);
                        begin
                            materialsInputManager.useLimitStateValuesForDesign();
                        end;

                    procedure TSNWForm.ActionAverageValuesExecute(Sender: TObject);
                        begin
                            materialsInputManager.useAverageValuesForDesign();
                        end;

                    procedure TSNWForm.ActionClearFactorsExecute(Sender: TObject);
                        begin
                            materialsInputManager.clearLimitStateFactors();
                        end;

                //wall geometry
                    procedure TSNWForm.ActionWallGeometryExecute(Sender: TObject);
                        begin
                            activeInputPage := EInputPage.ipWallGeom;

                            sortUI();
                        end;

                //nail properties
                    procedure TSNWForm.ActionNailPropertiesExecute(Sender: TObject);
                        begin
                            activeInputPage := EInputPage.ipNailProperties;

                            sortUI();
                        end;

                    procedure TSNWForm.ActionGenerateLayoutExecute(Sender: TObject);
                        begin
                            if ( nailPropertiesInputManager.NailLayoutGeneratorExecute() ) then
                                writeToAllInputControls( False );

                            sortUI();
                        end;

                    procedure TSNWForm.ActionClearLayoutExecute(Sender: TObject);
                        begin
                            SoilNailWallDesign.clearNailLayout();

                            writeToAllInputControls( True );
                        end;

                //load cases
                    procedure TSNWForm.ActionLoadsExecute(Sender: TObject);
                        begin
                            activeInputPage := EInputPage.ipLoadCases;

                            sortUI();
                        end;

                    procedure TSNWForm.ActionLoadCaseEditorExecute(Sender: TObject);
                        begin
                            loadCasesInputManager.loadCaseEditorExecute();
                        end;

                //examples
                    procedure TSNWForm.ActionExampleVerticalWallFlatSlopeExecute(Sender: TObject);
                        begin
                            loadExample( ESNWExample.seVerticalWallFlatSlope, SoilNailWallDesign );

                            writeToAllInputControls( True );

                            SNWGraphic.zoomAll();
                        end;

            //analysis & design tab
                procedure TSNWForm.ActionAnalysisExecute(Sender: TObject);
                    begin
                        setSpeedButtonDown( 2, SpeedButtonAnalysis );
                    end;

            //theme
                procedure TSNWForm.ActionDarkThemeExecute(Sender: TObject);
                    begin
                        setUITheme( EUITheme.uitDark );
                    end;

                procedure TSNWForm.ActionLightThemeExecute(Sender: TObject);
                    begin
                        setUITheme( EUITheme.uitLight );
                    end;

        //general events
            //input
                procedure TSNWForm.GridMaterialInputSelectCell( Sender          : TObject;
                                                                ACol, ARow      : Integer;
                                                                var CanSelect   : Boolean);
                    begin
                        if (PageControlProgrammeFlow.ActivePageIndex = PageMaterialParameters.PageIndex) then
                            begin
                                //fixed rows are 4 and 6 for parameters grids
                                    if (ACol in [4, 6]) then
                                        CanSelect := false;
                            end;

                        readFromAndWriteToInputControls();
                    end;

                procedure TSNWForm.GridInputCellChanged(Sender: TObject);
                    begin
                        readFromAndWriteToInputControls();
                    end;

                procedure TSNWForm.GridLoadCasesSelectCell( Sender          : TObject;
                                                            ACol, ARow      : LongInt;
                                                            var CanSelect   : Boolean );
                    var
                        activeLoadCase : string;
                    begin
                        activeLoadCase := loadCasesInputManager.getActiveLoadCase( ARow );

                        SoilNailWallDesign.setActiveLoadCase( activeLoadCase );

                        readFromAndWriteToInputControls();
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
                                setUITheme( EUITheme.uitLight );
                            EUITheme.uitDark:
                                setUITheme( EUITheme.uitDark );
                        end;
                    end;

            //ribbon
                procedure TSNWForm.PageControlRibbonChange(Sender: TObject);
                    begin
                        case (PageControlRibbon.ActivePageIndex) of
                            0:
                                showFilePopupMenu();
                            1:
                                activeRibbonTab := ERibbonTab.rtInput;
                            2:
                                activeRibbonTab := ERibbonTab.rtComputation;
                            3:
                                activeRibbonTab := ERibbonTab.rtOutput;
                        end;

                        sortUI();
                    end;

            //update graphics
                procedure TSNWForm.SNWGraphicUpdateGraphics(ASender: TObject; var AGraphic2DList: TGraphic2DList);
                    begin
                        SoilNailWallDesign.updateSoilNailWallGeomtry( AGraphic2DList );
                    end;

    //private
        //helper methods
            //enter pressed on grid
                procedure TSNWForm.gridCellEnterPressed();
                    begin
                        readFromAndWriteToInputControls();
                    end;

        //set up form
            procedure TSNWForm.setupForm();
                procedure
                    _pageConTabsVisiblity();
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

                    SoilNailWallDesign.setSlipWedgeVisible( False );

                    _pageConTabsVisiblity();

                    ComboBoxTheme.ItemIndex := 0;
                    ComboBoxThemeChange(nil);

                    activeInputPage         := EInputPage.ipMaterials;
                    activeComputationPage   := EComputationPage.cpAnalysis;
                    activeRibbonTab         := ERibbonTab.rtInput;

                    materialsInputManager := TMaterialParametersInputManager.create(
                                                                                        ListBoxMaterialProperties,
                                                                                        GridSoilParInput, GridSteelParInput, GridConcreteParInput,
                                                                                        GridPanelInputHeadings,
                                                                                        SoilNailWallDesign
                                                                                   );

                    wallGeometryInputManager := TWallGeometryInputManager.create(
                                                                                    ListBoxWallGeom,
                                                                                    GridWallProperties, GridSlopeProperties,
                                                                                    SoilNailWallDesign
                                                                                );

                    nailPropertiesInputManager := TNailPropertiesInputManager.create(
                                                                                        ListBoxNailProperties,
                                                                                        GridNailProperties, GridNailLayout,
                                                                                        SoilNailWallDesign
                                                                                    );

                    loadCasesInputManager := TLoadCasesInputManager.create( ListBoxLoadCases,
                                                                            GridLoadCases,
                                                                            SoilNailWallDesign  );

                    sortUI();

                    positionThemeDropMenu();

                    readFromAndWriteToInputControls();
                end;

        //UI management
            //popup menu
                procedure TSNWForm.showFilePopupMenu();
                    var
                        x, y                : integer;
                        popupPointOnRibbon,
                        popupPointOnScreen  : TPoint;
                    begin
                        popupPointOnRibbon := Point(PageControlRibbon.Left, PageControlRibbon.top + round(20 * self.ScaleFactor));

                        popupPointOnScreen := PageControlRibbon.ClientToScreen(popupPointOnRibbon);

                        x := popupPointOnScreen.X;
                        y := popupPointOnScreen.Y;

                        PopupMenuFile.Popup( x, y );
                    end;

            //ribbon management
                procedure TSNWForm.sortInputRibbon();
                    var
                        gridPanel : TGridPanel;
                    begin
                        //hide dependent input grid panels
                            for gridPanel in [GridPanelInputParOptions, GridPanelNailLayoutOptions, GridPanelLoadCaseOptions] do
                                gridPanel.Visible := False;

                        //show elevant grid panels
                            case (activeInputPage) of
                                EInputPage.ipMaterials:
                                    begin
                                        setSpeedButtonDown( 1, SpeedButtonInputParameters );
                                        GridPanelInputParOptions.Visible := True;
                                    end;

                                EInputPage.ipWallGeom:
                                    begin
                                        setSpeedButtonDown( 1, SpeedButtonWallGeometry );
                                    end;

                                EInputPage.ipNailProperties:
                                    begin
                                        setSpeedButtonDown( 1, SpeedButtonNailLayout );
                                        GridPanelNailLayoutOptions.Visible := True;
                                    end;

                                EInputPage.ipLoadCases:
                                    begin
                                        setSpeedButtonDown( 1, SpeedButtonLoadCases );
                                        GridPanelLoadCaseOptions.Visible := True;
                                    end;
                            end;

                        //order panels
                            orderComponentsLeftToRight( [   GridPanelInputType,
                                                            GridPanelInputParOptions,
                                                            GridPanelNailLayoutOptions,
                                                            GridPanelLoadCaseOptions,
                                                            GridPanelExamples           ] );
                    end;

                procedure TSNWForm.sortComputationRibbon();
                    begin
                        case (activeComputationPage) of
                            EComputationPage.cpAnalysis:
                                setSpeedButtonDown( 2, SpeedButtonAnalysis );

                            EComputationPage.cpDesign:
                                setSpeedButtonDown( 2, SpeedButtonDesign );
                        end;
                    end;

                procedure TSNWForm.sortRibbon();
                    begin
                        case (activeRibbonTab) of
                            ERibbonTab.rtInput:
                                begin
                                    PageControlRibbon.ActivePage := PageInput;
                                    sortInputRibbon();
                                end;
                            ERibbonTab.rtComputation:
                                begin
                                    PageControlRibbon.ActivePage := PageComputation;
                                    sortComputationRibbon();
                                end;
                            ERibbonTab.rtOutput:
                                begin
                                    PageControlRibbon.ActivePage := PageOutput;
                                end;
                        end;
                    end;

            //page management
                procedure TSNWForm.sortInputPage();
                    begin
                        case (activeInputPage) of
                            EInputPage.ipMaterials:
                                PageControlProgrammeFlow.ActivePage := PageMaterialParameters;

                            EInputPage.ipWallGeom:
                                PageControlProgrammeFlow.ActivePage := PageWallGeometry;

                            EInputPage.ipNailProperties:
                                PageControlProgrammeFlow.ActivePage := PageNailProperties;

                            EInputPage.ipLoadCases:
                                PageControlProgrammeFlow.ActivePage := PageLoads;
                        end;

                        SoilNailWallDesign.setLoadsVisible( activeInputPage = EInputPage.ipLoadCases );
                        SNWGraphic.updateGraphics();
                    end;

                procedure TSNWForm.sortComputationPage();
                    begin
                        case (activeComputationPage) of
                            EComputationPage.cpAnalysis:
                                PageControlProgrammeFlow.ActivePage := PageAnalysis;

                            EComputationPage.cpDesign:
                                PageControlProgrammeFlow.ActivePage := PageDesign;
                        end;
                    end;

                procedure TSNWForm.sortPage();
                    begin
                        case (activeRibbonTab) of
                            ERibbonTab.rtInput:
                                sortInputPage();

                            ERibbonTab.rtComputation:
                                sortComputationPage();
                        end;

                        PageControlProgammeFlowChanged();
                    end;

                procedure TSNWForm.PageControlProgammeFlowChanged();
                    procedure
                        _calculatePageWidth(const widestStringGridIn : TJDBStringGrid);
                            begin
                                PageControlProgrammeFlow.Width := widestStringGridIn.Width + (4 * widestStringGridIn.Left);
                            end;
                    begin
                        case (PageControlProgrammeFlow.ActivePageIndex) of
                            0: //input parameters
                                _calculatePageWidth( GridSoilParInput );

                            1: //wall geometry
                                _calculatePageWidth( GridWallProperties );

                            2: //nail properties
                                _calculatePageWidth( GridNailLayout );

                            3: //load cases
                                _calculatePageWidth( GridLoadCases );
                        end;
                    end;

            //theme menu
                procedure TSNWForm.setUITheme(const themeIn : EUITheme);
                    begin
                        activeUITheme := themeIn;
                        ComboBoxTheme.ItemIndex := integer(activeUITheme);

                        case (activeUITheme) of
                            EUITheme.uitLight:
                                TStyleManager.SetStyle( WINDOWS_11_THEME_LIGHT );

                            EUITheme.uitDark:
                                TStyleManager.SetStyle( WINDOWS_11_THEME_DARK );
                        end;

                        SNWGraphic.updateBackgroundColour();
                    end;

                procedure TSNWForm.positionThemeDropMenu();
                    begin
                        GridPanelTheme.top := 0;
                            GridPanelTheme.left := PageControlRibbon.Width - GridPanelTheme.width;

                        GridPanelTheme.BringToFront();
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
            function TSNWForm.readFromAllInputControls() : boolean;
                begin
                    result := TInputManager.readFromAllControls( [ materialsInputManager, wallGeometryInputManager, nailPropertiesInputManager, loadCasesInputManager ] );
                end;

            procedure TSNWForm.writeToAllInputControls(const updateEmptyCellsIn : boolean);
                var
                    inputErrorCount : integer;
                begin
                    TInputManager.writeToAllControls( [ materialsInputManager, wallGeometryInputManager, nailPropertiesInputManager, loadCasesInputManager ], updateEmptyCellsIn );

                    SNWGraphic.updateGraphics();

                    inputErrorCount := TInputManager.countInputErrors( [ materialsInputManager, wallGeometryInputManager, nailPropertiesInputManager, loadCasesInputManager ] );

//                    if (inputErrorCount = 0) then
//                        SoilNailWallDesign.calculateNailGroupTensionVSSlipAngleCurve( 0, 1 );

                    {$ifdef DEBUG}
                        PageControlRibbon.Pages[PageComputation.PageIndex].TabVisible := True;
                    {$else}


                        PageControlRibbon.Pages[PageComputation.PageIndex].TabVisible := ( inputErrorCount = 0 );
                    {$endif}
                end;

            function TSNWForm.readFromAndWriteToInputControls() : boolean;
                var
                    inputIsPopulated : boolean;
                begin
                    inputIsPopulated := readFromAllInputControls();

                    writeToAllInputControls( False );

                    result := inputIsPopulated;
                end;

        //file management
            procedure TSNWForm.loadSNWFile(const SNWFileNameIn : string);
                var
                    readSuccessful  : Boolean;
                    fileReadWrite   : TSoilNailWallFileReaderWriter;

                begin
                    fileReadWrite := TSoilNailWallFileReaderWriter.create( SNWFileNameIn );

                    if NOT( fileReadWrite.loadFile() ) then
                        begin
                            FreeAndNil( fileReadWrite );
                            exit();
                        end;

                    readSuccessful := SoilNailWallDesign.readFromFile( fileReadWrite );

                    writeToAllInputControls(True);

                    SNWGraphic.zoomAll();

                    FreeAndNil( fileReadWrite );
                end;

            procedure TSNWForm.saveSNWFile(SNWFileNameIn : string);
                const
                    FILE_EXTENSION : string = '.snw';
                var
                    fileReadWrite : TSoilNailWallFileReaderWriter;
                begin
                    if (NOT( Pos( FILE_EXTENSION, SNWFileNameIn ) > 0 )) then
                        SNWFileNameIn := SNWFileNameIn + FILE_EXTENSION;

                    fileReadWrite := TSoilNailWallFileReaderWriter.create( SNWFileNameIn );

                    SoilNailWallDesign.writeToFile( fileReadWrite );

                    fileReadWrite.saveFile();

                    FreeAndNil( fileReadWrite );
                end;

    //protected
        procedure TSNWForm.wndproc(var messageInOut : TMessage);
            begin
                inherited wndProc(messageInOut);
            end;



end.
