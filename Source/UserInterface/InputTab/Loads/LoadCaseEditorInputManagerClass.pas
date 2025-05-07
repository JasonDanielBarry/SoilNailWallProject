unit LoadCaseEditorInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Dialogs,
        CustomStringGridClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass,
        LoadCaseTypes, LoadCaseUIMethods
        ;

    type
        TLoadCaseEditorInputManager = class(TSoilNailWallInputManager)
            private
                const
                    DESC_COL    : integer = 0;
                    FACT_COL    : integer = 1;
                    LOAD_COL    : integer = 2;
                var
                    controlGridPanel    : TGridPanel;
                    loadCaseComboBox    : TComboBox;
                    loadCaseInputGrid   : TJDBStringGrid;
                //write load cases to combo box
                    procedure writeLoadCasesToComboBox();
                //setup input controls
                    procedure setupInputControls(); override;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const errorListBoxIn        : TListBox;
                                        const controlGridPanelIn    : TGridPanel;
                                        const loadCaseComboBoxIn    : TComboBox;
                                        const LCInputGridIn         : TJDBStringGrid;
                                        const soilNailWallIn        : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //reset controls
                    procedure resetInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
                //combo box changed
                    procedure loadCaseComboBoxChanged();
                //add new load case
                    function addNewLoadCase() : boolean;
                //detele a load case
                    procedure deleteLoadCase();

        end;

implementation

    //private
        //write load cases to combo box
            procedure TLoadCaseEditorInputManager.writeLoadCasesToComboBox();
                var
                    LCKey           : string;
                    arrOrderedKeys  : TArray<string>;
                    loadCases       : TLoadCaseMap;
                begin
                    loadCases := soilNailWallDesign.getLoadCases();

                    arrOrderedKeys := loadCases.Keys.ToArray();

                    loadCaseComboBox.Clear();

                    for LCKey in arrOrderedKeys do
                        loadCaseComboBox.Items.Add( LCKey );

                    loadCaseComboBox.ItemIndex := soilNailWallDesign.getLoadCases().getActiveLoadCaseIndex();
                end;

        //setup input controls
            procedure TLoadCaseEditorInputManager.setupInputControls();
                const
                    COLUMN_SIZES : TArray<integer> = [250, 80, 80];
                var
                    c                   : integer;
                    controlScaleFactor  : double;
                begin
                    inherited setupInputControls();

                    //get control scale factor
                        controlScaleFactor := controlGridPanel.ScaleFactor;

                    //position grid
                        loadCaseInputGrid.left  := 1;
                        loadCaseInputGrid.Top   := 1;

                    //size grid
                        loadCaseInputGrid.ColCount  := 3;
                        loadCaseInputGrid.FixedCols := 0;

                        loadCaseInputGrid.RowCount  := 2;
                        loadCaseInputGrid.FixedRows := 1;

                        for c := 0 to (Length( COLUMN_SIZES ) - 1) do
                            loadCaseInputGrid.ColWidths[c] := round( controlScaleFactor * COLUMN_SIZES[c] );

                        loadCaseInputGrid.minSize();
                        loadCaseInputGrid.setBorderProperties( 1, clSilver );

                        controlGridPanel.Width := loadCaseInputGrid.Width + round( controlScaleFactor * 2 * CONTROL_MARGIN ) + 2;

                    //headings
                        loadCaseInputGrid.Cells[DESC_COL, 0] := LC_HEADING_DESCRIPTION;
                        loadCaseInputGrid.Cells[FACT_COL, 0] := LC_HEADING_FACTOR;
                        loadCaseInputGrid.Cells[LOAD_COL, 0] := LC_HEADING_LOAD;

                    //populate combo box
                        writeLoadCasesToComboBox();
                end;

    //protected
        //check for input errors
            procedure TLoadCaseEditorInputManager.checkForInputErrors();
                var
                    i, arrLen   : integer;
                    loadCaseMap : TLoadCaseMap;
                    arrErrors   : TArray<string>;
                begin
                    inherited checkForInputErrors();

                    loadCaseMap := soilNailWallDesign.getLoadCases();

                    arrErrors := loadCaseMap.checkForErrors();

                    arrLen := length( arrErrors );

                    if ( arrLen < 1 ) then
                        exit();

                    for i := 0 to ( arrLen - 1 ) do
                        addError( arrErrors[i] );
                end;

    //public
        //constructor
            constructor TLoadCaseEditorInputManager.create( const errorListBoxIn        : TListBox;
                                                            const controlGridPanelIn    : TGridPanel;
                                                            const loadCaseComboBoxIn    : TComboBox;
                                                            const LCInputGridIn         : TJDBStringGrid;
                                                            const soilNailWallIn        : TSoilNailWall );
                begin
                    controlGridPanel    := controlGridPanelIn;
                    loadCaseComboBox    := loadCaseComboBoxIn;
                    loadCaseInputGrid   := LCInputGridIn;

                    inherited create( errorListBoxIn, soilNailWallIn );
                end;

        //destructor
            destructor TLoadCaseEditorInputManager.destroy();
                begin
                    inherited destroy();
                end;

        //reset controls
            procedure TLoadCaseEditorInputManager.resetInputControls();
                begin
                    controlGridPanel.LockDrawing();

                        loadCaseComboBox.ItemIndex := -1;

                        loadCaseInputGrid.clearRows( 1 );

                        loadCaseInputGrid.RowCount := 2;

                        loadCaseInputGrid.minSize();

                        loadCaseInputGrid.setBorderProperties( 1, clSilver );

                    controlGridPanel.UnlockDrawing();
                end;

        //process input
            //read input
                function TLoadCaseEditorInputManager.readFromInputControls() : boolean;
                    var
                        activeLoadCaseName  : string;
                        newlyReadLoadCase   : TLoadCase;
                        loadCaseMap         : TLoadCaseMap;
                    begin
                        //get the selected load case name
                            activeLoadCaseName := loadCaseComboBox.Text;

                            if ( activeLoadCaseName = '' ) then
                                exit( False );

                        //try read the load case
                            if NOT( tryReadLoadCase( DESC_COL, 1, loadCaseInputGrid.RowCount - 1, loadCaseInputGrid, newlyReadLoadCase ) ) then
                                exit( False );

                        //get the selected load case name
                            activeLoadCaseName          := loadCaseComboBox.Text;
                            newlyReadLoadCase.LCName    := activeLoadCaseName;

                        //get the load case map
                            loadCaseMap := soilNailWallDesign.getLoadCases();

                        //store in map
                            loadCaseMap.AddOrSetValue( activeLoadCaseName, newlyReadLoadCase );
                            loadCaseMap.setActiveLoadCase( activeLoadCaseName );

                        result := True;
                    end;

            //write to input controls
                procedure TLoadCaseEditorInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    var
                        activeLoadCase      : TLoadCase;
                        loadCaseMap         : TLoadCaseMap;
                    begin
                        inherited writeToInputControls( updateEmptyControlsIn );

                        //get the load case map
                            loadCaseMap := soilNailWallDesign.getLoadCases();

                        //get active load case
                            activeLoadCase := loadCaseMap.getActiveLoadCase();

                        //write load case data to controls
                            controlGridPanel.LockDrawing();

                                if ( updateEmptyControlsIn ) then
                                    loadCaseInputGrid.clearRows( 1 );

                                loadCaseInputGrid.RowCount := 2 + activeLoadCase.countCombinations();
                                loadCaseInputGrid.minSize();
                                loadCaseInputGrid.setBorderProperties( 1, clSilver );

                                writeLoadCaseToGrid( updateEmptyControlsIn, DESC_COL, 1, activeLoadCase, loadCaseInputGrid );

                                //update combo box items
                                    writeLoadCasesToComboBox();

                            controlGridPanel.UnlockDrawing();
                    end;

        //combo box changed
            procedure TLoadCaseEditorInputManager.loadCaseComboBoxChanged();
                var
                    newActiveLoadCase   : string;
                    loadCases           : TLoadCaseMap;
                begin
                    newActiveLoadCase := loadCaseComboBox.Text;

                    soilNailWallDesign.setActiveLoadCase( newActiveLoadCase );

                    writeToInputControls( True );
                end;

        //add new load case
            function TLoadCaseEditorInputManager.addNewLoadCase() : boolean;
                var
                    newLoadCaseName : string;
                    newLoadCase     : TLoadCase;
                    loadCaseMap     : TLoadCaseMap;
                begin
                    result := True;

                    if NOT( InputQuery( 'New Load Case', 'Enter load case name', newLoadCaseName ) ) then
                        exit( False );

                    newLoadCaseName := trim( newLoadCaseName );

                    if ( newLoadCaseName = '' ) then
                        exit();

                    //add the new load case with default values
                        loadCaseMap := soilNailWallDesign.getLoadCases();

                        newLoadCase.LCName := newLoadCaseName;
                        newLoadCase.addLoadCombination( 1.0, 0, 'C1' );

                        loadCaseMap.AddOrSetValue( newLoadCaseName, newLoadCase );
                        loadCaseMap.setActiveLoadCase( newLoadCaseName );

                        soilNailWallDesign.setLoadCases( loadCaseMap );

                    writeToInputControls( True );
                end;

        //detele a load case
            procedure TLoadCaseEditorInputManager.deleteLoadCase();
                var
                    loadCaseMap : TLoadCaseMap;
                begin
                    //get the load case map
                        loadCaseMap := soilNailWallDesign.getLoadCases();

                        loadCaseMap.deleteActiveLoadCase();

                        writeToInputControls( True );
                end;



end.
