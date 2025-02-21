function [TMHM]=modelTMHM(settings,res)
% This function models the Trend Surface Analysis MHM (TMHM) based on the 
% provided settings and residual data. It supports GPS, GLONASS, 
% GALILEO, and BDS systems and their respective frequencies

% INPUT:
% settings: a structure containing modeling parameters
% res: a structure containing residual data to be modeled

% OUTPUT:
% TMHM: a structure of TMHM including each frequency of each system

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Extract residual type from settings   
resType=settings.resType;

 % Process GPS system residuals
if settings.sys.gps==1
    % Model TMHM for L1 residuals
   if settings.freq.L1==1
      [TMHM.L1]=modelTrendSurfAnalysisMHM(res.L1,resType); 
   end
   if settings.freq.L2==1
      [TMHM.L2]=modelTrendSurfAnalysisMHM(res.L2,resType); 
   end
end

% Process GLONASS system residuals
if settings.sys.glo==1
   if settings.freq.G1==1
      [TMHM.G1]=modelTrendSurfAnalysisMHM(res.G1,resType);
   end
   if settings.freq.G2==1
      [TMHM.G2]=modelTrendSurfAnalysisMHM(res.G2,resType); 
   end
end

% Process Galileo system residuals
if settings.sys.gal==1
   if settings.freq.E1==1
      [TMHM.E1]=modelTrendSurfAnalysisMHM(res.E1,resType);
   end
   if settings.freq.E5a==1
      [TMHM.E5a]=modelTrendSurfAnalysisMHM(res.E5a,resType);
   end
end

% Process BDS system residuals
if settings.sys.bds==1
   % Define satellite types for BDS
   GEO=[1,2,3,4,5,59,60];
   IGSO=[6,7,8,9,10,13,16,38,39,40];
   MEO=[11,12,14,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,...
       41,42,43,44,45,46,57,58];
   if settings.freq.B1I==1
      % Extract residuals for GEO, IGSO, and MEO satellites
      index=ismember(res.B1I(:,3),GEO);
      resGEOB1I=res.B1I(index,:);

      index=ismember(res.B1I(:,3),IGSO);
      resIGSOB1I=res.B1I(index,:);

      index=ismember(res.B1I(:,3),MEO);
      resMEOB1I=res.B1I(index,:);

      [TMHM.GEOB1I]=modelTrendSurfAnalysisMHM(resGEOB1I,resType);
      [TMHM.IGSOB1I]=modelTrendSurfAnalysisMHM(resIGSOB1I,resType);
      [TMHM.MEOB1I]=modelTrendSurfAnalysisMHM(resMEOB1I,resType);
   end
   if settings.freq.B3I==1
     index=ismember(res.B3I(:,3),GEO);
      resGEOB3I=res.B3I(index,:);

      index=ismember(res.B3I(:,3),IGSO);
      resIGSOB3I=res.B3I(index,:);

      index=ismember(res.B3I(:,3),MEO);
      resMEOB3I=res.B3I(index,:);

      [TMHM.GEOB3I]=modelTrendSurfAnalysisMHM(resGEOB3I,resType);
      [TMHM.IGSOB3I]=modelTrendSurfAnalysisMHM(resIGSOB3I,resType);
      [TMHM.MEOB3I]=modelTrendSurfAnalysisMHM(resMEOB3I,resType);
   end
end