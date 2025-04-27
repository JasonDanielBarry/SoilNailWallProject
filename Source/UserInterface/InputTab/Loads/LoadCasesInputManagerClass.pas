unit LoadCasesInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridInterposerClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes, LoadCaseTypes,
        SoilNailWallMasterClass,
        LoadCaseUIMethods,
        LoadCaseEditorWizard
        ;

    type
        TLoadCasesInputManager = class(TSoilNailWallInputManager)
            private
                const
                    NAME_COL    : integer = 0;
                    DESC_COL    : integer = 1;
                    FACT_COL    : integer = 2;
                    LOAD_COL    : integer = 3;
                var
                    loadCasesLabel  : TLabel;
                    loadInputGrid   : TStringGrid;
                //read load case data from grid
                    function readLoadCases() : boolean;
                //write load case data to grid
                    function emptyCombinationPresent() : boolean;
                    procedure writeLoadCasesToGrid(const updateEmptyCellsIn : boolean);
                //setup input controls
                    procedure setupInputControls(); override;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const errorListBoxIn        : TListBox;
                                        const loadInputGridIn       : TStringGrid;
                                        const soilNailWallDesignIn  : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //reset controls
                    procedure resetInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
                //get active load case
                    function getActiveLoadCase(const selectedGridRowIn : integer) : string;
                //launch load case editor
                    function loadCaseEditorExecute() : boolean;
        end;

implementation

    //private
        //read load case data from grid
            function TLoadCasesInputManager.readLoadCases() : boolean;
                var
                    newLoadCaseFound    : boolean;
                    startRow, endRow,
                    row                 : integer;
                    currentLCName       : string;
                    loadCaseMap         : TLoadCaseMap;
                function _findLoadCaseEndRow(const startRowIn : integer) : integer;
                    var
                        gridFinished,
                        nextLoadCaseFound : boolean;
                    begin
                        _findLoadCaseEndRow := startRowIn;

                        repeat
                            inc( row );

                            //check if the next load case is found
                                nextLoadCaseFound := NOT( loadInputGrid.cellIsEmpty( NAME_COL, row ) );
                                if ( nextLoadCaseFound ) then
                                    begin
                                        dec( row ); //push the row back by 1 for when the loop comes around and inc( row ) is called
                                        exit( row );
                                    end;

                            //check if the end of the grid is reached
                                gridFinished := (loadInputGrid.RowCount - 1) < row;
                                if ( gridFinished ) then
                                    exit( row - 1 );
                        until False;
                    end;
                begin
                    loadCaseMap := soilNailWallDesign.getLoadCases();
                    loadCaseMap.Clear();

                    row := 0;
                    while ( row < loadInputGrid.RowCount ) do
                        begin
                            var loadCase : TLoadCase;

                            inc( row );

                            //check if a new load case is needed
                                newLoadCaseFound := NOT( loadInputGrid.cellIsEmpty( NAME_COL, row ) );

                                if NOT( newLoadCaseFound ) then
                                    Continue;

                            //read the load case
                                startRow    := row;
                                endRow      := _findLoadCaseEndRow( startRow );

                                currentLCName := loadInputGrid.Cells[ NAME_COL, startRow ];

                                if NOT( tryReadLoadCase( DESC_COL, startRow, endRow, loadInputGrid, loadCase ) ) then
                                    Continue;

                            //get name
                                loadCase.LCName := currentLCName;

                            //place load case in map
                                loadCaseMap.AddOrSetValue( currentLCName, loadCase );
                        end;

                    soilNailWallDesign.setLoadCases( loadCaseMap );

                    result := True;
                end;

        //write load case data to grid
            function TLoadCasesInputManager.emptyCombinationPresent() : boolean;
                var
                    descriptionEmpty,
                    factorEmpty,
                    loadEmpty           : boolean;
                    row                 : integer;
                begin
                    result := false;

                    if loadInputGrid.RowCount = 2 then
                        exit( false );

                    for row := 1 to ( loadInputGrid.RowCount - 2 ) do
                        begin
                            descriptionEmpty    := loadInputGrid.cellIsEmpty( DESC_COL, row );
                            factorEmpty         := loadInputGrid.cellIsEmpty( LOAD_COL, row );
                            loadEmpty           := loadInputGrid.cellIsEmpty( FACT_COL, row );

                            if ( descriptionEmpty AND factorEmpty AND loadEmpty ) then
                                exit( True );
                        end;
                end;

            procedure TLoadCasesInputManager.writeLoadCasesToGrid(const updateEmptyCellsIn : boolean);
                var
                    firstLoadCaseDeleted,
                    localUpdateEmptyCells   : boolean;
                    totalCombinations,
                    loadCaseStartRow,
                    loadCaseEndRow          : integer;
                    LCKey                   : string;
                    loadCase                : TLoadCase;
                    loadCaseMap             : TLoadCaseMap;
                    orderedKeys             : TArray<string>;
                begin
                    //get the load case map
                        loadCaseMap := soilNailWallDesign.getLoadCases();

                    //size the grid
                        totalCombinations := loadCaseMap.countTotalLoadCaseCombinations();

                        loadInputGrid.RowCount := totalCombinations + 2;

                        loadInputGrid.minSize();
                        loadInputGrid.setBorderProperties( 1, clSilver );

                    //check if a load case has been deleted
                    //this is signified by loadInputGrid.cell[0, 1] being empty
                        firstLoadCaseDeleted := loadInputGrid.cellIsEmpty( NAME_COL, 1 );

                    //check if empty combinations are present - a grid reset is required if true
                        if ( emptyCombinationPresent() OR firstLoadCaseDeleted OR updateEmptyCellsIn ) then
                            begin
                                loadInputGrid.clearRows( 1 );
                                localUpdateEmptyCells := True;
                            end
                        else
                            localUpdateEmptyCells := False;

                    //write load cases
                        orderedKeys := loadCaseMap.getOrderedKeys();

                        loadCaseStartRow := 1;

                        for LCKey in orderedKeys do
                            begin
                                if NOT( loadCaseMap.TryGetValue( LCKey, loadCase ) ) then
                                    Continue;

                                //write load case
                                    loadInputGrid.Cells[ NAME_COL, loadCaseStartRow ] := loadCase.LCName;

                                    writeLoadCaseToGrid( localUpdateEmptyCells, DESC_COL, loadCaseStartRow, loadCaseEndRow, loadCase, loadInputGrid );

                                //set start for next load case
                                    loadCaseStartRow := loadCaseEndRow + 1;
                            end;
                end;

        //setup input controls
            procedure TLoadCasesInputManager.setupInputControls();
                const
                    COLUMN_SIZES : TArray<integer> = [80, 250, 80, 80];
                var
                    i               : integer;
                    ctrlScaleFactor : double;
                    controlParent   : TWinControl;
                begin
                    inherited setupInputControls();

                    controlParent := loadInputGrid.Parent;

                    loadCasesLabel.Parent   := controlParent;
                    loadCasesLabel.AutoSize := True;

                    //position controls
                        ctrlScaleFactor := controlParent.ScaleFactor;

                        loadCasesLabel.Top      := round( CONTROL_MARGIN * ctrlScaleFactor );
                        loadCasesLabel.Left     := round( CONTROL_MARGIN * ctrlScaleFactor );
                        loadCasesLabel.AutoSize := True;
                        loadCasesLabel.Caption  := 'Load Cases';

                        loadInputGrid.Left  := loadCasesLabel.Left;
                        loadInputGrid.top   := loadCasesLabel.Top + round( 1.25 * loadCasesLabel.Height );

                    //setup grid
                        loadInputGrid.Width     := round( (SumInt( COLUMN_SIZES ) + 10) * ctrlScaleFactor );
                        loadInputGrid.ColCount  := 4;
                        loadInputGrid.RowCount  := 2;
                        loadInputGrid.FixedCols := 0;
                        loadInputGrid.FixedRows := 1;

                        for i := 0 to ( length( COLUMN_SIZES ) - 1 ) do
                            loadInputGrid.ColWidths[i] := round( COLUMN_SIZES[i] * ctrlScaleFactor );

                        loadInputGrid.Cells[NAME_COL, 0] := 'Name';
                        loadInputGrid.Cells[DESC_COL, 0] := LC_HEADING_DESCRIPTION;
                        loadInputGrid.Cells[FACT_COL, 0] := LC_HEADING_FACTOR;
                        loadInputGrid.Cells[LOAD_COL, 0] := LC_HEADING_LOAD;

                        loadInputGrid.minSize();
                        loadInputGrid.setBorderProperties( 1, clSilver );
                end;

    //protected
        //check for input errors
            procedure TLoadCasesInputManager.checkForInputErrors();
                var
                    i, arrLen   : integer;
                    errorString,
                    LCKey       : string;
                    loadCase    : TLoadCase;
                    loadCaseMap : TLoadCaseMap;
                    arrErrors   : TArray<string>;
                begin
                    inherited checkForInputErrors();

                    loadCaseMap := soilNailWallDesign.getLoadCases();

                    for LCKey in loadCaseMap.getOrderedKeys() do
                        begin
                            if NOT( loadCaseMap.TryGetValue( LCKey, loadCase ) ) then
                                Continue;

                            arrErrors := loadCase.checkForErrors();

                            arrLen := length( arrErrors );

                            if ( arrLen < 1 ) then
                                Continue;

                            for i := 0 to ( arrLen - 1 ) do
                                addError( arrErrors[i] );
                        end;
                end;

    //public
        //constructor
            constructor TLoadCasesInputManager.create(  const errorListBoxIn        : TListBox;
                                                        const loadInputGridIn       : TStringGrid;
                                                        const soilNailWallDesignIn  : TSoilNailWall );
                begin
                    loadInputGrid := loadInputGridIn;
                    loadCasesLabel := TLabel.Create( nil );

                    inherited create( errorListBoxIn, soilNailWallDesignIn );
                end;

        //destructor
            destructor TLoadCasesInputManager.destroy();
                begin
                    FreeAndNil( loadCasesLabel );

                    inherited destroy();
                end;

        //reset controls
            procedure TLoadCasesInputManager.resetInputControls();
                begin
                    loadInputGrid.clearRows( 1 );
                    loadInputGrid.RowCount := 2;
                end;

        //process input
            //read input
                function TLoadCasesInputManager.readFromInputControls() : boolean;
                    begin
                        result := readLoadCases();
                    end;

            //write to input controls
                procedure TLoadCasesInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    var
                        controlParent : TWinControl;
                    begin
                        controlParent := loadInputGrid.Parent;
                        controlParent.LockDrawing();

                        inherited writeToInputControls( updateEmptyControlsIn );

                        writeLoadCasesToGrid( updateEmptyControlsIn );

                        controlParent.UnlockDrawing();
                    end;

        //get active load case
            function TLoadCasesInputManager.getActiveLoadCase(const selectedGridRowIn : integer) : string;
                var
                    loadcaseFound,
                    gridFinished,
                    canExitLoop     : boolean;
                    currentRow      : integer;
                    currentLoadCase : string;
                begin
                    if ( loadInputGrid.cellIsEmpty(NAME_COL, 1) ) then
                        exit('');

                    //find load case associated with row
                        currentRow := 1;

                        repeat
                            //update load case if needed
                                if NOT( loadInputGrid.cellIsEmpty(NAME_COL, currentRow) ) then
                                    currentLoadCase := loadInputGrid.Cells[ NAME_COL, currentRow ];

                            //check if loop can end
                                loadcaseFound   := ( currentRow = selectedGridRowIn );
                                gridFinished    := ( (loadInputGrid.RowCount - 1) < currentRow );
                                canExitLoop     := ( loadcaseFound OR gridFinished );

                            inc( currentRow );
                        until ( canExitLoop );

                    result := currentLoadCase;
                end;

        //launch load case editor
            function TLoadCasesInputManager.loadCaseEditorExecute() : boolean;
                var
                    loadCaseEditor : TLoadCaseEditor;
                begin
                    loadCaseEditor := TLoadCaseEditor.Create( soilNailWallDesign );

                    loadCaseEditor.ShowModal();

                    if ( loadCaseEditor.ModalResult = mrOk ) then
                        begin
                            var newSNW : TSoilNailWall := loadCaseEditor.getSoilNailWallDesign();

                            soilNailWallDesign.copySNW( newSNW );

                            writeToInputControls( True );

                            result := True;
                        end
                    else
                        result := False;

                    freeandNil( loadCaseEditor );
                end;

end.
