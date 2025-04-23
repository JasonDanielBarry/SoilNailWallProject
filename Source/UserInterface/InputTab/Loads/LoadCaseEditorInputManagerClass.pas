unit LoadCaseEditorInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass, SoilNailWallInputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TLoadCaseEditorInputManager = class(TSoilNailWallInputManager)
            private
                var
                    loadCaseComboBox    : TComboBox;
                    loadCaseInputGrid   : TStringGrid;
            protected
                //check for input errors
                    procedure checkForInputErrors(); override;
            public
                //constructor
                    constructor create( const errorListBoxIn        : TListBox;
                                        const loadCaseComboBoxIn    : TComboBox;
                                        const LCInputGridIn         : TStringGrid;
                                        const soilNailWallIn        : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //protected
        //check for input errors
            procedure TLoadCaseEditorInputManager.checkForInputErrors();
                begin
                    inherited checkForInputErrors()
                end;

    //public
        //constructor
            constructor TLoadCaseEditorInputManager.create( const errorListBoxIn        : TListBox;
                                                            const loadCaseComboBoxIn    : TComboBox;
                                                            const LCInputGridIn         : TStringGrid;
                                                            const soilNailWallIn        : TSoilNailWall );
                begin
                    loadCaseComboBox    := loadCaseComboBoxIn;
                    loadCaseInputGrid   := LCInputGridIn;

                    inherited create( errorListBoxIn, soilNailWallDesign );
                end;

        //destructor
            destructor TLoadCaseEditorInputManager.destroy();
                begin
                    inherited destroy();
                end;

end.
