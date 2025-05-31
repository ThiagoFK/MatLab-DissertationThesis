function [fitresult, gof] = FitLinearlyThroughOrigin(abscissa, ordered)

%% Fit: 'Linear Fit Ax'.
[xData, yData] = prepareCurveData(abscissa, ordered);

% Set up fittype and options.
ft = fittype( {'x'}, 'independent', 'x', 'dependent', 'y', 'coefficients', {'a'} );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
