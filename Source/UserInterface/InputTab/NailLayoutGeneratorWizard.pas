unit NailLayoutGeneratorWizard;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Math, System.Variants, System.Classes, system.Types,
        Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
        System.Skia, Vcl.Skia,
        SoilNailWallMasterClass, CustomComponentPanelClass,
        Graphic2DComponent, GraphicDrawerObjectAdderClass
        ;

    type
      TNailLayoutGenForm = class(TForm)
        PanelLeft: TPanel;
        GridPanelInputs: TGridPanel;
        LabelTopSpace: TLabel;
        LabelNailSpacing: TLabel;
        LabelTopLength: TLabel;
        LabelBottomLength: TLabel;
        ComboBoxTopSpace: TComboBox;
        ComboBoxNailSpacing: TComboBox;
        ComboBoxTopLength: TComboBox;
        ComboBoxBottomLength: TComboBox;
        GridPanelCancelOK: TGridPanel;
        ButtonCancel: TButton;
        ButtonOK: TButton;
        JDBGraphic2DDrawing: TJDBGraphic2D;
        procedure ComboBoxChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure JDBGraphic2DDrawingUpdateGeometry(ASender         : TObject;
                                                    var AGeomDrawer : TGraphicDrawerObjectAdder);
      private
        { Private declarations }
        soilNailWallDesign : TSoilNailWall;
        procedure generateLayout();
      public
        constructor create(const soilNailWallIn : TSoilNailWall);
        destructor destroy(); override;
        function getSNW() : TSoilNailWall;
      end;

    var
      NailLayoutGenForm: TNailLayoutGenForm;

implementation

{$R *.dfm}

    procedure TNailLayoutGenForm.ComboBoxChange(Sender: TObject);
        begin
            generateLayout();
        end;

    procedure TNailLayoutGenForm.FormCreate(Sender: TObject);
        var
            i           : integer;
            nailLength  : string;
        begin
            //add items to combo boxes
                for i := 5 to 35 do
                    begin
                        nailLength := IntToStr(i);

                        ComboBoxTopLength.Items.Add(nailLength);
                        ComboBoxBottomLength.Items.Add(nailLength);
                    end;
        end;

    procedure TNailLayoutGenForm.JDBGraphic2DDrawingUpdateGeometry(   ASender         : TObject;
                                                                var AGeomDrawer : TGraphicDrawerObjectAdder );
        begin
            soilNailWallDesign.updateSoilNailWallGeomtry( AGeomDrawer );
        end;

    //private
        procedure TNailLayoutGenForm.generateLayout();
            var
                validLengths,   validSpaces,
                validInputs                     : boolean;
                topSpace,       nailToNailSpace,
                bottomLength,   topLength       : double;
            begin
                //get inputs from UI
                    //spacing
                        validSpaces := TryStrToFloat( trim(ComboBoxTopSpace.Text), topSpace );
                        validSpaces := validSpaces AND TryStrToFloat( trim(ComboBoxNailSpacing.Text), nailToNailSpace );

                    //lengths
                        validLengths := TryStrToFloat( trim(ComboBoxTopLength.Text), topLength );
                        validLengths := validLengths AND TryStrToFloat( trim(ComboBoxBottomLength.Text), bottomLength );

                //check the inputs make sense for the calculation to be run
                    validLengths    := validLengths AND ( (topLength >= 0.5) AND (bottomLength >= 0.5) );
                    validSpaces     := validSpaces  AND ( (topSpace > 1e-3) AND (nailToNailSpace >= 0.5) );
                    validInputs     := (validLengths AND validSpaces);

                    if ( NOT(validInputs) ) then
                        begin
                            Application.MessageBox('Values entered insufficient for layout generation', 'Invalid Input', MB_OK);
                            exit();
                        end;

                SoilNailWallDesign.generateSoilNailLayout(  topSpace,   nailToNailSpace,
                                                            topLength,  bottomLength    );

                JDBGraphic2DDrawing.updateGeometry();
            end;

    //public
        constructor TNailLayoutGenForm.create(const soilNailWallIn : TSoilNailWall);
            var
                topSpace,       nailToNailSpace,
                bottomLength,   topLength       : double;
            begin
                inherited create(nil);

                soilNailWallDesign := TSoilNailWall.create();

                soilNailWallDesign.copySNW(soilNailWallIn);

                //get the layout from the class
                    soilNailWallDesign.getNailLayout(   topSpace,   nailToNailSpace,
                                                        topLength,  bottomLength    );

                //draw wall
                    JDBGraphic2DDrawing.updateGeometry();
                    JDBGraphic2DDrawing.zoomAll();

                if ( IsZero( nailToNailSpace, 1e-3) ) then
                    exit();

                ComboBoxTopSpace.Text       := FloatToStrF( topSpace,        ffFixed, 5, 2 );
                ComboBoxNailSpacing.Text    := FloatToStrF( nailToNailSpace, ffFixed, 5, 2 );
                ComboBoxTopLength.Text      := FloatToStrF( topLength,       ffFixed, 5, 2 );
                ComboBoxBottomLength.Text   := FloatToStrF( bottomLength,    ffFixed, 5, 2 );
            end;

        destructor TNailLayoutGenForm.destroy();
            begin
                FreeAndNil(soilNailWallDesign);

                inherited destroy();
            end;

        function TNailLayoutGenForm.getSNW() : TSoilNailWall;
            begin
                result := soilNailWallDesign;
            end;


end.
