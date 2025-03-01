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
                        soil : TSoil;
                    begin
                        soil := getSoil();

                        fileReadWriteInOut.tryReadLimitStateMaterial('SoilFrictionAngle', soil.frictionAngle);
                    end;

            //save to file
                procedure TSoilNailWallFileManager.writeToFile(var fileReadWriteInOut : TSoilNailWallFileReaderWriter);
                    var
                        soil : TSoil;
                    begin
                        soil := getSoil();

                        fileReadWriteInOut.writeSoil( 'SoilFrictionAngle', soil );
                    end;

end.
