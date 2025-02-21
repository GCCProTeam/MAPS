function [input] = readPreciseClk(c_ipath,input)
%Read precise clock corrections from .clk file for multiple GNSS

%INPUT 
%c_ipath：Path to. clk file
%input：Structure for storing data

%OUTPUT
%input：Structure for storing data
 %GPS/GLO/GAL/BDS:          
 %... .t: time of every epoch in sec of week (#epochs x 1)
 %... .dT: (#epochs x #sats) clock corrections [s]
 %... .sigma_dT: (#epochs x #sats) sigma of clock corrections [s]

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

list_obs=dir([c_ipath '/*.clk']);
file_clk=[c_ipath '\' list_obs.name];

fid = fopen(file_clk);          % open precise clock file
% Initialization

clk.GPS = [];
clk.GAL = [];
clk.BDS = [];

%% Loop over header
while 1
    tline = fgetl(fid);
    % check for end of file and end of header
    if feof(fid)
        break;                  % break if end of file is reached
    end
    if contains(tline,'END OF HEADER')
        break;                  % break if end of header is reached
    end
end


%% Data records
% preparation
epoch = 0;
isfirst = true;

tline = fgetl(fid);
while ischar(tline)                 % loop over rows/lines of file
    if ~strcmp(tline(1:2), 'AS') 
        tline = fgetl(fid);         % only consider satellite clock data
        continue; 
    end
    % get data of current line
    gnss_char = tline(4);       % character of GNSS 
    prn_string = tline(5:6); prn = str2double(prn_string);      % PRN number
    data = textscan(tline,'%s %s %f%f%f%f%f%f%f%f%f');
    year = data{3};     month = data{4};    day = data{5};      % date
    hour = data{6};     min = data{7};      sec = data{8};  	% time
    no_data_values = data{9};           % number of data values to follow
    clkbias = data{10};                 % clock bias [s]
    clkbiasvar = data{11};              % clock bias sigma [s], might be empty
    if isempty(clkbiasvar); clkbiasvar = 0; end     % to avoid errors lateron
    
    % record of GNSS satellite:
    if gnss_char == 'G' || gnss_char == 'E' || gnss_char == 'C'
        % find out time (always GPS time)
        jd = cal2jd_GT(year, month, day + hour/24 + min/1440 + sec/86400);
        [~,sow,~] = jd2gps_GT(jd);
        % look if new epoch
        if isfirst
            epoch = epoch + 1;
            isfirst = false;
            t = round(sow);                         % Seconds of week
        elseif (sow-t) >= 0.5
            epoch = epoch + 1;
            t = round(sow);                         % Seconds of week
        end
        switch gnss_char
            case 'G'        % for GPS satellites
                clk.GPS.t(epoch,1) = t;
                clk.GPS.dT(epoch,prn) = clkbias;              % Clock bias [s]
                clk.GPS.sigma_dT(epoch, prn) = clkbiasvar;   	% Clock bias sigma [s]
            %case 'R'        % for GLONASS satellites
            %   clk.GLO.t(epoch,1) = t;
            %    clk.GLO.dT(epoch,prn) = clkbias;
            %    clk.GLO.sigma_dT(epoch, prn) = clkbiasvar;
            case 'E'        % for GALILEO satellites
                clk.GAL.t(epoch,1) = t;
                clk.GAL.dT(epoch,prn) = clkbias;
                clk.GAL.sigma_dT(epoch, prn) = clkbiasvar;
            case 'C'        % for BEIDOU satellites
                clk.BDS.t(epoch,1) = t;
                clk.BDS.dT(epoch,prn) = clkbias;
                clk.BDS.sigma_dT(epoch, prn) = clkbiasvar;                
        end
    end
    
    % get current line
    tline = fgetl(fid);
end

fclose(fid);        % close file
input.clk.t=clk.GPS.t;
input.clk.dT=[clk.GPS.dT,clk.GAL.dT,clk.BDS.dT];
input.clk.sigma_dT=[clk.GPS.sigma_dT,clk.GAL.sigma_dT,clk.BDS.sigma_dT];
end





