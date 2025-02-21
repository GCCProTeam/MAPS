function [SF,SF_sat]=modelSF(settings,res,NAV)
% A function to model SF for  GNSS

%INPUT:
%settings: a structure containing system and frequency settings
%res: residuals for different frequencies and systems
%NAV: navigation data for different systems

%OUTPUT:
%SF: SF model
%SF_sat: SF model stored by satellite number

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Process GPS if enabled
if settings.sys.gps==1  
   if settings.freq.L1==1
      SF.L1=SFGPS(res.L1,NAV.GPS);
      SF_sat.L1=Tosatcell(SF.L1,32);%SF model stored by satellite number
   end
   if settings.freq.L2==1
      SF.L2=SFGPS(res.L2,NAV.GPS);
      SF_sat.L2=Tosatcell(SF.L2,32);
   end
end

% Process Galileo system if enabled
if settings.sys.gal==1
   if settings.freq.E1==1
      SF.E1=SFGAL(res.E1,NAV.GAL);
      SF_sat.E1=Tosatcell(SF.E1,36);
   end
   if settings.freq.E5a==1
      SF.E5a=SFGAL(res.E5a,NAV.GAL);
      SF_sat.E5a=Tosatcell(SF.E5a,36);
   end

end 

% Process BeiDou system if enabled
if settings.sys.bds==1
   if settings.freq.B1I==1
      SF.B1I=SFBDS(res.B1I_7,res.B1I_1,NAV.BDS);
      SF_sat.B1I=Tosatcell(SF.B1I,46);
   end
   if settings.freq.B3I==1
      SF.B3I=SFBDS(res.B3I_7,res.B3I_1,NAV.BDS);
      SF_sat.B3I=Tosatcell(SF.B3I,46);
   end
   if settings.freq.B1C==1
      SF.B1C=SFBDS(res.B1C_7,res.B1C_1,NAV.BDS);
      SF_sat.B1C=Tosatcell(SF.B1C,46);
   end
   if settings.freq.B2a==1
      SF.B2a=SFBDS(res.B2a_7,res.B2a_1,NAV.BDS);
      SF_sat.B2a=Tosatcell(SF.B2a,46);
   end
end
end
%------------------------------Subfunction---------------------------------
function B=Tosatcell(A,k)
%Organize data into a cell array by satellite number

%INPUT:
%A: a data matrix
%k: total number of satellites

%OUTPUT:
%B: Cell array where each cell contains data for a specific satellite

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
if isempty(A)
   B=[];               % Return empty if input is empty
else
    B=cell(k,1);
    for i=1:k
        idx=A(:,2)==i; % Find rows corresponding to satellite i
        B{i}=A(idx,:); % Store data for satellite i
    end
end
end