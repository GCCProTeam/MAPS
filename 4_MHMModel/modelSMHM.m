function [SMHM]=modelSMHM(settings,res) 
%Establishing MHM of three different satellite orbit types

%INPUT:
%settings: settings of modeling parameters
%res: residual data to be modeled

%OUTPUT:
%SMHM(Structure): MHM of GEO/IGSO/MEO satellites

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Extract gridReso settings
gridReso=settings.gridReso;

% Check if BDS is enabled and model SMHM for BDS frequencies
if settings.sys.bds==1
    % Model SMHM for B1I frequency if enabled
   if settings.freq.B1I==1 
      [SMHM.B1I.GEO,SMHM.B1I.IGSO,SMHM.B1I.MEO]=modelSatMHM(res.B1I(:,[3,5,6,7,8]),gridReso);
   else
      SMHM.B1I.GEO=[];
      SMHM.B1I.IGSO=[];
      SMHM.B1I.MEO=[];
   end
   % Model SMHM for B3I frequency if enabled
   if settings.freq.B3I==1
      [SMHM.B3I.GEO,SMHM.B3I.IGSO,SMHM.B3I.MEO]=modelSatMHM(res.B3I(:,[3,5,6,7,8]),gridReso);
   else
      SMHM.B3I.GEO=[];
      SMHM.B3I.IGSO=[];
      SMHM.B3I.MEO=[];
   end
elseif settings.sys.bds==0
    SMHM=[];
end
end