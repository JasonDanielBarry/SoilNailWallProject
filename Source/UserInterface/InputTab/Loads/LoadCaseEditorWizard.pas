unit LoadCaseEditorWizard;

interface

    uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
        CustomComponentPanelClass, Graphic2DComponent, Vcl.StdCtrls, Vcl.Grids,
        Vcl.Buttons,
        Graphic2DListClass,
        SoilNailWallMasterClass, LoadCaseEditorInputManagerClass,
  CustomStringGridClass
        ;

    type
        TLoadCaseEditor = class(TForm)
            GridPanelMain: TGridPanel;
            JDBGraphic2D: TJDBGraphic2D;
            ButtonCancel: TButton;
            ButtonOK: TButton;
            GridPanelControls: TGridPanel;
            ComboBoxLoadCase: TComboBox;
            PanelInputGrid: TPanel;
            ListBoxErrors: TListBox;
            ButtonNewLoadCase: TButton;
            LabelCurrentLoadCase: TLabel;
            ButtonDeleteLoadCase: TButton;
            LCInputGrid: TJDBStringGrid;
            procedure ButtonNewLCClick(Sender: TObject);
            procedure ComboBoxLoadCaseChange(Sender: TObject);
            procedure ButtonDeleteLoadCaseClick(Sender: TObject);
            procedure LCInputGridCellChanged(Sender: TObject);
    procedure JDBGraphic2DUpdateGraphics(ASender: TObject;
      var AGraphic2DList: TGraphic2DList);
            private
                var
                    loadCaseEditorInputManager  : TLoadCaseEditorInputManager;
                    soilNailWall                : TSoilNailWall;
                procedure readFromAndWriteToAllInputControls();
            public
                constructor create(const soilNailWallDesignIn : TSoilNailWall);
                destructor destroy(); override;
                function getSoilNailWallDesign() : TSoilNailWall;
            { Public declarations }
        end;

implementation

{$R *.dfm}

    procedure TLoadCaseEditor.JDBGraphic2DUpdateGraphics(ASender: TObject; var AGraphic2DList: TGraphic2DList);
        begin
            soilNailWall.updateSoilNailWallGeomtry( AGraphic2DList );
        end;

    procedure TLoadCaseEditor.LCInputGridCellChanged(Sender: TObject);
        begin
            readFromAndWriteToAllInputControls();
        end;

    procedure TLoadCaseEditor.ButtonDeleteLoadCaseClick(Sender: TObject);
        begin
            loadCaseEditorInputManager.deleteLoadCase();
        end;

    procedure TLoadCaseEditor.ButtonNewLCClick(Sender: TObject);
        begin
            loadCaseEditorInputManager.addNewLoadCase()
        end;

    procedure TLoadCaseEditor.ComboBoxLoadCaseChange(Sender: TObject);
        begin
            loadCaseEditorInputManager.loadCaseComboBoxChanged();

            JDBGraphic2D.updateGraphics;
        end;

    //private
        procedure TLoadCaseEditor.readFromAndWriteToAllInputControls();
            begin
                loadCaseEditorInputManager.readFromInputControls();
                loadCaseEditorInputManager.writeToInputControls( false );

                JDBGraphic2D.updateGraphics();
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
                    loadCaseEditorInputManager := TLoadCaseEditorInputManager.create( ListBoxErrors, ButtonOK, GridPanelControls, ComboBoxLoadCase, LCInputGrid, soilNailWall );

                    loadCaseEditorInputManager.writeToInputControls( True );

                //draw graphic
                    JDBGraphic2D.updateGraphics();
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
