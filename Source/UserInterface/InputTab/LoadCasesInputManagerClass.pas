unit LoadCasesInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes, LoadCaseTypes,
        SoilNailWallMasterClass
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
                    function tryReadLoadCaseCombination(const gridRowIn : integer;
                                                        var loadCaseOut : TLoadCase) : boolean;
                    function tryReadLoadCase(const startRowIn : integer; out endRowOut : integer; out newLoadCaseOut : TLoadCase) : boolean;
                    function readLoadCases() : boolean;
                //write load case data to grid
                    procedure writeLoadCaseCombinationToGrid(   const updateEmptyCellsIn        : boolean;
                                                                const arrayIndexIn, gridRowIn   : integer;
                                                                const loadCaseIn                : TLoadCase );
                    procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                                    const startRowIn            : integer;
                                                    out endRowOut               : integer;
                                                    const loadCaseIn            : TLoadCase );
                    function emptyCombinationPresent() : boolean;
                    procedure writeLoadCasesToGrid(const updateEmptyCellsIn : boolean);
            protected
                //check for input errors
                    procedure checkLoadCaseCombinationForErrors(const arrayIndexIn : integer; const loadCaseIn : TLoadCase);
                    procedure checkLoadCaseForErrors(const loadCaseIn : TLoadCase);
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const errorListBoxIn        : TListBox;
                                        const loadInputGridIn       : TStringGrid;
                                        const soilNailWallDesignIn  : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //setup input controls
                    procedure setupInputControls(); override;
                //reset controls
                    procedure resetInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
                //get active load case
                    function getActiveLoadCase(const selectedGridRowIn : integer) : string;
        end;

implementation

    //private
        //read load case data from grid
            function TLoadCasesInputManager.tryReadLoadCaseCombination( const gridRowIn : integer;
                                                                        var loadCaseOut : TLoadCase ) : boolean;
                var
                    validCombination    : boolean;
                    factor, load        : double;
                    description         : string;
                begin
                    //extract load case from grid
                        description := loadInputGrid.Cells[ DESC_COL, gridRowIn ];
                        loadInputGrid.tryCellToDouble( FACT_COL, gridRowIn, factor );
                        loadInputGrid.tryCellToDouble( LOAD_COL, gridRowIn, load );

                    //test if load case is valid - this does not mean it will not raise an input error
                        validCombination := (description <> '');
                        validCombination := validCombination OR NOT( IsZero( factor, 1e-3 ) );
                        validCombination := validCombination OR NOT( IsZero( load, 1e-3 ) );

                    //send to load case record
                        if ( validCombination ) then
                            loadCaseOut.addLoadCombination( factor, load, description );

                    result := validCombination;
                end;

            function TLoadCasesInputManager.tryReadLoadCase(const startRowIn : integer; out endRowOut : integer; out newLoadCaseOut : TLoadCase) : boolean;
                var
                    gridFinished,
                    newLoadCaseFound,
                    canExitLoop         : boolean;
                    currentRow          : integer;
                begin
                    currentRow := startRowIn;

                    //read the load case
                        repeat
                            begin
                                //read the load combination
                                    tryReadLoadCaseCombination( currentRow, newLoadCaseOut );

                                //go to next row
                                    inc( currentRow );

                                //check if the loop must repeat
                                    newLoadCaseFound    := NOT( loadInputGrid.cellIsEmpty( NAME_COL, currentRow ) );
                                    gridFinished        := (loadInputGrid.RowCount - 1) < currentRow;

                                    canExitLoop := newLoadCaseFound OR gridFinished
                            end;
                        until ( canExitLoop );

                    //return the end row
                        endRowOut := currentRow - 1; //current row is the first row of the next load case

                    //get name
                        newLoadCaseOut.LCName := loadInputGrid.Cells[ NAME_COL, startRowIn ];

                    result := ( 0 < newLoadCaseOut.countCombinations() );
                end;

            function TLoadCasesInputManager.readLoadCases() : boolean;
                var
                    newLoadCaseFound    : boolean;
                    activeRow,
                    row                 : integer;
                    newLoadCase         : TLoadCase;
                    loadCaseMap         : TLoadCaseMap;
                begin
                    loadCaseMap := soilNailWallDesign.getLoadCases();
                    loadCaseMap.Clear();

                    row := 0;
                    while ( row < loadInputGrid.RowCount ) do
                        begin
                            inc( row );

                            //check if a new load case is needed
                                newLoadCaseFound := NOT( loadInputGrid.cellIsEmpty( NAME_COL, row ) );

                                if NOT( newLoadCaseFound ) then
                                    Continue;

                            //read the load case
                                if NOT( tryReadLoadCase( row, row, newLoadCase ) ) then
                                    Continue;

                            //place load case in map
                                loadCaseMap.AddOrSetValue( newLoadCase.LCName, newLoadCase );
                        end;

                    soilNailWallDesign.setLoadCases( loadCaseMap );

                    result := True;
                end;

        //write load case data to grid
            procedure TLoadCasesInputManager.writeLoadCaseCombinationToGrid(const updateEmptyCellsIn        : boolean;
                                                                            const arrayIndexIn, gridRowIn   : integer;
                                                                            const loadCaseIn                : TLoadCase);
                function _mustUpdateCell(const colIn : integer) : boolean;
                    var
                        cellIsEmptyAndMustBeUpdated,
                        cellIsEmpty                 : boolean;
                    begin
                        cellIsEmpty                 := ( loadInputGrid.cellIsEmpty( colIn, gridRowIn ) );
                        cellIsEmptyAndMustBeUpdated := updateEmptyCellsIn AND cellIsEmpty;

                        result := NOT( cellIsEmpty ) OR cellIsEmptyAndMustBeUpdated;
                    end;
                begin
                    if ( _mustUpdateCell( DESC_COL ) ) then
                        loadInputGrid.Cells[ DESC_COL, gridRowIn ] := loadCaseIn.getArrDescriptions()[ arrayIndexIn ];

                    if ( _mustUpdateCell( FACT_COL ) ) then
                        loadInputGrid.Cells[ FACT_COL, gridRowIn ] := FloatToStrF( loadCaseIn.getArrFactors()[ arrayIndexIn ], ffFixed, 5, 2 );

                    if ( _mustUpdateCell( LOAD_COL ) ) then
                        loadInputGrid.Cells[ LOAD_COL, gridRowIn ] := FloatToStrF( loadCaseIn.getArrLoads()[ arrayIndexIn ], ffFixed, 5, 2 );
                end;

            procedure TLoadCasesInputManager.writeLoadCaseToGrid(   const updateEmptyCellsIn    : boolean;
                                                                    const startRowIn            : integer;
                                                                    out endRowOut               : integer;
                                                                    const loadCaseIn            : TLoadCase );
                var
                    i, row, arrLen : integer;
                begin
                    arrLen := loadCaseIn.countCombinations();

                    for i := 0 to ( arrLen - 1 ) do
                        begin
                            row := startRowIn + i;

                            writeLoadCaseCombinationToGrid( updateEmptyCellsIn, i, row, loadCaseIn );
                        end;

                    endRowOut := row;
                end;

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
                    localUpdateEmptyCells   : boolean;
                    totalCombinations,
                    requiredRowCount,
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
                        totalCombinations := 0;

                        for LCKey in loadCaseMap.Keys do
                            begin
                                loadCaseMap.TryGetValue( LCKey, loadCase );

                                inc( totalCombinations, loadCase.countCombinations() );
                            end;

                        loadInputGrid.RowCount := totalCombinations + 2;

                        loadInputGrid.minSize();
                        loadInputGrid.editBorder( 1, clSilver );

                    //check if empty combinations are present - a grid reset is required if true
                        if ( emptyCombinationPresent() OR updateEmptyCellsIn ) then
                            begin
                                loadInputGrid.clearRows( 1 );
                                localUpdateEmptyCells := True;
                            end
                        else
                            localUpdateEmptyCells := False;

                    //write load cases
                        orderedKeys := loadCaseMap.getOrderedKeys().ToArray;

                        loadCaseStartRow := 1;

                        for LCKey in orderedKeys do
                            begin
                                if NOT( loadCaseMap.TryGetValue( LCKey, loadCase ) ) then
                                    Continue;

                                //write load case
                                    loadInputGrid.Cells[ NAME_COL, loadCaseStartRow ] := loadCase.LCName;

                                    writeLoadCaseToGrid( localUpdateEmptyCells, loadCaseStartRow, loadCaseEndRow, loadCase );

                                //set start for next load case
                                    loadCaseStartRow := loadCaseEndRow + 1;
                            end;
                end;

    //protected
        //check for input errors
            procedure TLoadCasesInputManager.checkLoadCaseCombinationForErrors(const arrayIndexIn : integer; const loadCaseIn : TLoadCase);
                var
                    factor, load    : double;
                    description     : string;
                begin
                    factor      := loadCaseIn.getArrFactors()[ arrayIndexIn ];
                    load        := loadCaseIn.getArrLoads()[ arrayIndexIn ];
                    description := loadCaseIn.getArrDescriptions()[ arrayIndexIn ];

                    if ( description = '' ) then
                        addError( loadCaseIn.LCName + ' must have descriptions for all combinations');

                    if ( IsZero( factor, 1e-3) OR (factor < 0) ) then
                        addError( loadCaseIn.LCName + ' - ' + description + ': factor must be greater than zero' );

                    if ( IsZero( load, 1e-3) OR (load < 0) ) then
                        addError( loadCaseIn.LCName + ' - ' + description + ': load must be greater than zero' );
                end;

            procedure TLoadCasesInputManager.checkLoadCaseForErrors(const loadCaseIn : TLoadCase);
                var
                    i : integer;
                begin
                    for i := 0 to ( loadCaseIn.countCombinations() - 1 ) do
                        checkLoadCaseCombinationForErrors( i, loadCaseIn );
                end;

            procedure TLoadCasesInputManager.checkForInputErrors();
                var
                    LCKey       : string;
                    loadCase    : TLoadCase;
                    loadCaseMap : TLoadCaseMap;
                begin
                    inherited checkForInputErrors();

                    loadCaseMap := soilNailWallDesign.getLoadCases();

                    for LCKey in loadCaseMap.getOrderedKeys() do
                        begin
                            if NOT( loadCaseMap.TryGetValue( LCKey, loadCase ) ) then
                                Continue;

                            checkLoadCaseForErrors( loadCase );
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
                        loadInputGrid.Cells[DESC_COL, 0] := 'Description';
                        loadInputGrid.Cells[FACT_COL, 0] := 'Factor';
                        loadInputGrid.Cells[LOAD_COL, 0] := 'Load (kN/m)';

                        loadInputGrid.minSize();
                        loadInputGrid.createBorder( 1, clSilver );
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

end.
