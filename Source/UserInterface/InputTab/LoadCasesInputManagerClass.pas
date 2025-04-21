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
                    NUMBER_COL  : integer = 0;
                    NAME_COL    : integer = 1;
                    DESC_COL    : integer = 2;
                    FACT_COL    : integer = 3;
                    LOAD_COL    : integer = 4;
                var
                    loadCasesLabel  : TLabel;
                    loadInputGrid   : TStringGrid;
                //read load case data from grid
                    function tryReadLoadCaseCombination(const gridRowIn : integer;
                                                        var loadCaseOut : TLoadCase) : boolean;
                    function tryReadLoadCase(const startRowIn : integer; out endRowOut : integer; out newLoadCaseOut : TLoadCase) : boolean;
                    function readLoadCases() : boolean;
                //write load case data to grid
                    procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                                    const gridRowIn             : integer;
                                                    const loadCaseIn            : TLoadCase );
                    procedure writeLoadCasesToGrid(const updateEmptyCellsIn : boolean);
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
                //setup input controls
                    procedure setupInputControls(); override;
                //reset controls
                    procedure resetInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
                //set active load case
                    procedure setActiveLoadCase(const loadCaseKeyIn : string);
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
            procedure TLoadCasesInputManager.writeLoadCaseToGrid(   const updateEmptyCellsIn    : boolean;
                                                                    const gridRowIn             : integer;
                                                                    const loadCaseIn            : TLoadCase );
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
//                    loadInputGrid.Cells[ NUMBER_COL, gridRowIn ] := IntToStr( gridRowIn );
//
//                    if ( _mustUpdateCell( NAME_COL ) ) then
//                        loadInputGrid.Cells[ NAME_COL, gridRowIn ] := loadCaseIn.name;
//
//                    if ( _mustUpdateCell( DESC_COL ) ) then
//                        loadInputGrid.Cells[ DESC_COL, gridRowIn ] := loadCaseIn.description;
//
//                    if ( _mustUpdateCell( FACT_COL ) ) then
//                        loadInputGrid.Cells[ FACT_COL, gridRowIn ] := FloatToStrF( loadCaseIn.factor, ffFixed, 5, 2 );
//
//                    if ( _mustUpdateCell( LOAD_COL ) ) then
//                        loadInputGrid.Cells[ LOAD_COL, gridRowIn ] := FloatToStrF( loadCaseIn.load, ffFixed, 5, 2 );
                end;

            procedure TLoadCasesInputManager.writeLoadCasesToGrid(const updateEmptyCellsIn : boolean);
                var
                    totalCombinations,
                    requiredRowCount,
                    row                 : integer;
                    LCKey               : string;
                    loadCase            : TLoadCase;
                    loadCaseMap         : TLoadCaseMap;
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
//
//                    for mapKey in loadCaseMap.Keys do
//                        begin
//                            if NOT( loadCaseMap.TryGetValue( mapKey, loadCase ) ) then
//                                Continue;
//
//                            row := mapKey;
//
//                            writeLoadCaseToGrid( updateEmptyCellsIn, row, loadCase );
//                        end;
                end;

    //protected
        //check for input errors
            procedure TLoadCasesInputManager.checkForInputErrors();
                begin
                    inherited checkForInputErrors();

                    addError( 'Still need to implement error handling here' );
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
                    COLUMN_SIZES : TArray<integer> = [45, 80, 250, 80, 80];
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
                        loadInputGrid.ColCount  := 5;
                        loadInputGrid.RowCount  := 2;
                        loadInputGrid.FixedCols := 1;
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

        //set active load case
            procedure TLoadCasesInputManager.setActiveLoadCase(const loadCaseKeyIn : string);
                begin

                end;

end.
