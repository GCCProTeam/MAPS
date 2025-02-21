function resGridMean=meanGridResData(resGridStd)
%Average the grid values

%INPUT:
%resGridStd: residual data after quality control

%OUTPUT:
%resGridMean: the average value of the grid of input data.

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
%Initialize the output matrix
resGridMean=nan(size(resGridStd,1),5);

% Calculate the mean values
for i=1:size(resGridStd,1)
    v=resGridStd{i};
    if(size(v,1)>1)
       meanL1=mean(v(:,3));
       meanP1=mean(v(:,4));
        resGridMean(i,:)=[v(1,1:2),meanL1,meanP1,size(v,1)];     
    end
    if(size(v,1)==1)
        resGridMean(i,:)=[v,1];
    end
end
resGridMean( isnan(resGridMean(:,5)), : )=[]; 
end