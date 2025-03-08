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

end.
