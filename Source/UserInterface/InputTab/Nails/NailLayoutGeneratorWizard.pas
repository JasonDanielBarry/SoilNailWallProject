unit NailLayoutGeneratorWizard;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Math, System.Variants, System.Classes, system.Types,
        Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
        System.Skia, Vcl.Skia,
        SoilNailWallMasterClass, CustomComponentPanelClass,
        Graphic2DComponent, Graphic2DListClass,
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
    procedure JDBGraphic2DDrawingUpdateGraphics(ASender: TObject;
      var AGraphic2DList: TGraphic2DList);
      private
        { Private declarations }
        var
            soilNailWallDesign      : TSoilNailWall;
            nailLayoutInputManager  : TNailLayoutGeneratorInputManager;
        procedure generateLayout();
      public
        constructor create(const soilNailWallIn : TSoilNailWall);
        destructor destroy(); override;
        function getSoilNailWallDesign() : TSoilNailWall;
      end;

implementation

{$R *.dfm}

    procedure TNailLayoutGenForm.ComboBoxChange(Sender: TObject);
        begin
            generateLayout();
        end;

    procedure TNailLayoutGenForm.JDBGraphic2DDrawingUpdateGraphics(ASender: TObject; var AGraphic2DList: TGraphic2DList);
        begin
            soilNailWallDesign.updateSoilNailWallGeomtry( AGraphic2DList );
        end;

//private
        procedure TNailLayoutGenForm.generateLayout();
            begin
                nailLayoutInputManager.readFromInputControls();
                nailLayoutInputManager.writeToInputControls( False );

                JDBGraphic2DDrawing.updateGraphics();
            end;

    //public
        constructor TNailLayoutGenForm.create(const soilNailWallIn : TSoilNailWall);
            begin
                inherited create( nil );

                //soil nail wall class
                    soilNailWallDesign := TSoilNailWall.create();

                    soilNailWallDesign.copySNW( soilNailWallIn );

                //input manager
                    nailLayoutInputManager := TNailLayoutGeneratorInputManager.create(  ListBoxErrors,
                                                                                        ComboBoxTopSpace, ComboBoxNailSpacing,
                                                                                        ComboBoxTopLength, ComboBoxBottomLength,
                                                                                        ButtonOK,
                                                                                        soilNailWallDesign                      );

                    nailLayoutInputManager.writeToInputControls( True );

                //draw wall
                    JDBGraphic2DDrawing.updateGraphics();
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
