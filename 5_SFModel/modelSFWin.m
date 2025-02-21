function [SF_W,SF_W_sat]=modelSFWin(settings,res,res1)
% A function to model Window Matching SF for GNSS

%INPUT:
%settings: a structure containing system and frequency settings
%res: residuals for different frequencies and systems
%res1: navigation data for different systems

%OUTPUT:
%SF: SF model
%SF_sat: SF model stored by satellite number

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Extract window size from settings
win=settings.Win;

% Process GPS if enabled
if settings.sys.gps==1 
   if settings.freq.L1==1
      % Compute Window Matching SF for GPS L1
      SF_W.L1=SFWinGPS(res.L1,res1.L1,win);
      % Organize Window Matching SF by satellite number
      SF_W_sat.L1=Tosatcell(SF_W.L1,32);
   end
   if settings.freq.L2==1
      SF_W.L2=SFWinGPS(res.L2,res1.L2,win);
      SF_W_sat.L2=Tosatcell(SF_W.L2,32);
   end 
end

% Process Galileo system if enabled
if settings.sys.gal==1
   if settings.freq.E1==1
      SF_W.E1=SFWinGAL(res.E1,res1.E1,win);
      SF_W_sat.E1=Tosatcell(SF_W.E1,36);
   end
   if settings.freq.E5a==1
      SF_W.E5a=SFWinGAL(res.E5a,res1.E5a,win);
      SF_W_sat.E5a=Tosatcell(SF_W.E5a,36);
   end
end  

% Process BeiDou system if enabled
if settings.sys.bds==1
   if settings.freq.B1I==1
      SF_W.B1I=SFWinBDS(res.B1I_1,res.B1I_7,res1.B1I,win);
      SF_W_sat.B1I=Tosatcell(SF_W.B1I,46);
   end
   if settings.freq.B3I==1
      SF_W.B3I=SFWinBDS(res.B3I_1,res.B3I_7,res1.B3I,win);
      SF_W_sat.B3I=Tosatcell(SF_W.B3I,46);
   end
   if settings.freq.B1C==1
      SF_W.B1C=SFWinBDS(res.B1C_1,res.B1C_7,res1.B1C,win);
      SF_W_sat.B1C=Tosatcell(SF_W.B1C,46);
   end
   if settings.freq.B2a==1
      SF_W.B2a=SFWinBDS(res.B2a_1,res.B2a_7,res1.B2a,win);
      SF_W_sat.B2a=Tosatcell(SF_W.B2a,46);
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