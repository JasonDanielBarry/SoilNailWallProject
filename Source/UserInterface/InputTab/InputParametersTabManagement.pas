unit InputParametersTabManagement;

interface

    uses
        //Delphi
            Winapi.Windows,
            System.SysUtils, Math,
            Vcl.Forms, Vcl.Grids, Vcl.Buttons,
        //custom
            LimitStateMaterialClass,
            StringGridHelperClass,
            SoilNailWallTypes,
            SoilNailWallMasterClass;

    //auto-populate grids
        //setup the grid so that average values entered will be design values
            procedure useAverageInputValuesForDesign(   var strGrdSoilParInputInOut,
                                                            strGrdSteelParInputInOut,
                                                            strGrdConcreteParInputInOut : TStringGrid); overload;

        //populate grids to limit state factors
            procedure InputParLimitStateFactors(var strGrdSoilParInputInOut,
                                                    strGrdSteelParInputInOut,
                                                    strGrdConcreteParInputInOut : TStringGrid);

        //clear the factors stored in the grid
            procedure clearInputFactors(var strGrdSoilParInputInOut,
                                            strGrdSteelParInputInOut,
                                            strGrdConcreteParInputInOut : TStringGrid); overload

    //read values from grids to SNW class
        function readInputParGrids( var strGrdSoilParInputInOut,
                                        strGrdSteelParInputInOut,
                                        strGrdConcreteParInputInOut : TStringGrid;
                                    var SNWClassInOut               : TSoilNailWall) : boolean;

    //write from SNW class into grids
        procedure writeToInputParGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdSoilParInputInOut,
                                            strGrdSteelParInputInOut,
                                            strGrdConcreteParInputInOut : TStringGrid;
                                        const SNWClassIn                : TSoilNailWall );

implementation

    //auto-populate grids
        //setup the grid so that average values entered will be design values
            procedure useAverageInputValuesForDesign(var strGrdInputParInOut : TStringGrid); overload
                var
                    row, col : integer;
                begin
                    for row := 0 to (strGrdInputParInOut.RowCount - 1) do
                        begin
                            for col in [2, 3] do
                                strGrdInputParInOut.Cells[col, row] := '0';

                            strGrdInputParInOut.Cells[5, row] := '1';
                        end;
                end;

            procedure useAverageInputValuesForDesign(   var strGrdSoilParInputInOut,
                                                            strGrdSteelParInputInOut,
                                                            strGrdConcreteParInputInOut : TStringGrid);
                begin
                    useAverageInputValuesForDesign(strGrdSoilParInputInOut);
                    useAverageInputValuesForDesign(strGrdSteelParInputInOut);
                    useAverageInputValuesForDesign(strGrdConcreteParInputInOut);
                end;

        //set grids to limit state factors
            //soil
                procedure soilLimitStateFactors(var strGrdSoilParInputInOut : TStringGrid);
                    begin
                        //cohesion
                            //variation coefficient
                                strGrdSoilParInputInOut.cells[2, 0] := '0.4';
                            //dowgrade factor
                                strGrdSoilParInputInOut.cells[3, 0] := '1';
                            //partial factor
                                strGrdSoilParInputInOut.cells[5, 0] := '1.4';

                        //friction angle
                            //variation coefficient
                                strGrdSoilParInputInOut.cells[2, 1] := '0.1';
                            //dowgrade factor
                                strGrdSoilParInputInOut.cells[3, 1] := '1';
                            //partial factor
                                strGrdSoilParInputInOut.cells[5, 1] := '1.25';

                        //unit weight
                            //variation coefficient
                                strGrdSoilParInputInOut.cells[2, 2] := '0';
                            //dowgrade factor
                                strGrdSoilParInputInOut.cells[3, 2] := '0';
                            //partial factor
                                strGrdSoilParInputInOut.cells[5, 2] := '1';
                    end;

            //steel
                procedure steelLimitStateFactors(var strGrdSteelParInputInOut : TStringGrid);
                    begin
                        //steel tensile strength
                            //variation coefficient
                                strGrdSteelParInputInOut.cells[2, 0] := '0.05';
                            //dowgrade factor
                                strGrdSteelParInputInOut.cells[3, 0] := '1';
                            //partial factor
                                strGrdSteelParInputInOut.cells[5, 0] := '1.8';

                        //grout soil interface bond strength
                            //variation coefficient
                                strGrdSteelParInputInOut.cells[2, 1] := '0.4';
                            //dowgrade factor
                                strGrdSteelParInputInOut.cells[3, 1] := '1';
                            //partial factor
                                strGrdSteelParInputInOut.cells[5, 1] := '1.4';
                    end;

            //concrete
                procedure concreteLimitStateFactors(var strGrdConcreteParInputInOut : TStringGrid);
                    begin
                        //steel reinforcement strength
                            //variation coefficient
                                strGrdConcreteParInputInOut.cells[2, 0] := '0.05';
                            //dowgrade factor
                                strGrdConcreteParInputInOut.cells[3, 0] := '1';
                            //partial factor
                                strGrdConcreteParInputInOut.cells[5, 0] := '1.15';

                        //concrete compressive strength
                            //variation coefficient
                                strGrdConcreteParInputInOut.cells[2, 1] := '0.15';
                            //dowgrade factor
                                strGrdConcreteParInputInOut.cells[3, 1] := '1';
                            //partial factor
                                strGrdConcreteParInputInOut.cells[5, 1] := '1.5';
                    end;

            procedure InputParLimitStateFactors(var strGrdSoilParInputInOut,
                                                    strGrdSteelParInputInOut,
                                                    strGrdConcreteParInputInOut : TStringGrid);
                begin
                    soilLimitStateFactors(strGrdSoilParInputInOut);

                    steelLimitStateFactors(strGrdSteelParInputInOut);

                    concreteLimitStateFactors(strGrdConcreteParInputInOut);
                end;

        //clear the factors stored in the grid
            procedure clearInputFactors(var strGrdInputParInOut : TStringGrid); overload;
                var
                    row, col : integer;
                begin
                    for row := 0 to (strGrdInputParInOut.RowCount - 1) do
                        for col in [2, 3, 5] do
                            begin
                                strGrdInputParInOut.Cells[col, row] := '';
                            end;
                end;

            procedure clearInputFactors(var strGrdSoilParInputInOut,
                                            strGrdSteelParInputInOut,
                                            strGrdConcreteParInputInOut : TStringGrid);
                begin
                    clearInputFactors(strGrdSoilParInputInOut);
                    clearInputFactors(strGrdSteelParInputInOut);
                    clearInputFactors(strGrdConcreteParInputInOut);
                end;

    //test if the grids are all populated
        //helper functions
            //function to test if the design values are available to read into the SWN class
                function areDesignValuesPopulated(var stringGridInOut : TStringGrid) : boolean;
                    var
                        arePopulatedOut : boolean;
                        col, row        : integer;
                    begin
                        for row := 0 to (stringGridInOut.RowCount - 1) do
                            for col := 1 to (stringGridInOut.ColCount - 1) do
                                begin
                                    arePopulatedOut := stringGridInOut.isCellDouble(col, row);

                                    if (arePopulatedOut = false) then
                                        begin
                                            result := arePopulatedOut;
                                            exit();
                                        end;
                                end;

                        result := arePopulatedOut;
                    end;

        function inputParametersGridsPopulated( var strGrdSoilParInputInOut,
                                                    strGrdSteelParInputInOut,
                                                    strGrdConcreteParInputInOut : TStringGrid) : boolean;
            var
                soilPropPopulated, steelPropPopulated, concretePropPopulated : boolean;
            begin
                soilPropPopulated       := areDesignValuesPopulated(strGrdSoilParInputInOut);

                steelPropPopulated      := areDesignValuesPopulated(strGrdSteelParInputInOut);

                concretePropPopulated   := areDesignValuesPopulated(strGrdConcreteParInputInOut);

                result := (soilPropPopulated AND steelPropPopulated AND concretePropPopulated);
            end;

    //read values from grid to SNW class
        //helper methods
            procedure gridToLimitStateMaterial( const gridRowIn     : integer;
                                                var materialInOut   : TLimitStateMaterial;
                                                var readGridInOut   : TStringGrid           );
                var
                    averageVal, coefVar, downgradeFac, partialFac : double;
                begin
                    averageVal      := readGridInOut.cellToDouble(1, gridRowIn);
                    coefVar         := readGridInOut.cellToDouble(2, gridRowIn);
                    downgradeFac    := readGridInOut.cellToDouble(3, gridRowIn);
                    partialFac      := readGridInOut.cellToDouble(5, gridRowIn);

                    materialInOut.setValues(averageVal, coefVar, downgradeFac, partialFac);
                end;

        //soil
            function readFromInputSoilParGrid(  var strGrdSoilParInputInOut : TStringGrid;
                                                var SNWClassInOut           : TSoilNailWall) : boolean;
                var
                    designValuesAvailable   : boolean;
                    soil                    : TSoil;
                begin
                    //check the values are available
                        designValuesAvailable := areDesignValuesPopulated(strGrdSoilParInputInOut);

                    //read values into SNW class
                        soil := SNWClassInOut.getSoil();

                        //cohesion
                            GridToLimitStateMaterial(   0,
                                                        soil.cohesion,
                                                        strGrdSoilParInputInOut );

                        //friction angle
                            gridToLimitStateMaterial(   1,
                                                        soil.frictionAngle,
                                                        strGrdSoilParInputInOut );

                        //unit weight
                            GridToLimitStateMaterial(   2,
                                                        soil.unitWeight,
                                                        strGrdSoilParInputInOut     );

                        SNWClassInOut.setSoil(soil);

                    result := designValuesAvailable;
                end;

        //steel
            function readFromInputSteelParGrid( var strGrdSteelParInputInOut    : TStringGrid;
                                                var SNWClassInOut               : TSoilNailWall) : boolean;
                var
                    designValuesAvailable   : boolean;
                    nails                   : TSoilNails;
                begin
                    //check the values are available
                        designValuesAvailable := areDesignValuesPopulated(strGrdSteelParInputInOut);

                    //read values into SNW class
                        nails := SNWClassInOut.getNails();

                        gridToLimitStateMaterial(   0,
                                                    nails.strength.tensile,
                                                    strGrdSteelParInputInOut    );

                        gridToLimitStateMaterial(   1,
                                                    nails.strength.groutSoilInterface,
                                                    strGrdSteelParInputInOut            );

                        SNWClassInOut.setNails(nails);

                    result := designValuesAvailable;
                end;

        //concrete
            function readFromInputConcreteParGrid(  var strGrdConcreteParInputInOut : TStringGrid;
                                                    var SNWClassInOut               : TSoilNailWall) : boolean;
                var
                    designValuesAvailable                       : boolean;
                    wall : TWall;
                    compressiveStrength, reinforcementStrength  : TLimitStateMaterial;
                begin
                    //check the values are available
                        designValuesAvailable := areDesignValuesPopulated(strGrdConcreteParInputInOut);

                        wall := SNWClassInOut.getWall();

                        gridToLimitStateMaterial(
                                                    0,
                                                    wall.concrete.strength.reinforcement,
                                                    strGrdConcreteParInputInOut
                                                );

                        gridToLimitStateMaterial(
                                                    1,
                                                    wall.concrete.strength.compressive,
                                                    strGrdConcreteParInputInOut
                                                );

                    //read values into SNW class
                        SNWClassInOut.setWall(wall);

                    result := designValuesAvailable;
                end;

        function readInputParGrids( var strGrdSoilParInputInOut,
                                        strGrdSteelParInputInOut,
                                        strGrdConcreteParInputInOut : TStringGrid;
                                    var SNWClassInOut               : TSoilNailWall) : boolean;
            var
                soilPropPopulated, steelPropPopulated, concretePropPopulated : boolean;
            begin
                //read all the input grids
                    soilPropPopulated       := readFromInputSoilParGrid(strGrdSoilParInputInOut, SNWClassInOut);

                    steelPropPopulated      := readFromInputSteelParGrid(strGrdSteelParInputInOut, SNWClassInOut);

                    concretePropPopulated   := readFromInputConcreteParGrid(strGrdConcreteParInputInOut, SNWClassInOut);

                result := (soilPropPopulated AND steelPropPopulated AND concretePropPopulated);
            end;

    //write from SNW class into grids
        //helper methods
            procedure limitStateMaterialToGrid( const updateEmptyCellsIn    : boolean;
                                                const gridRowIn             : integer;
                                                var materialInOut           : TLimitStateMaterial;
                                                var writeGridInOut          : TStringGrid           );
                var
                    validAverage, validCoefVar, validDownGrFac,
                    validCautiousEstimate,
                    validDesignValue                            : boolean;
                    col                                         : integer;
                    averageVal, coefVar, downgradeFac,
                    cautiousEstimate, partialFac, designValue,
                    doubleValue                                 : double;
                    stringValue                                 : string;
                begin
                    //get the values
                        averageVal          := materialInOut.averageValue;
                        coefVar             := materialInOut.variationCoefficient;
                        downgradeFac        := materialInOut.downgradeFactor;
                        cautiousEstimate    := materialInOut.cautiousEstimate();
                        partialFac          := materialInOut.partialFactor;
                        designValue         := materialInOut.designValue();

                    //write the values into the grid
                        col := 1;

                        for doubleValue in [averageVal, coefVar, downgradeFac, cautiousEstimate, partialFac, designValue] do
                            begin
                                if ( NOT(writeGridInOut.cellIsEmpty(col, gridRowIn)) OR updateEmptyCellsIn ) then
                                    begin
                                        stringValue := FloatToStrF(doubleValue, ffFixed, 5, 2);

                                        writeGridInOut.Cells[col, gridRowIn] := stringValue;
                                    end;

                                inc(col);
                            end;

                    //special cases
                        //write the cautious estimate
                            validAverage    := NOT(writeGridInOut.cellIsEmpty( 1, gridRowIn ));
                            validCoefVar    := NOT(writeGridInOut.cellIsEmpty( 2, gridRowIn ));
                            validDownGrFac  := NOT(writeGridInOut.cellIsEmpty( 3, gridRowIn ));

                            validCautiousEstimate := ( validAverage AND validCoefVar AND validDownGrFac );

                            if ( validCautiousEstimate OR updateEmptyCellsIn ) then
                                writeGridInOut.Cells[4, gridRowIn] := FloatToStrF( cautiousEstimate, ffFixed, 5, 2 )
                            else
                                writeGridInOut.Cells[4, gridRowIn] := '';

                        //write the design value
                            validDesignValue := ( validCautiousEstimate AND ( NOT(writeGridInOut.cellIsEmpty(5, gridRowIn)) ) );

                            if ( validDesignValue OR updateEmptyCellsIn ) then
                                writeGridInOut.Cells[6, gridRowIn] := FloatToStrF( designValue, ffFixed, 5, 2 )
                            else
                                writeGridInOut.Cells[6, gridRowIn] := '';
                end;

        //soil
            procedure writeToInputSoilParGrid(  const updateEmptyCellsIn    : boolean;
                                                var strGrdSoilParInputInOut : TStringGrid;
                                                const SNWClassIn            : TSoilNailWall );
                var
                    soil : TSoil;
                begin
                    soil := SNWClassIn.getSoil();

                    //write soil to grid
                        //cohesion
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        soil.cohesion,
                                                        strGrdSoilParInputInOut );

                        //friction angle
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        soil.frictionAngle,
                                                        strGrdSoilParInputInOut );

                        //unit weight
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        2,
                                                        soil.unitWeight,
                                                        strGrdSoilParInputInOut );
                end;

        //steel
            procedure writeToInputSteelParGrid( const updateEmptyCellsIn        : boolean;
                                                var strGrdSteelParInputInOut    : TStringGrid;
                                                const SNWClassIn                : TSoilNailWall );
                var
                    nails : TSoilNails;
                begin
                    nails := SNWClassIn.getNails();

                    //write nail strength values to grid
                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        nails.strength.tensile,
                                                        strGrdSteelParInputInOut);

                        //grout
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        nails.strength.groutSoilInterface,
                                                        strGrdSteelParInputInOut            );
                end;

        //concrete
            procedure writeToInputConcreteParGrid(  const updateEmptyCellsIn        : boolean;
                                                    var strGrdConcreteParInputInOut : TStringGrid;
                                                    const SNWClassIn                : TSoilNailWall );
                var
                    wall : TWall;
                begin
                    wall := SNWClassIn.getWall();

                    //write wall strength values to grid
                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        wall.concrete.strength.reinforcement,
                                                        strGrdConcreteParInputInOut             );

                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        wall.concrete.strength.compressive,
                                                        strGrdConcreteParInputInOut         );

                end;

        procedure writeToInputParGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdSoilParInputInOut,
                                            strGrdSteelParInputInOut,
                                            strGrdConcreteParInputInOut : TStringGrid;
                                        const SNWClassIn                : TSoilNailWall );
            begin
                writeToInputSoilParGrid(updateEmptyCellsIn, strGrdSoilParInputInOut, SNWClassIn);

                writeToInputSteelParGrid(updateEmptyCellsIn, strGrdSteelParInputInOut, SNWClassIn);

                writeToInputConcreteParGrid(updateEmptyCellsIn, strGrdConcreteParInputInOut, SNWClassIn);
            end;


end.
