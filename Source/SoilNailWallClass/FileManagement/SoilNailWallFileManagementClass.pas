unit SoilNailWallFileManagementClass;

interface

    uses
        SoilNailWallFileReaderWriterClass,
        LimitStateMaterialClass,
        SoilNailWallTypes,
        SoilNailWallGraphicClass
        ;

    type
        TSoilNailWallFileManager = class(TSoilNailWallGraphic)
            private
                const
                    SOIL_PROPERTIES         : string = 'SoilProperties';
                    SOIL_NAIL_PROPERTIES    : string = 'SoilNailProperties';
                    WALL_PROPERTIES         : string = 'WallProperties';
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //file management
                    //load from file
                        function readFromFile(var fileReadWriteInOut : TSoilNailWallFileReaderWriter) : boolean;
                    //save to file
                        procedure writeToFile(var fileReadWriteInOut : TSoilNailWallFileReaderWriter);
        end;

implementation

    //public
        //constructor
            constructor TSoilNailWallFileManager.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TSoilNailWallFileManager.destroy();
                begin
                    inherited destroy();
                end;

        //file management
            //load from file
                function TSoilNailWallFileManager.readFromFile(var fileReadWriteInOut : TSoilNailWallFileReaderWriter) : boolean;
                    var
                        readSuccessful  : boolean;
                        soil            : TSoil;
                        soilNails       : TSoilNails;
                        wall            : TWall;
                    begin
                        //soil
                            soil := getSoil();

                            readSuccessful := fileReadWriteInOut.tryReadSoil( SOIL_PROPERTIES, soil );

                            setSoil( soil );

                        //soil nails
                            soilNails := getNails();

                            readSuccessful := readSuccessful AND fileReadWriteInOut.tryReadSoilNails( SOIL_NAIL_PROPERTIES, soilNails );

                            setNails( soilNails );

                        //wall
                            wall := getWall();

                            readSuccessful := readSuccessful AND fileReadWriteInOut.tryReadWall( WALL_PROPERTIES, wall );

                            setWall( wall );

                        result := readSuccessful
                    end;

            //save to file
                procedure TSoilNailWallFileManager.writeToFile(var fileReadWriteInOut : TSoilNailWallFileReaderWriter);
                    var
                        soil        : TSoil;
                        soilNails   : TSoilNails;
                        wall        : TWall;
                    begin
                        soil := getSoil();

                        fileReadWriteInOut.writeSoil( SOIL_PROPERTIES, soil );

                        soilNails := getNails();

                        fileReadWriteInOut.writeSoilNails( SOIL_NAIL_PROPERTIES, soilNails );

                        wall := getWall();

                        fileReadWriteInOut.writeWall( WALL_PROPERTIES, wall );
                    end;

end.
