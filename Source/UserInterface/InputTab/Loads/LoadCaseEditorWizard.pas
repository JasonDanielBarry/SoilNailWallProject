unit LoadCaseEditorWizard;

interface

    uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
        CustomComponentPanelClass, Graphic2DComponent, Vcl.StdCtrls, Vcl.Grids,
        Vcl.Buttons,
        GraphicDrawerObjectAdderClass,
        SoilNailWallMasterClass, LoadCaseEditorInputManagerClass
        ;

    type
        TLoadCaseEditor = class(TForm)
            GridPanelMain: TGridPanel;
            JDBGraphic2D: TJDBGraphic2D;
            ButtonCancel: TButton;
            ButtonOK: TButton;
            GridPanelControls: TGridPanel;
            ComboBoxLoadCase: TComboBox;
            LCInputGrid: TStringGrid;
            PanelInputGrid: TPanel;
            ListBoxErrors: TListBox;
            SpeedButtonNewLC: TSpeedButton;
            procedure JDBGraphic2DUpdateGeometry(   ASender: TObject;
                                                    var AGeomDrawer: TGraphicDrawerObjectAdder  );
            private
                var
                    loadCaseEditorInputManager  : TLoadCaseEditorInputManager;
                    soilNailWall                : TSoilNailWall;
            public
                constructor create(const soilNailWallDesignIn : TSoilNailWall);
                destructor destroy(); override;
                function getSoilNailWallDesign() : TSoilNailWall;
            { Public declarations }
        end;

implementation

{$R *.dfm}

    procedure TLoadCaseEditor.JDBGraphic2DUpdateGeometry(   ASender: TObject;
                                                            var AGeomDrawer: TGraphicDrawerObjectAdder  );
        begin
            soilNailWall.updateSoilNailWallGeomtry( AGeomDrawer );
        end;

    //public
        constructor TLoadCaseEditor.create(const soilNailWallDesignIn : TSoilNailWall);
            begin
                inherited Create( nil );

                //soil nail wall class
                    soilNailWall := TSoilNailWall.create();

                    soilNailWall.copySNW( soilNailWallDesignIn );

                    soilNailWall.setLoadsVisible( True );

                //input manager
                    loadCaseEditorInputManager := TLoadCaseEditorInputManager.create( ListBoxErrors, ComboBoxLoadCase, LCInputGrid, soilNailWall );

                //draw graphic
                    JDBGraphic2D.updateGeometry();
                    JDBGraphic2D.zoomAll();
            end;

        destructor TLoadCaseEditor.destroy();
            begin
                FreeAndNil( soilNailWall );
                FreeAndNil( loadCaseEditorInputManager );

                inherited destroy();
            end;

        function TLoadCaseEditor.getSoilNailWallDesign() : TSoilNailWall;
            begin
                result := soilNailWall;
            end;


end.
