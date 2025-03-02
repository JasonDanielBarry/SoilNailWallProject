unit SoilNailWallTypes;

interface

    uses
        System.SysUtils, system.Math,
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
                    function tryReadFromXMLNode(const XMLNodeIn : IXMLNode) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode);
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
                    procedure addNail(const heightIn, lengthIn: double);
                    procedure clearNailLayout();
                    procedure copyHeightsAndLengths(const soilNailsIn : TSoilNails);
                    procedure generateLayout(const  topSpaceIn,  verticalSpacingIn,
                                                    topLengthIn, bottomLengthIn,
                                                    wallHeightIn                    : double);
                    procedure getNailLayout(const wallHeightIn                      : double;
                                            out topSpaceOut,    verticalSpacingOut,
                                                topLengthOut,   bottomLengthOut     : double);
                    function nailCount()            : integer;
                    function longestNailLength()    : double;
                    function getArrHeight()         : TArray<double>;
                    function getArrLengths()        : TArray<double>;
                    function tryReadFromXMLNode(var XMLNodeIn : IXMLNode) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode);
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
                    function tryReadFromXMLNode(var XMLNodeIn : IXMLNode) : boolean;
                    procedure writeToXMLNode(var XMLNodeInOut : IXMLNode);
            end;

implementation

    //TSoil----------------------------------------------------------------------------------------------------
        function TSoil.tryReadFromXMLNode(const XMLNodeIn : IXMLNode) : boolean;
            var
                readSuccessful : boolean;
                limitStateNode : IXMLNode;
            begin
                //test node type
                    if NOT( XMLNodeIsDataType( XMLNodeIn, DT_SOIL ) ) then
                        exit( False );

                //read data
                    //slope
                        readSuccessful := tryReadDoubleFromXMLNode( XMLNodeIn, SLOPE_ANGLE, slope.angle );
                        readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, SLOPE_MAX_HEIGHT, slope.maxHeight );

                    //cohesion
                        tryGetXMLChildNode( XMLNodeIn, SOIL_COHESION, limitStateNode );
                        readSuccessful := readSuccessful AND cohesion.tryReadFromXMLNode( limitStateNode );

                    //friction angle
                        tryGetXMLChildNode( XMLNodeIn, SOIL_FRICTION_ANGLE, limitStateNode );
                        readSuccessful := readSuccessful AND frictionAngle.tryReadFromXMLNode( limitStateNode );

                    //unit weight
                        tryGetXMLChildNode( XMLNodeIn, SOIL_UNIT_WEIGHT, limitStateNode );
                        readSuccessful := readSuccessful AND unitWeight.tryReadFromXMLNode( limitStateNode );

                result := readSuccessful;
            end;

        procedure TSoil.writeToXMLNode(var XMLNodeInOut : IXMLNode);
            var
                limitStateNode : IXMLNode;
            begin
                setXMLNodeDataType( XMLNodeInOut, DT_SOIL );

                writeDoubleToXMLNode( XMLNodeInOut, SLOPE_ANGLE, slope.angle );
                writeDoubleToXMLNode( XMLNodeInOut, SLOPE_MAX_HEIGHT, slope.maxHeight );

                tryCreateNewXMLChildNode( XMLNodeInOut, SOIL_COHESION, limitStateNode );
                cohesion.writeToXMLNode( limitStateNode );

                tryCreateNewXMLChildNode( XMLNodeInOut, SOIL_FRICTION_ANGLE, limitStateNode );
                frictionAngle.writeToXMLNode( limitStateNode );

                tryCreateNewXMLChildNode( XMLNodeInOut, SOIL_UNIT_WEIGHT, limitStateNode );
                unitWeight.writeToXMLNode( limitStateNode );
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TSoilNails----------------------------------------------------------------------------------------------------
        procedure TSoilNails.addNail(const heightIn, lengthIn: double);
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
                    arrLen := nailCount();

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

                arrLen := soilNailsIn.nailCount();

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
                            nailLength := nailLengthInterpolator.interpolateX(nailHeight);

                            addNail(nailHeight, nailLength);
                        end;

                FreeAndNil(nailLengthInterpolator);
            end;

        procedure TSoilNails.getNailLayout( const wallHeightIn                      : double;
                                            out topSpaceOut,    verticalSpacingOut,
                                                topLengthOut,   bottomLengthOut     : double);
            begin
                topSpaceOut         := 0;
                verticalSpacingOut  := 0;
                topLengthOut        := 0;
                bottomLengthOut     := 0;

                if (nailCount() < 2) then
                    exit();



                topSpaceOut         := wallHeightIn - arrHeights[0];
                verticalSpacingOut  := (arrHeights[0] - arrHeights[nailCount() - 1]) / (nailCount() - 1);
                topLengthOut        := arrLengths[0];
                bottomLengthOut     := arrLengths[nailCount() - 1];
            end;

        function TSoilNails.nailCount() : integer;
            begin
                result := length(arrHeights);
            end;

        function TSoilNails.longestNailLength() : double;
            var
                i               : integer;
                maxLengthOut    : double;
            begin
                maxLengthOut := 0;

                for i := 0 to (nailCount() - 1) do
                    maxLengthOut := max(arrLengths[i], maxLengthOut);

                result := maxLengthOut;
            end;

        function TSoilNails.getArrHeight() : TArray<double>;
            begin
                result := arrHeights;
            end;

        function TSoilNails.getArrLengths() : TArray<double>;
            begin
                result := arrLengths;
            end;

        function TSoilNails.tryReadFromXMLNode(var XMLNodeIn : IXMLNode) : boolean;
            var
                readSuccessful : boolean;
                limitStateNode : IXMLNode;
            begin
                if NOT( XMLNodeIsDataType( XMLNodeIn, DT_SOIL_NAILS ) ) then
                    exit( False );

                tryGetXMLChildNode( XMLNodeIn, GROUT_SOIL_INTERFACE, limitStateNode );
                readSuccessful := strength.groutSoilInterface.tryReadFromXMLNode( limitStateNode );

                tryGetXMLChildNode( XMLNodeIn, NAIL_TENSILE_STRENGTH, limitStateNode );
                readSuccessful := readSuccessful AND strength.tensile.tryReadFromXMLNode( limitStateNode );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, GROUT_HOLE_DIAMETER, diameter.groutHole );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, NAIL_DIAMETER, diameter.steel );

                readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( XMLNodeIn, NAIL_HEIGHTS, arrHeights );
                readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( XMLNodeIn, NAIL_LENGTHS, arrLengths );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, NAIL_ANGLE, angle );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, NAIL_HORIZONTAL_SPACING, horizontalSpacing );

                result := readSuccessful;
            end;

        procedure TSoilNails.writeToXMLNode(var XMLNodeInOut : IXMLNode);
            var
                limitStateNode : IXMLNode;
            begin
                setXMLNodeDataType( XMLNodeInOut, DT_SOIL_NAILS );

                tryCreateNewXMLChildNode( XMLNodeInOut, GROUT_SOIL_INTERFACE, limitStateNode);
                strength.groutSoilInterface.writeToXMLNode( limitStateNode );

                tryCreateNewXMLChildNode( XMLNodeInOut, NAIL_TENSILE_STRENGTH, limitStateNode );
                strength.tensile.writeToXMLNode( limitStateNode );

                writeDoubleToXMLNode( XMLNodeInOut, GROUT_HOLE_DIAMETER, diameter.groutHole );
                writeDoubleToXMLNode( XMLNodeInOut, NAIL_DIAMETER, diameter.steel );

                writeDoubleArrayToXMLNode( XMLNodeInOut, NAIL_HEIGHTS, arrHeights );
                writeDoubleArrayToXMLNode( XMLNodeInOut, NAIL_LENGTHS, arrLengths );

                writeDoubleToXMLNode( XMLNodeInOut, NAIL_ANGLE, angle );
                writeDoubleToXMLNode( XMLNodeInOut, NAIL_HORIZONTAL_SPACING, horizontalSpacing );
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TWall----------------------------------------------------------------------------------------------------
        function TWall.tryReadFromXMLNode(var XMLNodeIn : IXMLNode) : boolean;
            var
                readSuccessful : boolean;
                limitStateNode : IXMLNode;
            begin
                if NOT( XMLNodeIsDataType( XMLNodeIn, DT_WALL ) ) then
                    exit( False );

                tryGetXMLChildNode( XMLNodeIn, CONCRETE_COMPRESSIVE_STRENGTH, limitStateNode );
                readSuccessful := concrete.strength.compressive.tryReadFromXMLNode( limitStateNode );

                tryGetXMLChildNode( XMLNodeIn, CONCRETE_REINFORCEMENT_STRENGTH, limitStateNode );
                readSuccessful := readSuccessful AND concrete.strength.reinforcement.tryReadFromXMLNode( limitStateNode );

                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, WALL_ANGLE, angle );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, WALL_HEIGHT, height );
                readSuccessful := readSuccessful AND tryReadDoubleFromXMLNode( XMLNodeIn, WALL_THICKNESS, thickness );

                result := readSuccessful;
            end;

        procedure TWall.writeToXMLNode(var XMLNodeInOut : IXMLNode);
            var
                limitStateNode : IXMLNode;
            begin
                setXMLNodeDataType( XMLNodeInOut, DT_WALL );

                tryCreateNewXMLChildNode( XMLNodeInOut, CONCRETE_COMPRESSIVE_STRENGTH, limitStateNode );
                concrete.strength.compressive.writeToXMLNode( limitStateNode );

                tryCreateNewXMLChildNode( XMLNodeInOut, CONCRETE_REINFORCEMENT_STRENGTH, limitStateNode );
                concrete.strength.reinforcement.writeToXMLNode( limitStateNode );

                writeDoubleToXMLNode( XMLNodeInOut, WALL_ANGLE, angle );
                writeDoubleToXMLNode( XMLNodeInOut, WALL_HEIGHT, height );
                writeDoubleToXMLNode( XMLNodeInOut, WALL_THICKNESS, thickness );
            end;

end.
