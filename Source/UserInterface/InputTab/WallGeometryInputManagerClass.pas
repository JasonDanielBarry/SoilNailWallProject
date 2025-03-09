unit WallGeometryInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
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
                    slopeParametersGrid     : TStringGrid;
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
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const   errorListBoxIn          : TListBox;
                                        const   wallParametersGridIn,
                                                slopeParametersGridIn   : TStringGrid;
                                        const   soilNailWallDesignIn    : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //setup input controls
                    procedure setupInputControls(); override;
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

                        readSuccessful := wallParametersGrid.tryCellToDouble( 1, 0, wall.height ) AND readSuccessful;

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
                                                                    slopeParametersGridIn   : TStringGrid;
                                                            const   soilNailWallDesignIn    : TSoilNailWall );
                begin
                    //input grids
                        wallParametersGrid  := wallParametersGridIn;
                        slopeParametersGrid := slopeParametersGridIn;

                    inherited create( errorListBoxIn, soilNailWallDesignIn );
                end;

        //destructor
            destructor TWallGeometryInputManager.destroy();
                var
                    tempLabel : TLabel;
                begin
                    for tempLabel in [ wallLabel, slopeLabel ] do
                        FreeAndNil( tempLabel );

                    inherited destroy();
                end;

        //setup input controls
            procedure TWallGeometryInputManager.setupInputControls();
                const
                    COL_WIDTHS : TArray<integer> = [200, 75];
                var
                    ctrlScaleFactor : double;
                    tempComponent   : Tcontrol;
                    tempLabel       : TLabel;
                    tempGrid        : TStringGrid;
                    controlParent   : TWinControl;
                begin
                    inherited setupInputControls();

                    controlParent := wallParametersGrid.Parent;

                    //create labels
                        for tempLabel in [ wallLabel, slopeLabel ] do
                            FreeAndNil( tempLabel );

                        wallLabel   := TLabel.Create( nil );
                        slopeLabel  := TLabel.Create( nil );

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
                                tempGrid.ColCount := 2;

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
                            begin
                                tempGrid.minSize();
                                tempGrid.createBorder( 1, clSilver );
                            end;

                    setListBoxErrorsWidth( slopeParametersGrid.Width );
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
