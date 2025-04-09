unit LoadCasesInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TLoadCasesInputManager = class(TSoilNailWallInputManager)
            private
                var
                    loadCasesLabel  : TLabel;
                    loadInputGrid   : TStringGrid;
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
        end;

implementation

    //protected
        //check for input errors
            procedure TLoadCasesInputManager.checkForInputErrors();
                begin

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

                        loadInputGrid.Cells[0, 0] := 'Name';
                        loadInputGrid.Cells[1, 0] := 'Description';
                        loadInputGrid.Cells[2, 0] := 'Factor';
                        loadInputGrid.Cells[3, 0] := 'Load (kN/m)';

                        loadInputGrid.minSize();
                        loadInputGrid.createBorder( 1, clSilver );
                end;

        //reset controls
            procedure TLoadCasesInputManager.resetInputControls();
                begin

                end;

        //process input
            //read input
                function TLoadCasesInputManager.readFromInputControls() : boolean;
                    begin

                    end;

            //write to input controls
                procedure TLoadCasesInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin

                    end;

end.
