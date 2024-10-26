unit NailPropertiesTabManagement;

interface

    uses
        //Delphi
            Winapi.Windows,
            System.SysUtils, system.Math, system.UITypes,
            Vcl.Forms, vcl.Graphics, Vcl.Grids,
        //custom
            GeneralMathMethods,
            InterpolatorClass,
            StringGridHelperClass,
            SoilNailWallTypes,
            SoilNailWallMasterClass;

    //read from the nail layout grid to the SNW class
        function readNailPropGrids( var strGrdNailPropertiesInOut,
                                        strGrdNailLayoutInOut       : TStringGrid;
                                    var soilNailWallDesignInOut     : TSoilNailWall) : boolean;

    //write from the SNW class to the grids
        procedure writeToNailPropGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdNailPropertiesInOut,
                                            strGrdNailLayoutInOut       : TStringGrid;
                                        const soilNailWallDesignIn      : TSoilNailWall );

implementation

    //read from the nail grids
        //read the nail properties grid into the SNW class
            function readNailPropertiesGrid(var strGrdNailPropertiesInOut   : TStringGrid;
                                            var soilNailWallDesignInOut     : TSoilNailWall) : boolean;
                var
                    gridIsPopulated     : boolean;
                    row                 : integer;
                    nails               : TSoilNails;
                begin
                    for row := 0 to (strGrdNailPropertiesInOut.RowCount - 1) do
                        begin
                            gridIsPopulated := strGrdNailPropertiesInOut.isCellDouble(1, row);

                            if ( NOT(gridIsPopulated) ) then
                                break;
                        end;

                    nails := soilNailWallDesignInOut.getNails();

                    nails.angle                 := strGrdNailPropertiesInOut.cellToDouble(1, 0);
                    nails.horizontalSpacing     := strGrdNailPropertiesInOut.cellToDouble(1, 1);
                    nails.diameter.groutHole    := strGrdNailPropertiesInOut.cellToDouble(1, 2) / 1000;

                    soilNailWallDesignInOut.setNails( nails );

                    result := gridIsPopulated;
                end;

        //read from the nail layout grid to the SNW class
            function readNailLayoutGrid(var strGrdNailLayoutInOut   : TStringGrid;
                                        var soilNailWallDesignInOut : TSoilNailWall) : boolean;
                var
                    isValidSpace, isValidLength,
                    isValidNail                 : boolean;
                    i                           : integer;
                    dy,
                    nailHeight, nailLength,
                    nailSpace,  wallHeight      : double;
                begin
                    //reset layout
                        soilNailWallDesignInOut.clearNailLayout();

                    //initialise values
                        dy          := 0;
                        wallHeight  := soilNailWallDesignInOut.getWall().height;

                    //read values in from the grid
                        for i := 1 to (strGrdNailLayoutInOut.RowCount - 1) do
                            begin
                                nailSpace   := strGrdNailLayoutInOut.cellToDouble(2, i);
                                nailLength  := strGrdNailLayoutInOut.cellToDouble(3, i);

                                isValidSpace    := NOT(isAlmostZero(nailSpace));
                                isValidLength   := NOT(isAlmostZero(nailLength));
                                isValidNail     := (isValidSpace OR isValidLength);

                                if (isValidNail) then
                                    begin
                                        dy := dy + nailSpace;
                                        nailHeight := wallHeight - dy;

                                        soilNailWallDesignInOut.addNail(nailHeight, nailLength);
                                    end;
                            end;

                    result := strGrdNailLayoutInOut.RowCount > 2;
                end;

        function readNailPropGrids( var strGrdNailPropertiesInOut,
                                        strGrdNailLayoutInOut       : TStringGrid;
                                    var soilNailWallDesignInOut     : TSoilNailWall) : boolean;
            var
                propertiesPopulated, layoutPopulated : boolean;
            begin
                propertiesPopulated := readNailPropertiesGrid(strGrdNailPropertiesInOut, soilNailWallDesignInOut);
                layoutPopulated     := readNailLayoutGrid(strGrdNailLayoutInOut, soilNailWallDesignInOut);

                result := (propertiesPopulated AND layoutPopulated);
            end;

    //write to the nail grids
        //write from SNW class into nail properties grid
            procedure writeToNailPopertiesGrid( const updateEmptyCellsIn        : boolean;
                                                var strGrdNailPropertiesInOut   : TStringGrid;
                                                const soilNailWallDesignIn      : TSoilNailWall );
                var
                    row                 : integer;
                    nailAngle,
                    outOfPlaneSpacing,
                    groutHoleDiameter,
                    doubleValue         : double;
                    stringValue         : string;
                    nails               : TSoilNails;
                begin
                    nails := soilNailWallDesignIn.getNails();

                    nailAngle           := nails.angle;
                    outOfPlaneSpacing   := nails.horizontalSpacing;
                    groutHoleDiameter   := nails.diameter.groutHole * 1000;

                    row := 0;

                    for doubleValue in [nailAngle, outOfPlaneSpacing, groutHoleDiameter] do
                        begin
                            if ( NOT(strGrdNailPropertiesInOut.cellIsEmpty(1, row)) OR updateEmptyCellsIn ) then
                                begin
                                    stringValue := FloatToStrF( doubleValue, ffFixed, 5, 2 );

                                    strGrdNailPropertiesInOut.Cells[1, row] := stringValue;
                                end;

                            inc(row);
                        end;
                end;

        //write from SNW class into nail layout grid
            procedure writeToNailLayoutGrid(var strGrdNailLayoutInOut   : TStringGrid;
                                            const soilNailWallDesignIn  : TSoilNailWall);
                var
                    i, nailNum                  : integer;
                    nailHeight,     nailLength,
                    prevNailHeight, nailSpacing : double;
                    nails                       : TSoilNails;
                    arrHeights, arrLengths      : TArray<double>;
                begin
                    strGrdNailLayoutInOut.Parent.LockDrawing();

                    nails := soilNailWallDesignIn.getNails();

                    strGrdNailLayoutInOut.RowCount := nails.nailCount() + 2;

                    //get the nail arrays
                        arrHeights := nails.getArrHeight();
                        arrLengths := nails.getArrLengths();

                    //wall height it first prevHeight
                        prevNailHeight := soilNailWallDesignIn.getWall().height;

                    for i := 0 to (nails.nailCount() - 1) do
                        begin
                            //write nail number
                                nailNum := i + 1;
                                strGrdNailLayoutInOut.Cells[0, nailNum] := IntToStr(nailNum);

                            //write nail height
                                nailHeight := arrHeights[i];
                                strGrdNailLayoutInOut.Cells[1, nailNum] := FloatToStrF( nailHeight, ffFixed, 5, 2 );

                            //write nail spacing
                                nailSpacing := abs(prevNailHeight - nailHeight);

                                if (nailSpacing < 1e-3) then
                                    strGrdNailLayoutInOut.Cells[2, nailNum] := ''
                                else
                                    strGrdNailLayoutInOut.Cells[2, nailNum] := FloatToStrF(nailSpacing, ffFixed, 5, 2);

                            //write nail length
                                nailLength := nails.getArrLengths()[i];

                                if (nailLength < 1e-3) then
                                    strGrdNailLayoutInOut.Cells[3, nailNum] := ''
                                else
                                    strGrdNailLayoutInOut.Cells[3, nailNum] := FloatToStrF(nailLength, ffFixed, 5, 2);

                            //set previous nail height to current nail for next for loop pass
                                prevNailHeight := nailHeight;
                        end;

                    strGrdNailLayoutInOut.clearRow(strGrdNailLayoutInOut.RowCount - 1);

                    strGrdNailLayoutInOut.FixedCols := 2;
                    strGrdNailLayoutInOut.FixedRows := 1;

                    strGrdNailLayoutInOut.editBorder(1, clSilver);

                    strGrdNailLayoutInOut.Parent.UnlockDrawing();
                end;

        procedure writeToNailPropGrids( const updateEmptyCellsIn        : boolean;
                                        var strGrdNailPropertiesInOut,
                                            strGrdNailLayoutInOut       : TStringGrid;
                                        const soilNailWallDesignIn      : TSoilNailWall );
            begin
                writeToNailPopertiesGrid( updateEmptyCellsIn, strGrdNailPropertiesInOut, soilNailWallDesignIn );

                writeToNailLayoutGrid( strGrdNailLayoutInOut, soilNailWallDesignIn );
            end;


end.
