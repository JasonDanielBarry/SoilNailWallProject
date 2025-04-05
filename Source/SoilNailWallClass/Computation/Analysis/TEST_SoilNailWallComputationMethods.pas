unit TEST_SoilNailWallComputationMethods;

interface

    uses
        DUnitX.TestFramework,
        SoilNailWallComputationMethods;

    type
        [TestFixture]
        TTestSoilNailWallComputationMethods = class
        public
            //tension
                [TestCase('Nail Group Tension 1', '500, 45, 15.0, 2.5, 25.0, 10, 100, 1.00, 197.71423')]
                [TestCase('Nail Group Tension 2', '750, 50, 20.0, 5.0, 30.0,  5, 250, 1.25, 464.82122')]
                [TestCase('Nail Group Tension 3', '450, 55, 17.5, 3.0, 22.5, 15, 150, 1.50, 741.44863')]
                procedure testCalculateNailGroupTension(const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                                slipWedgeLengthIn, soilCohesionIn,
                                                                soilFrictionAngleIn, nailAngleIn,
                                                                appliedLoadIn, safetyFactorIn,
                                                                expectedValueIn                     : double);
            //safety factor
                [TestCase('Nail Group Tension 1', '500, 45, 20.0, 5.0, 30.0,  5, 500, 250, 1.78892')]
                [TestCase('Nail Group Tension 2', '750, 50, 25.0, 2.5, 25.0, 10, 250, 100, 0.83429')]
                [TestCase('Nail Group Tension 3', '450, 55, 27.5, 3.5, 27.5, 15, 425, 150, 1.27908')]
                procedure testCalculateNailGroupSafetyFactor(const  slipWedgeWeightIn, slipWedgeAngleIn,
                                                                    slipWedgeLengthIn, soilCohesionIn,
                                                                    soilFrictionAngleIn, nailAngleIn,
                                                                    nailGroupTensionIn, appliedLoadIn,
                                                                    expectedValueIn                     : double);


    end;

implementation

    procedure TTestSoilNailWallComputationMethods.testCalculateNailGroupTension(const   slipWedgeWeightIn, slipWedgeAngleIn,
                                                                                        slipWedgeLengthIn, soilCohesionIn,
                                                                                        soilFrictionAngleIn, nailAngleIn,
                                                                                        appliedLoadIn, safetyFactorIn,
                                                                                        expectedValueIn                     : double);
        var
            calculatedValue : double;
        begin
            calculatedValue := calculateNailGroupTension(   slipWedgeWeightIn, slipWedgeAngleIn,
                                                            slipWedgeLengthIn, soilCohesionIn,
                                                            soilFrictionAngleIn, nailAngleIn,
                                                            appliedLoadIn, safetyFactorIn           );

            Assert.AreEqual( calculatedValue, expectedValueIn, 1e-3 );
        end;

    procedure TTestSoilNailWallComputationMethods.testCalculateNailGroupSafetyFactor(const  slipWedgeWeightIn, slipWedgeAngleIn,
                                                                                            slipWedgeLengthIn, soilCohesionIn,
                                                                                            soilFrictionAngleIn, nailAngleIn,
                                                                                            nailGroupTensionIn, appliedLoadIn,
                                                                                            expectedValueIn                     : double);
        var
            calculatedValue : double;
        begin
            calculatedValue := calculateNailGroupSafetyFactor(  slipWedgeWeightIn, slipWedgeAngleIn,
                                                                slipWedgeLengthIn, soilCohesionIn,
                                                                soilFrictionAngleIn, nailAngleIn,
                                                                nailGroupTensionIn, appliedLoadIn   );

            Assert.AreEqual( calculatedValue, expectedValueIn, 1e-3 );
        end;

initialization

  TDUnitX.RegisterTestFixture( TTestSoilNailWallComputationMethods );

end.
