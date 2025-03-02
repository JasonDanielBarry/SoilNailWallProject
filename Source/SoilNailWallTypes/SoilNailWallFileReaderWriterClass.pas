unit SoilNailWallFileReaderWriterClass;

interface

    uses
        system.SysUtils, system.Classes, system.Generics.Collections, system.StrUtils,
        Xml.XMLDoc, Xml.XMLIntf,
        FileReaderWriterClass,
        LimitStateMaterialClass,
        SoilNailWallTypes
        ;

    type
        TSoilNailWallFileReaderWriter = class(TFileReaderWriter)
            public
                //constructor
                    constructor create(const fileNameIn : string); override;
                //destructor
                    destructor destroy(); override;
                //read
                    function tryReadLimitStateMaterial(const identifierIn : string; out valueOut : TLimitStateMaterial) : boolean;
                    function tryReadSoil(const identifierIn : string; out valueOut : TSoil) : boolean;
                    function tryReadSoilNails(const identifierIn : string; out valueOut : TSoilNails) : boolean;
                    function tryReadWall(const identifierIn : string; out valueOut : TWall) : boolean;
                //write
                    procedure writeLimitStateMaterial(const identifierIn : string; const valueIn : TlimitStateMaterial);
                    procedure writeSoil(const identifierIn : string; const valueIn : TSoil);
                    procedure writeSoilNails(const identifierIn : string; const valueIn : TSoilNails);
                    procedure writeWall(const identifierIn : string; const valueIn : TWall);
        end;

implementation

    //public
        //constructor
            constructor TSoilNailWallFileReaderWriter.create(const fileNameIn : string);
                begin
                    inherited create( fileNameIn );
                end;

        //destructor
            destructor TSoilNailWallFileReaderWriter.destroy();
                begin
                    inherited destroy();
                end;

        //read
            function TSoilNailWallFileReaderWriter.tryReadLimitStateMaterial(const identifierIn : string; out valueOut : TLimitStateMaterial) : boolean;
                var
                    nodeDataType    : string;
                    itemNode        : IXMLNode;
                begin
                    //initialise the value of the material
                        valueOut.setValues( 0, 0, 0, 1 );

                    //check the node exists
                        if NOT( tryGetNode( identifierIn, itemNode ) ) then
                            exit( False );

                    //read from XML node
                        result := valueOut.tryReadFromXMLNode( itemNode );
                end;

            function TSoilNailWallFileReaderWriter.tryReadSoil(const identifierIn : string; out valueOut : TSoil) : boolean;
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryGetNode( identifierIn, itemNode ) ) then
                        exit( False );

                    result := valueOut.tryReadFromXMLNode( itemNode );
                end;

            function TSoilNailWallFileReaderWriter.tryReadSoilNails(const identifierIn : string; out valueOut : TSoilNails) : boolean;
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryGetNode( identifierIn, itemNode ) ) then
                        exit( False );

                    result := valueOut.tryReadFromXMLNode( itemNode );
                end;

            function TSoilNailWallFileReaderWriter.tryReadWall(const identifierIn : string; out valueOut : TWall) : boolean;
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryGetNode( identifierIn, itemNode ) ) then
                        exit( False );

                    result := valueOut.tryReadFromXMLNode( itemNode );
                end;

        //write
            procedure TSoilNailWallFileReaderWriter.writeLimitStateMaterial(const identifierIn : string; const valueIn : TlimitStateMaterial);
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryCreateNewNode( identifierIn, itemNode ) ) then
                        exit();

                    valueIn.writeToXMLNode( itemNode );
                end;

            procedure TSoilNailWallFileReaderWriter.writeSoil(const identifierIn : string; const valueIn : TSoil);
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryCreateNewNode( identifierIn, itemNode ) ) then
                        exit();

                    valueIn.writeToXMLNode( itemNode );
                end;

            procedure TSoilNailWallFileReaderWriter.writeSoilNails(const identifierIn : string; const valueIn : TSoilNails);
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryCreateNewNode( identifierIn, itemNode ) ) then
                        exit();

                    valueIn.writeToXMLNode( itemNode );
                end;

            procedure TSoilNailWallFileReaderWriter.writeWall(const identifierIn : string; const valueIn : TWall);
                var
                    itemNode : IXMLNode;
                begin
                    if NOT( tryCreateNewNode( identifierIn, itemNode ) ) then
                        exit();

                    valueIn.writeToXMLNode( itemNode );
                end;

end.
