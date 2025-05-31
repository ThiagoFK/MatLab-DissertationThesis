function [Force,Deformation]=TestStartTestEnd(TensileTestData)

FindZero=find(TensileTestData(:,2)>0,1);
MaximumForce=max(TensileTestData(:,3));
ForceGradient = diff(TensileTestData(:,3));
Test=0;
Index=5000;
 for n=50:length(TensileTestData)-2 
     if or(abs(ForceGradient(n+1))>abs(5*ForceGradient(n)),Test==1)
         Test=1;
         if TensileTestData(n+1,3)<0.02*MaximumForce && n<Index
             Index=n;
        end
    end
 end
 if Index==5000
    Index=length(TensileTestData);
 end

Force=TensileTestData(FindZero:Index,3);
Deformation=TensileTestData(FindZero:Index,2);