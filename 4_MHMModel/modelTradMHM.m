function [MHM]=modelTradMHM(res,gridReso)
%Establish traditional MHM model

%INPUT:
%res: residual data to be modeled
%gridReso: MHM grid resolution

%OUTPUT:
%MHM: traditional MHM model

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Step 1: Grid the input data
resGrid=gridResData(res,gridReso);

% Step 2: Quality control of grid data based on standard deviation
resGridStd=stdGridResData(resGrid);

%Step 3: Average the grid values
resGridMean=meanGridResData(resGridStd);

% Step 4: Remove grid points with no data (where mean is zero)
resGridMean(resGridMean(:,5)==0,:)=[];

% Step 5: Obtain the final MHM.
MHM=resGridMean;
end

