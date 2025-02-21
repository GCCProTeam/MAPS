function resGrid=gridResData(res,gridReso)
%Grid the input data

%INPUT:
%res: residual data to be grided
%gridReso: MHM grid resolution

%OUTPUT:
%resGrid: Residual data after gridding

%%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Sort the input data SD based on the elevation
res=sortrows(res,1);

% Determine the grid resolution based on the gridReso
if(gridReso==1)
  res(:,1:2)=round(res(:,1:2)*2)/2;     
elseif (gridReso==2)
  res(:,1:2)=round(res(:,1:2));
else
  %If the setting is wrong, the default grid resolution is 1.    
  res(:,1:2)=round(res(:,1:2));
end

% Divide residual data into grids
[~,~,ic]=unique(res(:,1:2),'rows');  
ind=splitapply(@(x){x},find(ic),ic);
resGrid = cell(size(ind,1),1);
for i=1:size(resGrid,1)
   resGrid{i}= res(ind{i},:);
end 
end 