unit SoilNailWallMasterClass;

interface

    uses
        SoilNailWallFileManagementClass;

    type
        TSoilNailWall = class(TSoilNailWallFileManager)
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
