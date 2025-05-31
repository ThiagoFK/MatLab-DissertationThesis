function [Rpoints,Spoints,sigma_xxinit,sigma_yyinit] = MethodForBarlat2(Sy,a,c,h,Ry,p)
sigma_y = Sy(1,1);
theta_known=linspace(0,360,361)';
K1=zeros(length(theta_known),6);
m=6;

for i=1:length(theta_known)
    K3=( cosd(theta_known(i))^2+h*sind(theta_known(i))^2 )/2;
    K4=sqrt( ...
            ( ((cosd(theta_known(i)))^2-h*(sind(theta_known(i))^2) )/2)^2 ...
            +(p*sind(theta_known(i))*cosd(theta_known(i)))^2);
   coeffs=[((a*abs(K3+K4)^m)+(a*abs(K3-K4)^m)+(c*abs(2*K4)^m)) 0 0 0 0 0 -2*sigma_y^m];
   results=roots(coeffs);
   sigma_g0(i,1)=results(1);
   sigma_g0(i,2)=results(2);
   sigma_g0(i,3)=results(3);
   sigma_g0(i,4)=results(4);
   sigma_g0(i,5)=results(5);
   sigma_g0(i,6)=results(6);
end

%% I will make a subdivision here to plot the Barlat Yield Contour
%% Note that we do have some complex points and we need to remove then.
sigma_ginit=reshape(sigma_g0, 1, []);
sigma_xxinit=sigma_ginit.*cosd(theta_known).^2;
sigma_yyinit=sigma_ginit.*sind(theta_known).^2;

rootlogical=imag(sigma_g0)==0;
sigma_g=sigma_g0(rootlogical);
theta_known=[theta_known theta_known theta_known theta_known theta_known theta_known];
theta_known=theta_known(rootlogical);

rootlogical=sigma_g>0;
sigma_g=sigma_g(rootlogical);
theta_known=theta_known(rootlogical);
[theta_known, I]=sort(theta_known);
sigma_g=sigma_g(I);

sigma_xx=sigma_g.*cosd(theta_known).^2;
sigma_yy=sigma_g.*sind(theta_known).^2;
K1=(sigma_xx+h*sigma_yy)/2;
K2=sqrt(((sigma_xx-h*sigma_yy)/2).^2+p^2*sigma_xx.*sigma_yy);
xlim([-0.5 90.5])
ylim([0.75 1.25])
plot(theta_known,sigma_g/sigma_y,'LineWidth',1.5)
Spoints=[sigma_g(1) sigma_g(46) sigma_g(91)];

Number = get(gcf).Number+1;

figure (Number);
hold on
Delta=(sigma_xx-h*sigma_yy)./(4*K2);
dfsigmasxx=m*( ...
                a*(K1-K2).*(abs(K1-K2).^(m-2)).*(0.5-Delta) ...
                + a*(K1+K2).*(abs(K1+K2).^(m-2)).*(0.5+Delta) ...
                +(2^m)*c*(K2.^(m-1)).*Delta ...
            );
dfsigmasyy=m*( ...
                a*(K1-K2).*(abs(K1-K2).^(m-2)).*((0.5*h)+(h*Delta)) ...
                + a*(K1+K2).*(abs(K1+K2).^(m-2)).*((0.5*h)-(h*Delta)) ...
                -(2^m)*c*(K2.^(m-1))*h.*Delta ...
                );
dfsigmasxxyy=dfsigmasxx+dfsigmasyy;
Rtheta=( (2*m*(sigma_y^m))./(dfsigmasxxyy.*sigma_g)-1);
plot(theta_known,Rtheta,'LineWidth',1.5);
xlabel('Angle with RD')
ylabel('Lankford Coefficient')
hlines=get(gca, 'Children');
%set(hlines(5),'Color','k','LineStyle','-')
set(hlines(4),'Color','r','LineStyle','-.')
set(hlines(3),'Color','g','LineStyle','--')
set(hlines(2),'Color','b','LineStyle',':')
set(hlines(1),'Color','y','LineStyle','-')
scatter([0 45 90],Ry(:),'Marker','o')
hold off

%% Plotting the LankfordCoefficient in function of the angle with RD
figure(Number+100)
MaxMinRValue=0;
for angle=-90:0.001:90
    I1=angle+45-14.35:0.01:angle+45+14.35;
    I2=angle-45-14.35:0.01:angle-45+14.35;
    I3=angle-165-14.35:0.01:angle-165+14.35;
    R1=interp1(theta_known,Rtheta,mod(I1,360));
    R2=interp1(theta_known,Rtheta,mod(I2,360));
    R3=interp1(theta_known,Rtheta,mod(I3,360));
    IG=[I1 I2 I3];
    RG=[R1 R2 R3];
    MinRValue=min(RG);
    if MinRValue>MaxMinRValue
        MaxI1=I1;
        MaxI2=I2;
        MaxI3=I3;
        MaxIG=IG;
        MaxR1=R1;
        MaxR2=R2;
        MaxR3=R3;
        MaxRG=RG;
        MaxMinRValue=MinRValue;
        MaxAngle=angle;
    end
end
polarplot(deg2rad(theta_known),Rtheta)
hold on
rlim([0 max(Rtheta)+0.1])
polarplot(deg2rad(mod(MaxI1,360)),MaxR1,'LineStyle','none','Marker','o')
polarplot(deg2rad(mod(MaxI2,360)),MaxR2,'LineStyle','none','Marker','o')
polarplot(deg2rad(mod(MaxI3,360)),MaxR3,'LineStyle','none','Marker','o')

legend('Barlat89','Critical Interval 1','Critical Interval 2','Critical Interval 3')
%set(gca, 'color', 'none');       % axes transparent
%set(gcf, 'color', 'none');       % figure transparent
%exportgraphics(gca, 'Rtheta.png', 'BackgroundColor','none');
hold off
disp(MaxAngle);
Upgrade=MaxMinRValue/min(Rtheta);
disp(Upgrade)

figure(Number+102)
polarplot(deg2rad(theta_known),Rtheta)
rlim([0 max(Rtheta)+0.1])
hold on
R1BeforeOptim=interp1(theta_known,Rtheta,mod(MaxI1-130.16,360));
R2BeforeOptim=interp1(theta_known,Rtheta,mod(MaxI2-130.16,360));
R3BeforeOptim=interp1(theta_known,Rtheta,mod(MaxI3-130.16,360));
polarplot(deg2rad(mod(MaxI1-130.16,360)),R1BeforeOptim,'LineStyle','none','Marker','o')
polarplot(deg2rad(mod(MaxI2-130.16,360)),R2BeforeOptim,'LineStyle','none','Marker','o')
polarplot(deg2rad(mod(MaxI3-130.16,360)),R3BeforeOptim,'LineStyle','none','Marker','o')
legend('Barlat89','Critical Interval 1','Critical Interval 2','Critical Interval 3')
hold off

%% Plotting the Stress in function of the angle with RD
figure(Number+101)
MaxMinSValue=0;
for angle=-90:0.001:90
    I1=angle+45-14.35:0.01:angle+45+14.35;
    I2=angle-45-14.35:0.01:angle-45+14.35;
    I3=angle-165-14.35:0.01:angle-165+14.35;
    S1=interp1(theta_known,sigma_g/sigma_y,mod(I1,360));
    S2=interp1(theta_known,sigma_g/sigma_y,mod(I2,360));
    S3=interp1(theta_known,sigma_g/sigma_y,mod(I3,360));
    IG=[I1 I2 I3];
    SG=[S1 S2 S3];
    MinSValue=min(SG);
    if MinSValue>MaxMinSValue
        MaxI1=I1;
        MaxI2=I2;
        MaxI3=I3;
        MaxIG=IG;
        MaxS1=S1;
        MaxS2=S2;
        MaxS3=S3;
        MaxSG=SG;
        MaxMinSValue=MinSValue;
        MaxAngle=angle;
    end
end
polarplot(deg2rad(theta_known),sigma_g/sigma_y)
hold on
rlim([min(sigma_g/sigma_y)-0.1 max(sigma_g/sigma_y)+0.1])
polarplot(deg2rad(mod(MaxI1,360)),MaxS1,'LineStyle','none','Marker','o','LineWidth',1.5)
polarplot(deg2rad(mod(MaxI2,360)),MaxS2,'LineStyle','none','Marker','o','LineWidth',1.5)
polarplot(deg2rad(mod(MaxI3,360)),MaxS3,'LineStyle','none','Marker','o','LineWidth',1.5)
%set(gca, 'color', 'none');       % axes transparent
%set(gcf, 'color', 'none');       % figure transparent
%exportgraphics(gca, 'Stheta.png', 'BackgroundColor','none');
legend('Barlat89','Critical Interval 1','Critical Interval 2','Critical Interval 3')
disp(MaxAngle);
Test1=MaxMinRValue/min(Rtheta);
disp(Test1)

Rpoints=[Rtheta(1) Rtheta(46) Rtheta(91)];
figure (Number-1); 
end