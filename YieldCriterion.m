clc
clear all
close all
limit=1.5;
R=[1.2295 1.0725 1.5722; % R para o Material 1.4512 1.2[mm] com ângulo crescente
   0.7690 0.6846 1.3276]; % R para o Material 1.4509 3.0[mm] com ângulo crescente
Sy=[291.63 301.8 310.4;
    354.48 382.48 382.9];
p=[0.914552 0.861786];

for i=1:2
SyNorm(i,:)=Sy(i,:)./Sy(i,1);
end

%% Plot Degree in Function of the Anisotropy
Degree=[0,45,90];
figure (1)
hold on
plot(Degree,R(1,:),Degree,R(2,:));
ylim([0.5 2])
legend('1.4512','1.4509')
hold off

theta=deg2rad(90:1:180);
for i=1:2
%% Calculate relevant info like Rm and Delta_R
Rm(i)=(R(i,1)+2*R(i,2)+R(i,3))/4;
Delta_R(i)=(R(i,1)-2*R(i,2)+R(i,3))/2;

%% Plotting Von Mises
syms x y % x=sigma1; y=sigma2
YF=sqrt((x^2+y^2+(x-y)^2)/2)/Sy(i,1);

figure ((i-1)*3+2)
grid on
hold on
%Mises = fcontour(YF,'k',"LineStyle","-.",'LevelList',1);
Mises = fcontour(YF,'k',"LineStyle","-",'LevelList',1/Sy(i,1),'LineWidth',1.5);
Mises.YRange = [-limit,limit];
Mises.XRange = [-limit,limit];

%% Plotting Hill48

%% 0 degrees
H1=(R(i,3))/((1+R(i,3))*(SyNorm(i,3))^2);
F1=H1/R(i,3);
G1=(1/(SyNorm(i,1))^2)-H1;
N1=(2/SyNorm(i,2))-(G1+F1)/2;
YF0=((G1+H1)*x^2+(F1+H1)*y^2-2*H1*x*y);

% Hill0 = fcontour(YF0,'r','LevelList',Sy(i,1)^2);
Hill0 = fcontour(YF0,'r-.','LevelList',1,'LineWidth',1.5);
Hill0.YRange = [-limit,limit];
Hill0.XRange = [-limit,limit];

%% 90 degrees
H2=(R(i,1))/((1+R(i,1))*(SyNorm(i,1))^2);
G2=H2/R(i,1);
F2=(1/(SyNorm(i,3))^2)-H2;
N2=(2/SyNorm(i,2))-(G2+F2)/2;
YF90=(G2+H2)*x^2+(F2+H2)*y^2-2*H2*x*y; % This is the rotated one (F2 with G2)

% Hill90 = fcontour(YF90,'g','LevelList', Sy(i,1)^2);
Hill90 = fcontour(YF90,'g--','LevelList', 1,'LineWidth',1.5);

% From Anisotropy Ratio

G3=(1/(R(i,1)+1));
H3=(R(i,1)*G3);
F3=(H3/(R(i,3)));
N3=(1/2)*((R(i,1)+R(i,3))*(2*R(i,2)+1)/((R(i,3))*(R(i,1)+1)));

YFAnisotropy=(G3+H3)*x^2+(F3+H3)*y^2-2*H3*x*y;
% HillAnisotropy = fcontour(YFAnisotropy,'b','LevelList',Sy(i,1)^2);
HillAnisotropy = fcontour(YFAnisotropy,'b:','LevelList',1,'LineWidth',1.5);

%% Barlat - FromAnisotropy

a=2-2*sqrt((R(i,1)/(1+R(i,1)))*(R(i,3)/(1+R(i,3))));
c=2-a;
h=sqrt((R(i,1)/(1+R(i,1)))*((1+R(i,3))/R(i,3)));
m=6;
K1=(x+h*y)/2;
K2=sqrt(((x-h*y)/2)^2);
YFBarlat=a*(K1+K2)^m + a*(K1-K2)^m + c*(2*K2)^m;
% BarlatAnisotropy = fcontour(YFBarlat,'y','LevelList',2*Sy(i,1)^m);
BarlatAnisotropy = fcontour(YFBarlat,'m-','LevelList',2,'LineWidth',1.5);

xlim([-2 2])
ylim([-2 2])

%% Barlat

a2=2-2*sqrt((R(i,1)/(1+R(i,1)))*(R(i,3)/(1+R(i,3))));
c2=2-a;
h2=Sy(i,1)/Sy(i,3);

%% Experimental Results
scatter([SyNorm(i,1),0],[0,SyNorm(i,3)])
legend({'Von Mises','Hill48-FromStress0','Hill48-FromStress90','Hill48-FromAnisotropy','Barlat89-FromAnisotropy','ExperimentalYield'},'Location','southwest','NumColumns',2)
xlabel('Principal Stress 1')
ylabel('Principal Stress 2')
set(gca,'fontname','times','FontSize',12)
grid on
hold off

figure ((i)*3)
hold on
grid on
MethodForVonMises2(Sy(i,:));
[R1,S1]=MethodForHillYield2(Sy(i,:),G1,F1,H1,N1);
[R2,S2]=MethodForHillYield2(Sy(i,:),G2,F2,H2,N2);
[R3,S3]=MethodForHillYield2(Sy(i,:),G3,F3,H3,N3);
[R4,S4,sigma_xxBarlat,sigma_yyBarlat]=MethodForBarlat2(Sy(i,:),a,c,h,R(i,:),p(i));
S4=S4/Sy(i,1);
table([R1(1);R2(1);R3(1);R4(1);mean([R1(1),R2(1),R3(1),R4(1)]);std([R1(1),R2(1),R3(1),R4(1)])], ...
      [R1(1)-R(i,1);R2(1)-R(i,1);R3(1)-R(i,1);R4(1)-R(i,1);mean([R1(1)-R(i,1),R2(1)-R(i,1),R3(1)-R(i,1),R4(1)-R(i,1)]);std([R1(1)-R(i,1),R2(1)-R(i,1),R3(1)-R(i,1),R4(1)-R(i,1)])], ...
      [R1(2);R2(2);R3(2);R4(2);mean([R1(2),R2(2),R3(2),R4(2)]);std([R1(2),R2(2),R3(2),R4(2)])], ...
      [R1(2)-R(i,2);R2(2)-R(i,2);R3(2)-R(i,2);R4(2)-R(i,2);mean([R1(2)-R(i,2),R2(2)-R(i,2),R3(2)-R(i,2),R4(2)-R(i,2)]);std([R1(2)-R(i,2),R2(2)-R(i,2),R3(2)-R(i,2),R4(2)-R(i,2)])], ...
      [R1(3);R2(3);R3(3);R4(3);mean([R1(3),R2(3),R3(3),R4(3)]);std([R1(3),R2(3),R3(3),R4(3)])], ...
      [R1(3)-R(i,3);R2(3)-R(i,3);R3(3)-R(i,3);R4(3)-R(i,3);mean([R1(3)-R(i,3),R2(3)-R(i,3),R3(3)-R(i,3),R4(3)-R(i,3)]);std([R1(3)-R(i,3),R2(3)-R(i,3),R3(3)-R(i,3),R4(3)-R(i,3)])], ...
      [sqrt((R1(1)-R(i,1))^2+(R1(2)-R(i,2))^2+(R1(3)-R(i,3))^2)/3,sqrt((R2(1)-R(i,1))^2+(R2(2)-R(i,2))^2+(R2(3)-R(i,3))^2)/3,sqrt((R3(1)-R(i,1))^2+(R3(2)-R(i,2))^2+(R3(3)-R(i,3))^2)/3,sqrt((R4(1)-R(i,1))^2+(R4(2)-R(i,2))^2+(R4(3)-R(i,3))^2)/3,0,0]', ...
    'VariableNames',{'r_0','Dev. 1','r_45','Dev. 2','r_90','Dev. 3','Mean Error'}, ...
    'RowNames',{'HillStress0','HillStress90','HillAniso.',' BarlatAniso.','Mean','Std Dev.'})
table([S1(1);S2(1);S3(1);S4(1);mean([S1(1),S2(1),S3(1),S4(1)]);std([S1(1),S2(1),S3(1),S4(1)])], ...
      [S1(1)-SyNorm(i,1);S2(1)-SyNorm(i,1);S3(1)-SyNorm(i,1);S4(1)-SyNorm(i,1);mean([S1(1)-SyNorm(i,1),S2(1)-SyNorm(i,1),S3(1)-SyNorm(i,1),S4(1)-SyNorm(i,1)]);std([S1(1)-SyNorm(i,1),S2(1)-SyNorm(i,1),S3(1)-SyNorm(i,1),S4(1)-SyNorm(i,1)])], ...
      [S1(2);S2(2);S3(2);S4(2);mean([S1(2),S2(2),S3(2),S4(2)]);std([S1(2),S2(2),S3(2),S4(2)])], ...
      [S1(2)-SyNorm(i,2);S2(2)-SyNorm(i,2);S3(2)-SyNorm(i,2);S4(2)-SyNorm(i,2);mean([S1(2)-SyNorm(i,2),S2(2)-SyNorm(i,2),S3(2)-SyNorm(i,2),S4(2)-SyNorm(i,2)]);std([S1(2)-SyNorm(i,2),S2(2)-SyNorm(i,2),S3(2)-SyNorm(i,2),S4(2)-SyNorm(i,2)])], ...
      [S1(3);S2(3);S3(3);S4(3);mean([S1(3),S2(3),S3(3),S4(3)]);std([S1(3),S2(3),S3(3),S4(3)])], ...
      [S1(3)-SyNorm(i,3);S2(3)-SyNorm(i,3);S3(3)-SyNorm(i,3);S4(3)-SyNorm(i,3);mean([S1(3)-SyNorm(i,3),S2(3)-SyNorm(i,3),S3(3)-SyNorm(i,3),S4(3)-SyNorm(i,3)]);std([S1(3)-SyNorm(i,3),S2(3)-SyNorm(i,3),S3(3)-SyNorm(i,3),S4(3)-SyNorm(i,3)])], ...
      [sqrt((S1(1)-SyNorm(i,1))^2+(S1(2)-SyNorm(i,2))^2+(S1(3)-SyNorm(i,3))^2)/3,sqrt((S2(1)-SyNorm(i,1))^2+(S2(2)-SyNorm(i,2))^2+(S2(3)-SyNorm(i,3))^2)/3,sqrt((S3(1)-SyNorm(i,1))^2+(S3(2)-SyNorm(i,2))^2+(S3(3)-SyNorm(i,3))^2)/3,sqrt((S4(1)-SyNorm(i,1))^2+(S4(2)-SyNorm(i,2))^2+(S4(3)-SyNorm(i,3))^2)/3,0,0]', ...
    'VariableNames',{'Sy_0','Dev. 1','Sy_45','Dev. 2','Sy_90','Dev. 3','Mean Error'}, ...
    'RowNames',{'HillStress0','HillStress90','HillAniso.',' BarlatAniso.','Mean','Std Dev.'})
table(sqrt((R1(1)-R(i,1))^2+(R1(2)-R(i,2))^2+(R1(3)-R(i,3))^2+(S1(1)-SyNorm(i,1))^2+(S1(2)-SyNorm(i,2))^2+(S1(3)-SyNorm(i,3))^2)/6,...
    sqrt((R2(1)-R(i,1))^2+(R2(2)-R(i,2))^2+(R2(3)-R(i,3))^2+(S2(1)-SyNorm(i,1))^2+(S2(2)-SyNorm(i,2))^2+(S2(3)-SyNorm(i,3))^2)/6,...
    sqrt((R3(1)-R(i,1))^2+(R3(2)-R(i,2))^2+(R3(3)-R(i,3))^2+(S3(1)-SyNorm(i,1))^2+(S3(2)-SyNorm(i,2))^2+(S3(3)-SyNorm(i,3))^2)/6,...
    sqrt((R4(1)-R(i,1))^2+(R4(2)-R(i,2))^2+(R4(3)-R(i,3))^2+(S4(1)-SyNorm(i,1))^2+(S4(2)-SyNorm(i,2))^2+(S4(3)-SyNorm(i,3))^2)/6,...
    'VariableNames',{'HillStress0','HillStress90','HillAniso','BarlatAniso.'}, ...
    'RowNames',{'RMS'})
hlines=get(gca, 'Children');
xlabel('Angle with RD')
ylabel('Normalized Tensile Yield Stress')
set(gca,'fontname','times','FontSize',12)
set(hlines(5),'Color','k','LineStyle','-','LineWidth',1.5)
set(hlines(4),'Color','r','LineStyle','-.','LineWidth',1.5)
set(hlines(3),'Color','g','LineStyle','--','LineWidth',1.5)
set(hlines(2),'Color','b','LineStyle',':','LineWidth',1.5)
set(hlines(1),'Color','m','LineStyle','-','LineWidth',1.5)
plot([0 45 90],[SyNorm(i,1) SyNorm(i,2) SyNorm(i,3)],'Marker','o','LineStyle','none','LineWidth',1.5)
legend({'Von Mises','Hill48-FromStress0','Hill48-FromStress90','Hill48-FromAnisotropy','Barlat89-FromAnisotropy','ExperimentalYield'},'Location','southwest','NumColumns',2)
hold off
Number = get(gcf).Number+1;
figure(Number)
set(gca,'fontname','times','FontSize',12)
grid on
legend({'Hill48-FromStress0','Hill48-FromStress90','Hill48-FromAnisotropy','Barlat89-FromAnisotropy','ExperimentalYield'},'Location','southwest','NumColumns',2)
end


