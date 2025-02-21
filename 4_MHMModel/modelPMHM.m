function [PMHM]=modelPMHM(settings,res) 
%The traditional MHM modeling of GNSS multipath is established

%INPUT:
%settings: settings of modeling parameters
%res: residual data to be modeled

%OUTPUT:
%MHM: traditional MHM

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Extract gridReso settings
gridReso=settings.gridReso;

% Check if GPS is enabled and model PMHM for GPS frequencies
if settings.sys.gps==1
    % Model PMHM for L1 frequency if enabled
   if settings.freq.L1==1
      [PMHM.L1]=modelPrecMHM(res.L1(:,5:8),gridReso); 
   else
      PMHM.L1=[];
   end
   % Model PMHM for L2 frequency if enabled
   if settings.freq.L2==1
      [PMHM.L2]=modelPrecMHM(res.L2(:,5:8),gridReso); 
   else
      PMHM.L2=[];
   end
end

%Check if GLONASS is enabled and model PMHM for GLONASS frequencies  
if settings.sys.glo==1 
   if settings.freq.G1==1
      [PMHM.G1]=modelPrecMHM(res.G1(:,5:8),gridReso); 
   else
      PMHM.G1=[];
   end
   if settings.freq.G2==1
      [PMHM.G2]=modelPrecMHM(res.G2(:,5:8),gridReso); 
   else
      PMHM.G2=[];
   end
end

% Check if Galileo is enabled and model PMHM for Galileo frequencies
if settings.sys.gal==1 
   if settings.freq.E1==1
      [PMHM.E1]=modelPrecMHM(res.E1(:,5:8),gridReso); 
   else
      PMHM.E1=[];
   end
   if settings.freq.E5a==1
      [PMHM.E5a]=modelPrecMHM(res.E5a(:,5:8),gridReso); 
   else
      PMHM.E5a=[];
   end
end

% Check if BDS is enabled and model PMHM for BDS frequencies
if settings.sys.bds==1 
   if settings.freq.B1I==1
      [PMHM.B1I]=modelPrecMHM(res.B1I(:,5:8),gridReso); 
   else
      PMHM.B1I=[]; 
   end
   if settings.freq.B3I==1
      [PMHM.B3I]=modelPrecMHM(res.B3I(:,5:8),gridReso); 
   else
      PMHM.B3I=[];
   end
end
end