unit SoilNailWallMasterClass;

interface

    uses
        SoilNailWallGraphicClass;

    type
        TSoilNailWall = class(TSoilNailWallGraphic)
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //public
        //constructor
            constructor TSoilNailWall.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TSoilNailWall.destroy();
                begin
                    inherited destroy();
                end;

end.
