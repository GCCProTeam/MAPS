function [MHMGEO,MHMIGSO,MHMMEO]=modelSatMHM(res,gridReso)
%Establishing MHM of three different satellite orbit types

%INPUT:
%res: residual data to be modeled
%gridReso: MHM grid resolution

%OUTPUT:
%MHMGEO: MHM of GEO satellites
%MHMIGSO: MHM of IGSO satellites
%MHMMEO: MHM of MEO satellites

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Define satellite types by their IDs  
GEO=[1,2,3,4,5,59,60];
IGSO=[6,7,8,9,10,13,16,38,39,40];
MEO=[11,12,14,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,41,42,43,44,45,46,57,58];

% Process GEO satellites
indexGEO=ismember(res(:,1),GEO);
resGEO=res(indexGEO,:);
resGEO=resGEO(:,2:end);
% Step 1: Grid the input data
resGEOGrid=gridResData(resGEO,gridReso);
% Step 2: Quality control of grid data based on standard deviation
resGEOGridStd=stdGridResData(resGEOGrid);
%Step 3: Average the grid values
resGEOGridMean=meanGridResData(resGEOGridStd);
% Step 4: Remove grid points with no data (where mean is zero)
resGEOGridMean(resGEOGridMean(:,5)==0,:)=[];
% Step 5: Obtain the final MHM of GEO satellites.
MHMGEO=resGEOGridMean;

% Process IGSO satellites
indexIGSO=ismember(res(:,1),IGSO);
resIGSO=res(indexIGSO,:);
resIGSO=resIGSO(:,2:end);

resIGSOGrid=gridResData(resIGSO,gridReso);
resIGSOGridStd=stdGridResData(resIGSOGrid);
resIGSOGridMean=meanGridResData(resIGSOGridStd);
resIGSOGridMean(resIGSOGridMean(:,5)==0,:)=[];
MHMIGSO=resIGSOGridMean;

% Process MEO satellites
indexMEO=ismember(res(:,1),MEO);
resMEO=res(indexMEO,:);
resMEO=resMEO(:,2:end);

resMEOGrid=gridResData(resMEO,gridReso);
resMEOGridStd=stdGridResData(resMEOGrid);
resMEOGridMean=meanGridResData(resMEOGridStd);
resMEOGridMean(resMEOGridMean(:,5)==0,:)=[];
MHMMEO=resMEOGridMean;
end

