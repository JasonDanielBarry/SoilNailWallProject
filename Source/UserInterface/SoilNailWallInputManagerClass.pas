unit SoilNailWallInputManagerClass;

interface

    uses
        system.SysUtils, system.Math, System.Classes, system.Generics.Collections, System.UITypes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
        StringGridHelperClass,
        InputManagerClass,
        SoilNailWallTypes,
        SoilNailWallMasterClass
        ;

    type
        TSoilNailWallInputManager = class(TInputManager)
            protected
                const
                    CATEGORY_SPACE : integer = 20;
                var
                    soilNailWallDesign : TSoilNailWall;
            public
                //constructor
                    constructor create( const errorListBoxIn        : TListBox;
                                        const soilNailWallDesignIn  : TSoilNailWall );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //public
        //constructor
            constructor TSoilNailWallInputManager.create(   const errorListBoxIn        : TListBox;
                                                            const soilNailWallDesignIn  : TSoilNailWall );
                begin
                    inherited create( errorListBoxIn );

                    soilNailWallDesign := soilNailWallDesignIn;
                end;

        //destructor
            destructor TSoilNailWallInputManager.destroy();
                begin
                    inherited destroy();
                end;

end.
