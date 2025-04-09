unit SoilNailWallBaseClass;

interface

    uses
        System.SysUtils, Math,
        LimitStateMaterialClass,
        LimitStateAngleClass,
        SoilNailWallTypes;

    type
        TSoilNailWallBase = class
            private
                var
                    nails       : TSoilNails;
                    soil        : TSoil;
                    wall        : TWall;
                    slipWedge   : TSlipWedge;
                    loadCases   : TLoadCaseMap;
                //instantiate material classes
                    procedure instantiateMaterialClasses();
                //destroy material classes
                    procedure destroyMaterialClasses();
                //deep copy
                    procedure deepCopy(const otherSNWIn : TSoilNailWallBase);
            protected
                //modifier helpers
                    //nails
                        //geometry
                            procedure setNailAngle(const nailAngleIn : double);
                            procedure setNailHorizontalSpacing(const horizontalSpacingIn : double);
                        //diameter
                            procedure setGroutHoleDiameter(const diameterIn : double);
                            procedure setNailSteelDiameter(const diameterIn : double);
                        //strength
                            procedure setNailGroutSoilInterfaceStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                            procedure setNailTensileStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                    //slip wedge
                        procedure setSlipWedgeVisible(const visibleIn : boolean);
                        procedure setSlipWedgeAngle(const angleIn : double);
                        procedure setSlipWedgeLength(const lengthIn : double);
                        procedure setSlipWedgeWeight(const selfWeightIn : double);
                    //soil
                        //parameters
                            procedure setSoilCohesion(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                            procedure setSoilFrictionAngle(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                            procedure setSoilUnitWeight(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        //up-slope
                            procedure setSoilSlopeAngle(const soilSlopeAngleIn : double);
                            procedure setSoilSlopeMaxHeight(const soilSlopeMaxHeightIn : double);
                    //wall
                        //concrete
                            procedure setConcreteCompressiveStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                            procedure setConcreteReinforcementStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        //geometry
                            procedure setWallAngle(const wallAngleIn : double);
                            procedure setWallHeight(const wallHeightIn : double);
                            procedure setWallThickness(const wallThicknessIn : double);
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //accessors
                    //load
                        function getLoadCases() : TLoadCaseMap;
                    //nails
                        function getNails() : TSoilNails;
                    //slip wedge
                        function getSlipWedge(const updateSlipWedgeIn : boolean = False) : TSlipWedge; virtual;
                    //soil
                        function getSoil() : TSoil;
                    //wall
                        function getWall() : TWall;
                //modifiers
                    //load
                        procedure setLoadCases(const loadCasesIn : TLoadCaseMap);
                    //nails
                        procedure addNail(const heightIn, lengthIn : double);
                        procedure clearNailLayout();
                        procedure setNails(const nailsIn : TSoilNails);
                    //slip-wedge
                        procedure setSlipWedge(const slipWedgeIn : TSlipWedge);
                    //soil
                        procedure setSoil(const soilIn : TSoil);
                    //wall
                        procedure setWall(const wallIn : TWall);
                //copy other soil nail wall
                    procedure copySNW(const otherSoilNailWallIn : TSoilNailWallBase);
                //generate soil nail layout
                    procedure generateSoilNailLayout(const  topSpaceIn,  verticalSpacingIn,
                                                            topLengthIn, bottomLengthIn     : double);
                    procedure getNailLayout(out topSpaceOut,    verticalSpacingOut,
                                                topLengthOut,   bottomLengthOut     : double);
        end;

implementation

    //private
        //instantiate all classes
            procedure TSoilNailWallBase.instantiateMaterialClasses();
                begin
                    //nails
                        nails.strength.groutSoilInterface   := TLimitStateMaterial.create();
                        nails.strength.tensile              := TLimitStateMaterial.create();

                    //soil
                        soil.cohesion       := TLimitStateMaterial.create();
                        soil.frictionAngle  := TLimitStateAngle.create();
                        soil.unitWeight     := TLimitStateMaterial.create();

                    //wall
                        wall.concrete.strength.compressive      := TLimitStateMaterial.create();
                        wall.concrete.strength.reinforcement    := TLimitStateMaterial.create();
                end;

        //destroy material classes
            procedure TSoilNailWallBase.destroyMaterialClasses();
                begin
                    //nails
                        FreeAndNil( nails.strength.groutSoilInterface );
                        FreeAndNil( nails.strength.tensile );

                    //soil
                        FreeAndNil( soil.cohesion );
                        FreeAndNil( soil.frictionAngle );
                        FreeAndNil( soil.unitWeight );

                    //wall
                        FreeAndNil( wall.concrete.strength.compressive );
                        FreeAndNil( wall.concrete.strength.reinforcement );
                end;

        //deep copy
            procedure TSoilNailWallBase.deepCopy(const otherSNWIn : TSoilNailWallBase);

                begin
//                    self.setLoadCases( otherSNWIn.load );
                    self.setNails( otherSNWIn.nails );
                    self.setSlipWedge( otherSNWIn.slipWedge );
                    self.setSoil( otherSNWIn.soil );
                    self.setWall( otherSNWIn.wall );
                end;

    //protected
        //modifier helpers
            //nails
                //geometry
                    procedure TSoilNailWallBase.setNailAngle(const nailAngleIn : double);
                        begin
                            nails.angle := max(0, nailAngleIn);
                        end;

                    procedure TSoilNailWallBase.setNailHorizontalSpacing(const horizontalSpacingIn : double);
                        begin
                            nails.horizontalSpacing := max(0, horizontalSpacingIn);
                        end;

                //diameter
                    procedure TSoilNailWallBase.setGroutHoleDiameter(const diameterIn : double);
                        begin
                            nails.diameter.groutHole := max(0, diameterIn);
                        end;

                    procedure TSoilNailWallBase.setNailSteelDiameter(const diameterIn : double);
                        begin
                            nails.diameter.steel := max(0, diameterIn);
                        end;

                //strength
                    procedure TSoilNailWallBase.setNailGroutSoilInterfaceStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            nails.strength.groutSoilInterface.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                    procedure TSoilNailWallBase.setNailTensileStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            nails.strength.tensile.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

            //slip wedge
                procedure TSoilNailWallBase.setSlipWedgeVisible(const visibleIn : boolean);
                    begin
                        slipWedge.visible := visibleIn;
                    end;

                procedure TSoilNailWallBase.setSlipWedgeAngle(const angleIn : double);
                    begin
                        slipWedge.angle := max(1, angleIn);

                        slipWedge.angle := min(slipWedge.angle, 89);
                    end;

                procedure TSoilNailWallBase.setSlipWedgeLength(const lengthIn : double);
                    begin
                        slipWedge.length := max(0, lengthIn);
                    end;

                procedure TSoilNailWallBase.setSlipWedgeWeight(const selfWeightIn : double);
                    begin
                        slipWedge.selfWeight := max(0, selfWeightIn);
                    end;

            //soil
                //parameters
                    procedure TSoilNailWallBase.setSoilCohesion(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin


                            soil.cohesion.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                    procedure TSoilNailWallBase.setSoilFrictionAngle(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            soil.frictionAngle.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                    procedure TSoilNailWallBase.setSoilUnitWeight(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            soil.unitWeight.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                //up-slope
                    procedure TSoilNailWallBase.setSoilSlopeAngle(const soilSlopeAngleIn : double);
                        begin
                            soil.slope.angle := max(0, soilSlopeAngleIn);

                            if (soil.slope.angle < 1) then
                                setSoilSlopeMaxHeight(wall.height);
                        end;

                    procedure TSoilNailWallBase.setSoilSlopeMaxHeight(const soilSlopeMaxHeightIn : double);
                        begin
                            if (soil.slope.angle < 1) then
                                begin
                                    soil.slope.maxHeight := wall.height;
                                    exit();
                                end;

                            soil.slope.maxHeight := max(wall.height, soilSlopeMaxHeightIn);
                        end;

            //wall
                //concrete
                    procedure TSoilNailWallBase.setConcreteCompressiveStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            wall.concrete.strength.compressive.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                    procedure TSoilNailWallBase.setConcreteReinforcementStrength(const averageIn, coefVarIn, downgradeFactorIn, partialFacIn : double);
                        begin
                            wall.concrete.strength.reinforcement.setValues(averageIn, coefVarIn, downgradeFactorIn, partialFacIn);
                        end;

                //geometry
                    procedure TSoilNailWallBase.setWallAngle(const wallAngleIn : double);
                        begin
                            wall.angle := max(0, wallAngleIn);
                        end;

                    procedure TSoilNailWallBase.setWallHeight(const wallHeightIn : double);
                        begin
                            wall.height := max(0, wallHeightIn);

                            setSoilSlopeMaxHeight(soil.slope.maxHeight);
                        end;

                    procedure TSoilNailWallBase.setWallThickness(const wallThicknessIn : double);
                        begin
                            wall.thickness := max(0, wallThicknessIn);
                        end;

    //public
        //constructor
            constructor TSoilNailWallBase.create();
                begin
                    inherited create();

                    instantiateMaterialClasses();

                    //load cases
                        loadCases := TLoadCaseMap.Create();

                    //nails
                        clearNailLayout();
                        setNailAngle(0);
                        setNailGroutSoilInterfaceStrength(0, 0, 0, 1);
                        setNailTensileStrength(0, 0, 0, 1);

                    //soil
                        //parameters
                            setSoilCohesion(0, 0, 0, 1);
                            setSoilFrictionAngle(0, 0, 0, 1);
                            setSoilUnitWeight(0, 0, 0, 1);

                        //slope
                            setSoilSlopeAngle(0);
                            setSoilSlopeMaxHeight(0);

                    //wall
                        //concrete
                            setConcreteCompressiveStrength(0, 0, 0, 1);
                            setConcreteReinforcementStrength(0, 0, 0, 1);

                        //geometry
                            setWallAngle(0);
                            setWallHeight(0);
                end;

        //destructor
            destructor TSoilNailWallBase.destroy();
                begin
                    destroyMaterialClasses();

                    FreeAndNil( loadCases );

                    inherited destroy();
                end;

        //accessors
            //load
                function TSoilNailWallBase.getLoadCases() : TLoadCaseMap;
                    begin
                        result := loadCases;
                    end;

            //nails
                function TSoilNailWallBase.getNails() : TSoilNails;
                    begin
                        result := nails;
                    end;

            //slip wedge
                function TSoilNailWallBase.getSlipWedge(const updateSlipWedgeIn : boolean = False) : TSlipWedge;
                    begin
                        result := slipWedge;
                    end;

            //soil
                function TSoilNailWallBase.getSoil() : TSoil;
                    begin
                        result := soil;
                    end;

            //wall
                function TSoilNailWallBase.getWall() : TWall;
                    begin
                        result := wall;
                    end;

        //modifiers
            //load
                procedure TSoilNailWallBase.setLoadCases(const loadCasesIn : TLoadCaseMap);
                    begin
                        loadCases := loadCasesIn;
                    end;

            //nails
                procedure TSoilNailWallBase.addNail(const heightIn, lengthIn: double);
                    begin
                        nails.addNail(heightIn, lengthIn);
                    end;

                procedure TSoilNailWallBase.clearNailLayout();
                    begin
                        nails.clearNailLayout();
                    end;

                procedure TSoilNailWallBase.setNails(const nailsIn : TSoilNails);
                    begin
                        //geometry
                            setNailAngle(nailsIn.angle);
                            setNailHorizontalSpacing(nailsIn.horizontalSpacing);

                        //diameter
                            setGroutHoleDiameter(nailsIn.diameter.groutHole);
                            setNailSteelDiameter(nailsIn.diameter.steel);

                        //strength
                            nails.strength.groutSoilInterface.copyOther(nailsIn.strength.groutSoilInterface);
                            nails.strength.tensile.copyOther(nailsIn.strength.tensile);

                        //nail heights and lengths
                            nails.copyHeightsAndLengths(nailsIn);
                    end;

            //slip-wedge
                procedure TSoilNailWallBase.setSlipWedge(const slipWedgeIn : TSlipWedge);
                    begin
                        setSlipWedgeVisible(slipWedgeIn.visible);
                        setSlipWedgeAngle(slipWedgeIn.angle);
                        setSlipWedgeLength(slipWedgeIn.length);
                        setSlipWedgeWeight(slipWedgeIn.selfWeight);
                    end;

            //soil
                procedure TSoilNailWallBase.setSoil(const soilIn: TSoil);
                    begin
                        //material paramaters
                            soil.cohesion.copyOther( soilIn.cohesion );
                            soil.frictionAngle.copyOther( soilIn.frictionAngle );
                            soil.unitWeight.copyOther( soilIn.unitWeight );

                        //up-slope
                            setSoilSlopeAngle( soilIn.slope.angle );
                            setSoilSlopeMaxHeight( soilIn.slope.maxHeight );
                    end;

            //wall
                procedure TSoilNailWallBase.setWall(const wallIn : TWall);
                    begin
                        setWallAngle( wallIn.angle );
                        setWallHeight( wallIn.height );
                        setWallThickness( wallIn.thickness );

                        wall.concrete.strength.compressive.copyOther( wallIn.concrete.strength.compressive );
                        wall.concrete.strength.reinforcement.copyOther( wallIn.concrete.strength.reinforcement );
                    end;

        //copy other soil nail wall
            procedure TSoilNailWallBase.copySNW(const otherSoilNailWallIn : TSoilNailWallBase);
                begin
                    self.deepCopy( otherSoilNailWallIn );
                end;

        //generate soil nail layout
            procedure TSoilNailWallBase.generateSoilNailLayout(const    topSpaceIn,  verticalSpacingIn,
                                                                        topLengthIn, bottomLengthIn     : double);
                begin
                    nails.generateLayout(   topSpaceIn,  verticalSpacingIn,
                                            topLengthIn, bottomLengthIn,
                                            wall.height                     );
                end;

            procedure TSoilNailWallBase.getNailLayout(  out topSpaceOut,    verticalSpacingOut,
                                                            topLengthOut,   bottomLengthOut     : double);
                begin
                    nails.getNailLayout(wall.height,
                                        topSpaceOut,    verticalSpacingOut,
                                        topLengthOut,   bottomLengthOut     );
                end;

end.
