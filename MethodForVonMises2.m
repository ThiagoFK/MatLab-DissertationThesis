function [sigma_xxinit,sigma_yyinit] = MethodForVonMises2(Sy)
sigma_y = Sy(1,1);

theta_known =linspace(0,360,361);
root=zeros(length(theta_known),2);
for i=1:length(theta_known)
   coeffs=[(cosd(theta_known(i)))^4+(sind(theta_known(i)))^4+2*(cosd(theta_known(i)))^2*(sind(theta_known(i)))^2 0 -sigma_y^2];
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

rootlogical=and(imag(root)==0,root>=0);
sigma_g= sigma_g(rootlogical);
theta_known = [theta_known'; theta_known'];
theta_known=theta_known(rootlogical);
plot(theta_known(1:91),sigma_g(1:91)/sigma_y,'LineWidth',1.5)
end