unit SoilNailWallComputationMethods;

interface

    uses
        System.SysUtils, Math,
        SoilNailWallTypes;

    function nailGroupTension(  const appliedLoadIn, safetyFactorIn   : double;
                                const nailsIn                         : TSoilNails;
                                const slipWedgeIn                     : TSlipWedge;
                                const soilIn                          : TSoil     ) : double;

implementation

    function nailGroupTension(  const appliedLoadIn, safetyFactorIn   : double;
                                const nailsIn                         : TSoilNails;
                                const slipWedgeIn                     : TSlipWedge;
                                const soilIn                          : TSoil     ) : double;
        var
            a, c, FS, L, phi, Q, theta, W,
            numerator, denominator,
            tensionOut                      : double;
        begin
            a       := degToRad(slipWedgeIn.angle);
            c       := soilIn.cohesion.designValue;
            Fs      := safetyFactorIn;
            L       := slipWedgeIn.length;
            phi     := degToRad(soilIn.frictionAngle.designValue);
            Q       := appliedLoadIn;
            theta   := degToRad(nailsIn.angle);
            W       := slipWedgeIn.selfWeight;

            numerator   :=      (W + Q) * (Fs * sin(a) - cos(a) * tan(phi))  - (c * L);
                            //  ------------------------------------------------------
            denominator :=          cos(a + theta) + sin(a + theta) * tan(phi);

            tensionOut := numerator / denominator;

            result := tensionOut;
        end;

    function nailGroupSafetyFactor( const appliedLoadIn, groupTensionIn   : double;
                                    const nailsIn                         : TSoilNails;
                                    const slipWedgeIn                     : TSlipWedge;
                                    const soilIn                          : TSoil     ) : double;
        var
            a, c, F, L, N, phi, Q, T, theta, W,
            drivingForce, resistingForce,
            safetyFactorOut                     : double;
        begin
            a       := degToRad(slipWedgeIn.angle);
            c       := soilIn.cohesion.designValue;
            L       := slipWedgeIn.length;
            phi     := degToRad(soilIn.frictionAngle.designValue);
            Q       := appliedLoadIn;
            T       := groupTensionIn;
            theta   := degToRad(nailsIn.angle);
            W       := slipWedgeIn.selfWeight;

            //driving force
                drivingForce := (W + Q) * sin(a);

            //resisting force
                //normal force
                    N := ((W + Q) * cos(a)) + (T * sin(a + theta));

                //cohesive/friction force
                    F := (c * L) + (N * tan(phi));

                resistingForce := (T * cos(a + theta)) + F;

            safetyFactorOut := resistingForce / drivingForce;

            result := safetyFactorOut;
        end;

end.
