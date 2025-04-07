unit SoilNailWallGeometryClass;

interface

    uses
        //Delphi
            System.SysUtils, System.Math,
        //custom
            InterpolatorClass,
            GeometryTypes, GeomBox, GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
            SoilNailWallTypes,
            SoilNailWallBaseClass;

    type
        TSoilNailWallGeometry = class(TSoilNailWallBase)
            private
                //helper methods
                    //nails
                        //lowest nail end point height
                            function lowestNailEndPointHeight() : double;
                    //slip wedge
                        //helper methods
                            //check if angle usable
                                function usableSlipWedgeAngle() : boolean;
                            //slip wedge slope-to-flat angle
                                function slipWedgeSlopeToFlatAngle() : double;
                        //boundaries
                            //right
                                function slipWedgeRightBoundary() : double;
                        //top right point
                            function slipWedgeTopRightPoint() : TGeomPoint;
                    //soil
                        //soil boundaries
                            //left
                                function soilLeftBoundary() : double;
                            //right
                                function soilRightBoundary() : double;
                            //top
                                function soilTopBoundary() : double;
                            //bottom
                                function soilBottomBoundary() : double;
                        //slope-to-flat point
                            //exact slope-to-flat point
                                function determineSlopeToFlatPoint() : TGeomPoint;
                            //max length point - find the slope end point if the soil nail length is the criterion
                                function determineMaxLengthSlopeEndPoint() : TGeomPoint;
                            //slope end-point - use the max heigth and length points to find where the angled slope ends
                                function determineSlopeEndPoint() : TGeomPoint;
                        //soil bottom left point
                            function determineSoilBottomLeftPoint() : TGeomPoint;
                        //soil top right point
                            function determineSoilTopRightPoint() : TGeomPoint;
                        //soil slope line
                            function determineSlopeLine() : TGeomLine;
                    //wall
                        //top right point
                            function wallTopRightPoint() : TGeomPoint;
            protected
                //boundary
                    function SNWboundingBox() : TGeomBox;
                //nails
                    function determineNailGeometry() : TArray<TGeomLine>;
                    function determineAnchoredNailGeometry : Tarray<TGeomLine>;
                    procedure freeNailGeometry(var arrNailGeomIn : Tarray<TGeomLine>);
                //slip wedge
                    function determineSlipLine() : TGeomLine;
                    function determineSlipWedgeGeometry() : TGeomPolygon;
                    function calculateSlipWedgeWeight() : double;
                    function calculateSlipWedgeLength() : double;
                    function getSlipWedge(const updateSlipWedgeIn : boolean = False) : TSlipWedge; override;
                //soil
                    function determineSoilGeometry() : TGeomPolygon;
                //wall
                    function determineWallGeometry() : TGeomPolygon;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //helper methods
            //nails
                //lowest nail end point height
                    function TSoilNailWallGeometry.lowestNailEndPointHeight() : double;
                        var
                            lowestNailIndex                     : integer;
                            lowestNailLength,lowestNailHeight,
                            endPointHeightOut                   : double;
                            nails                               : TSoilNails;
                        begin
                            lowestNailIndex := getNails().nailCount();

                            if (lowestNailIndex = 0) then
                                begin
                                    result := 0;
                                    exit;
                                end;

                            nails := getNails();

                            lowestNailLength := nails.getArrLengths()[lowestNailIndex - 1];
                            lowestNailHeight := nails.getArrHeight()[lowestNailIndex - 1];

                            endPointHeightOut := lowestNailHeight - lowestNailLength * sin( DegToRad(nails.angle) );

                            result := endPointHeightOut - 2;
                        end;

            //slip wedge
                //helper methods
                    //check if angle usable
                        function TSoilNailWallGeometry.usableSlipWedgeAngle() : boolean;
                            begin
                                result := ( (5 <= getSlipWedge().angle) AND (getSlipWedge().angle <= 85) );
                            end;

                    //slip wedge slope-to-flat angle
                        function TSoilNailWallGeometry.slipWedgeSlopeToFlatAngle() : double;
                            var
                                x, y                : double;
                                slopeToFlatPoint    : TGeomPoint;
                            begin
                                slopeToFlatPoint := determineSlopeToFlatPoint();

                                x := slopeToFlatPoint.x;
                                y := slopeToFlatPoint.y;

                                //tan(A) = Yc / Xc
                                //A = atan(Yc / Xc);
                                    result := RadToDeg(ArcTan(y / x));
                            end;

                //boundaries
                    //right
                        function TSoilNailWallGeometry.slipWedgeRightBoundary() : double;
                            var
                                x, y        : double;
                                soil        : TSoil;
                                slipWedge   : TSlipWedge;
                            begin
                                if ( usableSlipWedgeAngle() ) then
                                    begin
                                        soil        := getSoil();
                                        slipWedge   := getSlipWedge();

                                        //calculate the x distance based on the max height of the slope
                                            y := soil.slope.maxHeight;

                                            x := y / tan(DegToRad(slipWedge.angle));
                                    end
                                else
                                    x := 0;

                                result := x;
                            end;

                        function TSoilNailWallGeometry.slipWedgeTopRightPoint() : TGeomPoint;
                            var

                                topRightPointOut            : TGeomPoint;
                                slipTestLine, soilSlopeLine : TGeomLine;
                            function
                                _determineSlipTestLine() : TGeomLine;
                                    var
                                        x, y : double;
                                    begin
                                        x := slipWedgeRightBoundary();
                                        y := getSoil().slope.maxHeight;

                                        result := TGeomLine.create(
                                                                        TGeomPoint.create(0, 0),
                                                                        TGeomPoint.create(x, y)
                                                                  );
                                    end;
                            begin
                                //check that the slip wedge angle is valid
                                    if ( NOT(usableSlipWedgeAngle()) ) then
                                        exit( TGeomPoint.create(0, 0) );

                                //if the slip wedge right boundary is less than the slope-to-flat point x-ordinate then
                                //find the intersection between the slip-test-line and the slope-line
                                //otherwise the slip wedge top right point lies on the flat part of the soil

                                    if ( determineSlopeToFlatPoint().x < slipWedgeRightBoundary() ) then
                                        exit( TGeomPoint.create( slipWedgeRightBoundary(), getSoil().slope.maxHeight ) );

                                    soilSlopeLine   := determineSlopeLine();
                                    slipTestLine    := _determineSlipTestLine();

                                    topRightPointOut := TGeomLine.calculateLineIntersection( soilSlopeLine, slipTestLine, True ).point;

                                result := topRightPointOut;
                            end;

            //soil
                //soil boundary
                    //left
                        function TSoilNailWallGeometry.soilLeftBoundary() : double;
                            var
                                wall : TWall;
                            begin
                                wall := getWall();

                                result := min(
                                                -(wall.thickness + wall.height / 10),
                                                -2
                                             );
                            end;

                    //right
                        function TSoilNailWallGeometry.soilRightBoundary() : double;
                            var
                                nailLengthCriterion,
                                slipWedgeAngleLengthCriterion,
                                wallHeightLengthCriterion       : double;
                            begin
                                //test different scenarios to see which one must be used to determine the soil right boundary

                                //rigth boundary scenarios
                                    //nail length
                                        nailLengthCriterion := wallTopRightPoint().x + (1.15 * getNails().longestNailLength());

                                    //slip wedge
                                        slipWedgeAngleLengthCriterion := slipWedgeRightBoundary() + 2.5;

                                    //wall height
                                        wallHeightLengthCriterion := wallTopRightPoint().x + getWall().height;

                                result := MaxValue([
                                                        nailLengthCriterion,
                                                        slipWedgeAngleLengthCriterion,
                                                        wallHeightLengthCriterion
                                                  ]);
                            end;

                    //top
                        function TSoilNailWallGeometry.soilTopBoundary() : double;
                            begin
                                result := determineSoilTopRightPoint().y;
                            end;

                    //bottom
                        function TSoilNailWallGeometry.soilBottomBoundary() : double;
                            begin
                                result := min(
                                                soilLeftBoundary(),
                                                lowestNailEndPointHeight()
                                             );
                            end;

                //slope-to-flat point
                    //exact slope-to-flat point
                        function TSoilNailWallGeometry.determineSlopeToFlatPoint() : TGeomPoint;
                            var
                                dx, dy  : double;
                                soil    : TSoil;
                                wall    : TWall;
                            begin
                                soil := getSoil();
                                wall := getwall();

                                //find (x, y) using the max slope height as the criterion
                                    dy := soil.slope.maxHeight - wall.height;

                                    //a dy value of zero results in x = 0
                                        if ( (1e-3 < dy) AND (1e-3 < soil.slope.angle) ) then
                                            dx := dy / (tan(DegToRad(soil.slope.angle)))
                                        else
                                            dx := soilRightBoundary();

                                result := TGeomPoint.create(dx, wall.height + dy);
                            end;

                    //max length point
                        function TSoilNailWallGeometry.determineMaxLengthSlopeEndPoint() : TGeomPoint;
                            var
                                x, y : double;
                            begin
                                //find (x, y) using the soil right boundary as criterion
                                    x := soilRightBoundary();

                                    y := getWall().height + x * tan(DegToRad(getSoil().slope.angle));

                                result := TGeomPoint.create(x, y);
                            end;

                    //slope end point
                        function TSoilNailWallGeometry.determineSlopeEndPoint() : TGeomPoint;
                            var
                                maxHeightPoint, maxLengthPoint : TGeomPoint;
                            begin
                                maxHeightPoint := determineSlopeToFlatPoint();
                                maxLengthPoint := determineMaxLengthSlopeEndPoint();

                                //the slope end point is where the soil turns from slope to flat
                                    //[1] if the slope rises above the max height by the end then return the point where the change from slope to flat occurs
                                    //[2] if the slope does not rise to the max heigth there is only slope until the top right

                                //choose which point to return
                                    if (maxHeightPoint.y < maxLengthPoint.y) then
                                        result := maxHeightPoint //[1]
                                    else
                                        result := maxLengthPoint;//[2]
                            end;

                //soil bottom left point
                    function TSoilNailWallGeometry.determineSoilBottomLeftPoint() : TGeomPoint;
                        begin
                            result := TGeomPoint.create(
                                                            soilLeftBoundary(),
                                                            soilBottomBoundary()
                                                        );
                        end;

                //soil top right point
                    function TSoilNailWallGeometry.determineSoilTopRightPoint() : TGeomPoint;
                        var
                            x, y : double;
                            soil : TSoil;
                            wall : TWall;
                        begin
                            soil := getSoil();
                            wall := getWall();

                            x := soilRightBoundary();

                            //calculate y at the soil right boundary
                                y := wall.height + (x * tan(DegToRad(soil.slope.angle)));

                            //y is the min between the max slope height and the calculated y-value
                                y := min(soil.slope.maxHeight, y);

                            result := TGeomPoint.create(x, y);
                        end;

                //soil slope line
                    function TSoilNailWallGeometry.determineSlopeLine() : TGeomLine;
                        begin
                            result := TGeomLine.create(
                                                            wallTopRightPoint(),
                                                            determineSlopeToFlatPoint()
                                                      );
                        end;

            //wall
                //top right point
                    function TSoilNailWallGeometry.wallTopRightPoint() : TGeomPoint;
                        var
                            wall : TWall;
                        begin
                            wall := getWall();

                            result := TGeomPoint.create(
                                                            wall.height * sin(DegToRad(wall.angle)),
                                                            wall.height
                                                       );
                        end;

    //protected
        //boundary
            function TSoilNailWallGeometry.SNWboundingBox() : TGeomBox;
                var
                    boxOut : TGeomBox;
                begin
                    boxOut.minPoint     := determineSoilBottomLeftPoint();
                    boxOut.minPoint.z   := 0;

                    boxOut.maxPoint     := determineSoilTopRightPoint();
                    boxOut.maxPoint.z   := 0;

                    result := boxOut;
                end;

        //nails
            function TSoilNailWallGeometry.determineNailGeometry() : TArray<TGeomLine>;
                var
                    i                       : integer;
                    nailX, nailY            : double;
                    startPoint, endPoint    : TGeomPoint;
                    arrLinesOut             : TArray<TGeomLine>;
                    interpolator            : TInterpolator;
                    nails                   : TSoilNails;
                    wall                    : TWall;
                begin
                    nails   := getNails();
                    wall    := getWall();

                    setlength(arrLinesOut, nails.nailCount());

                    interpolator := TInterpolator.create(0, wall.height, 0, wallTopRightPoint().x);

                    for i := 0 to (nails.nailCount() - 1) do
                        begin
                            //nailX and nailY define where the nail line intersects the back of the wall
                                nailX := interpolator.interpolateX(nails.getArrHeight()[i]);
                                nailY := nails.getArrHeight()[i];

                            startPoint := TGeomPoint.create(
                                                                nailX - wall.thickness / 2,
                                                                nailY + wall.thickness * sin(DegToRad(wall.angle))
                                                           );

                            endPoint := TGeomPoint.create(
                                                            startPoint.x + nails.getArrLengths()[i] * cos(DegToRad(nails.angle)),
                                                            startPoint.y - nails.getArrLengths()[i] * sin(DegToRad(nails.angle))
                                                         );

                            arrLinesOut[i] := TGeomLine.create( startPoint, endPoint );
                        end;

                    result := arrLinesOut;
                end;

            function TSoilNailWallGeometry.determineAnchoredNailGeometry : Tarray<TGeomLine>;
                var
                    nailBeyondSlipLine  : boolean;
                    anchoredNails, i    : integer;
                    intersectionPoint,
                    nailEndPoint        : TGeomPoint;
                    slipLine            : TGeomLine;
                    arrNailGeometry,
                    arrAnchoredNailGeom : Tarray<TGeomLine>;
                begin
                    //get the slip line
                        slipLine := determineSlipLine();

                    //loop through the nails
                        anchoredNails := 0;

                        arrNailGeometry := determineNailGeometry();

                        for i := 0 to (length(arrNailGeometry) - 1) do
                            begin
                                //find the intersection of the nail and the slip line
                                    intersectionPoint   := slipLine.calculateLineIntersection(arrNailGeometry[i], True).point;
                                    nailEndPoint        := arrNailGeometry[i].getEndPoint();

                                //create a line representing nail anchored section
                                    nailBeyondSlipLine := ( intersectionPoint.x < nailEndPoint.x );

                                    if NOT(nailBeyondSlipLine) then
                                        continue;

                                    inc(anchoredNails);

                                    SetLength(arrAnchoredNailGeom, anchoredNails);

                                    arrAnchoredNailGeom[anchoredNails - 1] := TGeomLine.create(intersectionPoint, nailEndPoint);
                            end;

                    //free nail geometry memory
                        freeNailGeometry(arrNailGeometry);

                    result := arrAnchoredNailGeom;
                end;

            procedure TSoilNailWallGeometry.freeNailGeometry(var arrNailGeomIn : Tarray<TGeomLine>);
                var
                    i : integer;
                begin
                    for i := 0 to (length(arrNailGeomIn) - 1) do
                        FreeAndNil(arrNailGeomIn[i]);
                end;

        //slip wedge
            function TSoilNailWallGeometry.determineSlipLine() : TGeomLine;
                var
                    startPoint, endPoint : TGeomPoint;
                begin
                    startPoint  := TGeomPoint.create(0, 0);
                    endPoint    := slipWedgeTopRightPoint();

                    result := TGeomLine.create(startPoint, endPoint);
                end;

            function TSoilNailWallGeometry.determineSlipWedgeGeometry() : TGeomPolygon;
                var
                    slipWedgeTopRight, slopToFlatPoint  : TGeomPoint;
                    slipWedgeGeometry                   : TGeomPolygon;
                begin
                    slipWedgeTopRight   := slipWedgeTopRightPoint();
                    slopToFlatPoint     := determineSlopeToFlatPoint();
                    slipWedgeGeometry   := TGeomPolygon.create();

                    //add points
                        //origin
                            slipWedgeGeometry.addVertex(0, 0);
                        //top right
                            slipWedgeGeometry.addVertex(slipWedgeTopRight);
                        //slope-to-flat point
                            if (slopToFlatPoint.x < slipWedgeTopRight.x) then
                                slipWedgeGeometry.addVertex(slopToFlatPoint);
                        //wall top
                            slipWedgeGeometry.addVertex(wallTopRightPoint());

                    result := slipWedgeGeometry;
                end;

            function TSoilNailWallGeometry.calculateSlipWedgeWeight() : double;
                var
                    wedgeWeightOut      : double;
                    slipWedgeGeometry   : TGeomPolygon;
                begin
                    slipWedgeGeometry := determineSlipWedgeGeometry();

                    wedgeWeightOut := slipWedgeGeometry.calculatePolygonArea() * getSoil().unitWeight.designValue();

                    setslipWedgeWeight( wedgeWeightOut );

                    FreeAndNil( slipWedgeGeometry );

                    result := wedgeWeightOut;
                end;

            function TSoilNailWallGeometry.calculateSlipWedgeLength() : double;
                var
                    lineLengthOut   : double;
                    slipLine        : TGeomLine;
                begin
                    //slip length
                        slipLine        := determineSlipLine();
                        lineLengthOut   := slipline.calculateLength();
                        setSlipWedgeLength( lineLengthOut );
                        FreeAndNil( slipLine );

                    result := lineLengthOut;
                end;

            function TSoilNailWallGeometry.getSlipWedge(const updateSlipWedgeIn : boolean = False) : TSlipWedge;
                begin
                    if ( updateSlipWedgeIn ) then
                        begin
                            calculateSlipWedgeWeight();
                            calculateSlipWedgeLength();
                        end;

                    result := inherited getSlipWedge();
                end;

        //soil
            function TSoilNailWallGeometry.determineSoilGeometry() : TGeomPolygon;
                var
                    soilGeometry : TGeomPolygon;
                begin
                    soilGeometry := TGeomPolygon.create();

                    //add points
                        soilGeometry.addVertex( 0, 0 );                                         //wall bottom
                        soilGeometry.addVertex( soilLeftBoundary(),  0                      );  //soil left ground level
                        soilGeometry.addVertex( determineSoilBottomLeftPoint()              );  //soil bottom left
                        soilGeometry.addVertex( soilRightBoundary(), soilBottomBoundary()   );  //soil bottom right
                        soilGeometry.addVertex( determineSoilTopRightPoint()                );  //soil top right
                        soilGeometry.addVertex( determineSlopeEndPoint()                    );  //slope end
                        soilGeometry.addVertex( wallTopRightPoint()                         );  //wall top

                    result := soilGeometry;
                end;

        //wall
            function TSoilNailWallGeometry.determineWallGeometry() : TGeomPolygon;
                var
                    topLeft,    topRight,
                    bottomLeft, bottomRight,
                    point                   : TGeomPoint;
                    wallGeometry            : TGeomPolygon;
                    wall                    : TWall;
                begin
                    wall := getWall();

                    //the origin of the SNW geometry is the bottom right corner of the wall
                        bottomRight := TGeomPoint.create(0                          , 0         );
                        topRight    := wallTopRightPoint();
                        topLeft     := TGeomPoint.create(topRight.x - wall.thickness, topRight.y);
                        bottomLeft  := TGeomPoint.create(-wall.thickness            , 0         );

                    wallGeometry := TGeomPolygon.create();

                    for point in [bottomRight, topRight, topLeft, bottomLeft] do
                        wallGeometry.addVertex(point);

                    result := wallGeometry;
                end;

    //public
        //constructor
            constructor TSoilNailWallGeometry.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TSoilNailWallGeometry.destroy();
                begin
                    inherited destroy();
                end;

end.
