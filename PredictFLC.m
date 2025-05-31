%function [] = PredictFLC(LankfordCoefficient,TotalElongation,Thickness)

clc
clear
close all

R=[1.2295,1.0725,1.5722;0.769,0.685,1.328];
amax=[0.33338,0.28256,0.30602;0.328,0.33,0.31];
T=[1.2 1.2 1.2;3,3,3];
N=[0.1584 0.1434 0.1359;0.1383,0.1260,0.1271];

for i=1:2
figure 
hold on
Amax=amax(i,:)*100;
r=R(i,:);
n=N(i,:);
t=T(i,:);

%% Keeler - Brazier (1977)
E2NEG=-0.5:0.005:0;
E2POS=0.005:0.005:0.5;
E2TOT=-0.5:0.005:0.5;
FLC0=log((n(i)/0.21)*(0.233+0.1413*t(i))+1);
LeftSide=FLC0-E2NEG;
RightSide=((1+FLC0)*(1+E2POS).^(0.5))-1;
BothSideKeeler=cat(2,LeftSide,RightSide);
plot(E2TOT,BothSideKeeler)

%% Be sure that LankfordCoefficient and TotalElongation are Vectors with 0,45,90 degrees informations
LocalStrainRatio=0.797*r(i)^(0.701);
StrainVectorLength=0.0626*(Amax(i)^(0.567)) + (t(i)-1)*(0.12-0.0024*Amax(i));

x=-sqrt((StrainVectorLength^2)/(1+LocalStrainRatio^2));
%StrainUniaxialTensile=[x,LocalStrainRatio*x,-(1+LocalStrainRatio)*x];
StrainUniaxialTensile=[LocalStrainRatio*x,-(1+LocalStrainRatio)*x];
%StrainUniaxialTensile=[min(StrainUniaxialTensile),max(StrainUniaxialTensile)];

StrainPlane=0.0084*Amax(i)+0.0017*Amax(i)*(t(i)-1);
StrainPlane=[0,StrainPlane];

ttrans=(1.5-0.00215*min(Amax))/(0.6+0.00285*min(Amax));
Transition=[t,ttrans];

StrainBiaxial=0.00215*min(Amax)+0.25+0.00285*min(Amax)*min(Transition);
StrainBiaxial=[StrainBiaxial,StrainBiaxial];

IB1=0.0062*Amax(i)+0.18+0.0027*Amax(i)*(min(Transition)-1);
IB2=0.75*IB1;
StrainIntermediateBiaxial=[IB2,IB1];

All = cat(1,StrainUniaxialTensile,StrainPlane,StrainIntermediateBiaxial,StrainBiaxial);
plot(All(:,1),All(:,2))
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.FontName = 'Times New Roman'; % Aplica aos rótulos dos eixos
ax.FontSize = 12;
grid on
xticks(-1:0.1:1);
yticks(-1:0.1:1);
xlim([-0.6 0.6]);

legend('Keeler - Beizer','Abspoel')
xlabel('Minor Strain[-]')
ylabel('Major Strain[-]')
box on
end