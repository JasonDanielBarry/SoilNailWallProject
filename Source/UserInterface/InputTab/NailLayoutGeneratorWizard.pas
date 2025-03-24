unit NailLayoutGeneratorWizard;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Math, System.Variants, System.Classes, system.Types,
        Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
        System.Skia, Vcl.Skia,
        SoilNailWallMasterClass, CustomComponentPanelClass,
        Graphic2DComponent, GraphicDrawerObjectAdderClass,
        NailLayoutGeneratorInputManagerClass
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
        ListBoxErrors: TListBox;
        GridPanelMain: TGridPanel;
        procedure ComboBoxChange(Sender: TObject);
        procedure JDBGraphic2DDrawingUpdateGeometry(ASender         : TObject;
                                                    var AGeomDrawer : TGraphicDrawerObjectAdder);
      private
        { Private declarations }
        soilNailWallDesign      : TSoilNailWall;
        nailLayoutInputManager  : TNailLayoutGeneratorInputManager;
        procedure generateLayout();
      public
        constructor create(const soilNailWallIn : TSoilNailWall);
        destructor destroy(); override;
        function getSoilNailWallDesign() : TSoilNailWall;
      end;

    var
      NailLayoutGenForm: TNailLayoutGenForm;

implementation

{$R *.dfm}

    procedure TNailLayoutGenForm.ComboBoxChange(Sender: TObject);
        begin
            generateLayout();

            ButtonOK.Enabled := ( nailLayoutInputManager.errorCount() = 0 );
        end;

    procedure TNailLayoutGenForm.JDBGraphic2DDrawingUpdateGeometry( ASender         : TObject;
                                                                    var AGeomDrawer : TGraphicDrawerObjectAdder );
        begin
            soilNailWallDesign.updateSoilNailWallGeomtry( AGeomDrawer );
        end;

    //private
        procedure TNailLayoutGenForm.generateLayout();
            begin
                nailLayoutInputManager.readFromInputControls();
                nailLayoutInputManager.writeToInputControls( False );

                JDBGraphic2DDrawing.updateGeometry();
            end;

    //public
        constructor TNailLayoutGenForm.create(const soilNailWallIn : TSoilNailWall);
            var
                topSpace,       nailToNailSpace,
                bottomLength,   topLength       : double;
            begin
                inherited create( nil );

                soilNailWallDesign := TSoilNailWall.create();

                soilNailWallDesign.copySNW( soilNailWallIn );

                //get the layout from the class
                    nailLayoutInputManager := TNailLayoutGeneratorInputManager.create(  ListBoxErrors,
                                                                                        ComboBoxTopSpace, ComboBoxNailSpacing,
                                                                                        ComboBoxTopLength, ComboBoxBottomLength,
                                                                                        soilNailWallDesign                      );

                    nailLayoutInputManager.writeToInputControls( True );

                    ButtonOK.Enabled := ( nailLayoutInputManager.errorCount() = 0 );

                //draw wall
                    JDBGraphic2DDrawing.updateGeometry();
                    JDBGraphic2DDrawing.zoomAll();
            end;

        destructor TNailLayoutGenForm.destroy();
            begin
                FreeAndNil( soilNailWallDesign );
                FreeAndNil( nailLayoutInputManager );

                inherited destroy();
            end;

        function TNailLayoutGenForm.getSoilNailWallDesign() : TSoilNailWall;
            begin
                result := soilNailWallDesign;
            end;


end.
