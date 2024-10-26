unit SoilNailWallAnalysisClass;

interface

    uses
        system.SysUtils, system.Math,
        SoilNailWallGeometryClass
        ;

    type
        TSoilNailWallAnalysis = class(TSoilNailWallGeometry)
            private

            protected
                var
                    requiredSafetyFactor : double;
//                function calculateNailGroupTension() : double;
//                function calcuateNailGroupSafetyFactor() : double;
            public

                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
        end;

implementation

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
