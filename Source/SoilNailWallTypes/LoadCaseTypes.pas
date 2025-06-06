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
                    procedure checkLoadCaseCombinationForErrors(const arrayIndexIn : integer; var arrErrorsInOut : TArray<string>);
                public
                    var
                        LCName : string;
                    //make a copy
                        procedure copyOther(const otherLoadCaseIn : TLoadCase);
                    //accessors
                        function getArrFactors() : TArray<double>; inline;
                        function getArrLoads() : TArray<double>; inline;
                        function getArrDescriptions() : TArray<string>; inline;
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
                    //check for errors
                        procedure checkForErrors(var arrErrorsInOut : TArray<string>);
            end;

        //load case map
            TLoadCaseMap = class(TOrderedDictionary<string, TLoadCase>)
                strict private
                    const
                        DT_LOAD_CASE_MAP    : string = 'TLoadCaseMap';
                        LOAD_CASE_KEYS      : string = 'LoadCaseNames';
                        LC_PREFIX           : string = 'LoadCase_';
                    var
                        activeLoadCaseKey   : string;
                public
                    //constructor
                        constructor create();
                    //destructor
                        destructor destroy(); override;
                    //add or set value
                        procedure AddOrSetValue(const KeyIn : string; const ValueIn : TLoadCase);
                    //make copy
                        procedure copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
                    //XML file read/write
                        function tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                        procedure writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
                    //active load case
                        function getActiveLoadCase() : TLoadCase;
                        function getActiveLoadCaseIndex() : integer;
                        function getActiveLoadCaseName() : string;
                        procedure setActiveLoadCase(const loadCaseKeyIn : string);
                        procedure clearActiveLoadCaseKey();
                        procedure deleteActiveLoadCase();
                    //critical load case
                        function getCriticalLoadCaseKey() : string;
                        function getCriticalLoadCase() : TLoadCase;
                    //count total load combinations
                        function countLoadCaseCombinations(const loadCaseKeyIn : string) : integer;
                        function countTotalLoadCaseCombinations() : integer;
                    //check for errors
                        function checkForErrors() : TArray<string>;

            end;

implementation

    //TLoadCase--------------------------------------------------------------------------------------------------
        //private
            //check for errors
                procedure TLoadCase.checkLoadCaseCombinationForErrors(const arrayIndexIn : integer; var arrErrorsInOut : TArray<string>);
                    var
                    arrLen          : integer;
                    factor, load    : double;
                    description     : string;
                    procedure _addError(const errorMessageIn : string);
                        begin
                            inc( arrLen );

                            SetLength( arrErrorsInOut, arrLen );

                            arrErrorsInOut[arrLen - 1] := errorMessageIn;
                        end;
                    begin
                        arrLen := length( arrErrorsInOut );

                        factor      := arrFactors[ arrayIndexIn ];
                        load        := arrLoads[ arrayIndexIn ];
                        description := arrDescriptions[ arrayIndexIn ];

                        if ( description = '' ) then
                            _addError( LCName + ' must have descriptions for all combinations');

                        if ( IsZero( factor, 1e-3) OR (factor < 0) ) then
                            _addError( LCName + ' - ' + description + ': factor must be greater than zero' );

                        if ( IsZero( load, 1e-3) OR (load < 0) ) then
                            _addError( LCName + ' - ' + description + ': load must be greater than zero' );
                    end;

        //public
            //make a copy
                procedure TLoadCase.copyOther(const otherLoadCaseIn : TLoadCase);
                    var
                        i, arrLen : integer;
                    begin
                        self.LCName := otherLoadCaseIn.LCName;

                        arrLen := otherLoadCaseIn.countCombinations();

                        SetLength( self.arrDescriptions, arrLen );
                        SetLength( self.arrFactors, arrLen );
                        SetLength( self.arrLoads, arrLen );

                        for i := 0 to ( otherLoadCaseIn.countCombinations() - 1 ) do
                            begin
                                self.arrDescriptions[i] := otherLoadCaseIn.arrDescriptions[i];
                                self.arrFactors[i]      := otherLoadCaseIn.arrFactors[i];
                                self.arrLoads[i]        := otherLoadCaseIn.arrLoads[i];
                            end;
                    end;

            //accessors
                function TLoadCase.getArrFactors() : TArray<double>;
                    begin
                        result := arrFactors;
                    end;

                function TLoadCase.getArrLoads() : TArray<double>;
                    begin
                        result := arrLoads;
                    end;

                function TLoadCase.getArrDescriptions() : TArray<string>;
                    begin
                        result := arrDescriptions;
                    end;

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

                            for i := 0 to ( arrLen - 1 ) do
                                begin
                                    factoredLoad_i := arrFactors[i] * arrLoads[i];

                                    factoredLoadSumOut := factoredLoadSumOut + factoredLoad_i;
                                end;

                        result := factoredLoadSumOut;
                    end;

            //XML file read/write
                function TLoadCase.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    var
                        readSuccessful  : boolean;
                        loadCaseNode    : IXMLNode;
                    begin
                        if NOT( tryGetXMLChildNode( XMLNodeIn, identifierIn, DT_LOAD_CASE, loadCaseNode ) ) then
                            exit( False );

                        readSuccessful := tryReadStringFromXMLNode( loadCaseNode, NAME, LCName );
                        readSuccessful := readSuccessful AND TryReadStringArrayFromXMLNode( loadCaseNode, DESCRIPTIONS, arrDescriptions );
                        readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( loadCaseNode, FACTORS, arrFactors );
                        readSuccessful := readSuccessful AND TryReadDoubleArrayFromXMLNode( loadCaseNode, LOADS, arrLoads );

                        result := readSuccessful;
                    end;

                procedure TLoadCase.writeToXMLNode(var XMLNodeInOut : IXMLNode; const identifierIn : string);
                    var
                        loadCaseNode : IXMLNode;
                    begin
                        if NOT( tryCreateNewXMLChildNode( XMLNodeInOut, identifierIn, DT_LOAD_CASE, loadCaseNode ) ) then
                            exit();

                        writeStringToXMLNode( loadCaseNode, NAME, LCName );
                        writeStringArrayToXMLNode( loadCaseNode, DESCRIPTIONS, arrDescriptions );
                        writeDoubleArrayToXMLNode( loadCaseNode, FACTORS, arrFactors );
                        writeDoubleArrayToXMLNode( loadCaseNode, LOADS, arrLoads );
                    end;

            //check for errors
                procedure TLoadCase.checkForErrors(var arrErrorsInOut : TArray<string>);
                    var
                        i : integer;
                    begin
                        for i := 0 to ( countCombinations() - 1 ) do
                            checkLoadCaseCombinationForErrors( i, arrErrorsInOut );
                    end;

    //TLoadCaseMap--------------------------------------------------------------------------------------------------
        //private

        //public
            //constructor
                constructor TLoadCaseMap.create();
                    begin
                        inherited Create();

                        clearActiveLoadCaseKey();
                    end;

            //destructor
                destructor TLoadCaseMap.destroy();
                    begin
                        inherited destroy();
                    end;

            //add or set value
                procedure TLoadCaseMap.AddOrSetValue(const KeyIn : string; const ValueIn : TLoadCase);
                    var
                        localLoadCase : TLoadCase;
                    begin
                        if NOT( KeyIn = ValueIn.LCName ) then
                            exit();

                        //make sure a fresh copy of the record is added so that no referencing issues occur
                            localLoadCase.copyOther( ValueIn );

                        inherited AddOrSetValue( KeyIn, localLoadCase );
                    end;

            //make copy
                procedure TLoadCaseMap.copyOther(const otherLoadCaseMapIn : TLoadCaseMap);
                    var
                        itemKey         : string;
                        otherLoadCase   : TLoadCase;
                    begin
                        self.Clear();

                        for itemKey in otherLoadCaseMapIn.Keys do
                            begin
                                if NOT( otherLoadCaseMapIn.TryGetValue( itemKey, otherLoadCase ) ) then
                                    Continue;

                                self.AddOrSetValue( itemKey, otherLoadCase );
                            end;

                        self.activeLoadCaseKey := otherLoadCaseMapIn.activeLoadCaseKey;
                    end;

            //XML file read/write
                function TLoadCaseMap.tryReadFromXMLNode(var XMLNodeIn : IXMLNode; const identifierIn : string) : boolean;
                    var
                        readSuccessful  : boolean;
                        LCName          : string;
                        loadCaseMapNode : IXMLNode;
                        arrOrderedKeys  : TArray<string>;
                    begin
                        if NOT( tryGetXMLChildNode( XMLNodeIn, identifierIn, DT_LOAD_CASE_MAP, loadCaseMapNode ) ) then
                            exit( False );

                        self.clear();

                        //read ordered keys

                            readSuccessful := TryReadStringArrayFromXMLNode( loadCaseMapNode, LOAD_CASE_KEYS, arrOrderedKeys );

                        //read all load cases
                            for LCName in arrOrderedKeys do
                                begin
                                    var newLoadCase : TLoadCase;

                                    readSuccessful := readSuccessful AND newLoadCase.tryReadFromXMLNode( loadCaseMapNode, LC_PREFIX + LCName );

                                    AddOrSetValue( LCName, newLoadCase );
                                end;

                        result := readSuccessful;
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
                            arrOrderedKeys := Keys.ToArray();

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
                        TryGetValue( activeLoadCaseKey, loadCaseOut );//if the active load case key has no load case then an empty load case is returned

                        result := loadCaseOut;
                    end;

                function TLoadCaseMap.getActiveLoadCaseIndex() : integer;
                    begin
                        if NOT( self.ContainsKey( activeLoadCaseKey ) ) then
                            exit( -1 );

                        result := IndexOf( activeLoadCaseKey );
                    end;

                function TLoadCaseMap.getActiveLoadCaseName() : string;
                    begin
                        result := activeLoadCaseKey;
                    end;

                procedure TLoadCaseMap.setActiveLoadCase(const loadCaseKeyIn : string);
                    begin
                        if NOT( ContainsKey( loadCaseKeyIn ) ) then
                            exit();

                        activeLoadCaseKey := loadCaseKeyIn;
                    end;

                procedure TLoadCaseMap.clearActiveLoadCaseKey();
                    begin
                        activeLoadCaseKey := 'NONE';
                    end;

                procedure TLoadCaseMap.deleteActiveLoadCase();
                    begin
                        remove( activeLoadCaseKey );

                        clearActiveLoadCaseKey();
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

                //count total load combinations
                    function TLoadCaseMap.countLoadCaseCombinations(const loadCaseKeyIn : string) : integer;
                        var
                            loadCase : TLoadCase;
                        begin
                            result := 0;

                            if NOT( TryGetValue( loadCaseKeyIn, loadCase ) ) then
                                exit( 0 );

                            result := loadCase.countCombinations();
                        end;

                    function TLoadCaseMap.countTotalLoadCaseCombinations() : integer;
                        var
                            loadCaseCombinations,
                            totalCombinations       : integer;
                            LCKey                   : string;
                        begin
                            totalCombinations := 0;

                            for LCKey in Keys do
                                begin
                                    loadCaseCombinations := countLoadCaseCombinations( LCKey );

                                    inc( totalCombinations, loadCaseCombinations );
                                end;

                            result := totalCombinations;
                        end;

                //check for errors
                    function TLoadCaseMap.checkForErrors() : TArray<string>;
                        var
                            i, arrLen   : integer;
                            LCKey       : string;
                            loadCase    : TLoadCase;
                            arrErrors   : TArray<string>;
                        begin
                            SetLength( arrErrors, 0 );

                            for LCKey in Keys do
                                begin
                                    if NOT( TryGetValue( LCKey, loadCase ) ) then
                                        Continue;

                                    loadCase.checkForErrors( arrErrors );
                                end;

                            result := arrErrors;
                        end;

end.
