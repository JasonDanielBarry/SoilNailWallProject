unit SoilNailWallComputationMethods;

interface

    uses
        System.SysUtils, Math
        ;

    function calculateNailGroupTension( const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                slipWedgeLengthIn, soilCohesionIn,
                                                soilFrictionAngleIn, nailAngleIn,
                                                appliedLoadIn, safetyFactorIn       : double ) : double;

    function calculateNailGroupSafetyFactor(const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                    slipWedgeLengthIn, soilCohesionIn,
                                                    soilFrictionAngleIn, nailAngleIn,
                                                    nailGroupTensionIn, appliedLoadIn   : double) : double;

implementation

    function calculateNailGroupTension( const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                slipWedgeLengthIn, soilCohesionIn,
                                                soilFrictionAngleIn, nailAngleIn,
                                                appliedLoadIn, safetyFactorIn       : double ) : double;
        var
            alpha, c, FS, L, phi, Q, theta, W,
            numerator, denominator,
            tensionOut                      : double;
        begin
            //calculation variables
                alpha   := degToRad( slipWedgeAngleIn );
                c       := soilCohesionIn;
                Fs      := safetyFactorIn;
                L       := slipWedgeLengthIn;
                phi     := degToRad( soilFrictionAngleIn );
                Q       := appliedLoadIn;
                theta   := degToRad( nailAngleIn );
                W       := slipWedgeWeightIn;

            //equation
                numerator   :=      (W + Q) * (Fs * sin( alpha ) - cos( alpha ) * tan( phi ))  - (c * L);
                                //  --------------------------------------------------------------------
                denominator :=          cos( alpha + theta ) + sin( alpha + theta ) * tan( phi );

                tensionOut := numerator / denominator;

            result := max(0, tensionOut);
        end;

    function calculateNailGroupSafetyFactor(const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                    slipWedgeLengthIn, soilCohesionIn,
                                                    soilFrictionAngleIn, nailAngleIn,
                                                    nailGroupTensionIn, appliedLoadIn   : double) : double;
        var
            alpha, c, F, L, N, phi, Q, T, theta, W,
            drivingForce, resistingForce,
            safetyFactorOut                     : double;
        begin
            //calculation variables
                alpha   := degToRad( slipWedgeAngleIn );
                c       := soilCohesionIn;
                L       := slipWedgeLengthIn;
                phi     := degToRad( soilFrictionAngleIn );
                Q       := appliedLoadIn;
                T       := nailGroupTensionIn;
                theta   := degToRad( nailAngleIn );
                W       := slipWedgeWeightIn;

            //equation
                //driving force
                    drivingForce := (W + Q) * sin(alpha);

                //resisting force
                    //normal force
                        N := (W + Q) * cos( alpha ) + T * sin( alpha + theta );

                    //cohesive and friction force
                        F := (c * L) + ( N * tan( phi ) );

                    resistingForce := T * cos( alpha + theta ) + F;

                safetyFactorOut := resistingForce / drivingForce;

            result := safetyFactorOut;
        end;

end.
