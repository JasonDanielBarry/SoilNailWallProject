unit NailLayoutGenerator;

interface

    uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, system.Types,
        Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
        System.Skia, Vcl.Skia,

        GeneralMathMethods,
        SoilNailWallMasterClass
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
    PBWallDrawing: TSkPaintBox;
    procedure PBWallDrawingDraw(ASender         : TObject;
                                const ACanvas   : ISkCanvas;
                                const ADest     : TRectF;
                                const AOpacity  : Single    );
    procedure ComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
      private
        { Private declarations }
        soilNailWallDesign : TSoilNailWall;
        procedure drawWall(canvasIn : ISkCanvas);
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

    procedure TNailLayoutGenForm.PBWallDrawingDraw( ASender         : TObject;
                                                    const ACanvas   : ISkCanvas;
                                                    const ADest     : TRectF;
                                                    const AOpacity  : Single    );
        begin
            drawWall(ACanvas);
        end;

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

    //private
        procedure TNailLayoutGenForm.drawWall(canvasIn : ISkCanvas);
            begin
                soilNailWallDesign.drawSoilNailWall(PBWallDrawing.Height, PBWallDrawing.Width, canvasIn)
            end;

        procedure TNailLayoutGenForm.generateLayout();
            var
                validLengths,   validSpaces,
                validInputs                     : boolean;
                topSpace,       nailToNailSpace,
                bottomLength,   topLength       : double;
            begin
                try
                    //get inputs from UI
                        //spacing
                            topSpace        := strToFloat( trim(ComboBoxTopSpace.Text) );
                            nailToNailSpace := strToFloat( trim(ComboBoxNailSpacing.Text) );

                        //lengths
                            topLength       := strToFloat( trim(ComboBoxTopLength.Text) );
                            bottomLength    := strToFloat( trim(ComboBoxBottomLength.Text) );

                    //check the inputs make sense for the calculation to be run
                        validLengths    := (topLength >= 0.5) AND (bottomLength >= 0.5);
                        validSpaces     := (topSpace > 1e-3) AND (nailToNailSpace >= 0.5);
                        validInputs     := (validLengths AND validSpaces);

                        if ( NOT(validInputs) ) then
                            begin
                                Application.MessageBox('Values entered insufficient for layout generation', 'Invalid Input', MB_OK);
                                exit();
                            end;

                    SoilNailWallDesign.generateSoilNailLayout(  topSpace,   nailToNailSpace,
                                                                topLength,  bottomLength    );

                    PBWallDrawing.Redraw();
                except
                    //do nothing
                end;
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

                if isAlmostZero(nailToNailSpace) then
                    exit();

                ComboBoxTopSpace.Text       := FloatToStrF(topSpace,        ffFixed, 5, 2);
                ComboBoxNailSpacing.Text    := FloatToStrF(nailToNailSpace, ffFixed, 5, 2);
                ComboBoxTopLength.Text      := FloatToStrF(topLength,       ffFixed, 5, 2);
                ComboBoxBottomLength.Text   := FloatToStrF(bottomLength,    ffFixed, 5, 2);
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
