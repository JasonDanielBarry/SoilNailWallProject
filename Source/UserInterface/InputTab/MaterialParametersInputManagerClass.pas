unit MaterialParametersInputManagerClass;

interface

    uses
        system.SysUtils, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass,
        SoilNailWallMasterClass
        ;

    type
        TMaterialParametersInputManager = class(TInputManager)
            private
                var
                    soilLabel, nailsLabel,
                    concreteLabel           : TLabel;
                    soilParametersGrid,
                    nailParametersGrid,
                    concreteParametersGrid  : TStringGrid;
                    gridPanelLabels         : TGridPanel;
                    soilNailWallDesign      : TSoilNailWall;
            public
                //constructor
                    constructor create( const   errorListBoxIn              : TListBox;
                                        const   soilParametersGridIn,
                                                nailParametersGridIn,
                                                concreteParametersGridIn    : TStringGrid;
                                        const   gridPanelLabelsIn           : TGridPanel;
                                        const   soilNailWallDesignIn        : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //setup input controls
                    procedure setupInputControls(); override;
        end;

implementation

    const
        CATEGORY_SPACE : integer = 20;

    //private

    //public
        //constructor
            constructor TMaterialParametersInputManager.create( const   errorListBoxIn              : TListBox;
                                                                const   soilParametersGridIn,
                                                                        nailParametersGridIn,
                                                                        concreteParametersGridIn    : TStringGrid;
                                                                const   gridPanelLabelsIn           : TGridPanel;
                                                                const   soilNailWallDesignIn        : TSoilNailWall );
                begin
                    //input grids
                        soilParametersGrid      := soilParametersGridIn;
                        nailParametersGrid      := nailParametersGridIn;
                        concreteParametersGrid  := concreteParametersGridIn;

                    //grid panel
                        gridPanelLabels := gridPanelLabelsIn;

                    soilNailWallDesign := soilNailWallDesignIn;

                    inherited create( errorListBoxIn );
                end;

        //destructor
            destructor TMaterialParametersInputManager.destroy();
                var
                    tempLabel : TLabel;
                begin
                    for tempLabel in [ soilLabel, nailsLabel, concreteLabel ] do
                        FreeAndNil( tempLabel );

                    inherited destroy();
                end;

        //setup input controls
            procedure TMaterialParametersInputManager.setupInputControls();
                var
                    ctrlScaleFactor : double;
                    tempComponent   : Tcontrol;
                    tempLabel       : TLabel;
                    tempGrid        : TStringGrid;
                    controlParent   : TWinControl;
                begin
                    inherited setupInputControls();

                    controlParent   := soilParametersGrid.Parent;

                    //create labels
                        for tempComponent in [ soilLabel, nailsLabel, concreteLabel ] do
                            FreeAndNil( tempComponent );

                        soilLabel       := TLabel.Create( nil );
                        nailsLabel      := TLabel.Create( nil );
                        concreteLabel   := TLabel.Create( nil );

                        for tempLabel in [ soilLabel, nailsLabel, concreteLabel ] do
                            begin
                                tempLabel.Parent := controlParent;
                                tempLabel.AutoSize := True;
                            end;

                    //position controls
                        ctrlScaleFactor := controlParent.ScaleFactor;

                        for tempComponent in [ soilLabel, nailsLabel, concreteLabel, soilParametersGrid, nailParametersGrid, concreteParametersGrid ] do
                            tempComponent.Left := round( CONTROL_LEFT * ctrlScaleFactor );

                        gridPanelLabels.left := round( (CONTROL_LEFT + 249) * ctrlScaleFactor );

                    //setup grids
                        for tempGrid in [ soilParametersGrid, nailParametersGrid, concreteParametersGrid ] do
                            begin
                                tempGrid.ColWidths[0] := round( 249 * ctrlScaleFactor );

                                tempGrid.ColCount := 7;

                                tempGrid.FixedCols := 1;
                                tempGrid.FixedRows := 0;
                            end;

                        gridPanelLabels.top := round( 5 * ctrlScaleFactor );

                        //soil input
                            soilLabel.Caption   := 'Soil Parameters';
                            soilLabel.Top       := gridPanelLabels.top + gridPanelLabels.Height + round( 5 * ctrlScaleFactor );

                            soilParametersGrid.top      := soilLabel.Top + round( 1.25 * soilLabel.Height );
                            soilParametersGrid.RowCount := 3;
                            soilParametersGrid.Cells[0, 0] := 'Cohesion - c'' (kPa)';
                            soilParametersGrid.Cells[0, 1] := 'Friction Angle - '#966' ('#176')';
                            soilParametersGrid.Cells[0, 2] := 'Soil Unit Weight - '#947' (kN/m'#179')';
                            soilParametersGrid.minSize();

                        //nail input
                            nailsLabel.Caption  := 'Nail Parameters';
                            nailsLabel.top      := soilParametersGrid.top + soilParametersGrid.Height + round( CATEGORY_SPACE * ctrlScaleFactor );

                            nailParametersGrid.top      := nailsLabel.Top + round( 1.25 * nailsLabel.Height );
                            nailParametersGrid.RowCount := 2;
                            nailParametersGrid.Cells[0, 0] := 'Nail Tensile Strength - fu (MPa)';
                            nailParametersGrid.Cells[0, 1] := 'Grout-Soil Interface Bond Strength (kPa)';
                            nailParametersGrid.minSize();

                        //concrete input
                            concreteLabel.Caption   := 'Nail Parameters';
                            concreteLabel.top       := nailParametersGrid.top + nailParametersGrid.Height + round( CATEGORY_SPACE * ctrlScaleFactor );

                            concreteParametersGrid.top      := concreteLabel.Top + round( 1.25 * concreteLabel.Height );
                            concreteParametersGrid.RowCount := 2;
                            concreteParametersGrid.Cells[0, 0] := 'Steel Reinforcement Strength  - fy (MPa)';
                            concreteParametersGrid.Cells[0, 1] := 'Concrete Compressive Strength - fcu (MPa)';
                            concreteParametersGrid.minSize();

                        for tempGrid in [ soilParametersGrid, nailParametersGrid, concreteParametersGrid ] do
                            begin
                                tempGrid.minSize();
                                tempGrid.createBorder( 1, clSilver );
                            end;
                end;


end.
