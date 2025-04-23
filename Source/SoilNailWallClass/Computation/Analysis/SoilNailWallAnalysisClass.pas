unit SoilNailWallAnalysisClass;

interface

    uses
        system.SysUtils, system.Math,
        GeometryTypes,
        GeomLineClass, GeomPolygonClass,
        SoilNailWallTypes,
        SoilNailWallComputationMethods,
        SoilNailWallGeometryClass
        ;

    type
        TSoilNailWallAnalysis = class(TSoilNailWallGeometry)
            private
                var
                    requiredSafetyFactor : double;
                //maximum nail tension
                    function calculateNailGroupMaxTension() : double;
            public
                //required tension for stability
                    function calculateRequiredNailGroupTension(const appliedLoadIn, requiredSafetyFactorIn : double) : double;
                    function calculateNailGroupTensionVSSlipAngleCurve(const appliedLoadIn, requiredSafetyFactorIn : double) : TArray<TGeomPoint>;
                //slope safety factor
                    function calculateNailGroupSafetyFactor(const appliedLoadIn : double) : double;
                    function calculateNailGroupSafetyFactorVSSlipAngleCurve(const appliedLoadIn : double) : TArray<TGeomPoint>;
//            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //maximum nail tension
            function TSoilNailWallAnalysis.calculateNailGroupMaxTension() : double;
                var
                    i                   : integer;
                    nailAnchoredLength,
                    maxTensionOut       : double;
                    nails               : TSoilNails;
                    anchoredNailGeom    : TArray<TGeomLine>;
                begin
                    nails := getNails();

                    anchoredNailGeom := determineAnchoredNailGeometry();

                    nailAnchoredLength := 0;

                    for i := 0 to ( nails.determineNailCount() - 1 ) do
                        nailAnchoredLength := nailAnchoredLength + anchoredNailGeom[i].calculateLength();

                    maxTensionOut {kN} := Pi * nails.diameter.groutHole / 1000 {m} * nails.strength.groutSoilInterface.designValue() {kPa} * nailAnchoredLength {m};

                    result := maxTensionOut;
                end;

    //protected
        //required tension for stability
            function TSoilNailWallAnalysis.calculateRequiredNailGroupTension(const appliedLoadIn, requiredSafetyFactorIn : double) : double;
                var
                    soil        : TSoil;
                    slipWedge   : TSlipWedge;
                begin
                    soil        := getSoil();
                    slipWedge   := getSlipWedge( True );

                    result := calculateNailGroupTension(
                                                            slipWedge.selfWeight, slipWedge.angle, slipWedge.length,
                                                            soil.cohesion.designValue(), soil.frictionAngle.designValue(),
                                                            getNails().angle, appliedLoadIn, requiredSafetyFactorIn
                                                       );
                end;

            function TSoilNailWallAnalysis.calculateNailGroupTensionVSSlipAngleCurve(const appliedLoadIn, requiredSafetyFactorIn : double) : TArray<TGeomPoint>;
                const
                    START_ANGLE     : double = 10;
                    END_ANGLE       : double = 85;
                    ANGLE_INCREMENT : double = 0.05;
                var
                    i, pointCount       : integer;
                    requiredNailTension,
                    slipAngle           : double;
                    curveOut            : TArray<TGeomPoint>;
                begin
                    pointCount := round( (END_ANGLE - START_ANGLE) / ANGLE_INCREMENT ) + 1;

                    SetLength( curveOut, pointCount );

                    slipAngle := START_ANGLE;

                    for i := 0 to (pointCount - 1) do
                        begin
                            setSlipWedgeAngle( slipAngle );

                            requiredNailTension := calculateRequiredNailGroupTension( appliedLoadIn, requiredSafetyFactorIn );

                            curveOut[i].setPoint( slipAngle, requiredNailTension );

                            slipAngle := slipAngle + ANGLE_INCREMENT;
                        end;

                    result := curveOut;
                end;

        //slope safety factor
            function TSoilNailWallAnalysis.calculateNailGroupSafetyFactor(const appliedLoadIn : double) : double;
                var
                    maxNailTension  : double;
                    soil            : TSoil;
                    slipWedge       : TSlipWedge;
                begin
                    maxNailTension  := calculateNailGroupMaxTension();
                    soil            := getSoil();
                    slipWedge       := getSlipWedge( True );

                    result := SoilNailWallComputationMethods.calculateNailGroupSafetyFactor(
                                                                                                slipWedge.selfWeight, slipWedge.angle, slipWedge.length,
                                                                                                soil.cohesion.designValue(), soil.frictionAngle.designValue(),
                                                                                                getNails().angle, maxNailTension, appliedLoadIn
                                                                                           );
                end;

            function TSoilNailWallAnalysis.calculateNailGroupSafetyFactorVSSlipAngleCurve(const appliedLoadIn : double) : TArray<TGeomPoint>;
                const
                    START_ANGLE     : double = 10;
                    END_ANGLE       : double = 80;
                    ANGLE_INCREMENT : double = 0.05;
                var
                    i, pointCount   : integer;
                    safetyFactor,
                    slipAngle       : double;
                    curveOut        : TArray<TGeomPoint>;
                begin
                    pointCount := round( (END_ANGLE - START_ANGLE) / ANGLE_INCREMENT ) + 1;

                    SetLength( curveOut, pointCount );

                    slipAngle := START_ANGLE;

                    for i := 0 to (pointCount - 1) do
                        begin
                            setSlipWedgeAngle( slipAngle );

                            safetyFactor := calculateNailGroupSafetyFactor( appliedLoadIn );

                            curveOut[i].setPoint( slipAngle, safetyFactor );

                            slipAngle := slipAngle + ANGLE_INCREMENT;
                        end;

                    result := curveOut;
                end;

    //public
        //constructor
            constructor TSoilNailWallAnalysis.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TSoilNailWallAnalysis.destroy();
                begin
                    inherited destroy();
                end;

end.
