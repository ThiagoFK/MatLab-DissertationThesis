function [Rpoints,Spoints,sigma_xxinit,sigma_yyinit] = MethodForHillYield2(Sy,G,F,H,N)
sigma_y = Sy(1,1);

theta_known =linspace(0,360,361);
root=zeros(length(theta_known),2);

for i=1:length(theta_known)
   coeffs=[((G+H)*((cosd(theta_known(i)))^4))+((F+H)*((sind(theta_known(i)))^4))+((2*N)-(2*H))*((cosd(theta_known(i)))^2)*((sind(theta_known(i)))^2) 0 -1];
   results=roots(coeffs);
   sigma_g(i,1)=results(1);
   sigma_g(i,2)=results(2);
end
sigma_ginit=reshape(sigma_g, 1, []);
sigma_ginit=sigma_ginit(imag(root)==0);
theta_knowninit=[theta_known' theta_known'];
theta_knowninit=theta_knowninit(imag(root)==0);
sigma_xxinit=sigma_ginit.*cosd(theta_knowninit)*abs(cosd(theta_knowninit));
sigma_yyinit=sigma_ginit.*sind(theta_knowninit)*abs(sind(theta_knowninit));

rootlogical=and(imag(sigma_g)==0,sigma_g>=0);
sigma_g=sigma_g(rootlogical);
theta_known = [theta_known'; theta_known'];
theta_known=theta_known(rootlogical);
[theta_known,I]=sort(theta_known);
sigma_g=sigma_g(I);
sigma_xx=sigma_g.*(cosd(theta_known)).^2;
sigma_yy=sigma_g.*(sind(theta_known)).^2;
xlim([-1 91])
ylim([0.75 1.25])
plot(theta_known,sigma_g,'LineWidth',1.5);
Spoints=[sigma_g(1),sigma_g(46),sigma_g(91)];
Number = get(gcf).Number+1;
figure (Number);
hold on
R=((2*N-G-F)*(sind(theta_known).^2.*cosd(theta_known).^2)+(H*cosd(2*theta_known).^2))./((F*sind(theta_known).^2)+(G*cosd(theta_known).^2));
xlim([0 90])
ylim([min(R)-0.2 max(R)+0.2])
plot(theta_known(1:91),R(1:91),'LineWidth',1.5)
hold off
Rpoints=[R(1),R(46),R(91)];
figure (Number-1);
end