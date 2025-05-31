function [ElasticityModulus,LinearFitData,YieldStress,StrainAtYieldStress,Amax,Ag,EngStress,EngStrain]=StressStrainEngineeringMultiple(Force,Deformation,Thickness,Width,UsefulLength)

% Note how the force and deformation values are divided by the initial parameters
% The 1E3 therm refers to the conversion rate to meters of the data which comes from the table
EngStrain=Deformation/(UsefulLength*1E3); %[%] Engineering Strain
EngStress=Force/(Width*Thickness*1E3);  %[%] Engineering Stress
Amax = max(EngStrain, [], 'all');
Ag = max(EngStress, [], 'all');

%% Linear Regression for Determining the Modulus of Elasticity
% Please reselect the interval where the linear regression will be made
ElasticityModulus.a=1;
for Init=0.1*Ag;
    End=0.55*Ag;
    InitialRange=find(EngStress>Init,1);
    FinalRange=find(EngStress>End,1); 
    ElasticEngStrain=EngStrain(InitialRange:FinalRange);
    ElasticEngStress=EngStress(InitialRange:FinalRange);

    [ElasticityModulusTest, LinearFitDataTest]=FitLinearly(ElasticEngStrain, ElasticEngStress);
            if ElasticityModulusTest.a>ElasticityModulus.a && LinearFitDataTest.rsquare>0.8
                ElasticityModulus=ElasticityModulusTest;
                LinearFitData=LinearFitDataTest;
                IndexInit=Init;
                IndexEnd=End;
            end
end
T=table([IndexInit;IndexEnd],'VariableNames',{'Range'},'RowNames',{'Initial','End'});
disp(T);

%% Determining the Yield Stress

LinearSpace=0.002:0.001:0.05; % Linear Space for Plotting the Linear Fit
LinFitIntersect=207e+3*(LinearSpace-0.002); % Plotting the Linear Fit with a 0.02 Strain Displacement

[StrainAtYieldStress,YieldStress] = polyxpoly(EngStrain,EngStress,LinearSpace,LinFitIntersect); %Obtain the Yield Stress at intersection
return