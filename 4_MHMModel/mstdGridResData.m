function resGridMstd=mstdGridResData(resGridStd)
%Calculate the standard error of each grid in the input data

%INPUT:
%resGridStd: residual data after quality control

%OUTPUT:
%resGridMstd: the average value of the grid of input data.

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Initialize the output cell array
resGridMstd=nan(size(resGridStd,1),5);

% Traverse each grid and calculate standard error 
for i=1:size(resGridStd,1)
    v=resGridStd{i};
    if(size(v,1)>1)
       n=size(v,1);
       STDL1=std(v(:,3));
       STDP1=std(v(:,4)); 
       MSTDL1=STDL1/sqrt(n-1);
       MSTDP1=STDP1/sqrt(n-1);
       resGridMstd(i,:)=[v(1,1:2),MSTDL1,MSTDP1,size(v,1)];     
    end
    if(size(v,1)==1)
        resGridMstd(i,:)=[v,1];
    end
resGridMstd( isnan(resGridMstd(:,5)), : )=[]; 
end
end