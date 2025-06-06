unit WallGeometryInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        CustomStringGridClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TWallGeometryInputManager = class(TSoilNailWallInputManager)
            private
                var
                    wallLabel, slopeLabel   : TLabel;
                    wallParametersGrid,
                    slopeParametersGrid     : TJDBStringGrid;
                //read from controls
                    //wall
                        function readWallParameters() : boolean;
                    //slope
                        function readSlopeParameters() : boolean;
                //write to input controls
                    //wall
                        procedure writeWallParameters(const updateEmptyCellsIn : boolean);
                    //slope
                        procedure writeSlopeParameters(const updateEmptyCellsIn : boolean);
                //setup input controls
                    procedure setupInputControls(); override;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const   errorListBoxIn          : TListBox;
                                        const   wallParametersGridIn,
                                                slopeParametersGridIn   : TJDBStringGrid;
                                        const   soilNailWallDesignIn    : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //reset controls
                    procedure resetInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
        end;

implementation

    //private
        //read from controls
            //wall
                function TWallGeometryInputManager.readWallParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        wall            : TWall;
                    begin
                        wall := soilNailWallDesign.getWall();

                        readSuccessful := wallParametersGrid.tryCellToDouble( 1, 0, wall.height );

                        readSuccessful := wallParametersGrid.tryCellToDouble( 1, 1, wall.thickness ) AND readSuccessful;
                        wall.thickness := wall.thickness / 1000;

                        readSuccessful := wallParametersGrid.tryCellToDouble( 1, 2, wall.angle ) AND readSuccessful;

                        soilNailWallDesign.setWall( wall );

                        result := readSuccessful;
                    end;

            //slope
                function TWallGeometryInputManager.readSlopeParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        soil            : TSoil;
                    begin
                        soil := soilNailWallDesign.getSoil();

                        readSuccessful := slopeParametersGrid.tryCellToDouble( 1, 0, soil.slope.angle );
                        readSuccessful := slopeParametersGrid.tryCellToDouble( 1, 1, soil.slope.maxHeight ) AND readSuccessful;

                        soilNailWallDesign.setSoil( soil );

                        result := readSuccessful;
                    end;

        //write to input controls
            //wall
                procedure TWallGeometryInputManager.writeWallParameters(const updateEmptyCellsIn : boolean);
                    var
                        row         : integer;
                        doubleValue : double;
                        stringValue : string;
                        wall        : TWall;
                    begin
                        wall := soilNailWallDesign.getWall();

                        row := -1;

                        for doubleValue in [ (wall.height), (1000 * wall.thickness), (wall.angle) ] do
                            begin
                                inc( row );

                                if ( wallParametersGrid.cellIsEmpty( 1, row ) AND NOT(updateEmptyCellsIn) ) then
                                    Continue;

                                stringValue := FloatToStrF(doubleValue, ffFixed, 5, 2);
                                wallParametersGrid.Cells[1, row] := stringValue;
                            end;
                    end;

            //slope
                procedure TWallGeometryInputManager.writeSlopeParameters(const updateEmptyCellsIn : boolean);
                    var
                        row         : integer;
                        doubleValue : double;
                        stringValue : string;
                        soil        : TSoil;
                    begin
                        soil := soilNailWallDesign.getSoil();

                        row := -1;

                        for doubleValue in [ (soil.slope.angle), (soil.slope.maxHeight) ] do
                            begin
                                inc( row );

                                if ( slopeParametersGrid.cellIsEmpty( 1, row ) AND NOT(updateEmptyCellsIn) ) then
                                    Continue;

                                stringValue := FloatToStrF(doubleValue, ffFixed, 5, 2);
                                slopeParametersGrid.Cells[1, row] := stringValue;
                            end;
                    end;

        //setup input controls
            procedure TWallGeometryInputManager.setupInputControls();
                const
                    COL_WIDTHS : TArray<integer> = [150, 70];
                var
                    ctrlScaleFactor : double;
                    tempComponent   : Tcontrol;
                    tempLabel       : TLabel;
                    tempGrid        : TJDBStringGrid;
                    controlParent   : TWinControl;
                begin
                    inherited setupInputControls();

                    controlParent := wallParametersGrid.Parent;

                    for tempLabel in [ wallLabel, slopeLabel ] do
                        begin
                            tempLabel.Parent    := controlParent;
                            tempLabel.AutoSize  := True;
                        end;

                    //position controls
                        ctrlScaleFactor := controlParent.ScaleFactor;

                        for tempComponent in [ wallLabel, slopeLabel, wallParametersGrid, slopeParametersGrid ] do
                            tempComponent.Left := round( CONTROL_MARGIN * ctrlScaleFactor );

                    //setup grids
                        for tempGrid in [ wallParametersGrid, slopeParametersGrid ] do
                            begin
                                tempGrid.ColCount   := 2;
                                tempGrid.FixedCols  := 1;
                                tempGrid.FixedRows  := 0;

                                tempGrid.width := round( (COL_WIDTHS[0]+ COL_WIDTHS[1] + 10) * ctrlScaleFactor );
                                tempGrid.ColWidths[0] := round( COL_WIDTHS[0] * ctrlScaleFactor );
                                tempGrid.ColWidths[1] := round( COL_WIDTHS[1] * ctrlScaleFactor );
                            end;

                        //wall input
                            wallLabel.Caption   := 'Wall Properties';
                            wallLabel.Top       := round( CONTROL_MARGIN * ctrlScaleFactor );

                            wallParametersGrid.top      := wallLabel.Top + round( 1.25 * wallLabel.Height );
                            wallParametersGrid.RowCount := 3;
                            wallParametersGrid.Cells[0, 0] := 'Height (m)';
                            wallParametersGrid.Cells[0, 1] := 'Thickness (mm)';
                            wallParametersGrid.Cells[0, 2] := 'Angle ('#176')';
                            wallParametersGrid.minSize();

                        //slope input
                            slopeLabel.Caption  := 'Slope Properties';
                            slopeLabel.Top      := wallParametersGrid.top + wallParametersGrid.Height + round( CATEGORY_SPACE * ctrlScaleFactor );

                            slopeParametersGrid.top         := slopeLabel.Top + round( 1.25 * slopeLabel.Height );
                            slopeParametersGrid.RowCount    := 2;
                            slopeParametersGrid.Cells[0, 0] := 'Angle ('#176')';
                            slopeParametersGrid.Cells[0, 1] := 'Height (m)';
                            slopeParametersGrid.minSize();

                        for tempGrid in [ wallParametersGrid, slopeParametersGrid ] do
                            tempGrid.setBorderProperties( 1, clSilver );
                end;

    //protected
        //check for input errors
            procedure TWallGeometryInputManager.checkForInputErrors();
                var
                    wall : TWall;
                begin
                    inherited checkForInputErrors();

                    wall := soilNailWallDesign.getWall();

                    if ( (wall.height < 0) OR IsZero( wall.height, 1e-3 ) ) then
                        addError('Wall height must be non-zero');

                    if ( (wall.thickness < 0) OR IsZero( wall.thickness, 1e-3 ) ) then
                        addError('Wall thickness must be non-zero');
                end;

    //public
        //constructor
            constructor TWallGeometryInputManager.create(   const   errorListBoxIn          : TListBox;
                                                            const   wallParametersGridIn,
                                                                    slopeParametersGridIn   : TJDBStringGrid;
                                                            const   soilNailWallDesignIn    : TSoilNailWall );
                begin
                    //input grids
                        wallParametersGrid  := wallParametersGridIn;
                        slopeParametersGrid := slopeParametersGridIn;

                    //create labels
                        wallLabel   := TLabel.Create( nil );
                        slopeLabel  := TLabel.Create( nil );

                    inherited create( errorListBoxIn, soilNailWallDesignIn );
                end;

        //destructor
            destructor TWallGeometryInputManager.destroy();
                begin
                    FreeAndNil( wallLabel );
                    FreeAndNil( slopeLabel );

                    inherited destroy();
                end;

        //reset controls
            procedure TWallGeometryInputManager.resetInputControls();
                begin
                    wallParametersGrid.clearColumn( 1 );
                    slopeParametersGrid.clearColumn( 1 );
                end;

        //process input
            //read input
                function TWallGeometryInputManager.readFromInputControls() : boolean;
                    var
                        readSuccessful : boolean;
                    begin
                        readSuccessful := readWallParameters();
                        readSuccessful := readSlopeParameters() AND readSuccessful;

                        result := readSuccessful;
                    end;

            //write to input controls
                procedure TWallGeometryInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin
                        inherited writeToInputControls( updateEmptyControlsIn );

                        writeWallParameters( updateEmptyControlsIn );
                        writeSlopeParameters( updateEmptyControlsIn );
                    end;

end.
