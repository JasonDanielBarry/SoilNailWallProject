unit SoilNailWallExampleMethods;

interface

    uses
        system.SysUtils, system.Math,
        LoadCaseTypes,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        ESNWExample = (seVerticalWallFlatSlope = 0);

    procedure loadExample(  const exampleIDIn           : ESNWExample;
                            var soilNailWallDesignInOut : TSoilNailWall );

implementation

    //vertical wall, flat slope and limit state parameters
        procedure loadExampleVerticalWallAndFlatSlope(var soilNailWallDesignInOut : TSoilNailWall);
            var
                nails       : TSoilNails;
                soil        : TSoil;
                wall        : TWall;
                loadCase    : TLoadCase;
                loadCases   : TLoadCaseMap;
            begin
                //set up nails
                    nails := soilNailWallDesignInOut.getNails();

                    nails.angle := 10;
                    nails.horizontalSpacing := 1.5;
                    nails.diameter.groutHole := 0.1;
                    nails.strength.groutSoilInterface.setValues(150, 0.4, 1.0, 1.4);
                    nails.strength.tensile.setValues(500, 0.05, 1.0, 1.8);

                    soilNailWallDesignInOut.setNails( nails );

                //set up soil
                    soil := soilNailWallDesignInOut.getSoil();

                    soil.cohesion.setValues(5, 0.4, 1.0, 1.4);
                    soil.frictionAngle.setValues(30, 0.1, 1.0, 1.25);
                    soil.unitWeight.setValues(19, 0, 0, 1.0);

                    soil.slope.angle := 0;
                    soil.slope.maxHeight := 10;

                    soilNailWallDesignInOut.setSoil( soil );

                //set up wall
                    wall := soilNailWallDesignInOut.getWall();

                    wall.angle := 0;
                    wall.height := 10;
                    wall.thickness := 0.25;
                    wall.concrete.strength.compressive.setValues(30, 0.15, 1.0, 1.5);
                    wall.concrete.strength.reinforcement.setValues(450, 0.05, 1.0, 1.15);

                    soilNailWallDesignInOut.setWall( wall );

                //layout
                    soilNailWallDesignInOut.generateSoilNailLayout(0.5, 1.5, 20, 10);

                //loads
                    loadCases := soilNailWallDesignInOut.getLoadCases();

                    loadCase.LCName := 'LC1';
                    loadCase.addLoadCombination(1.2, 10, 'Dead Load');
                    loadCase.addLoadCombination(1.6, 15, 'Live Load');

                    loadCases.AddOrSetValue( loadCase.LCName, loadCase );

                    loadCases.setActiveLoadCase( loadCase.LCName );

                    soilNailWallDesignInOut.setLoadCases( loadCases );
            end;

    procedure loadExample(  const exampleIDIn           : ESNWExample;
                            var soilNailWallDesignInOut : TSoilNailWall);
        begin
            case (exampleIDIn) of
                ESNWExample.seVerticalWallFlatSlope:
                    loadExampleVerticalWallAndFlatSlope( soilNailWallDesignInOut );


            end;
        end;

end.
