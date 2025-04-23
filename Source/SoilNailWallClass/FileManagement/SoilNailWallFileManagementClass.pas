unit SoilNailWallFileManagementClass;

interface

    uses
        SoilNailWallFileReaderWriterClass,
        LimitStateMaterialClass,
        SoilNailWallTypes, LoadCaseTypes,
        SoilNailWallGraphicClass
        ;

    type
        TSoilNailWallFileManager = class(TSoilNailWallGraphic)
            private
                const
                    LOAD_CASES              : string = 'LoadCases';
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
                        loadCases       : TLoadCaseMap;
                        soil            : TSoil;
                        soilNails       : TSoilNails;
                        wall            : TWall;
                    begin
                        //load cases
                            loadCases := getLoadCases();

                            readSuccessful := fileReadWriteInOut.tryReadLoadCases( LOAD_CASES, loadCases );

                            setLoadCases( loadCases );

                        //soil
                            soil := getSoil();

                            readSuccessful := readSuccessful AND fileReadWriteInOut.tryReadSoil( SOIL_PROPERTIES, soil );

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
                        loadCases   : TLoadCaseMap;
                        soil        : TSoil;
                        soilNails   : TSoilNails;
                        wall        : TWall;
                    begin
                        //load cases
                            loadCases := getLoadCases;

                            fileReadWriteInOut.writeLoadCases( LOAD_CASES, loadCases );

                        //soil
                            soil := getSoil();

                            fileReadWriteInOut.writeSoil( SOIL_PROPERTIES, soil );

                        //nails
                            soilNails := getNails();

                            fileReadWriteInOut.writeSoilNails( SOIL_NAIL_PROPERTIES, soilNails );

                        //wall
                            wall := getWall();

                            fileReadWriteInOut.writeWall( WALL_PROPERTIES, wall );
                    end;

end.
