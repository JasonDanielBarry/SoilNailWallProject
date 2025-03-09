unit SoilNailWallGraphicClass;

interface

    uses
        //Delphi
            System.SysUtils, System.Math, system.Types, system.UITypes,
            VCL.Graphics,
        //custom
            GeometryTypes, GeomBox, GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
            SoilNailWallTypes, SoilNailWallGeometryClass,
            GraphicDrawerObjectAdderClass;

    type
        TSoilNailWallGraphic = class(TSoilNailWallGeometry)
            private
                //drawing methods
                    //nails
                        procedure updateNailGeometry(   const nailColourIn      : TAlphaColor;
                                                        var arrNailGeomInOut    : TArray<TGeomLine>;
                                                        var graphicDrawerInOut  : TGraphicDrawerObjectAdder );
                        procedure updateNails(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                        procedure updateAnchoredNails(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    //slip wedge
                        procedure updateSlipWedge(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                        procedure updateSlipLine(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    //soil
                        procedure updateSoil(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    //wall
                        procedure updateWall(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //drawing
                    procedure updateSoilNailWallGeomtry(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
        end;

implementation

    //private
        //drawing methods
            //nails
                procedure TSoilNailWallGraphic.updateNailGeometry(  const nailColourIn      : TAlphaColor;
                                                                    var arrNailGeomInOut    : TArray<TGeomLine>;
                                                                    var graphicDrawerInOut  : TGraphicDrawerObjectAdder );
                    var
                        i, nailCount : integer;
                    begin
                        nailCount := length( arrNailGeomInOut );

                        for i := 0 to (nailCount - 1) do
                            begin
                                graphicDrawerInOut.addLine( arrNailGeomInOut[i], 16, nailColourIn );

                                graphicDrawerInOut.addLine( arrNailGeomInOut[i], 4 );
                            end;

                        freeNailGeometry(arrNailGeomInOut);
                    end;

                procedure TSoilNailWallGraphic.updateNails(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        arrNailGeom : TArray<TGeomLine>;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer('Nails');

                        arrNailGeom := determineNailGeometry();

                        updateNailGeometry( TColors.Grey, arrNailGeom, graphicDrawerInOut );
                    end;

                procedure TSoilNailWallGraphic.updateAnchoredNails(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        arrAnchoredNailGeom : TArray<TGeomLine>;
                    begin
                        if ( NOT(getSlipWedge().visible) ) then
                            exit();

                        graphicDrawerInOut.setCurrentDrawingLayer('Anchored Length');

                        arrAnchoredNailGeom := determineAnchoredNailGeometry();

                        updateNailGeometry( TColors.Darkred, arrAnchoredNailGeom, graphicDrawerInOut );
                    end;

            //slip wedge
                procedure TSoilNailWallGraphic.updateSlipWedge(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        slipWedgePolygon : TGeomPolygon;
                    begin
                        if (getSlipWedge().visible = False) then
                            exit();

                        graphicDrawerInOut.setCurrentDrawingLayer('Slip Wedge');

                        slipWedgePolygon := determineSlipWedgeGeometry();

                        graphicDrawerInOut.addPolygon(  slipWedgePolygon,
                                                        True,
                                                        2,
                                                        TColors.Orangered  );

                        FreeAndNil( slipWedgePolygon );
                    end;

                procedure TSoilNailWallGraphic.updateSlipLine(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        slipLine : TGeomLine;
                    begin
                        if (getSlipWedge().visible = False) then
                            exit();

                        slipLine := determineSlipLine();

                        graphicDrawerInOut.setCurrentDrawingLayer('Slip Wedge');

                        graphicDrawerInOut.addLine( slipLine,
                                                    5,
                                                    TColors.Darkred );

                        FreeAndNil( slipLine );
                    end;

            //soil
                procedure TSoilNailWallGraphic.updateSoil(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        soilPolygon : TGeomPolygon;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer('Soil');

                        soilPolygon := determineSoilGeometry();

                        graphicDrawerInOut.addPolygon(  soilPolygon,
                                                        True,
                                                        2,
                                                        TColors.Lightgreen
                                                        );

                        FreeAndNil( soilPolygon );
                    end;

            //wall
                procedure TSoilNailWallGraphic.updateWall(var graphicDrawerInOut : TGraphicDrawerObjectAdder);
                    var
                        wallPolygon : TGeomPolygon;
                    begin
                        graphicDrawerInOut.setCurrentDrawingLayer('Wall');

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
                end;

        //destructor
            destructor TSoilNailWallGraphic.destroy();
                begin
                    inherited destroy();
                end;

        //drawing
            procedure TSoilNailWallGraphic.updateSoilNailWallGeomtry(var graphicDrawerInOut: TGraphicDrawerObjectAdder);
                begin
                    //for now set a value of 50 to the wedge angle for testing
                        setSlipWedgeAngle(45);
                        setslipWedgevisible(False);

                    updateSoil( graphicDrawerInOut );

                    updateSlipWedge( graphicDrawerInOut );

                    updateNails( graphicDrawerInOut );
                    updateAnchoredNails( graphicDrawerInOut );

                    updateSlipLine( graphicDrawerInOut );

                    updateWall( graphicDrawerInOut );
                end;

        //drawing
//            procedure TSoilNailWallGraphic.drawSoilNailWall(canvasHeightIn, canvasWidthIn   : integer;
//                                                            var canvasInOut                 : ISkCanvas);
//                begin
//                    //for now set a value of 50 to the wedge angle for testing
//                        setSlipWedgeAngle(45);
//                        setslipWedgevisible(False);
//
//                    updateSoil(canvasInOut);
//
//                    updateSlipWedge(canvasInOut);
//
//                    updateNails(canvasInOut);
//                    updateAnchoredNails(canvasInOut);
//
//                    updateSlipLine(canvasInOut);
//
//                    updateWall(canvasInOut);
//                end;


end.
