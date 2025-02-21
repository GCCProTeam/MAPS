function [PMHM]=modelPrecMHM(res,gridReso)
%Establish traditional multipath precision hemispherical map (PMHM) model

%INPUT:
%res: residual data to be modeled
%gridReso: PMHM grid resolution

%OUTPUT:
%MHM: PMHM model

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Step 1: Grid the input data
resGrid=gridResData(res,gridReso);

% Step 2: Quality control of grid data based on standard deviation
resGridStd=stdGridResData(resGrid);

%Step 3: Calculate the standard error of each grid
resGridMstd=mstdGridResData(resGridStd);

% Step 4: Remove grid points with no data (where mean is zero)
resGridMstd(resGridMstd(:,5)==0,:)=[];

% Step 5: Obtain the final PMHM.
PMHM=resGridMstd;
end
