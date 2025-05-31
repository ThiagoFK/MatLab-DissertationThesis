function [RangeIndex]=FindIndexOffset(Strain,Stress,ElasticityModulus,Offset)

LinearSpace=0:0.001:0.5;
LinFitIntersect=ElasticityModulus(LinearSpace-Offset);
[RangeStrain,~] = polyxpoly(Strain,Stress,LinearSpace,LinFitIntersect); %Obtain the Yield Stress at intersection
RangeIndex = find(Strain(:) > RangeStrain, 1);

return