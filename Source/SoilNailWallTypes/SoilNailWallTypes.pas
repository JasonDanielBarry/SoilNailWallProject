unit SoilNailWallTypes;

interface

    uses
        System.SysUtils, system.Math,
        system.Generics.Collections,
        Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom,
        XMLDocumentMethods,
        InterpolatorClass,
        LimitStateMaterialClass;

    type
        //failure slip wedge
            TSlipWedge = record
                var
                    visible     : boolean;
                    angle,
                    length,
                    selfWeight  : double;
            end;

        //soil behind wall
            TSoil = record
                strict private
                    const
                        DT_SOIL             : string = 'TSoil';
                        SLOPE_ANGLE         : string = 'SlopeAngle';
                        SLOPE_MAX_HEIGHT    : string = 'SlopeMaxHeight';
                        SOIL_COHESION       : string = 'SoilCohesion';
                        SOIL_FRICTION_ANGLE : string = 'SoilFrictionAngle';
                        SOIL_UNIT_WEIGHT    : string = 'SoilUnitWeight';
                    type
                        TSlope = record
                            angle,
                            maxHeight : double;
                        end;
                public
                    var
                        cohesion,
                        frictionAngle,
                        unitWeight      : TLimitStateMaterial;
                        slope           : TSlope;
                    function tryReadFromXMLNode(const XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

        //soil wall nails
            TSoilNails = record
                strict private
                    const
                        DT_SOIL_NAILS           : string = 'TSoilNails';
                        GROUT_SOIL_INTERFACE    : string = 'GroutSoilInterfaceStrength';
                        NAIL_TENSILE_STRENGTH   : string = 'NailTensileStrength';
                        GROUT_HOLE_DIAMETER     : string = 'GroutHoleDiameter';
                        NAIL_DIAMETER           : string = 'NailDiameter';
                        NAIL_HEIGHTS            : string = 'NailHeights';
                        NAIL_LENGTHS            : string = 'NailLengths';
                        NAIL_ANGLE              : string = 'NailAngle';
                        NAIL_HORIZONTAL_SPACING : string = 'NailHorizontalSpacing';
                    type
                        TSoilNailStrength = record
                            groutSoilInterface,
                            tensile             : TLimitStateMaterial;
                        end;
                        TNailDiameter = record
                            groutHole,
                            steel       : double;
                        end;
                    var
                        arrHeights,
                        arrLengths  : TArray<double>;
                public
                    var
                        angle,
                        horizontalSpacing   : double;
                        diameter            : TNailDiameter;
                        strength            : TSoilNailStrength;
                    procedure addNail(const heightIn, lengthIn : double);
                    procedure clearNailLayout();
                    procedure copyHeightsAndLengths(const soilNailsIn : TSoilNails);
                    procedure generateLayout(const  topSpaceIn,  verticalSpacingIn,
                                                    topLengthIn, bottomLengthIn,
                                                    wallHeightIn                    : double);
                    procedure getNailLayout(const wallHeightIn                      : double;
                                            out topSpaceOut,    verticalSpacingOut,
                                                topLengthOut,   bottomLengthOut     : double);
                    function determineNailCount()            : integer;
                    function longestNailLength()    : double;
                    function getArrHeight()         : TArray<double>;
                    function getArrLengths()        : TArray<double>;
                    function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

        //wall in front of soil
            TWall = record
                strict private
                    const
                        DT_WALL                         : string = 'TWall';
                        CONCRETE_COMPRESSIVE_STRENGTH   : string = 'ConcreteCompressiveStrength';
                        CONCRETE_REINFORCEMENT_STRENGTH : string = 'ConcreteReinforcementStrength';
                        WALL_ANGLE                      : string = 'WallAngle';
                        WALL_HEIGHT                     : string = 'WallHeight';
                        WALL_THICKNESS                  : string = 'WallThickness';
                    type
                        TConcrete = record
                            strict private
                                type
                                    TConcreteStrength = record
                                        compressive,
                                        reinforcement   : TLimitStateMaterial;
                                    end;
                            public
                                strength : TConcreteStrength;
                        end;
                public
                    var
                        angle,
                        height,
                        thickness   : double;
                        concrete    : TConcrete;
                    function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

        //load cases
            TLoadCase = record
                factor, load        : double;
                name, description   : string;
                procedure setvalues(const factorIn, loadIn      : double;
                                    const nameIn, descriptionIn : string);
            end;

            TLoadCaseMap = class(TDictionary<integer, TLoadCase>)
                public
                    procedure copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
                    function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

implementation

    //TSoil----------------------------------------------------------------------------------------------------
        function TSoil.tryReadFromXMLNode(const XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
            var
                readSuccessful  : boolean;
                soilNode        : IXMLNode;
            begin
                //test node type
                    if NOT( tryGetXMLChildNode( XMLNodeIn, identifierIn, DT_SOIL, soilNode ) ) then
                        exit( False );

                //read data
                    //slope
                        readSuccessful := tryReadDoubleFromXMLNode( soilNode, SLOPE_ANGLE, slope.angle );
                        readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( soilNode, SLOPE_MAX_HEIGHT, slope.maxHeight );

                    //cohesion
                        readSuccessful := readSuccessful AND cohesion.tryReadFromXMLNode( soilNode, SOIL_COHESION );

                    //friction angle
                        readSuccessful := readSuccessful AND frictionAngle.tryReadFromXMLNode( soilNode, SOIL_FRICTION_ANGLE );

                    //unit weight
                        readSuccessful := readSuccessful AND unitWeight.tryReadFromXMLNode( soilNode, SOIL_UNIT_WEIGHT );

                result := readSuccessful;
            end;

        procedure TSoil.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            var
                soilNode : IXMLNode;
            begin
                if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_SOIL, soilNode ) ) then
                    exit();

                writeDoubleToXMLNode( soilNode, SLOPE_ANGLE, slope.angle );
                writeDoubleToXMLNode( soilNode, SLOPE_MAX_HEIGHT, slope.maxHeight );

                cohesion.writeToXMLNode( soilNode, SOIL_COHESION );

                frictionAngle.writeToXMLNode( soilNode, SOIL_FRICTION_ANGLE );

                unitWeight.writeToXMLNode( soilNode, SOIL_UNIT_WEIGHT );
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TSoilNails----------------------------------------------------------------------------------------------------
        procedure TSoilNails.addNail(const heightIn, lengthIn : double);
            var
                nailHeightIsTaken           : boolean;
                i, arrLen                   : integer;
                testHeight                  : double;
            function
                _isValidHeight() : boolean;
                    var
                        isNotZero, isPositive : boolean;
                    begin
                        isNotZero   := NOT( isZero(heightIn, 1e-3) );
                        isPositive  := heightIn > 0;

                        _isValidHeight := (isNotZero AND isPositive);
                    end;
            begin
                if ( NOT( _isValidHeight() ) ) then
                    exit();

                //get number of nails
                    arrLen := determineNailCount();

                //check the nail height is valid
                    for i := 0 to (arrLen - 1) do
                        begin
                            testHeight := arrHeights[i];

                            nailHeightIsTaken := ( SameValue( heightIn, testHeight ) );

                            if (nailHeightIsTaken) then
                                exit();
                        end;

                //increment
                    setLength(arrHeights, arrLen + 1);
                    setLength(arrLengths, arrLen + 1);

                //assign height and length
                    arrHeights[arrLen] := heightIn;
                    arrLengths[arrLen] := lengthIn;
            end;

        procedure TSoilNails.clearNailLayout();
            begin
                SetLength( arrHeights, 0 );
                SetLength( arrLengths, 0 );
            end;

        procedure TSoilNails.copyHeightsAndLengths(const soilNailsIn : TSoilNails);
            var
                i, arrLen : integer;
            begin
                self.clearNailLayout();

                arrLen := soilNailsIn.determineNailCount();

                if (arrLen < 1) then
                    exit();

                SetLength(Self.arrHeights, arrLen);
                SetLength(Self.arrLengths, arrLen);

                for i := 0 to (arrLen - 1) do
                    begin
                        self.arrHeights[i] := soilNailsIn.arrHeights[i];
                        self.arrLengths[i] := soilNailsIn.arrLengths[i];
                    end;
            end;

        procedure TSoilNails.generateLayout(const   topSpaceIn,  verticalSpacingIn,
                                                    topLengthIn, bottomLengthIn,
                                                    wallHeightIn                    : double);
            var
                arrLen                  : integer;
                nailHeight, nailLength,
                topHeight,  bottomHeight,
                x0, x1, y0, y1          : double;
                nailLengthInterpolator  : TInterpolator;
                arrNailHeights          : TArray<double>;
            begin
                //check for valid initial nail height
                    nailHeight := wallHeightIn - topSpaceIn;

                    if ( isZero(nailHeight, 1e-3) OR (nailHeight < 0) ) then
                        exit();

                //fill the array with nail heights
                    arrLen := 0;

                    while (0 < nailHeight) do
                        begin
                            inc(arrLen);
                            SetLength( arrNailHeights, arrLen );

                            arrNailHeights[arrLen - 1] := nailHeight;

                            nailHeight := nailHeight - verticalSpacingIn
                        end;

                //get the top and bottom heights
                    topHeight       := arrNailHeights[0];
                    bottomHeight    := arrNailHeights[arrLen - 1];

                //instantiate the interpolator
                    x0 := topHeight;
                    x1 := bottomHeight;

                    y0 := topLengthIn;
                    y1 := bottomLengthIn;

                    nailLengthInterpolator := TInterpolator.create(x0, x1, y0, y1);

                //loop through the nail heights and calculate the lengths
                    clearNailLayout();

                    for nailHeight in arrNailHeights do
                        begin
                            nailLength := nailLengthInterpolator.interpolateX( nailHeight );

                            addNail( nailHeight, nailLength );
                        end;

                FreeAndNil(nailLengthInterpolator);
            end;

        procedure TSoilNails.getNailLayout( const wallHeightIn                      : double;
                                            out topSpaceOut,    verticalSpacingOut,
                                                topLengthOut,   bottomLengthOut     : double);
            var
                localNailCount : integer;
            begin
                topSpaceOut         := 0;
                verticalSpacingOut  := 0;
                topLengthOut        := 0;
                bottomLengthOut     := 0;

                localNailCount := determineNailCount();

                if (localNailCount < 2) then
                    exit();

                topSpaceOut         := wallHeightIn - arrHeights[0];
                verticalSpacingOut  := (arrHeights[0] - arrHeights[localNailCount - 1]) / (localNailCount - 1);
                topLengthOut        := arrLengths[0];
                bottomLengthOut     := arrLengths[localNailCount - 1];
            end;

        function TSoilNails.determineNailCount() : integer;
            begin
                result := length( arrHeights );
            end;

        function TSoilNails.longestNailLength() : double;
            begin
                if ( determineNailCount() < 1 ) then
                    exit(0);

                result := MaxValue( arrLengths );
            end;

        function TSoilNails.getArrHeight() : TArray<double>;
            begin
                result := arrHeights;
            end;

        function TSoilNails.getArrLengths() : TArray<double>;
            begin
                result := arrLengths;
            end;

        function TSoilNails.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
            var
                readSuccessful  : boolean;
                soilNailsNode   : IXMLNode;
            begin
                if NOT( tryGetXMLChildNode( XMLNodeIn, identifierIn, DT_SOIL_NAILS, soilNailsNode ) ) then
                    exit( False );

                readSuccessful := strength.groutSoilInterface.tryReadFromXMLNode( soilNailsNode, GROUT_SOIL_INTERFACE );
                readSuccessful := readSuccessful AND strength.tensile.tryReadFromXMLNode( soilNailsNode, NAIL_TENSILE_STRENGTH );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( soilNailsNode, GROUT_HOLE_DIAMETER, diameter.groutHole );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( soilNailsNode, NAIL_DIAMETER, diameter.steel );

                readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( soilNailsNode, NAIL_HEIGHTS, arrHeights );
                readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( soilNailsNode, NAIL_LENGTHS, arrLengths );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( soilNailsNode, NAIL_ANGLE, angle );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( soilNailsNode, NAIL_HORIZONTAL_SPACING, horizontalSpacing );

                result := readSuccessful;
            end;

        procedure TSoilNails.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            var
                soilNailsNode : IXMLNode;
            begin
                if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_SOIL_NAILS, soilNailsNode ) ) then
                    exit();

                strength.groutSoilInterface.writeToXMLNode( soilNailsNode, GROUT_SOIL_INTERFACE );

                strength.tensile.writeToXMLNode( soilNailsNode, NAIL_TENSILE_STRENGTH );

                writeDoubleToXMLNode( soilNailsNode, GROUT_HOLE_DIAMETER, diameter.groutHole );
                writeDoubleToXMLNode( soilNailsNode, NAIL_DIAMETER, diameter.steel );

                writeDoubleArrayToXMLNode( soilNailsNode, NAIL_HEIGHTS, arrHeights );
                writeDoubleArrayToXMLNode( soilNailsNode, NAIL_LENGTHS, arrLengths );

                writeDoubleToXMLNode( soilNailsNode, NAIL_ANGLE, angle );
                writeDoubleToXMLNode( soilNailsNode, NAIL_HORIZONTAL_SPACING, horizontalSpacing );
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TWall----------------------------------------------------------------------------------------------------
        function TWall.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
            var
                readSuccessful  : boolean;
                wallNode        : IXMLNode;
            begin
                if NOT( tryGetXMLChildNode( XMLNodeIn, identifierIn, DT_WALL, wallNode ) ) then
                    exit( False );

                readSuccessful := concrete.strength.compressive.tryReadFromXMLNode( wallNode, CONCRETE_COMPRESSIVE_STRENGTH );

                readSuccessful := readSuccessful AND concrete.strength.reinforcement.tryReadFromXMLNode( wallNode, CONCRETE_REINFORCEMENT_STRENGTH );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( wallNode, WALL_ANGLE, angle );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( wallNode, WALL_HEIGHT, height );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( wallNode, WALL_THICKNESS, thickness );

                result := readSuccessful;
            end;

        procedure TWall.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            var
                wallNode : IXMLNode;
            begin
                if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_WALL, wallNode ) ) then
                    exit();

                concrete.strength.compressive.writeToXMLNode( wallNode, CONCRETE_COMPRESSIVE_STRENGTH );

                concrete.strength.reinforcement.writeToXMLNode( wallNode, CONCRETE_REINFORCEMENT_STRENGTH );

                writeDoubleToXMLNode( wallNode, WALL_ANGLE, angle );
                writeDoubleToXMLNode( wallNode, WALL_HEIGHT, height );
                writeDoubleToXMLNode( wallNode, WALL_THICKNESS, thickness );
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TLoadCaseMap--------------------------------------------------------------------------------------------------
        procedure TLoadCase.setvalues(  const factorIn, loadIn      : double;
                                        const nameIn, descriptionIn : string    );
            begin
                factor      := factorIn;
                load        := loadIn;
                name        := nameIn;
                description := descriptionIn;
            end;

        procedure TLoadCaseMap.copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
            var
                itemKey     : integer;
                loadCase    : TLoadCase;
            begin
                self.Clear();

                for itemKey in otherLoadCaseMapIn.Keys do
                    begin
                        if NOT( otherLoadCaseMapIn.TryGetValue( itemKey, loadCase ) ) then
                            Continue;

                        self.AddOrSetValue( itemKey, loadCase );
                    end;
            end;

        function TLoadCaseMap.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
            begin
                // to do
            end;

        procedure TLoadCaseMap.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            begin
                // to do
            end;


end.
