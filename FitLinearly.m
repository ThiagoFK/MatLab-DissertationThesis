function [fitresult, gof] = FitLinearly(abscissa, ordered)

%% Fit: 'Linear Fit Ax+b'.
[xData, yData] = prepareCurveData(abscissa, ordered);

% Set up fittype and options.
ft = fittype( {'x', '1'}, 'independent', 'x', 'dependent', 'y', 'coefficients', {'a', 'b'} );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
