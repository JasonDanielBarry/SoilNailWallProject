unit LoadCaseUIMethods;

interface

    uses
        System.SysUtils, System.Math,
        Vcl.Grids,
        CustomStringGridClass,
        LoadCaseTypes
        ;

    const
        LC_HEADING_DESCRIPTION  : string = 'Description';
        LC_HEADING_FACTOR       : string = 'Factor';
        LC_HEADING_LOAD         : string = 'Load (kN/m)';

    //read load case data from grid
        function tryReadLoadCase(   const   startColIn,
                                            startRowIn,
                                            endRowIn    : integer;
                                    const   gridIn      : TJDBStringGrid;
                                    out loadCaseInOut   : TLoadCase         ) : boolean;

    //write load case data to grid
        procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                        const startCol, startRowIn  : integer;
                                        out endRowOut               : integer;
                                        const loadCaseIn            : TLoadCase;
                                        const gridIn                : TJDBStringGrid   ); overload;

        procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                        const startCol, startRowIn  : integer;
                                        const loadCaseIn            : TLoadCase;
                                        const gridIn                : TJDBStringGrid   ); overload;

implementation

    //read load case data from grid
        function tryReadLoadCaseCombination(const startColIn, gridRowIn : integer;
                                            const gridIn                : TJDBStringGrid;
                                            var loadCaseInOut           : TLoadCase     ) : boolean;
            var
                validCombination    : boolean;
                factor, load        : double;
                description         : string;
            begin
                //extract load case from grid
                    description := gridIn.Cells[ startColIn, gridRowIn ];
                    gridIn.tryCellToDouble( startColIn + 1, gridRowIn, factor );
                    gridIn.tryCellToDouble( startColIn + 2, gridRowIn, load );

                //test if load case is valid - this does not mean it will not raise an input error
                    validCombination := (description <> '');
                    validCombination := validCombination OR NOT( IsZero( factor, 1e-3 ) );
                    validCombination := validCombination OR NOT( IsZero( load, 1e-3 ) );

                //send to load case record
                    if ( validCombination ) then
                        loadCaseInOut.addLoadCombination( factor, load, description );

                result := validCombination;
            end;

        function tryReadLoadCase(   const   startColIn,
                                            startRowIn,
                                            endRowIn    : integer;
                                    const   gridIn      : TJDBStringGrid;
                                    out loadCaseInOut   : TLoadCase         ) : boolean;
            var
                row : integer;
            begin
                for row := startRowIn to endRowIn do
                    tryReadLoadCaseCombination( startColIn, row, gridIn, loadCaseInOut );

                result := ( 0 < loadCaseInOut.countCombinations() );
            end;

    //write load case data to grid
        procedure writeLoadCaseCombinationToGrid(   const   updateEmptyCellsIn      : boolean;
                                                    const   startColIn, gridRowIn,
                                                            arrayIndexIn            : integer;
                                                    const   loadCaseIn              : TLoadCase;
                                                    const   gridIn                  : TJDBStringGrid   );
            function _mustUpdateCell(const colIn : integer) : boolean;
                    var
                        cellIsEmptyAndMustBeUpdated,
                        cellIsEmpty                 : boolean;
                    begin
                        cellIsEmpty                 := ( gridIn.cellIsEmpty( colIn, gridRowIn ) );
                        cellIsEmptyAndMustBeUpdated := updateEmptyCellsIn AND cellIsEmpty;

                        result := NOT( cellIsEmpty ) OR cellIsEmptyAndMustBeUpdated;
                    end;
                begin
                    if ( _mustUpdateCell( startColIn ) ) then
                        gridIn.Cells[ startColIn, gridRowIn ] := loadCaseIn.getArrDescriptions()[ arrayIndexIn ];

                    if ( _mustUpdateCell( startColIn + 1 ) ) then
                        gridIn.Cells[ startColIn + 1, gridRowIn ] := FloatToStrF( loadCaseIn.getArrFactors()[ arrayIndexIn ], ffFixed, 5, 2 );

                    if ( _mustUpdateCell( startColIn + 2 ) ) then
                        gridIn.Cells[ startColIn + 2, gridRowIn ] := FloatToStrF( loadCaseIn.getArrLoads()[ arrayIndexIn ], ffFixed, 5, 2 );
                end;

        procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                        const startCol, startRowIn  : integer;
                                        out endRowOut               : integer;
                                        const loadCaseIn            : TLoadCase;
                                        const gridIn                : TJDBStringGrid   );
            var
                i, row, arrLen : integer;
            begin
                arrLen := loadCaseIn.countCombinations();

                if ( arrlen < 1 ) then
                    exit();

                row := startRowIn;

                for i := 0 to ( arrLen - 1 ) do
                    begin
                        row := startRowIn + i;

                        writeLoadCaseCombinationToGrid( updateEmptyCellsIn, startCol, row, i, loadCaseIn, gridIn );
                    end;

                endRowOut := row;
            end;

        procedure writeLoadCaseToGrid(  const updateEmptyCellsIn    : boolean;
                                        const startCol, startRowIn  : integer;
                                        const loadCaseIn            : TLoadCase;
                                        const gridIn                : TJDBStringGrid   );
            var
                dummyInt : integer;
            begin
                writeLoadCaseToGrid( updateEmptyCellsIn, startCol, startRowIn, dummyInt, loadCaseIn, gridIn );
            end;

end.
