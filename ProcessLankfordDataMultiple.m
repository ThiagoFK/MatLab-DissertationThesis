function [LankfordRatio,LankfordData]=ProcessLankfordDataMultiple(LankfordRawTable,TrueStress,TrueStrain,ElasticityModulus,XIndex,YIndex)

%% From the data of Digital Image Correlation, obtain the Lankford Coefficient
% Fix the missing data by a linear interpolation.
FilledLankfordData=fillmissing(LankfordRawTable,'linear');

% Takes the average value to obtain the best value
LankfordAverageData(:,1)=mean(FilledLankfordData(:,XIndex),2); %Width Data
LankfordAverageData(:,2)=mean(FilledLankfordData(:,YIndex),2); %Length Data
L=length(LankfordAverageData(:,1));

%% Synchronize intervals
EngStrain=(exp(TrueStrain)-1);
LankfordEngineeringData(:,1)=exp(LankfordAverageData(:,1))-1;
LankfordEngineeringData(:,2)=exp(LankfordAverageData(:,2))-1;
CorrectionFactor=max(LankfordEngineeringData(:,2))/max(EngStrain);
EngStrain=EngStrain*CorrectionFactor;
LankfordAverageData(:,1)=log((LankfordEngineeringData(:,1))+1);
LankfordAverageData(:,2)=log((LankfordEngineeringData(:,2))+1);

TrueStressInterp=interp1(TrueStrain,TrueStress,LankfordAverageData(:,2),'linear');

% Calculate the Elastic Deformation and obtain the true strain
ElasticStrainAtLankfordInterval=TrueStressInterp/207e+3;

poisson=0.3;
LankfordTrueWidthStrain=LankfordAverageData(:,1)+(poisson*ElasticStrainAtLankfordInterval);
LankfordTrueLengthStrain=LankfordAverageData(:,2)-ElasticStrainAtLankfordInterval;

%% Select the interval where we can calculate 8% of plastic deformation and 12% of plastic deformation.
%Find the interval
EightPercentIndex = find(LankfordTrueLengthStrain(:)>0.08,1);
TwelvePercentIndex = find(LankfordTrueLengthStrain(:)>0.12,1);

[LankfordSlope, LankfordData]=FitLinearlyThroughOrigin(LankfordTrueLengthStrain(EightPercentIndex:TwelvePercentIndex),LankfordTrueWidthStrain(EightPercentIndex:TwelvePercentIndex));
LankfordRatio=-LankfordSlope.a/(1+LankfordSlope.a);