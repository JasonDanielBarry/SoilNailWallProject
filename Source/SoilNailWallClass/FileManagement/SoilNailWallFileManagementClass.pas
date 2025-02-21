unit SoilNailWallFileManagementClass;

interface

    uses
        FileReaderWriterClass,
        SoilNailWallGraphicClass;

    type
        TSoilNailWallFileManager = class(TSoilNailWallGraphic)
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //file management
                    //load from file
                        function loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
                    //save to file
                        procedure saveToFile(var fileReadWriteInOut : TFileReaderWriter);
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
                function TSoilNailWallFileManager.loadFromFile(var fileReadWriteInOut : TFileReaderWriter) : boolean;
                    begin

                    end;

            //save to file
                procedure TSoilNailWallFileManager.saveToFile(var fileReadWriteInOut : TFileReaderWriter);
                    begin

                    end;

end.
