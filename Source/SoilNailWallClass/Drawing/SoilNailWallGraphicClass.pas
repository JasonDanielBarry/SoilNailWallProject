unit SoilNailWallGraphicClass;

interface

    uses
        //Delphi
            System.SysUtils, System.Math, system.Types, system.UITypes,
            System.Skia, Vcl.Skia,
        //custom
            GeometryTypes, GeomBox, GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
            SoilNailWallTypes, SoilNailWallGeometryClass,
            GraphicDrawerObjectAdderClass;

    type
        TSoilNailWallGraphic = class(TSoilNailWallGeometry)
            private
                //drawing methods
                    //nails
                        procedure drawNailGeometry( const nailColourIn      : TAlphaColor;
                                                    var arrNailGeomInOut    : TArray<TGeomLine>;
                                                    var canvasInOut         : ISkCanvas         );
                        procedure drawNails(var canvasInOut : ISkCanvas);
                        procedure drawAnchoredNails(var canvasInOut : ISkCanvas);
                    //slip wedge
                        procedure drawSlipWedge(var canvasInOut : ISkCanvas);
                        procedure drawSlipLine(var canvasInOut : ISkCanvas);
                    //soil
                        procedure drawSoil(var canvasInOut : ISkCanvas);
                    //wall
                        procedure drawWall(var canvasInOut : ISkCanvas);
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //drawing
                    procedure updateSoilNailWallGeomtry(
                                                        var canvasInOut                 : ISkCanvas );
        end;

implementation

    //private
        //drawing methods
            //nails
                procedure TSoilNailWallGraphic.drawNailGeometry(const nailColourIn      : TAlphaColor;
                                                                var arrNailGeomInOut    : TArray<TGeomLine>;
                                                                var canvasInOut         : ISkCanvas         );
                    procedure
                        _drawSingleNail(const lineThicknessIn   : integer;
                                        const colourIn          : TAlphaColor;
                                        const nailIn            : TGeomLine );
                            begin
                                if ( IsZero(nailIn.calculateLength(), 1e-6) ) then
                                    exit();

                                drawSkiaLine(   nailIn,
                                                colourIn,
                                                axisConverter,
                                                canvasInOut,
                                                False,
                                                lineThicknessIn       );
                            end;
                    procedure
                        _drawNails( const lineThicknessIn   : integer;
                                    const colourIn          : TAlphaColor);
                            var
                                i : integer;
                            begin
                                for i := 0 to (length(arrNailGeomInOut) - 1) do
                                    _drawSingleNail(
                                                        lineThicknessIn,
                                                        colourIn,
                                                        arrNailGeomInOut[i]
                                                   );
                            end;
                    begin
                        _drawNails(16,  nailColourIn);
                        _drawNails(4,   TAlphaColors.Black);

                        freeNailGeometry(arrNailGeomInOut);
                    end;

                procedure TSoilNailWallGraphic.drawNails(var canvasInOut : ISkCanvas);
                    var
                        arrNailGeom : TArray<TGeomLine>;
                    begin
                        arrNailGeom := determineNailGeometry();

                        drawNailGeometry(TAlphaColors.Grey, arrNailGeom, canvasInOut);
                    end;

                procedure TSoilNailWallGraphic.drawAnchoredNails(var canvasInOut : ISkCanvas);
                    var
                        arrAnchoredNailGeom : TArray<TGeomLine>;
                    begin
                        if ( NOT(getSlipWedge().visible) ) then
                            exit();

                        arrAnchoredNailGeom := determineAnchoredNailGeometry();

                        drawNailGeometry(TAlphaColors.Darkred, arrAnchoredNailGeom, canvasInOut);
                    end;

            //slip wedge
                procedure TSoilNailWallGraphic.drawSlipWedge(var canvasInOut : ISkCanvas);
                    begin
                        if (getSlipWedge().visible = False) then
                            exit();

                        drawSkiaPolygon(determineSlipWedgeGeometry(),
                                        TAlphaColors.Orangered,
                                        TAlphaColors.Black,
                                        axisConverter,
                                        canvasInOut                 );
                    end;

                procedure TSoilNailWallGraphic.drawSlipLine(var canvasInOut : ISkCanvas);
                    begin
                        if (getSlipWedge().visible = False) then
                            exit();

                        drawSkiaLine(   determineSlipLine(),
                                        TAlphaColors.Darkred,
                                        axisConverter,
                                        canvasInOut,
                                        True,
                                        5                       );
                    end;

            //soil
                procedure TSoilNailWallGraphic.drawSoil(var canvasInOut : ISkCanvas);
                    begin
                        drawSkiaPolygon(determineSoilGeometry(),
                                        TAlphaColors.Lightgreen,
                                        TAlphaColors.Black,
                                        axisConverter,
                                        canvasInOut             );
                    end;

            //wall
                procedure TSoilNailWallGraphic.drawWall(var canvasInOut : ISkCanvas);
                    begin
                        drawSkiaPolygon(determineWallGeometry(),
                                        TAlphaColors.Yellow,
                                        TAlphaColors.Black,
                                        axisConverter,
                                        canvasInOut             );
                    end;

    //public
        //constructor
            constructor TSoilNailWallGraphic.create();
                begin
                    inherited create();

                    axisConverter := TDrawingAxisConverter.create();
                end;

        //destructor
            destructor TSoilNailWallGraphic.destroy();
                begin
                    FreeAndNil(axisConverter);

                    inherited destroy();
                end;

        //drawing
            procedure TSoilNailWallGraphic.drawSoilNailWall(canvasHeightIn, canvasWidthIn   : integer;
                                                            var canvasInOut                 : ISkCanvas);
                begin
                    determineDrawingBoundaries(canvasHeightIn, canvasWidthIn);

                    //for now set a value of 50 to the wedge angle for testing
                        setSlipWedgeAngle(45);
                        setslipWedgevisible(False);

                    drawSoil(canvasInOut);

                    drawSlipWedge(canvasInOut);

                    drawNails(canvasInOut);
                    drawAnchoredNails(canvasInOut);

                    drawSlipLine(canvasInOut);

                    drawWall(canvasInOut);
                end;


end.
