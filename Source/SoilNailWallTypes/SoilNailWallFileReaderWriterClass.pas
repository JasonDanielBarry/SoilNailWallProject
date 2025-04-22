unit SoilNailWallFileReaderWriterClass;

interface

    uses
        system.SysUtils, system.Classes, system.Generics.Collections, system.StrUtils,
        Xml.XMLDoc, Xml.XMLIntf,
        FileReaderWriterClass,
        LimitStateMaterialClass,
        SoilNailWallTypes, LoadCaseTypes
        ;

    type
        TSoilNailWallFileReaderWriter = class(TFileReaderWriter)
            public
                //constructor
                    constructor create(const fileNameIn : string); override;
                //destructor
                    destructor destroy(); override;
                //read
                    function tryReadLimitStateMaterial(const identifierIn : string; out LSMOut : TLimitStateMaterial) : boolean;
                    function tryReadSoil(const identifierIn : string; out soilOut : TSoil) : boolean;
                    function tryReadSoilNails(const identifierIn : string; out soilNailsOut : TSoilNails) : boolean;
                    function tryReadWall(const identifierIn : string; out wallOut : TWall) : boolean;
                //write
                    procedure writeLoadCases(const identifierIn : string; const loadCaseMapIn : TLoadCaseMap);
                    procedure writeLimitStateMaterial(const identifierIn : string; const LSMIn : TlimitStateMaterial);
                    procedure writeSoil(const identifierIn : string; const soilIn : TSoil);
                    procedure writeSoilNails(const identifierIn : string; const soilNailsIn : TSoilNails);
                    procedure writeWall(const identifierIn : string; const wallIn : TWall);
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
            function TSoilNailWallFileReaderWriter.tryReadLimitStateMaterial(const identifierIn : string; out LSMOut : TLimitStateMaterial) : boolean;
                var
                    nodeDataType    : string;
                    itemNode        : IXMLNode;
                begin
                    //initialise the value of the material
                        LSMOut.setValues( 0, 0, 0, 1 );

                    //read from XML node
                        result := LSMOut.tryReadFromXMLNode( rootNode, identifierIn );
                end;

            function TSoilNailWallFileReaderWriter.tryReadSoil(const identifierIn : string; out soilOut : TSoil) : boolean;
                begin
                    result := soilOut.tryReadFromXMLNode( rootNode, identifierIn );
                end;

            function TSoilNailWallFileReaderWriter.tryReadSoilNails(const identifierIn : string; out soilNailsOut : TSoilNails) : boolean;
                begin
                    result := soilNailsOut.tryReadFromXMLNode( rootNode, identifierIn );
                end;

            function TSoilNailWallFileReaderWriter.tryReadWall(const identifierIn : string; out wallOut : TWall) : boolean;
                begin
                    result := wallOut.tryReadFromXMLNode( rootNode, identifierIn );
                end;

        //write
            procedure TSoilNailWallFileReaderWriter.writeLoadCases(const identifierIn : string; const loadCaseMapIn : TLoadCaseMap);
                begin
                    loadCaseMapIn.writeToXMLNode( rootNode, identifierIn );
                end;

            procedure TSoilNailWallFileReaderWriter.writeLimitStateMaterial(const identifierIn : string; const LSMIn : TlimitStateMaterial);
                begin
                    LSMIn.writeToXMLNode( rootNode, identifierIn );
                end;

            procedure TSoilNailWallFileReaderWriter.writeSoil(const identifierIn : string; const soilIn : TSoil);
                begin
                    soilIn.writeToXMLNode( rootNode, identifierIn );
                end;

            procedure TSoilNailWallFileReaderWriter.writeSoilNails(const identifierIn : string; const soilNailsIn : TSoilNails);
                begin
                    soilNailsIn.writeToXMLNode( rootNode, identifierIn );
                end;

            procedure TSoilNailWallFileReaderWriter.writeWall(const identifierIn : string; const wallIn : TWall);
                begin
                    wallIn.writeToXMLNode( rootNode, identifierIn );
                end;

end.
