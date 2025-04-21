unit LoadCaseTypes;

interface

    uses
        System.SysUtils, system.Math,
        system.Generics.Collections,
        Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom,
        XMLDocumentMethods
        ;

    type
        //load case record
            TLoadCase = record
                strict private
                    var
                        arrFactors, arrLoads    : TArray<double>;
                        arrDescriptions         : TArray<string>;
                public
                    var
                        name : string;
                    //add load combination
                        procedure addLoadCombination(   const factorIn, loadIn  : double;
                                                        const descriptionIn     : string    );
                    //calculate load combination resultant load
                        function calculateFactoredLoad() : double;
                    //XML file read/write
                        function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                        procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

        //load case map
            TLoadCaseMap = class(TDictionary<string, TLoadCase>)
                private
                    activeLoadCaseKey : string;
                public
                    //make copy
                        procedure copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
                    //XML file read/write
                        function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                        procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
                    //active load case
                        function getActiveLoadCase() : TLoadCase;
                        procedure setActiveLoadCase(const loadCaseKeyIn : string);
                    //critical load case
                        function getCriticalLoadCaseKey() : string;
                        function getCriticalLoadCase() : TLoadCase;
            end;

implementation

    //TLoadCase--------------------------------------------------------------------------------------------------
        procedure TLoadCase.addLoadCombination( const factorIn, loadIn  : double;
                                                const descriptionIn     : string );
            var
                arrLen : integer;
            begin
                //get the length of the arrays
                    arrLen := length( arrFactors );

                //increment array lengths
                    SetLength( arrFactors, arrLen + 1 );
                    SetLength( arrLoads, arrLen + 1 );
                    SetLength( arrDescriptions, arrLen + 1 );

                //assign values
                    arrFactors[ arrLen ]        := factorIn;
                    arrLoads[ arrLen ]          := loadIn;
                    arrDescriptions[ arrLen ]   := descriptionIn;
            end;

        function TLoadCase.calculateFactoredLoad() : double;
            var
                i, arrLen           : integer;
                factoredLoad_i,
                factoredLoadSumOut  : double;
            begin
                result := 0;

                //get the length of the arrays
                    arrLen := length( arrFactors );

                    if ( arrLen < 0 ) then
                        exit( 0 );

                //calculate sum of factored loads
                    factoredLoadSumOut := 0;

                    for i := 0 to arrLen do
                        begin
                            factoredLoad_i := arrFactors[i] * arrLoads[i];

                            factoredLoadSumOut := factoredLoadSumOut + factoredLoad_i;
                        end;

                result := factoredLoadSumOut;
            end;
    //--------------------------------------------------------------------------------------------------------------

    //TLoadCaseMap--------------------------------------------------------------------------------------------------
        //make copy
            procedure TLoadCaseMap.copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
                var
                    itemKey     : string;
                    loadCase    : TLoadCase;
                begin
                    self.Clear();

                    for itemKey in otherLoadCaseMapIn.Keys do
                        begin
                            if NOT( otherLoadCaseMapIn.TryGetValue( itemKey, loadCase ) ) then
                                Continue;

                            self.AddOrSetValue( itemKey, loadCase );
                        end;
                end;

        //XML file read/write
            function TLoadCaseMap.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                begin
                    // to do
                end;

            procedure TLoadCaseMap.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
                begin
                    // to do
                end;

        //active load case
            function TLoadCaseMap.getActiveLoadCase() : TLoadCase;
                var
                    loadCaseOut : TLoadCase;
                begin
                    if NOT( TryGetValue( activeLoadCaseKey, loadCaseOut ) ) then
                        exit( loadCaseOut );

                    result := loadCaseOut;
                end;

            procedure TLoadCaseMap.setActiveLoadCase(const loadCaseKeyIn : string);
                begin
                    if NOT( ContainsKey( loadCaseKeyIn ) ) then
                        exit();

                    activeLoadCaseKey := loadCaseKeyIn;
                end;

        //critical load case
            function TLoadCaseMap.getCriticalLoadCaseKey() : string;
                var
                    currentLoad,
                    maxLoad     : double;
                    criticalKey,
                    LCKey       : string;
                    loadCase    : TLoadCase;
                begin
                    maxLoad := 0;

                    for LCKey in Keys do
                        begin
                            if NOT( TryGetValue( LCKey, loadCase ) ) then
                                Continue;

                            currentLoad := loadCase.calculateFactoredLoad();

                            if ( currentLoad < maxLoad ) then
                                Continue;

                            criticalKey := LCKey;
                            maxLoad     := currentLoad;
                        end;

                    result := criticalKey;
                end;

            function TLoadCaseMap.getCriticalLoadCase() : TLoadCase;
                var
                    criticalKey : string;
                    loadCaseOut : TLoadCase;
                begin
                    criticalKey := getCriticalLoadCaseKey();

                    self.TryGetValue( criticalKey, loadCaseOut );

                    result := loadCaseOut;
                end;


end.
