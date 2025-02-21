function [FMHM]=modelFMHM(settings,res)
%Establish overlapping MHM model

%INPUT:
%settings: settings of modeling parameters
%res: residual data to be modeled

%OUTPUT:
%FMHM(Structure): overlapping MHM model

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Extract gridReso settings
gridReso=settings.gridReso;

% Determine which systems can establish overlapping MHM
if settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.bds~=1
   if settings.freq.L1==1&&settings.freq.E1==1&&settings.freq.B1C~=1
      MAT_all=[res.L1;res.E1]; % Combine residuals
      [FMHM.GE_1]=modelTradMHM(MAT_all(:,5:8),gridReso);%% Model combined data
   else
      FMHM.GE_1=[];
   end
   if settings.freq.L2==1&&settings.freq.E5a==1&&settings.freq.B2a~=1
      MAT_all=[res.L2;res.E5a]; 
      [FMHM.GE_2]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.GE_2=[];
   end

% Determine which systems can establish overlapping MHM
elseif settings.sys.gps==1&&settings.sys.bds==1&&settings.sys.gal~=1
   if settings.freq.L1==1&&settings.freq.B1C==1&&settings.freq.E1~=1
      MAT_all=[res.L1;res.B1C]; 
      [FMHM.GC_1]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.GC_1=[];
   end
   if settings.freq.L2==1&&settings.freq.B2a==1&&settings.freq.E5a~=1
      MAT_all=[res.L2;res.B2a]; 
      [FMHM.GC_2]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.GC_2=[];
   end

% Determine which systems can establish overlapping MHM
elseif settings.sys.bds==1&&settings.sys.gal==1&&settings.sys.gps~=1
   if settings.freq.B1C==1&&settings.freq.E1==1&&settings.freq.L1~=1
      MAT_all=[res.B1C;res.E1]; 
      [FMHM.EC_1]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.EC_1=[];
   end
   if settings.freq.B2a==1&&settings.freq.E5a==1&&settings.freq.L2~=1
      MAT_all=[res.B2a;res.E5a]; 
      [FMHM.EC_2]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.EC_2=[];
   end 

% Determine which systems can establish overlapping MHM
elseif settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.bds==1
   if settings.freq.L1==1&&settings.freq.B1C==1&&settings.freq.E1==1
      MAT_all=[res.L1;res.B1C;res.E1]; 
      [FMHM.GEC_1]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.GEC_1=[];
   end
   if settings.freq.L2==1&&settings.freq.B2a==1&&settings.freq.E5a==1
      MAT_all=[res.L2;res.B2a;res.E5a]; 
      [FMHM.GEC_2]=modelTradMHM(MAT_all(:,5:8),gridReso);
   else
      FMHM.GEC_2=[];
   end
else
    FMHM=[];
end
end