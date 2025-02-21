function resGridStd=stdGridResData(resGrid)
%Quality control of grid data based on standard deviation (STD)

%INPUT:
%resGrid: residual data before quality control

%OUTPUT:
%resGridStd: residual data after quality control

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Initialize the output cell array
resGridStd=cell(size(resGrid,1),1);

% Loop through each cell in the input resGrid
for i=1:size(resGrid,1)
    v=resGrid{i};

    % Check if the number of rows in the current cell is greater than 15
    if(size(v,1)>15)      
        v=stdRefiData(v,3);  %Using phase residual data for quality control
        resGridStd{i} = v;
    else
        resGridStd{i}=[];
    end
end
end