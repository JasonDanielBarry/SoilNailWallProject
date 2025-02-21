unit SoilNailWallTypes;

interface

    uses
        System.SysUtils, system.Math,
        FileReaderWriterClass,
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
                    function loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
                    procedure saveToFile(var fileReadWriteInOut : TFileReaderWriter);
            end;

        //soil wall nails
            TSoilNails = record
                strict private
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
                    function loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
                    procedure saveToFile(var fileReadWriteInOut : TFileReaderWriter);
            end;

        //wall in front of soil
            TWall = record
                strict private
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
                    function loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
                    procedure saveToFile(var fileReadWriteInOut : TFileReaderWriter);
            end;

implementation

    //TSoil----------------------------------------------------------------------------------------------------
        function TSoil.loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
            var
                successfulRead : boolean;
            begin
//                successfulRead := fileReadWriteInOut.tryReadDouble
            end;

        procedure TSoil.saveToFile(var fileReadWriteInOut : TFileReaderWriter);
            begin

            end;
    //--------------------------------------------------------------------------------------------------------------

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

end.
