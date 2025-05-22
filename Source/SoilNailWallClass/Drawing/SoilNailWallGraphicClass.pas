unit SoilNailWallGraphicClass;

interface

    uses
        //Delphi
            System.SysUtils, System.Math, system.Types, system.UITypes,
            VCL.Graphics,
        //custom
            GeometryTypes, GeomBox, GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
            SoilNailWallTypes, LoadCaseTypes,
            SoilNailWallAnalysisClass,
            Graphic2DListClass,
            GraphicDrawingTypes;

    type
        TSoilNailWallGraphic = class(TSoilNailWallAnalysis)
            private
                var
                    loadsVisible, slipWedgeVisible : boolean;
                //drawing methods
                    //load cases
                        procedure updateLoadCase(var graphicDrawerInOut : TGraphic2DList);
                    //nails
                        procedure updateNailGeometry(   const nailColourIn      : TAlphaColor;
                                                        var arrNailGeomInOut    : TArray<TGeomLine>;
                                                        var graphicDrawerInOut  : TGraphic2DList );
                        procedure updateNails(var graphicDrawerInOut : TGraphic2DList);
                        procedure updateAnchoredNails(var graphicDrawerInOut : TGraphic2DList);
                    //slip wedge
                        procedure updateSlipWedge(var graphicDrawerInOut : TGraphic2DList);
                        procedure updateSlipLine(var graphicDrawerInOut : TGraphic2DList);
                    //soil
                        procedure updateSoil(var graphicDrawerInOut : TGraphic2DList);
                    //wall
                        procedure updateWall(var graphicDrawerInOut : TGraphic2DList);
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //copy other soil nail wall
                    procedure copySNW(const otherSoilNailWallIn : TSoilNailWallGraphic);
                //set optional graphics visibility
                    procedure setLoadsVisible(const visibleIn : boolean);
                    procedure setSlipWedgeVisible(const visibleIn : boolean);
                //drawing
                    procedure updateSoilNailWallGeomtry(var graphicDrawerInOut : TGraphic2DList);
        end;

implementation

    const
        ANCHORED_LENGTH_LAYER   : string = 'Anchored Length';
        LOAD_LAYER              : string = 'Load';
        NAIL_LAYER              : string = 'Nails';
        SLIP_WEDGE_LAYER        : string = 'Slip Wedge';
        SOIL_LAYER              : string = 'Soil';
        WALL_LAYER              : string = 'Wall';

    //private
        //drawing methods
            //load cases
                procedure TSoilNailWallGraphic.updateLoadCase(var graphicDrawerInOut : TGraphic2DList);
                    var
                        load,
                        textCentreX     : double;
                        loadCaseText    : string;
                        activeLoadCase  : TLoadCase;
                        loadCaseMap     : TLoadCaseMap;
                        loadLine        : TGeomPolyLine;
                    begin
                        if NOT( loadsVisible ) then
                            exit();

                        //get the active factored load
                            loadCaseMap := getLoadCases();

                            activeLoadCase := loadCaseMap.getActiveLoadCase();

                            load := activeLoadCase.calculateFactoredLoad();

                            if ( IsZero( load, 1e-3 ) ) then
                                exit();

                        //draw the load case
                            graphicDrawerInOut.setCurrentDrawingLayer( LOAD_LAYER );

                            loadLine := determineSoilSurface();

                            loadLine.shift( 0, 0.2 );

                            graphicDrawerInOut.addArrowGroup( 2, loadLine, EArrowOrigin.aoHead, EArrowGroupDirection.agdDown, 0, True, 2, clSilver, clSilver );

                        //load case text
                            loadCaseText :=     'Load Case: ' + activeLoadCase.LCName
                                            +   ', Resultant = ' + FloatToStrF( load, ffFixed, 5, 2 ) + ' kN/m';

                            textCentreX := loadLine.getArrGeomPoints()[0].x;

                            graphicDrawerInOut.addText( textCentreX, loadLine.getArrGeomPoints()[0].y + 3, loadCaseText, False, 10 );

                        FreeAndNil( loadLine );
                    end;

            //nails
                procedure TSoilNailWallGraphic.updateNailGeometry(  const nailColourIn      : TAlphaColor;
                                                                    var arrNailGeomInOut    : TArray<TGeomLine>;
                                                                    var graphicDrawerInOut  : TGraphic2DList );
                    var
                        i, nailCount : integer;
                    begin
                        nailCount := length( arrNailGeomInOut );

                        for i := 0 to (nailCount - 1) do
                            begin
                                graphicDrawerInOut.addLine( arrNailGeomInOut[i], 16, nailColourIn );

                                graphicDrawerInOut.addLine( arrNailGeomInOut[i], 4 );
                            end;

                        freeNailGeometry( arrNailGeomInOut );
                    end;

                procedure TSoilNailWallGraphic.updateNails(var graphicDrawerInOut : TGraphic2DList);
                    var
                        arrNailGeom : TArray<TGeomLine>;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer( NAIL_LAYER );

                        arrNailGeom := determineNailGeometry();

                        updateNailGeometry( TColors.Grey, arrNailGeom, graphicDrawerInOut );
                    end;

                procedure TSoilNailWallGraphic.updateAnchoredNails(var graphicDrawerInOut : TGraphic2DList);
                    var
                        arrAnchoredNailGeom : TArray<TGeomLine>;
                    begin
                        if NOT( slipWedgeVisible ) then
                            exit();

                        graphicDrawerInOut.setCurrentDrawingLayer( ANCHORED_LENGTH_LAYER );

                        arrAnchoredNailGeom := determineAnchoredNailGeometry();

                        updateNailGeometry( TColors.Darkred, arrAnchoredNailGeom, graphicDrawerInOut );
                    end;

            //slip wedge
                procedure TSoilNailWallGraphic.updateSlipWedge(var graphicDrawerInOut : TGraphic2DList);
                    var
                        slipWedgePolygon : TGeomPolygon;
                    begin
                        if NOT( slipWedgeVisible ) then
                            exit();

                        graphicDrawerInOut.setCurrentDrawingLayer( SLIP_WEDGE_LAYER );

                        slipWedgePolygon := determineSlipWedgeGeometry();

                        graphicDrawerInOut.addPolygon(  slipWedgePolygon,
                                                        True,
                                                        2,
                                                        TColors.Orangered  );

                        FreeAndNil( slipWedgePolygon );
                    end;

                procedure TSoilNailWallGraphic.updateSlipLine(var graphicDrawerInOut : TGraphic2DList);
                    var
                        slipLine : TGeomLine;
                    begin
                        if NOT( slipWedgeVisible ) then
                            exit();

                        slipLine := determineSlipLine();

                        graphicDrawerInOut.setCurrentDrawingLayer( SLIP_WEDGE_LAYER );

                        graphicDrawerInOut.addLine( slipLine,
                                                    5,
                                                    TColors.Darkred );

                        FreeAndNil( slipLine );
                    end;

            //soil
                procedure TSoilNailWallGraphic.updateSoil(var graphicDrawerInOut : TGraphic2DList);
                    var
                        soilPolygon : TGeomPolygon;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer( SOIL_LAYER );

                        soilPolygon := determineSoilGeometry();

                        graphicDrawerInOut.addPolygon(  soilPolygon,
                                                        True,
                                                        2,
                                                        TColors.Lightgreen
                                                        );

                        FreeAndNil( soilPolygon );
                    end;

            //wall
                procedure TSoilNailWallGraphic.updateWall(var graphicDrawerInOut : TGraphic2DList);
                    var
                        wallPolygon : TGeomPolygon;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer( WALL_LAYER );

                        wallPolygon := determineWallGeometry();

                        graphicDrawerInOut.addPolygon( wallPolygon,
                                                       True,
                                                       2,
                                                       TColors.Yellow );

                        FreeAndNil( wallPolygon );
                    end;

    //public
        //constructor
            constructor TSoilNailWallGraphic.create();
                begin
                    inherited create();

                    loadsVisible        := False;
                    slipWedgeVisible    := False;
                end;

        //destructor
            destructor TSoilNailWallGraphic.destroy();
                begin
                    inherited destroy();
                end;

        //copy other soil nail wall
            procedure TSoilNailWallGraphic.copySNW(const otherSoilNailWallIn : TSoilNailWallGraphic);
                begin
                    inherited copySNW( otherSoilNailWallIn );

                    self.loadsVisible       := otherSoilNailWallIn.loadsVisible;
                    self.slipWedgeVisible   := otherSoilNailWallIn.slipWedgeVisible;
                end;

        //set optional graphics visibility
            procedure TSoilNailWallGraphic.setLoadsVisible(const visibleIn : boolean);
                begin
                    loadsVisible := visibleIn;
                end;

            procedure TSoilNailWallGraphic.setSlipWedgeVisible(const visibleIn : boolean);
                begin
                    slipWedgeVisible := visibleIn;
                end;

        //drawing
            procedure TSoilNailWallGraphic.updateSoilNailWallGeomtry(var graphicDrawerInOut: TGraphic2DList);
                begin
                    //for now set a value to the wedge angle for testing
                        setSlipWedgeAngle(35);
//                        setslipWedgevisible(True);

                    updateSoil( graphicDrawerInOut );

                    updateSlipWedge( graphicDrawerInOut );

                    updateNails( graphicDrawerInOut );
                    updateAnchoredNails( graphicDrawerInOut );

                    updateSlipLine( graphicDrawerInOut );

                    updateWall( graphicDrawerInOut );

                    updateLoadCase( graphicDrawerInOut );
                end;

end.
