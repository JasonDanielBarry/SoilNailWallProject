unit LoadCaseEditorWizard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  CustomComponentPanelClass, Graphic2DComponent, Vcl.StdCtrls, Vcl.Grids,
  Vcl.Buttons;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoadCaseEditor: TLoadCaseEditor;

implementation

{$R *.dfm}

end.
