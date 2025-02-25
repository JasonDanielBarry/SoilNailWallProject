unit SoilNailWallFileReaderWriterClass;

interface

    uses
        system.SysUtils, system.Classes, system.Generics.Collections, system.StrUtils,
        Xml.XMLDoc, Xml.XMLIntf,
        FileReaderWriterClass,
        LimitStateMaterialClass
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
                //write
                    procedure writeLimitStateMaterial(const identifierIn : string; const valueIn : TlimitStateMaterial);
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
                    aveVal : string;
                    readXMLNode : IXMLNode;
                begin

                    aveVal := tryRead( readXMLNode.ChildNodes.FindNode('AverageValue').text );



                end;

        //write
            procedure TSoilNailWallFileReaderWriter.writeLimitStateMaterial(const identifierIn : string; const valueIn : TlimitStateMaterial);
                var
                    newXMLNode : IXMLNode;
                    limitStateValuesArray : TArray<double>;
                begin
                    //place data into a double array
                        SetLength( limitStateValuesArray, 4 );

//                        limitStateValuesArray[0] := valueIn.averageValue;
//                        limitStateValuesArray[1] := valueIn.variationCoefficient;
//                        limitStateValuesArray[2] := valueIn.downgradeFactor;
//                        limitStateValuesArray[3] := valueIn.partialFactor;


                    newXMLNode := createNewNode( identifierIn, 'LIMITSTATETYPE' );

                    newXMLNode.AddChild('AverageValue').text := FloatToStr( valueIn.averageValue );
                    newXMLNode.AddChild('VariationCoeff').text := FloatToStr( valueIn.variationCoefficient );


                    //write double array
                        writeDoubleArray( identifierIn, limitStateValuesArray );
                end;

end.
