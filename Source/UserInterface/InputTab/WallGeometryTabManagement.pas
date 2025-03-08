unit WallGeometryTabManagement;

interface

    uses
        //Delphi
            Winapi.Windows,
            System.SysUtils, Math,
            Vcl.Forms, Vcl.Grids, Vcl.Buttons,
        //custom
            StringGridHelperClass,
            SoilNailWallTypes,
            SoilNailWallMasterClass;

    //check if the wall geometry grids are populated
        function wallGeomGridsPopulated(var strGrdWallPropertiesInOut,
                                            strGrdSlopePropertiesInOut  : TStringGrid) : boolean;

    //read info from grids into SNW class
        function readWallGeomGrids( var strGrdWallPropertiesInOut,
                                        strGrdSlopePropertiesInOut  : TStringGrid;
                                    var SNWClassInOut               : TSoilNailWall) : boolean;

    //write from SNW class to grids
        procedure writeToWallGeomGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdWallPropertiesInOut,
                                            strGrdSlopePropertiesInOut  : TStringGrid;
                                        const SNWClassIn                : TSoilNailWall );

implementation

    //update the grid based on input data
//        procedure gridWallGeomChanged(var strGrdPropInOut : TStringGrid);
//            var
//                row : integer;
//            begin
//                //check if a double is entered
//                    for row := 0 to (strGrdPropInOut.RowCount - 1) do
//                        strGrdPropInOut.isCellDouble(1, row);
//            end;

    //check if the wall geometry grids are populated
        //helper method
            function isWallGeomGridPopulated(var strGrdWallGeomInOut : TStringGrid) : boolean;
                var
                    gridPopulated   : boolean;
                    row             : integer;
                    dummy           : double;
                begin
//                    gridWallGeomChanged(strGrdWallGeomInOut);

                    for row := 0 to (strGrdWallGeomInOut.RowCount - 1) do
                        begin
                            gridPopulated := strGrdWallGeomInOut.tryCellToDouble( 1, row, dummy );

                            if (gridPopulated = False) then
                                break;
                        end;

                    result := gridPopulated
                end;

        function wallGeomGridsPopulated(var strGrdWallPropertiesInOut,
                                            strGrdSlopePropertiesInOut  : TStringGrid) : boolean;
            var
                wallPropPopulated, slopePropPopulated : boolean;
            begin
                wallPropPopulated   := isWallGeomGridPopulated(strGrdWallPropertiesInOut);
                slopePropPopulated  := isWallGeomGridPopulated(strGrdSlopePropertiesInOut);

                result := (wallPropPopulated AND slopePropPopulated);
            end;

    //read info from grids into SNW class
        //wall properties
            function readWallPropertiesGrid(var strGrdWallPropertiesInOut   : TStringGrid;
                                            var SNWClassInOut               : TSoilNailWall) : boolean;
                var
                    gridIsPopulated : boolean;
                    wall            : TWall;
                begin
                    //check grid populated
                        gridIsPopulated := isWallGeomGridPopulated(strGrdWallPropertiesInOut);

                    //read into SNW class
                        wall := SNWClassInOut.getWall();

                        wall.height     := strGrdWallPropertiesInOut.cellToDouble(1, 0);
                        wall.thickness  := strGrdWallPropertiesInOut.cellToDouble(1, 1) / 1000;
                        wall.angle      := strGrdWallPropertiesInOut.cellToDouble(1, 2);

                        SNWClassInOut.setWall(wall);

                    result := gridIsPopulated
                end;

        //slope properties
            function readSlopePropertiesGrid(   var strGrdSlopePropertiesInOut  : TStringGrid;
                                                var SNWClassInOut               : TSoilNailWall) : boolean;
                var
                    gridIsPopulated         : boolean;
                    slopeAngle, slopeHeight,
                    wallheight              : double;
                    soil                    : TSoil;
                begin
                    //check grid populated
                        gridIsPopulated := isWallGeomGridPopulated(strGrdSlopePropertiesInOut);

                    //read into SNW class
                        soil := SNWClassInOut.getSoil();

                        soil.slope.angle        := strGrdSlopePropertiesInOut.cellToDouble(1, 0);
                        soil.slope.maxHeight    := strGrdSlopePropertiesInOut.cellToDouble(1, 1);

                        SNWClassInOut.setSoil(soil);

                    result := gridIsPopulated;
                end;

        function readWallGeomGrids( var strGrdWallPropertiesInOut,
                                        strGrdSlopePropertiesInOut  : TStringGrid;
                                    var SNWClassInOut               : TSoilNailWall) : boolean;
            var
                wallPropPopulated, slopePropPopulated : boolean;
            begin
                //read all the input grids
                    wallPropPopulated   := readWallPropertiesGrid(strGrdWallPropertiesInOut, SNWClassInOut);

                    slopePropPopulated  := readSlopePropertiesGrid(strGrdSlopePropertiesInOut, SNWClassInOut);

                result := (wallPropPopulated AND slopePropPopulated);
            end;

    //write from SNW class to grids
        //wall properties
            procedure writeToWallPropertiesGrid(const updateEmptyCellsIn        : boolean;
                                                var strGrdWallPropertiesInOut   : TStringGrid;
                                                const SNWClassIn                : TSoilNailWall);
                var
                    row                                     : integer;
                    wallHeight, wallThickness, wallAngle,
                    doubleValue                             : double;
                    stringValue                             : string;
                    wall                                    : TWall;
                begin
                    wall := SNWClassIn.getWall();

                    wallHeight      := wall.height;
                    wallThickness   := 1000 * wall.thickness; //convert from m -> mm
                    wallAngle       := wall.angle;

                    row := 0;

                    for doubleValue in [wallHeight, wallThickness, wallAngle] do
                        begin
                            if ( NOT(strGrdWallPropertiesInOut.cellIsEmpty(1, row)) OR updateEmptyCellsIn ) then
                                begin
                                    stringValue := FloatToStrF(doubleValue, ffFixed, 5, 2);

                                    strGrdWallPropertiesInOut.Cells[1, row] := stringValue;
                                end;

                            inc(row);
                        end;
                end;

        //slope properties
            procedure writeToSlopePropertiesGrid(   const updateEmptyCellsIn        : boolean;
                                                    var strGrdSlopePropertiesInOut  : TStringGrid;
                                                    const SNWClassIn                : TSoilNailWall );
                var
                    row                     : integer;
                    slopeAngle, slopeHeight,
                    doubleValue             : double;
                    stringValue             : string;
                    soil                    : TSoil;
                begin
                    soil := SNWClassIn.getSoil();

                    slopeAngle  := soil.slope.angle;
                    slopeHeight := soil.slope.maxHeight;

                    row := 0;

                    for doubleValue in [slopeAngle, slopeHeight] do
                        begin
                            if ( NOT(strGrdSlopePropertiesInOut.cellIsEmpty(1, row)) OR updateEmptyCellsIn ) then
                                begin
                                    stringValue := FloatToStrF(doubleValue, ffFixed, 5, 2);

                                    strGrdSlopePropertiesInOut.Cells[1, row] := stringValue;
                                end;

                            inc(row);
                        end;
                end;

        procedure writeToWallGeomGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdWallPropertiesInOut,
                                            strGrdSlopePropertiesInOut  : TStringGrid;
                                        const SNWClassIn                : TSoilNailWall );
            begin
                writeToWallPropertiesGrid( updateEmptyCellsIn, strGrdWallPropertiesInOut, SNWClassIn );

                writeToSlopePropertiesGrid( updateEmptyCellsIn, strGrdSlopePropertiesInOut, SNWClassIn );
            end;


end.
