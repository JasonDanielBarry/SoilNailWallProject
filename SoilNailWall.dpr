program SoilNailWall;

uses
  Vcl.Forms,
  MainSNWForm in 'Source\MainSNWForm.pas' {SNWForm},
  SoilNailWallExampleMethods in 'Source\SoilNailWallExampleMethods.pas',
  SoilNailWallGeneralMethods in 'Source\SoilNailWallGeneralMethods.pas',
  SNWUITypes in 'Source\UserInterface\SNWUITypes.pas',
  UISetupMethods in 'Source\UserInterface\UISetupMethods.pas',
  NailLayoutGeneratorWizard in 'Source\UserInterface\InputTab\NailLayoutGeneratorWizard.pas' {NailLayoutGenForm},
  NailPropertiesTabManagement in 'Source\UserInterface\InputTab\NailPropertiesTabManagement.pas',
  SoilNailWallTypes in 'Source\SoilNailWallTypes\SoilNailWallTypes.pas',
  SoilNailWallMasterClass in 'Source\SoilNailWallClass\SoilNailWallMasterClass.pas',
  SoilNailWallBaseClass in 'Source\SoilNailWallClass\Base\SoilNailWallBaseClass.pas',
  SoilNailWallAnalysisClass in 'Source\SoilNailWallClass\Computation\Analysis\SoilNailWallAnalysisClass.pas',
  SoilNailWallComputationMethods in 'Source\SoilNailWallClass\Computation\Analysis\SoilNailWallComputationMethods.pas',
  SoilNailWallGraphicClass in 'Source\SoilNailWallClass\Drawing\SoilNailWallGraphicClass.pas',
  SoilNailWallGeometryClass in 'Source\SoilNailWallClass\Geometry\SoilNailWallGeometryClass.pas',
  Vcl.Themes,
  Vcl.Styles,
  SoilNailWallFileManagementClass in 'Source\SoilNailWallClass\FileManagement\SoilNailWallFileManagementClass.pas',
  SoilNailWallFileReaderWriterClass in 'Source\SoilNailWallTypes\SoilNailWallFileReaderWriterClass.pas',
  MaterialParametersInputManagerClass in 'Source\UserInterface\InputTab\MaterialParametersInputManagerClass.pas',
  NailLayoutGeneratorInputManager in 'Source\UserInterface\InputTab\NailLayoutGeneratorInputManager.pas',
  WallGeometryInputManagerClass in 'Source\UserInterface\InputTab\WallGeometryInputManagerClass.pas',
  SoilNailWallInputManagerClass in 'Source\UserInterface\SoilNailWallInputManagerClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Light');
  Application.CreateForm(TSNWForm, SNWForm);
  Application.CreateForm(TSNWForm, SNWForm);
  Application.CreateForm(TNailLayoutGenForm, NailLayoutGenForm);
  Application.Run;
end.
