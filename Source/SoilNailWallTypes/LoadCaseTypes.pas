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
                    const
                        DT_LOAD_CASE    : string = 'TLoadCase';
                        NAME            : string = 'Name';
                        DESCRIPTIONS    : string = 'Descriptions';
                        FACTORS         : string = 'Factors';
                        LOADS           : string = 'Loads';
                    var
                        arrFactors, arrLoads    : TArray<double>;
                        arrDescriptions         : TArray<string>;
                public
                    var
                        LCName : string;
                    //add load combination
                        procedure addLoadCombination(   const factorIn, loadIn  : double;
                                                        const descriptionIn     : string    );
                    //count combinations
                        function countCombinations() : integer;
                    //calculate load combination resultant load
                        function calculateFactoredLoad() : double;
                    //XML file read/write
                        function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                        procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
            end;

        //load case map
            TLoadCaseMap = class(TDictionary<string, TLoadCase>)
                strict private
                    const
                        DT_LOAD_CASE_MAP    : string = 'TLoadCaseMap';
                        LOAD_CASE_KEYS      : string = 'LoadCaseNames';
                        LC_PREFIX           : string = 'LoadCase_';
                    var
                        activeLoadCaseKey   : string;
                        orderedKeysList     : TList<string>;
                public
                    //constructor
                        constructor create();
                    //destructor
                        destructor destroy(); override;
                    //clear items
                        procedure clear();
                    //add or set value
                        procedure AddOrSetValue(const KeyIn : string; const ValueIn : TLoadCase);
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
                    //ordered keys
                        function getOrderedKeys() : TList<string>;
            end;

implementation

    //TLoadCase--------------------------------------------------------------------------------------------------
        //add load combination
            procedure TLoadCase.addLoadCombination( const factorIn, loadIn  : double;
                                                    const descriptionIn     : string );
                var
                    arrLen : integer;
                begin
                    //get the length of the arrays
                        arrLen := countCombinations();

                    //increment array lengths
                        SetLength( arrFactors, arrLen + 1 );
                        SetLength( arrLoads, arrLen + 1 );
                        SetLength( arrDescriptions, arrLen + 1 );

                    //assign values
                        arrFactors[ arrLen ]        := factorIn;
                        arrLoads[ arrLen ]          := loadIn;
                        arrDescriptions[ arrLen ]   := descriptionIn;
                end;

        //count combinations
            function TLoadCase.countCombinations() : integer;
                begin
                    result := length( arrFactors );
                end;

        //calculate load combination resultant load
            function TLoadCase.calculateFactoredLoad() : double;
                var
                    i, arrLen           : integer;
                    factoredLoad_i,
                    factoredLoadSumOut  : double;
                begin
                    result := 0;

                    //get the length of the arrays
                        arrLen := countCombinations();

                        if ( arrLen < 1 ) then
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

        //XML file read/write
            function TLoadCase.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                begin

                end;

            procedure TLoadCase.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
                var
                    loadCaseNode : IXMLNode;
                begin
                    if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_LOAD_CASE, loadCaseNode ) ) then
                        exit();

                    //write name
                        writeStringToXMLNode( loadCaseNode, NAME, LCName );

                    //write descriptions
                        writeStringArrayToXMLNode( loadCaseNode, DESCRIPTIONS, arrDescriptions );

                    //write factors
                        writeDoubleArrayToXMLNode( loadCaseNode, FACTORS, arrFactors );

                    //write loads
                        writeDoubleArrayToXMLNode( loadCaseNode, LOADS, arrLoads );
                end;

    //TLoadCaseMap--------------------------------------------------------------------------------------------------
        //constructor
            constructor TLoadCaseMap.create();
                begin
                    inherited Create();

                    orderedKeysList := TList<string>.Create();
                end;

        //destructor
            destructor TLoadCaseMap.destroy();
                begin
                    FreeAndNil( orderedKeysList );

                    inherited destroy();
                end;

        //clear items
            procedure TLoadCaseMap.clear();
                begin
                    orderedKeysList.Clear();

                    inherited Clear();
                end;

        //add or set value
            procedure TLoadCaseMap.AddOrSetValue(const KeyIn : string; const ValueIn : TLoadCase);
                begin
                    inherited AddOrSetValue( KeyIn, ValueIn );

                    if NOT( orderedKeysList.Contains( KeyIn ) ) then
                        orderedKeysList.add( KeyIn );
                end;

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
                var
                    LCName          : string;
                    loadCaseMapNode : IXMLNode;
                    loadCase        : TLoadCase;
                    arrOrderedKeys  : TArray<string>;
                begin
                    if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_LOAD_CASE_MAP, loadCaseMapNode ) ) then
                        exit();

                    //write ordered keys
                        arrOrderedKeys := orderedKeysList.ToArray();

                        writeStringArrayToXMLNode( loadCaseMapNode, LOAD_CASE_KEYS, arrOrderedKeys );

                    //write load cases
                        for LCName in arrOrderedKeys do
                            begin
                                if NOT( TryGetValue( LCName, loadCase ) ) then
                                    Continue;

                                loadCase.writeToXMLNode( loadCaseMapNode, LC_PREFIX + LCName );
                            end;
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

            //ordered keys
                function TLoadCaseMap.getOrderedKeys() : TList<string>;
                    begin
                        result := orderedKeysList;
                    end;

end.
