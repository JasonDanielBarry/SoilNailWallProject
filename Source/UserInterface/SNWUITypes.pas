unit SNWUITypes;

interface

    const
        WINDOWS_11_THEME_LIGHT   : string = 'Windows11 Modern Light';
        WINDOWS_11_THEME_DARK    : string = 'Windows11 Modern Dark';

    type
        EInputPage = (ipMaterials = 0, ipWallGeom = 1, ipNailProperties = 2, ipLoadCases = 3);
        EComputationPage = (apAnalysis = 0, apDesign = 1);
        ERibbonTab = (rtInput = 0, rtComputation = 1, rtOutput = 2);
        EUITheme = (uitLight = 0, uitDark = 1);

implementation

end.
