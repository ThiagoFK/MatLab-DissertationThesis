clear all

cd 'T:\Tese Mestrado\Ensaios'
t0=[2.90e-3 2.89e-3 2.87e-3];
w0=[12.75e-3 12.79e-3 12.77e-3];
Lu=50e-3;

TensileTestData1 = importdata('Ensaio1_4509_30_Teste_90_01\30T9001.mad');
TensileTestData2 = importdata('Ensaio1_4509_30_Teste_90_02\30T9002.mad');
TensileTestData3 = importdata('Ensaio1_4509_30_Teste_90_03\30T9003.mad');
LankfordData1 = readmatrix('Ensaio1_4509_30_Teste_90_01\30T9001.csv');
LankfordData2 = readmatrix('Ensaio1_4509_30_Teste_90_02\30T9002.csv');
LankfordData3 = readmatrix('Ensaio1_4509_30_Teste_90_03\30T9003.csv');

cd 'T:\Tese Mestrado\MatLabArchives'

%% Crop the Initial and Final Value of the Tensile Test
[Force1,Deformation1]=TestStartTestEnd(TensileTestData1);
[Force2,Deformation2]=TestStartTestEnd(TensileTestData2);
[Force3,Deformation3]=TestStartTestEnd(TensileTestData3);


%% Calling the Function to Plot the Engineering Stress Strain Curve and Relevant Info
[ElasticityModulus1,R2E1,Sy1,Ey1,Amax1,Ag1,Stress1,Strain1]=StressStrainEngineeringMultiple(Force1,Deformation1,t0(1),w0(1),Lu);
[ElasticityModulus2,R2E2,Sy2,Ey2,Amax2,Ag2,Stress2,Strain2]=StressStrainEngineeringMultiple(Force2,Deformation2,t0(2),w0(2),Lu);
[ElasticityModulus3,R2E3,Sy3,Ey3,Amax3,Ag3,Stress3,Strain3]=StressStrainEngineeringMultiple(Force3,Deformation3,t0(3),w0(3),Lu);

figure( 'Name', 'Engineering Stress Strain Curve' )
title('3.0[mm] 90º')
hold on
xlim([0 0.30])
ylim([0 500])
xlabel('Engineering Strain [-]')
ylabel('Engineering Stress [MPa]')
plot(Strain1,Stress1,Strain2,Stress2,Strain3,Stress3);
scatter([Ey1 Ey2 Ey3],[Sy1 Sy2 Sy3]);
legend('First Test','Second Test','Third Test','Yield Stress');
hold off

E1=(ElasticityModulus1.a)/1e+3;
E2=(ElasticityModulus2.a)/1e+3;
E3=(ElasticityModulus3.a)/1e+3;

%% Calling the function to plot the mean deviation
PlotDesvPad(Stress1,Strain1,Stress2,Strain2,Stress3,Strain3)

%% Calling the Function to Calculate the True Stress Strain Curve and Relevant Info
[K1,n1,R2Law1,TrueStrain1,TrueStress1]=StressStrainTrueMultiple(Force1,Deformation1,t0(1),w0(1),Lu,ElasticityModulus1);
[K2,n2,R2Law2,TrueStrain2,TrueStress2]=StressStrainTrueMultiple(Force2,Deformation2,t0(2),w0(2),Lu,ElasticityModulus2);
[K3,n3,R2Law3,TrueStrain3,TrueStress3]=StressStrainTrueMultiple(Force3,Deformation3,t0(3),w0(3),Lu,ElasticityModulus3);

figure( 'Name', 'True Stress Strain Curve' )
title('3.0[mm] 90º')
hold on
plot(TrueStrain1,TrueStress1,TrueStrain2,TrueStress2,TrueStrain3,TrueStress3)
legend('First Test','Second Test','Third Test');
xlim([0 0.25])
ylim([0 600])
xlabel('True Strain [-]')
ylabel('True Stress [MPa]')
hold off

%% Calling the Function to Process the Lankford Generated Data
XIndex1=[1,2,3,4,5]+1;
YIndex1=[1,2,3]+6;
XIndex2=[1,2,3,4,5]+1;
YIndex2=[1,3]+6;
XIndex3=[1,2,3,5]+1;
YIndex3=[1,2,3]+6;
[r1,R2L1]=ProcessLankfordDataMultiple(LankfordData1,TrueStress1,TrueStrain1,ElasticityModulus1,XIndex1,YIndex1);
[r2,R2L2]=ProcessLankfordDataMultiple(LankfordData2,TrueStress2,TrueStrain2,ElasticityModulus2,XIndex2,YIndex2);
[r3,R2L3]=ProcessLankfordDataMultiple(LankfordData3,TrueStress3,TrueStrain3,ElasticityModulus3,XIndex3,YIndex3);

disp('Ensaios 1.4509 3.0[mm] 90º')


T = table([Ag1;Ag2;Ag3;mean([Ag1,Ag2,Ag3]);std([Ag1,Ag2,Ag3])], ...
    [Amax1;Amax2;Amax3;mean([Amax1,Amax2,Amax3]);std([Amax1,Amax2,Amax3])], ...
    [E1;E2;E3;mean([E1,E2,E3]);std([E1,E2,E3])], ...
    [R2E1.rsquare;R2E2.rsquare;R2E3.rsquare;mean([R2E1.rsquare,R2E2.rsquare,R2E3.rsquare]);std([R2E1.rsquare,R2E2.rsquare,R2E3.rsquare])],...
    [Sy1;Sy2;Sy3;mean([Sy1,Sy2,Sy3]);std([Sy1,Sy2,Sy3])], ...
    [Ey1;Ey2;Ey3;mean([Ey1,Ey2,Ey3]);std([Ey1,Ey2,Ey3])], ...
    [K1;K2;K3;mean([K1,K2,K3]);std([K1,K2,K3])], ...
    [n1;n2;n3;mean([n1,n2,n3]);std([n1,n2,n3])], ...
    [R2Law1.rsquare;R2Law2.rsquare;R2Law3.rsquare;mean([R2Law1.rsquare,R2Law2.rsquare,R2Law3.rsquare]);std([R2Law1.rsquare,R2Law2.rsquare,R2Law3.rsquare])],...
    [r1;r2;r3;mean([r1,r2,r3]);std([r1,r2,r3])],...
    [R2L1.rsquare;R2L2.rsquare;R2L3.rsquare;mean([R2L1.rsquare,R2L2.rsquare,R2L3.rsquare]);std([R2L1.rsquare,R2L2.rsquare,R2L3.rsquare])],'VariableNames',{'S_ut[MPa]','Amax[adm]','E[GPa]','R^2-Lin[adm]','sigma_y[MPa]','Ey[adm]','K[MPa]','n[adm]','R^2-LinLog[adm]','r[adm]','R^2-Lankford[adm]'},'RowName',{'Specimen 01','Specimen 02','Specimen 03','Mean','Standard Deviation'});

disp(T);