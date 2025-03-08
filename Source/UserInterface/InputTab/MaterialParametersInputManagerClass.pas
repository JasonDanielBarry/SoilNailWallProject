unit MaterialParametersInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass, LimitStateMaterialClass,
        InputManagerClass,
        SoilNailWallTypes,
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
                //read from controls
                    //soil
                        function readSoilParameters() : boolean;
                    //nails
                        function readNailParameters() : boolean;
                    //concrete
                        function readConcreteParameters() : boolean;
                //write to controls
                    //soil
                        procedure writeSoilParameters(const updateEmptyCellsIn : boolean);
                    //nails
                        procedure writeNailParameters(const updateEmptyCellsIn : boolean);
                    //concrete
                        procedure writeConcreteParameters(const updateEmptyCellsIn : boolean);
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
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
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
        end;

implementation

    const
        CATEGORY_SPACE : integer = 20;

    //helper methods
        function tryGridToLimitStateMaterial(   const gridRowIn     : integer;
                                                var materialInOut   : TLimitStateMaterial;
                                                var readGridInOut   : TStringGrid           ) : boolean;
            var
                readSuccessful                                  : boolean;
                averageVal, coefVar, downgradeFac, partialFac   : double;
            begin
                readSuccessful := readGridInOut.tryCellToDouble( 1, gridRowIn, averageVal );
                readSuccessful := readSuccessful AND readGridInOut.tryCellToDouble( 2, gridRowIn, coefVar );
                readSuccessful := readSuccessful AND readGridInOut.tryCellToDouble( 3, gridRowIn, downgradeFac );
                readSuccessful := readSuccessful AND readGridInOut.tryCellToDouble( 5, gridRowIn, partialFac );

                materialInOut.setValues( averageVal, coefVar, downgradeFac, partialFac );

                result := readSuccessful;
            end;

        procedure limitStateMaterialToGrid( const updateEmptyCellsIn    : boolean;
                                            const gridRowIn             : integer;
                                            var materialInOut           : TLimitStateMaterial;
                                            var writeGridInOut          : TStringGrid           );
                var
                    mustUpdateCell,
                    validAverage, validCoefVar, validDownGrFac,
                    validCautiousEstimate,
                    validDesignValue                            : boolean;
                    col                                         : integer;
                    averageVal, coefVar, downgradeFac,
                    cautiousEstimate, partialFac, designValue,
                    doubleValue                                 : double;
                    stringValue                                 : string;
                begin
                    //get the values
                        averageVal          := materialInOut.averageValue;
                        coefVar             := materialInOut.variationCoefficient;
                        downgradeFac        := materialInOut.downgradeFactor;
                        cautiousEstimate    := materialInOut.cautiousEstimate();
                        partialFac          := materialInOut.partialFactor;
                        designValue         := materialInOut.designValue();

                    //write the values into the grid
                        col := 0;
                        for doubleValue in [averageVal, coefVar, downgradeFac, cautiousEstimate, partialFac, designValue] do
                            begin
                                inc( col ); //this is here first on purpose; col initialised to 0 and set to 1 at start of looping

                                mustUpdateCell := NOT(writeGridInOut.cellIsEmpty(col, gridRowIn)) OR updateEmptyCellsIn;

                                if NOT( mustUpdateCell ) then
                                    Continue;

                                stringValue := FloatToStrF( doubleValue, ffFixed, 5, 2 );

                                writeGridInOut.Cells[col, gridRowIn] := stringValue;
                            end;

                    //special cases
                        //write the cautious estimate
                            validAverage    := NOT(writeGridInOut.cellIsEmpty( 1, gridRowIn ));
                            validCoefVar    := NOT(writeGridInOut.cellIsEmpty( 2, gridRowIn ));
                            validDownGrFac  := NOT(writeGridInOut.cellIsEmpty( 3, gridRowIn ));

                            validCautiousEstimate := ( validAverage AND validCoefVar AND validDownGrFac );

                            if ( validCautiousEstimate OR updateEmptyCellsIn ) then
                                writeGridInOut.Cells[4, gridRowIn] := FloatToStrF( cautiousEstimate, ffFixed, 5, 2 )
                            else
                                writeGridInOut.Cells[4, gridRowIn] := '';

                        //write the design value
                            validDesignValue := ( validCautiousEstimate AND ( NOT(writeGridInOut.cellIsEmpty(5, gridRowIn)) ) );

                            if ( validDesignValue OR updateEmptyCellsIn ) then
                                writeGridInOut.Cells[6, gridRowIn] := FloatToStrF( designValue, ffFixed, 5, 2 )
                            else
                                writeGridInOut.Cells[6, gridRowIn] := '';
                end;

    //private
        //read from controls
            //soil
                function TMaterialParametersInputManager.readSoilParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        soil            : TSoil;
                    begin
                        soil := soilNailWallDesign.getSoil();

                        //cohesion
                            readSuccessful := tryGridToLimitStateMaterial( 0, soil.cohesion, soilParametersGrid );

                        //friction angle
                            readSuccessful := tryGridToLimitStateMaterial( 1, soil.frictionAngle, soilParametersGrid ) AND readSuccessful;

                        //unit weight
                            readSuccessful := tryGridToLimitStateMaterial( 2, soil.unitWeight, soilParametersGrid ) AND readSuccessful;

                        soilNailWallDesign.setSoil( soil );

                        result := readSuccessful;
                    end;

            //nails
                function TMaterialParametersInputManager.readNailParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        nails           : TSoilNails;
                    begin
                        nails := soilNailWallDesign.getNails();

                        //tensile strength
                            readSuccessful := tryGridToLimitStateMaterial( 0, nails.strength.tensile, nailParametersGrid );

                        //grout interface
                            readSuccessful := tryGridToLimitStateMaterial( 1, nails.strength.groutSoilInterface, nailParametersGrid ) AND readSuccessful;

                        soilNailWallDesign.setNails( nails );

                        result := readSuccessful;
                    end;

            //concrete
                function TMaterialParametersInputManager.readConcreteParameters() : boolean;
                    var
                        readSuccessful  : boolean;
                        wall            : TWall;
                    begin
                        wall := soilNailWallDesign.getWall();

                        //reinforcement
                            readSuccessful := tryGridToLimitStateMaterial( 0, wall.concrete.strength.reinforcement, concreteParametersGrid );

                        //compressive strength
                            readSuccessful := tryGridToLimitStateMaterial( 1, wall.concrete.strength.compressive, concreteParametersGrid ) AND readSuccessful;

                        soilNailWallDesign.setWall( wall );

                        result := readSuccessful;
                    end;

        //write to controls
            //soil
                procedure TMaterialParametersInputManager.writeSoilParameters(const updateEmptyCellsIn : boolean);
                    var
                        soil : TSoil;
                    begin
                        soil := soilNailWallDesign.getSoil();

                        //cohesion
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        soil.cohesion,
                                                        soilParametersGrid );

                        //friction angle
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        soil.frictionAngle,
                                                        soilParametersGrid );

                        //unit weight
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        2,
                                                        soil.unitWeight,
                                                        soilParametersGrid );
                    end;

            //nails
                procedure TMaterialParametersInputManager.writeNailParameters(const updateEmptyCellsIn : boolean);
                    var
                        nails : TSoilNails;
                    begin
                        nails := soilNailWallDesign.getNails();

                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        nails.strength.tensile,
                                                        nailParametersGrid      );

                        //grout
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        nails.strength.groutSoilInterface,
                                                        nailParametersGrid                  );

                    end;

            //concrete
                procedure TMaterialParametersInputManager.writeConcreteParameters(const updateEmptyCellsIn : boolean);
                    var
                        wall : TWall;
                    begin
                        wall := soilNailWallDesign.getWall();

                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        0,
                                                        wall.concrete.strength.reinforcement,
                                                        concreteParametersGrid                  );

                        //steel
                            limitStateMaterialToGrid(   updateEmptyCellsIn,
                                                        1,
                                                        wall.concrete.strength.compressive,
                                                        concreteParametersGrid              );
                    end;

    //protected
        //check for input errors
            procedure TMaterialParametersInputManager.checkForInputErrors();
                var
                    soil    : TSoil;
                    nails   : TSoilNails;
                    wall    : TWall;
                begin
                    inherited checkForInputErrors();

                    //soil
                        soil := soilNailWallDesign.getSoil();

                        if ( soil.cohesion.designValue() < 0 ) then
                            addError('Soil cohesion must be greater than or equal to 0');

                        if ( (soil.frictionAngle.designValue() < 0) OR IsZero( soil.frictionAngle.designValue(), 1e-3 ) ) then
                            addError('Soil friction angle must be non-zero');

                        if ( (soil.unitWeight.designValue() < 0) OR IsZero( soil.unitWeight.designValue(), 1e-3 ) ) then
                            addError('Soil unit weight must be non-zero');

                    //nails
                        nails := soilNailWallDesign.getNails();

                        if ( (nails.strength.tensile.designValue() < 0) OR IsZero( nails.strength.tensile.designValue(), 1e-3 ) ) then
                            addError('Nail tensile strength must be non-zero');

                        if ( (nails.strength.groutSoilInterface.designValue() < 0) OR IsZero( nails.strength.groutSoilInterface.designValue(), 1e-3 ) ) then
                            addError('Nail grout-soil interface strength must be non-zero');

                    //concrete
                        wall := soilNailWallDesign.getWall();

                        if ( (wall.concrete.strength.reinforcement.designValue() < 0) OR IsZero( wall.concrete.strength.reinforcement.designValue(), 1e-3 ) ) then
                            addError('Concrete reinforcement tensile strength must be non-zero');

                        if ( (wall.concrete.strength.compressive.designValue() < 0) OR IsZero( wall.concrete.strength.compressive.designValue(), 1e-3 ) ) then
                            addError('Concrete compressive strength must be non-zero');
                end;

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
                            tempComponent.Left := round( CONTROL_EDGE_SPACE * ctrlScaleFactor );

                        gridPanelLabels.left := round( (CONTROL_EDGE_SPACE + 249) * ctrlScaleFactor );

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

        //process input
            //read input
                function TMaterialParametersInputManager.readFromInputControls() : boolean;
                    var
                        readSuccessful : boolean;
                    begin
                        readSuccessful := readSoilParameters();

                        readSuccessful := readNailParameters() AND readSuccessful;

                        readSuccessful := readConcreteParameters() AND readSuccessful;

                        result := readSuccessful;
                    end;

            //write to input controls
                procedure TMaterialParametersInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin
                        inherited writeToInputControls( updateEmptyControlsIn );

                        writeSoilParameters( updateEmptyControlsIn );

                        writeNailParameters( updateEmptyControlsIn );

                        writeConcreteParameters( updateEmptyControlsIn );
                    end;

end.
