unit SNWUITypes;

interface

    const
        WINDOWS11_THEME_LIGHT   : string = 'Windows11 Modern Light';
        WINDOWS11_THEME_DARK    : string = 'Windows11 Modern Dark';

    type
        EActiveInputPage = (aipMaterials = 0, aipWallGeom = 1, aipNailProperties = 2);
        EActiveComputationPage = (aapAnalysis = 0, aapDesign = 1);
        EActiveRibbonTab = (artInput = 0, artComputation = 1, artOutput = 2);
        EUITheme = (uitLight = 0, uitDark = 1);

implementation

end.
