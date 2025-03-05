unit UISetupMethods;

interface

    uses
        //Delphi
            Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
            Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        //custom
            StringGridHelperClass;

    //set up input tab
        procedure setupInputTab(var GridPanelLabelsInOut                                                            : TGridPanel;
                                var StrGrdSoilParInOut,         StrGrdSteelParInOut,        StrGrdConcreteParInOut,
                                    strGrdWallPropertiesInOut,  strGrdSlopePropertiesInOut,
                                    strGrdSoilNailPropInOut,    strGrdNailLayoutInOut                               : TStringGrid);

implementation

    const
        CATEGORY_SPACE : integer = 20;

    //helper methods
        procedure setupLabel(   captionIn                   : string;
                                var labelInOut              : TLabel;
                                var parentComponentInOut    : TWinControl);
            begin
                //create
                    labelInOut := TLabel.create(parentComponentInOut);

                //caption
                    labelInOut.Caption  := captionIn;

                //parent
                    labelInOut.Parent   := parentComponentInOut;

                //position
                    labelInOut.left     := 5;
            end;

        procedure gridPositionAndSize(  const gridLabelIn   : TLabel;
                                        var strGrdInOut     : TStringGrid   );
            begin
                //position
                    strGrdInOut.left := gridLabelIn.left;
                    strGrdInOut.top  := gridLabelIn.top + gridLabelIn.height + 5;

                //size
                    strGrdInOut.minSize();

                //border
                    strGrdInOut.createBorder(1, clSilver);
            end;

    //wall geometry tab
        procedure setupWallGeometryTab(var strGrdWallPropertiesInOut, strGrdSlopePropertiesInOut : TStringGrid);
            const
                PANEL_MARGIN    : integer = 5;
                COL_WIDTHS      : TArray<integer> = [200, 75];
            var
                gridLabel       : TLabel;
                previousGrid    : TStringGrid;
                parentComponent : TWinControl;
            procedure
                _setupGrid(var strGrdInOut : TStringGrid);
                    begin
                        //column widths
                            strGrdInOut.width := COL_WIDTHS[0]+ COL_WIDTHS[1] + 10;
                            strGrdInOut.ColWidths[0] := COL_WIDTHS[0];
                            strGrdInOut.ColWidths[1] := COL_WIDTHS[1];

                        //column count
                            strGrdInOut.ColCount := 2;

                        gridPositionAndSize(gridLabel, strGrdInOut);

                        //fixed columns
                            strGrdInOut.FixedCols := 1;
                    end;
            procedure
                _wallProperties();
                    begin
                        //label
                            setupLabel('Wall Properties', gridLabel, parentComponent);

                            //position
                                gridLabel.top := PANEL_MARGIN;

                        //string grid
                            strGrdWallPropertiesInOut.RowCount := 3;

                            //text
                                strGrdWallPropertiesInOut.Cells[0, 0] := 'Height (m)';
                                strGrdWallPropertiesInOut.Cells[0, 1] := 'Thickness (mm)';
                                strGrdWallPropertiesInOut.Cells[0, 2] := 'Angle ('#176')';

                            _setupGrid(strGrdWallPropertiesInOut);

                            previousGrid := strGrdWallPropertiesInOut;
                    end;
            procedure
                _slopeProperties();
                    begin
                        //label
                            setupLabel('Up-Slope Properties', gridLabel, parentComponent);

                            //position
                                gridLabel.top := previousGrid.top + previousGrid.height + CATEGORY_SPACE;

                        //string grid
                            strGrdSlopePropertiesInOut.RowCount := 2;

                            //text
                                strGrdSlopePropertiesInOut.Cells[0, 0] := 'Angle ('#176')';
                                strGrdSlopePropertiesInOut.Cells[0, 1] := 'Height (m)';

                            _setupGrid(strGrdSlopePropertiesInOut);

                            previousGrid := strGrdSlopePropertiesInOut
                    end;
            procedure
                _loads();
                    begin
//                        //label
//                            setupLabel('Loads', gridLabel, parentComponent);
//
//                            //position
//                                gridLabel.top := previousGrid.top + previousGrid.height + CATEGORY_SPACE;
//
//                        //string grid
//                            //text
//                                strGrdLoadsInOut.Cells[0, 0] := 'Surcharge Load Intensity - Q (kPa)';
//
//                            _setupGrid(strGrdLoadsInOut);
//
//                        previousGrid := strGrdLoadsInOut
                    end;
            begin
                parentComponent := strGrdWallPropertiesInOut.Parent;

                _wallProperties();
                _slopeProperties();
            end;

    //nail layout tab
        procedure setupNailLayoutTab(var strGrdSoilNailPropInOut, strGrdNailLayoutInOut : TStringGrid);
            const
                COLUMN_SIZES : TArray<integer> = [45, 75, 75, 75];
            var
                gridLabel       : TLabel;
                parentComponent : TWinControl;
            procedure
                _setupGrid(strGrdInOut : TStringGrid);
                    begin
                        gridPositionAndSize(gridLabel, strGrdInOut);
                    end;
            procedure
                _soilNailProperties();
                    begin
                        //label
                            setupLabel('Nail Properties', gridLabel, parentComponent);

                            //position
                                gridLabel.top := 5;

                        //string grid
                            //rows & cols
                                strGrdSoilNailPropInOut.RowCount := 3;
                                strGrdSoilNailPropInOut.ColCount := 2;

                            //text
                                strGrdSoilNailPropInOut.Cells[0, 0] := 'Angle ('#176')';
                                strGrdSoilNailPropInOut.Cells[0, 1] := 'Out-of-plane Spacing (m)';
                                strGrdSoilNailPropInOut.Cells[0, 2] := 'Grout Hole Diameter (mm)';

                            //column widths
                                strGrdSoilNailPropInOut.Width := 350;
                                strGrdSoilNailPropInOut.ColWidths[0] := COLUMN_SIZES[0] + COLUMN_SIZES[1] + COLUMN_SIZES[2] + 2;
                                strGrdSoilNailPropInOut.ColWidths[1] := COLUMN_SIZES[3];

                            _setupGrid(strGrdSoilNailPropInOut);
                    end;
            procedure
                _nailLayout();
                    var
                        i : integer;
                    begin
                        //label
                            setupLabel('Nail Layout', gridLabel, parentComponent);

                            //position
                                gridLabel.top := strGrdSoilNailPropInOut.top + strGrdSoilNailPropInOut.height + CATEGORY_SPACE;

                        //string grid
                            //rows & cols
                                strGrdNailLayoutInOut.RowCount := 2;
                                strGrdNailLayoutInOut.ColCount := 4;

                            //cell text
                                strGrdNailLayoutInOut.Cells[0, 0] := 'No.';
                                strGrdNailLayoutInOut.Cells[1, 0] := 'Height (m)';
                                strGrdNailLayoutInOut.Cells[2, 0] := 'Spacing (m)';
                                strGrdNailLayoutInOut.Cells[3, 0] := 'Length (m)';

                            //column sizes
                                for i := 0 to (length(COLUMN_SIZES) - 1) do
                                    begin
                                        strGrdNailLayoutInOut.ColWidths[i] := COLUMN_SIZES[i];
                                    end;

                            _setupGrid(strGrdNailLayoutInOut);

                            strGrdNailLayoutInOut.FixedCols := 2;
                            strGrdNailLayoutInOut.FixedRows := 1;
                    end;
            begin
                parentComponent := strGrdSoilNailPropInOut.Parent;

                _soilNailProperties();
                _nailLayout();
            end;

    //set up input tab
        procedure setupInputTab(var GridPanelLabelsInOut                                                            : TGridPanel;
                                var StrGrdSoilParInOut,         StrGrdSteelParInOut,        StrGrdConcreteParInOut,
                                    strGrdWallPropertiesInOut,  strGrdSlopePropertiesInOut,
                                    strGrdSoilNailPropInOut,    strGrdNailLayoutInOut                               : TStringGrid);
            begin
                setupWallGeometryTab(strGrdWallPropertiesInOut, strGrdSlopePropertiesInOut);

                setupNailLayoutTab(strGrdSoilNailPropInOut, strGrdNailLayoutInOut);
            end;

end.
