unit NailPropertiesInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass,
        NailLayoutGeneratorWizard
        ;

    type
        TNailPropertiesInputManager = class(TSoilNailWallInputManager)
            private
                var
                    nailPropertiesLabel,
                    nailLayoutLabel     : TLabel;
                    nailParametersGrid,
                    nailLayoutGrid      : TStringGrid;
                //read from controls
                    //nail parameters
                        function readNailParameters() : boolean;
                    //nail layout
                        function readNailLayout() : boolean;
                //write to controls
                    //nail parameters
                        procedure writeNailParameters(const updateEmptyCellsIn : boolean);
                    //nail layout
                        procedure writeNailLayout();
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
                //launch layout generator
                    function NailLayoutGeneratorExecute() : boolean;
        end;

implementation

    //private
        //read from controls
            //nail properties
                function TNailPropertiesInputManager.readNailParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        nails           : TSoilNails;
                    begin
                        nails := soilNailWallDesign.getNails();

                        readSuccessful := nailParametersGrid.tryCellToDouble(1, 0, nails.angle);
                        readSuccessful := nailParametersGrid.tryCellToDouble(1, 1, nails.horizontalSpacing) AND readSuccessful;
                        readSuccessful := nailParametersGrid.tryCellToDouble(1, 2, nails.diameter.groutHole) AND readSuccessful;
                        nails.diameter.groutHole := nails.diameter.groutHole / 1000;

                        soilNailWallDesign.setNails( nails );

                        result := readSuccessful;
                    end;

            //nail layout
                function TNailPropertiesInputManager.readNailLayout() : boolean;
                    var
                        isValidSpace, isValidLength,
                        isValidNail                 : boolean;
                        i                           : integer;
                        dy,
                        nailHeight, nailLength,
                        nailSpace,  wallHeight      : double;
                    begin
                        //reset layout
                            soilNailWallDesign.clearNailLayout();

                        //initialise values
                            dy          := 0;
                            wallHeight  := soilNailWallDesign.getWall().height;

                        //read values in from the grid
                            for i := 1 to ( nailLayoutGrid.RowCount - 1 ) do
                                begin
                                    //check that the nail entered is valid
                                        nailSpace   := nailLayoutGrid.cellToDouble( 2, i );
                                        nailLength  := nailLayoutGrid.cellToDouble( 3, i );

                                        isValidSpace    := NOT(isZero( nailSpace, 1e-3 ));
                                        isValidLength   := NOT(isZero( nailLength, 1e-3 ));
                                        isValidNail     := (isValidSpace OR isValidLength);

                                        if NOT(isValidNail) then
                                            Continue;

                                    //add nail to layout
                                        dy := dy + nailSpace;
                                        nailHeight := wallHeight - dy;

                                        soilNailWallDesign.addNail( nailHeight, nailLength );
                                end;

                        result := nailLayoutGrid.RowCount > 2;
                    end;

        //write to controls
            //nail parameters
                procedure TNailPropertiesInputManager.writeNailParameters(const updateEmptyCellsIn : boolean);
                    var
                        row                 : integer;
                        nailAngle,
                        outOfPlaneSpacing,
                        groutHoleDiameter,
                        doubleValue         : double;
                        stringValue         : string;
                        nails               : TSoilNails;
                    begin
                        nails := soilNailWallDesign.getNails();

                        nailAngle           := nails.angle;
                        outOfPlaneSpacing   := nails.horizontalSpacing;
                        groutHoleDiameter   := nails.diameter.groutHole * 1000;

                        row := -1;

                        for doubleValue in [nailAngle, outOfPlaneSpacing, groutHoleDiameter] do
                            begin
                                inc(row);

                                if ( (nailParametersGrid.cellIsEmpty(1, row)) AND NOT(updateEmptyCellsIn) ) then
                                    Continue;

                                stringValue := FloatToStrF( doubleValue, ffFixed, 5, 2 );

                                nailParametersGrid.Cells[1, row] := stringValue;
                            end;
                    end;

            //nail layout
                procedure TNailPropertiesInputManager.writeNailLayout();
                    var
                        i, nailNum                  : integer;
                        nailHeight, nailLength,
                        prevNailHeight, nailSpacing : double;
                        nails                       : TSoilNails;
                        arrHeights, arrLengths      : TArray<double>;
                    begin
                        nailLayoutGrid.Parent.LockDrawing();

                        nails := soilNailWallDesign.getNails();

                        nailLayoutGrid.RowCount := nails.determineNailCount() + 2;

                        //get the nail arrays
                            arrHeights := nails.getArrHeight();
                            arrLengths := nails.getArrLengths();

                        //wall height it first prevHeight
                            prevNailHeight := soilNailWallDesign.getWall().height;

                        for i := 0 to ( nails.determineNailCount() - 1 ) do
                            begin
                                //write nail number
                                    nailNum := i + 1;
                                    nailLayoutGrid.Cells[0, nailNum] := IntToStr( nailNum );

                                //write nail height
                                    nailHeight := arrHeights[i];
                                    nailLayoutGrid.Cells[1, nailNum] := FloatToStrF( nailHeight, ffFixed, 5, 2 );

                                //write nail spacing
                                    nailSpacing := abs( prevNailHeight - nailHeight );

                                    if (nailSpacing < 1e-3) then
                                        nailLayoutGrid.Cells[2, nailNum] := ''
                                    else
                                        nailLayoutGrid.Cells[2, nailNum] := FloatToStrF( nailSpacing, ffFixed, 5, 2 );

                                //write nail length
                                    nailLength := nails.getArrLengths()[i];

                                    if (nailLength < 1e-3) then
                                        nailLayoutGrid.Cells[3, nailNum] := ''
                                    else
                                        nailLayoutGrid.Cells[3, nailNum] := FloatToStrF( nailLength, ffFixed, 5, 2 );

                                //set previous nail height to current nail for next for loop pass
                                    prevNailHeight := nailHeight;
                            end;

                        nailLayoutGrid.clearRow(nailLayoutGrid.RowCount - 1);

                        nailLayoutGrid.FixedCols := 2;
                        nailLayoutGrid.FixedRows := 1;

                        nailLayoutGrid.editBorder(1, clSilver);

                        nailLayoutGrid.Parent.UnlockDrawing();
                    end;

    //protected
        //check for input errors
            procedure TNailPropertiesInputManager.checkForInputErrors();
                var
                    i               : integer;
                    arrNaillengths  : TArray<double>;
                    nails           : TSoilNails;
                begin
                    inherited checkForInputErrors();

                    //nail parameters
                        nails := soilNailWallDesign.getNails();

                        if ( ( nails.angle < 0 ) OR IsZero( nails.angle, 1e-3 ) ) then
                            addError('Nail angle must be non-zero');

                        if ( ( nails.horizontalSpacing < 0 ) OR IsZero( nails.horizontalSpacing, 1e-3 ) ) then
                            addError('Out of plane spacing must be non-zero');

                        if ( ( nails.diameter.groutHole < 0 ) OR IsZero( nails.diameter.groutHole, 1e-3 ) ) then
                            addError('Grout hole diameter must be non-zero');

                    //nail layout
                        if ( nails.determineNailCount() < 2 ) then
                            addError('At least 2 nail are required for a valid layout');

                        arrNaillengths := nails.getArrLengths();

                        for i := 0 to (nails.determineNailCount() - 1) do
                            if ( IsZero( arrNaillengths[i], 1e-3 ) ) then
                                addError('Nail ' + IntToStr(i+1) + ' length must be non-zero');
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

                    inherited create( errorListBoxIn, soilNailWallDesignIn );
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

                    controlParent := nailLayoutGrid.Parent;

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
                            nailParametersGrid.Width        := round( (SumInt( COLUMN_SIZES ) + 10) * ctrlScaleFactor );
                            nailParametersGrid.ColCount     := 2;
                            nailParametersGrid.ColWidths[0] := round( (SumInt( COLUMN_SIZES ) - COLUMN_SIZES[3] + 2) * ctrlScaleFactor );
                            nailParametersGrid.ColWidths[1] := round( COLUMN_SIZES[3] * ctrlScaleFactor );
                            nailParametersGrid.RowCount     := 3;
                            nailParametersGrid.Cells[0, 0]  := 'Angle ('#176')';
                            nailParametersGrid.Cells[0, 1]  := 'Out-of-plane Spacing (m)';
                            nailParametersGrid.Cells[0, 2]  := 'Grout Hole Diameter (mm)';
                            nailParametersGrid.FixedCols    := 1;
                            nailParametersGrid.FixedRows    := 0;
                            nailParametersGrid.minSize();

                        //nail layout
                            nailLayoutLabel.Caption := 'Nail Layout';
                            nailLayoutLabel.Top     := nailParametersGrid.top + nailParametersGrid.Height + round( CATEGORY_SPACE * ctrlScaleFactor );

                            nailLayoutGrid.Top          := nailLayoutLabel.Top + round( 1.25 * nailLayoutLabel.Height );
                            nailLayoutGrid.Width        := round( (SumInt( COLUMN_SIZES ) + 10) * ctrlScaleFactor );
                            nailLayoutGrid.ColCount     := 4;
                            nailLayoutGrid.RowCount     := 2;
                            nailLayoutGrid.FixedCols    := 2;
                            nailLayoutGrid.FixedRows    := 1;

                            for i := 0 to ( length( COLUMN_SIZES ) - 1 ) do
                                nailLayoutGrid.ColWidths[i] := round( COLUMN_SIZES[i] * ctrlScaleFactor );

                            nailLayoutGrid.Cells[0, 0] := 'No.';
                            nailLayoutGrid.Cells[1, 0] := 'Height (m)';
                            nailLayoutGrid.Cells[2, 0] := 'Spacing (m)';
                            nailLayoutGrid.Cells[3, 0] := 'Length (m)';
                            nailLayoutGrid.minSize();

                        for tempGrid in [ nailParametersGrid, nailLayoutGrid ] do
                            tempGrid.createBorder( 1, clSilver );
                end;

        //reset controls
            procedure TNailPropertiesInputManager.resetInputControls();
                begin
                    nailParametersGrid.clearColumn( 1 );

                    nailLayoutGrid.clearRows( 1 );
                    nailLayoutGrid.RowCount := 2;
                end;

        //process input
            //read input
                function TNailPropertiesInputManager.readFromInputControls() : boolean;
                    var
                        readSuccessful : boolean;
                    begin
                        readSuccessful := readNailParameters();
                        readSuccessful := readNailLayout() AND readSuccessful;;

                        result := readSuccessful;
                    end;

            //write to input controls
                procedure TNailPropertiesInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin
                        inherited writeToInputControls( updateEmptyControlsIn );

                        writeNailParameters( updateEmptyControlsIn );
                        writeNailLayout();
                    end;

        //launch layout generator
            function TNailPropertiesInputManager.NailLayoutGeneratorExecute() : boolean;
                var
                    formModalResult     : TModalResult;
                    generateLayoutForm  : TNailLayoutGenForm;
                begin
                    generateLayoutForm := TNailLayoutGenForm.create( SoilNailWallDesign );

                    generateLayoutForm.ShowModal();

                    formModalResult := generateLayoutForm.ModalResult;

                    if ( formModalResult = mrOk ) then
                        begin
                            var newSNW : TSoilNailWall := generateLayoutForm.getSoilNailWallDesign();

                            SoilNailWallDesign.copySNW( newSNW );

                            result := True;
                        end
                    else
                        result := False;

                    FreeAndNil( generateLayoutForm );
                end;

end.
