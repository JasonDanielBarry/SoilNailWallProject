unit NailPropertiesInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TNailPropertiesInputManager = class(TSoilNailWallInputManager)
            private
                var
                    nailPropertiesLabel,
                    nailLayoutLabel     : TLabel;
                    nailParametersGrid,
                    nailLayoutGrid      : TStringGrid;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const   errorListBoxIn          : TListBox;
                                        const   nailParametersGridIn,
                                                nailLayoutGridIn        : TStringGrid;
                                        const   soilNailWallDesignIn    : TSoilNailWall );
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
        end;

implementation

    //protected
        //check for input errors
            procedure TNailPropertiesInputManager.checkForInputErrors();
                begin

                end;

    //public
        //constructor
            constructor TNailPropertiesInputManager.create( const   errorListBoxIn          : TListBox;
                                                            const   nailParametersGridIn,
                                                                    nailLayoutGridIn        : TStringGrid;
                                                            const   soilNailWallDesignIn    : TSoilNailWall );
                begin
                    nailParametersGrid  := nailParametersGridIn;
                    nailLayoutGrid      := nailLayoutGridIn;

                    inherited create( errorListBoxIn, soilNailWallDesign );
                end;

        //destructor
            destructor TNailPropertiesInputManager.destroy();
                var
                    tempLabel : TLabel;
                begin
                    for tempLabel in [ nailPropertiesLabel, nailLayoutLabel ] do
                        FreeAndNil( tempLabel );

                    inherited destroy();
                end;

        //setup input controls
            procedure TNailPropertiesInputManager.setupInputControls();
                const
                    COLUMN_SIZES : TArray<integer> = [45, 75, 75, 75];
                var
                    i               : integer;
                    ctrlScaleFactor : double;
                    tempComponent   : Tcontrol;
                    tempLabel       : TLabel;
                    tempGrid        : TStringGrid;
                    controlParent   : TWinControl;
                begin
                    inherited setupInputControls();

                    controlParent := nailParametersGrid.Parent;

                    //create labels
                        for tempLabel in [ nailPropertiesLabel, nailLayoutLabel ] do
                            FreeAndNil( tempLabel );

                        nailPropertiesLabel := TLabel.Create( nil );
                        nailLayoutLabel     := TLabel.Create( nil );

                        for tempLabel in [ nailPropertiesLabel, nailLayoutLabel ] do
                            begin
                                tempLabel.Parent    := controlParent;
                                tempLabel.AutoSize  := True;
                            end;

                    //position controls
                        ctrlScaleFactor := controlParent.ScaleFactor;

                        for tempComponent in [ nailPropertiesLabel, nailLayoutLabel, nailParametersGrid, nailLayoutGrid ] do
                            tempComponent.Left := round( CONTROL_MARGIN * ctrlScaleFactor );

                    //setup grids
                        //nail properties
                            nailPropertiesLabel.Caption := 'Nail Properties';
                            nailPropertiesLabel.Top     := round( CONTROL_MARGIN * ctrlScaleFactor );

                            nailParametersGrid.top          := nailPropertiesLabel.Top + round( 1.25 * nailPropertiesLabel.Height );
                            nailParametersGrid.Width        := SumInt( COLUMN_SIZES ) + 10;
                            nailParametersGrid.ColCount     := 2;
                            nailParametersGrid.ColWidths[0] := COLUMN_SIZES[0];
                            nailParametersGrid.ColWidths[1] := SumInt( COLUMN_SIZES ) - COLUMN_SIZES[0];
                            nailParametersGrid.RowCount     := 3;
                            nailParametersGrid.Cells[0, 0]  := 'Angle ('#176')';
                            nailParametersGrid.Cells[0, 1]  := 'Out-of-plane Spacing (m)';
                            nailParametersGrid.Cells[0, 2]  := 'Grout Hole Diameter (mm)';
                            nailParametersGrid.FixedCols    := 1;
                            nailParametersGrid.FixedRows    := 0;

                        //nail layout
                            nailLayoutLabel.Caption := 'Nail Layout';
                            nailLayoutLabel.Top     := nailParametersGrid.top + nailParametersGrid.Height + round( CATEGORY_SPACE * ctrlScaleFactor );

                            nailLayoutGrid.Top          := nailLayoutLabel.Top + round( 1.25 * nailLayoutLabel.Height );
                            nailLayoutGrid.Width        := SumInt( COLUMN_SIZES ) + 10;
                            nailLayoutGrid.ColCount     := 4;
                            nailLayoutGrid.RowCount     := 2;
                            nailLayoutGrid.FixedCols    := 2;
                            nailLayoutGrid.FixedRows    := 1;

                            for i := 0 to ( length( COLUMN_SIZES ) - 1 ) do
                                nailLayoutGrid.ColWidths[i] := COLUMN_SIZES[i];

                            nailLayoutGrid.Cells[0, 0] := 'No.';
                            nailLayoutGrid.Cells[1, 0] := 'Height (m)';
                            nailLayoutGrid.Cells[2, 0] := 'Spacing (m)';
                            nailLayoutGrid.Cells[3, 0] := 'Length (m)';

                        for tempGrid in [ nailParametersGrid, nailLayoutGrid ] do
                            begin
                                tempGrid.minSize();
                                tempGrid.createBorder( 1, clSilver );
                            end;
                end;

        //reset controls
            procedure TNailPropertiesInputManager.resetInputControls();
                begin

                end;

        //process input
            //read input
                function TNailPropertiesInputManager.readFromInputControls() : boolean;
                    begin

                    end;

            //write to input controls
                procedure TNailPropertiesInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin

                    end;

end.
