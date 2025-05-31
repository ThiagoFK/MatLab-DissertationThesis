function [LankfordRatio,LankfordData]=ProcessLankfordData(LankfordRawTable,TrueStress,TrueStrain,ElasticityModulus,XIndex,YIndex)

%% From the data of Digital Image Correlation, obtain the Lankford Coefficient
% Fix the missing data by a linear interpolation.
FilledLankfordData=fillmissing(LankfordRawTable,'linear');

% Verify if the width and length extensometers didn't lose reference
try
    figure
    subplot(2,1,1);
    plot(FilledLankfordData(:,1),FilledLankfordData(:,2:6));
    legend('Extensometer 1','Extensometer 2','Extensometer 3','Extensometer 4','Extensometer 5')
    xlabel('Frame Progression')
    ylabel('True Width Strain [-]')
    subplot(2,1,2);
    plot(FilledLankfordData(:,1),FilledLankfordData(:,7:9));
    legend('Extensometer 1','Extensometer 2','Extensometer 3')
    xlabel('Frame Progression')
    ylabel('True Length Strain [-]')
    hold off
end

% Show the selected extensometer data
figure
title('Selected Extensometers')
subplot(2,1,1);
plot(FilledLankfordData(:,1),FilledLankfordData(:,XIndex));
xlabel('Frame Progression')
ylabel('True Width Strain [-]')
subplot(2,1,2);
plot(FilledLankfordData(:,1),FilledLankfordData(:,YIndex));
xlabel('Frame Progression')
ylabel('True Length Strain [-]')
hold off

% Takes the average value to obtain the best value
LankfordAverageData(:,1)=mean(FilledLankfordData(:,XIndex),2); %Width Data
LankfordAverageData(:,2)=mean(FilledLankfordData(:,YIndex),2); %Length Data
L=length(LankfordAverageData(:,1));

%% Synchronize intervals
EngStrain=(exp(TrueStrain)-1);
LankfordEngineeringData(:,1)=exp(LankfordAverageData(:,1))-1;
LankfordEngineeringData(:,2)=exp(LankfordAverageData(:,2))-1;
CorrectionFactor=max(LankfordEngineeringData(:,2))/max(EngStrain);

IndexChange=find(EngStrain>0.20,1);
FinalStrain=zeros(length(EngStrain),1);
FinalStrain(IndexChange+1:length(EngStrain))=EngStrain(IndexChange+1:length(EngStrain))-EngStrain(IndexChange)+EngStrain(IndexChange)*CorrectionFactor;
Offset=find(gradient(LankfordEngineeringData(:,2))>0.0005,1);
EngStrain(1:IndexChange)=EngStrain(1:IndexChange)*CorrectionFactor;
EngStrain(IndexChange+1:length(EngStrain))=0;
EngStrain=EngStrain+FinalStrain;
TimeTest=zeros(length(EngStrain),1);
TimeTest(1:IndexChange)=(EngStrain(1:IndexChange)*50/(2.54/60))*CorrectionFactor+Offset;
TimeTest(IndexChange+1:length(EngStrain))=(EngStrain(IndexChange+1:length(EngStrain))*50/(2.54/60))+Offset-EngStrain(IndexChange)*50/(2.54/60)+(EngStrain(IndexChange)*50/(2.54/60))*CorrectionFactor;

figure
plot(TimeTest,EngStrain,FilledLankfordData(:,1),LankfordEngineeringData(:,2))
xlabel('Time[s]')
ylabel('Engineering Strain[adm]')
TrueStrain=log(EngStrain+1);

fprintf(['\nCorrection Factor=',num2str(CorrectionFactor)])
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
figure
h=plot(LankfordSlope, LankfordTrueLengthStrain(EightPercentIndex:TwelvePercentIndex,:), LankfordTrueWidthStrain(EightPercentIndex:TwelvePercentIndex,:));
legend( h, 'Real Data', 'Fitted', 'Location', 'NorthEast', 'Interpreter', 'none' );
ylabel('True Plastic Width Strain [-]')
xlabel('True Plastic Length Strain [-]')

LankfordRatio=-LankfordSlope.a/(1+LankfordSlope.a);
fprintf(['\nr=',num2str(LankfordRatio),'[adm]']);
fprintf(['\nR-square=',num2str(LankfordData.rsquare),'[adm]']);