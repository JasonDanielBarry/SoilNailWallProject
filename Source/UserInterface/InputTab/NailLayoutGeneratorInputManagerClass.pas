unit NailLayoutGeneratorInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TNailLayoutGeneratorInputManager = class(TSoilNailWallInputManager)
            private
                var
                    topSpace, verticalNailSpacing,
                    bottomLength, topLength         : double;
                    topSpaceComboBox,
                    NailSpacingComboBox,
                    topLengthComboBox,
                    bottomLengthComboBox            : TComboBox;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const   errorListBoxIn          : TListBox;
                                        const   topSpaceComboBoxIn,
                                                NailSpacingComboBoxIn,
                                                topLengthComboBoxIn,
                                                bottomLengthComboBoxIn  : TComboBox;
                                        const   soilNailWallDesignIn    : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
                //setup input controls
                    procedure setupInputControls(); override;
                //process input
                    //read input
                        function readFromInputControls() : boolean; override;
                    //write to input controls
                        procedure writeToInputControls(const updateEmptyControlsIn : boolean = False); override;
        end;

implementation

    //protected
        //check for input errors
            procedure TNailLayoutGeneratorInputManager.checkForInputErrors();
                begin
                    inherited checkForInputErrors();

                    if ( topSpace < 0.5 ) then
                        addError('Top space should be 0.5m or greater');

                    if ( verticalNailSpacing < 0.5 ) then
                        addError('Vertical spacing should be 0.5m or greater');

                    if ( IsZero( topLength, 1e-3 ) OR (topLength < 0) ) then
                        addError('Top nail length must be non-zero');

                    if ( IsZero( bottomLength, 1e-3 ) OR (bottomLength < 0) ) then
                        addError('Bottom nail length must be non-zero');
                end;

    //public
        //constructor
            constructor TNailLayoutGeneratorInputManager.create(const   errorListBoxIn          : TListBox;
                                                                const   topSpaceComboBoxIn,
                                                                        NailSpacingComboBoxIn,
                                                                        topLengthComboBoxIn,
                                                                        bottomLengthComboBoxIn  : TComboBox;
                                                                const   soilNailWallDesignIn    : TSoilNailWall);
                begin
                    topSpaceComboBox        := topSpaceComboBoxIn;
                    NailSpacingComboBox     := NailSpacingComboBoxIn;
                    topLengthComboBox       := topLengthComboBoxIn;
                    bottomLengthComboBox    := bottomLengthComboBoxIn;

                    inherited create( errorListBoxIn, soilNailWallDesignIn );

                    soilNailWallDesign.getNailLayout( topSpace, verticalNailSpacing, topLength, bottomLength );
                end;

        //destructor
            destructor TNailLayoutGeneratorInputManager.destroy();
                begin
                    inherited destroy();
                end;

        //setup input controls
            procedure TNailLayoutGeneratorInputManager.setupInputControls();
                var
                    i           : integer;
                    nailLength  : string;
                begin
                    inherited setupInputControls();

                    //add items to combo boxes
                        for i := 5 to 35 do
                            begin
                                nailLength := IntToStr( i );

                                topLengthComboBox.Items.Add(nailLength);
                                bottomLengthComboBox.Items.Add(nailLength);
                            end;
                end;

        //process input
            //read input
                function TNailLayoutGeneratorInputManager.readFromInputControls() : boolean;
                    var
                        readSuccessful : boolean;
                    begin
                        topSpace            := 0;
                        verticalNailSpacing := 0;
                        bottomLength        := 0;
                        topLength           := 0;

                        //spacing
                            readSuccessful := TryStrToFloat( trim(topSpaceComboBox.Text), topSpace );
                            readSuccessful := TryStrToFloat( trim(NailSpacingComboBox.Text), verticalNailSpacing ) AND readSuccessful;

                        //lengths
                            readSuccessful := TryStrToFloat( trim(topLengthComboBox.Text), topLength ) AND readSuccessful;
                            readSuccessful := TryStrToFloat( trim(bottomLengthComboBox.Text), bottomLength ) AND readSuccessful;

                        result := readSuccessful;
                    end;

            //write to input controls
                procedure TNailLayoutGeneratorInputManager.writeToInputControls(const updateEmptyControlsIn : boolean = False);
                    begin
                        inherited writeToInputControls( updateEmptyControlsIn );

                        if ( updateEmptyControlsIn ) then
                            begin
                                topSpaceComboBox.Text       := FloatToStrF( topSpace,               ffFixed, 5, 2 );
                                NailSpacingComboBox.Text    := FloatToStrF( verticalNailSpacing,    ffFixed, 5, 2 );
                                topLengthComboBox.Text      := FloatToStrF( topLength,              ffFixed, 5, 2 );
                                bottomLengthComboBox.Text   := FloatToStrF( bottomLength,           ffFixed, 5, 2 );
                            end;

                        if ( errorCount() = 0 ) then
                            soilNailWallDesign.generateSoilNailLayout( topSpace, verticalNailSpacing, topLength, bottomLength )
                        else
                            soilNailWallDesign.generateSoilNailLayout( 0, 1, 0, 0 )
                    end;


end.
