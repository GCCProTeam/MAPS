function [MHM]=modelMHM(settings,res)
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

% Check if GPS is enabled and model MHM for GPS frequencies
if settings.sys.gps==1 
    % Model MHM for L1 frequency if enabled
   if settings.freq.L1==1
      [MHM.L1]=modelTradMHM(res.L1(:,5:8),gridReso); 
   else
      MHM.L1=[];
   end

   % Model MHM for L2 frequency if enabled
   if settings.freq.L2==1
      [MHM.L2]=modelTradMHM(res.L2(:,5:8),gridReso); 
   else
      MHM.L2=[];
   end
end

%Check if GLONASS is enabled and model MHM for GLONASS frequencies
%Modeling MHM of GLO using the data of the 3rd-10th day
if settings.sys.glo==1 
   if settings.freq.G1==1
      [MHM.G1]=modelTradMHM(res.G1(:,5:8),gridReso); 
   else
      MHM.G1=[]; 
   end

   if settings.freq.G2==1
      [MHM.G2]=modelTradMHM(res.G2(:,5:8),gridReso); 
   else
      MHM.G2=[]; 
   end
end

% Check if Galileo is enabled and model MHM for Galileo frequencies
%Modeling MHM of GAL using the data of the 1st-10th day
if settings.sys.gal==1 
   if settings.freq.E1==1
      [MHM.E1]=modelTradMHM(res.E1(:,5:8),gridReso); 
   else
      MHM.E1=[]; 
   end
   if settings.freq.E5a==1
      [MHM.E5a]=modelTradMHM(res.E5a(:,5:8),gridReso); 
   else
      MHM.E5a=[];
   end
end

% Check if BDS is enabled and model MHM for BDS frequencies
%Modeling MHM of BDS using the data of the 4-10th day
if settings.sys.bds==1 
   if settings.freq.B1I==1
      [MHM.B1I]=modelTradMHM(res.B1I(:,5:8),gridReso); 
   else
      MHM.B1I=[];
   end
   if settings.freq.B3I==1
      [MHM.B3I]=modelTradMHM(res.B3I(:,5:8),gridReso); 
   else
      MHM.B3I=[];
   end
end
end