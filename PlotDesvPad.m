function [] = PlotDesvPad(Stress1,Strain1,Stress2,Strain2,Stress3,Strain3)

MaximumStrain=min([max(Strain1(:)),max(Strain2(:)),max(Strain3(:))]);
CommonStrain=linspace(0,MaximumStrain,1000);

[Strain1, Index] = unique(Strain1); 
Stress1= Stress1(Index);
[Strain2, Index] = unique(Strain2); 
Stress2= Stress2(Index);
[Strain3, Index] = unique(Strain3); 
Stress3= Stress3(Index);
stress1_interp = interp1(Strain1, Stress1, CommonStrain, 'linear','extrap');
stress2_interp = interp1(Strain2, Stress2, CommonStrain, 'linear','extrap');
stress3_interp = interp1(Strain3, Stress3, CommonStrain, 'linear','extrap');

MeanStress=mean([stress1_interp;stress2_interp;stress3_interp]);
StdDeviation=std([stress1_interp;stress2_interp;stress3_interp]);

figure
hold on
grid on
plot(CommonStrain,MeanStress + StdDeviation,Color='r',LineStyle='--')
plot(CommonStrain,MeanStress,Color='b')
plot(CommonStrain,MeanStress - StdDeviation,Color='r',LineStyle='--')
plot(Strain1,Stress1)
plot(Strain2,Stress2)
plot(Strain3,Stress3)
legend('Max Limit','Mean Curve','Min Limit')
ylim([0 1.1*max(MeanStress)]);
xlim([-0.002 1.1*max(CommonStrain)])
hold off