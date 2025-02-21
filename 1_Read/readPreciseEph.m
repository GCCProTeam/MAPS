function [input] = readPreciseEph(s_ipath,input)
%Reads precise ephemerides for GPS, GLO, GAL and BDS from sp3 file
 
%INPUT:
%s_ipath：Path to. sp3 file
%input：Structure for storing data

%OUPUT:
%input：Structure for storing data

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------
TGPS.t=[];TGPS.X=[];TGPS.Y=[];TGPS.Z=[];TGPS.dT=[];
TGAL.t=[];TGAL.X=[];TGAL.Y=[];TGAL.Z=[];TGAL.dT=[];
TBDS.t=[];TBDS.X=[];TBDS.Y=[];TBDS.Z=[];TBDS.dT=[];

list_obs=dir([s_ipath '/*.sp3']);
FileNum=length(list_obs);
for Num=1:FileNum
    filename=[s_ipath '\' list_obs(Num).name];
    GPS = []; 
    GAL = [];   
    BDS = [];

    % open and read sp3-file
    fid = fopen(filename);          % open file
    lines = textscan(fid,'%s', 'delimiter','\n', 'whitespace','');
    lines = lines{1};
    fclose(fid);
    no_lines = length(lines);   % number of lines of file
    
    i = 1;
    while 1                 % loop to go to the first entry
        tline = lines{i};   i = i + 1;
        if (tline(1) == '*')
            break
        end
    end
    
    idx = 0; 	% index of epoch
    while i <= no_lines         % loop till end of file
        if tline(1) ~= '*'
            continue
        end
        % start with epoch header (always in GPS time)
        epochheader = sscanf(tline,'%*c %f %f %f %f %f %f');      
        date = epochheader;
        jd = cal2jd_GT(date(1), date(2), date(3) + date(4)/24 + ...
            date(5)/1440 + date(6)/86400);
        [~, sow,~] = jd2gps_GT(jd);
        idx = idx + 1;          % increase epoch index
        
        
        tline = lines{i};   i = i + 1;
        % loop over data entry
        while tline(1) ~= '*' && tline(1) ~= 'E'            
            % - jump over QZSS
            if tline(2) == 'J'
                tline = lines{i};   i = i + 1;
                continue
            end
            
            % - get data
            type = tline(1);                % Position or Velocity data
            Epoch = sscanf(tline(3:end),'%f');
            prn = Epoch(1);
            X = Epoch(2);       	
            Y = Epoch(3);
            Z = Epoch(4);
            dT = Epoch(5)*10^-6;     % [microsec] to [s]
            if dT >= 0.1             % sometimes dt is denoted as 99999.99
                dT = 0;
            end
            gnss = tline(2);
            
            % - save data
            if type == 'P'          % Position data
                if gnss == 'G'
                    GPS = save_position(GPS, idx, prn, sow, X, Y, Z, dT);
                elseif gnss == 'E'
                    GAL = save_position(GAL, idx, prn, sow, X, Y, Z, dT);
                elseif gnss == 'C'
                    BDS = save_position(BDS, idx, prn, sow, X, Y, Z, dT);
                end
            end      
            % - get next line
            tline = lines{i};   
            i = i + 1;
        end
    end

% check read data to prevent errors later-on
% e.g., size of struct and GPS week rollover 
%GPS = checkPrecEph(GPS, DEF.SATS_GPS, bool_check);
%GLO = checkPrecEph(GLO, DEF.SATS_GLO, bool_check);
%GAL = checkPrecEph(GAL, DEF.SATS_GAL, bool_check);
%BDS = checkPrecEph(BDS, DEF.SATS_BDS, bool_check);
TGPS.t=[TGPS.t;GPS.t];TGPS.X=[TGPS.X;GPS.X];TGPS.Y=[TGPS.Y;GPS.Y];TGPS.Z=...
[TGPS.Z;GPS.Z];TGPS.dT=[TGPS.dT;GPS.dT];
TGAL.t=[TGAL.t;GAL.t];TGAL.X=[TGAL.X;GAL.X];TGAL.Y=[TGAL.Y;GAL.Y];TGAL.Z=...
[TGAL.Z;GAL.Z];TGAL.dT=[TGAL.dT;GAL.dT];
TBDS.t=[TBDS.t;BDS.t];TBDS.X=[TBDS.X;BDS.X];TBDS.Y=[TBDS.Y;BDS.Y];TBDS.Z=...
[TBDS.Z;BDS.Z];TBDS.dT=[TBDS.dT;BDS.dT];

end

input.sp3gps=TGPS;
input.sp3bds=TBDS;
input.sp3gal=TGAL;

% save-function for position
function GNSS = save_position(GNSS, i, prn, sow, X, Y, Z, dT)
GNSS.t (i, prn)	= round(sow);
GNSS.X (i, prn)	= X*1000;       % [km] to [m]
GNSS.Y (i, prn)	= Y*1000;
GNSS.Z (i, prn) = Z*1000;
GNSS.dT(i, prn) = dT;

% check read-in precise ephemeris
function GNSS = checkPrecEph(GNSS, noSats, bool_check)
if isempty(GNSS)
    return              % no data for this GNSS
end
[rows, sats] = size(GNSS.t);
% check for missing columns/satellites
if sats < noSats       
    GNSS.t (rows, noSats) = 0;
    GNSS.X (rows, noSats) = 0;
    GNSS.Y (rows, noSats) = 0;
    GNSS.Z (rows, noSats) = 0;
    GNSS.dT(rows, noSats) = 0;
end
% check for GPS week rollover:
% If the processed day is a Saturday, the last epoch of the precise orbit 
% file is 0h on the next day = Sunday = 1st day of new GPS week. Therefore 
% the time-stamp of this epoch has to be corrected from 0 to 604800 [sow]
newGPSweek = GNSS.t < GNSS.t(1,:);
GNSS.t = GNSS.t + newGPSweek.*86400*7;

if bool_check
% check if there are epochs without data at all, these epochs prevent 
% reasonable interpolation during processing -> delete these epochs
bool_empty_epoch = ...
    all(GNSS.X == 0, 2)  | all(GNSS.Y == 0, 2)  | all(GNSS.Z == 0, 2) | ...
    all(isnan(GNSS.X),2) | all(isnan(GNSS.Y),2) | all(isnan(GNSS.Z),2);
GNSS.t(bool_empty_epoch,:) = [];
GNSS.X(bool_empty_epoch,:) = [];
GNSS.Y(bool_empty_epoch,:) = [];
GNSS.Z(bool_empty_epoch,:) = [];
GNSS.dT(bool_empty_epoch,:) = [];
end
