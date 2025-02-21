function [dT_clk] = satelliteClockBrdc(sv, t,Ttr, input, isGPS, isGAL, isBDS)
%Calculate (precise satellite) clock.

%INPUT:
%sv: satellite vehicle number
%t: gpstime
%Ttr: transmission time (GPStime)
%input: Containing several input data (Ephemerides, etc...)
%isGPS: boolean, GPS-satellite
%isGAL: boolean, Galileo-satellite
%isBDS: boolean, BeiDou-satellite

%OUTPUT:
%dT_clk: satellite clock correction, [s]

%Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------
%% Preparations
if isGPS
        Eph = input.Eph_GPS;

        idx_sat = find(Eph(1,:) == sv);   	 % columns of satellites
        Eph_sat = Eph(:, idx_sat);          % broadcast data satellite
         % look for column of current satellite in brdc ephemeris
        if ~isempty(idx_sat)                    % check if satellite is included in Broadcast-Ephemeris
            r_toc = 21;             % row of time-stamp
            dt_eph = abs(t - Eph_sat(r_toc,:));      % diff. transmission time to times of satellite ephemeris
            k = idx_sat(dt_eph == min(dt_eph)); 	% column of ephemeris, take nearest
            if ~isempty(k)
                k = k(1);                           % in case of multiple suitable datasets take first
            end
        end

        toe  = Eph(18,k);   % time of ephemeris, [seconds of week]
        toc  = Eph(21,k);   % time of clock, [seconds of week]
elseif isGAL  
        Eph = input.Eph_GAL;
        idx_sat = find(Eph(1,:) == sv);   	 % columns of satellites
        Eph_sat = Eph(:, idx_sat);          % broadcast data satellite
         % look for column of current satellite in brdc ephemeris
        if ~isempty(idx_sat)                    % check if satellite is included in Broadcast-Ephemeris
            r_toc = 21;             % row of time-stamp
            dt_eph = abs(t - Eph_sat(r_toc,:));      % diff. transmission time to times of satellite ephemeris
            k = idx_sat(dt_eph == min(dt_eph)); 	% column of ephemeris, take nearest
            if ~isempty(k)
                k = k(1);                           % in case of multiple suitable datasets take first
            end
        end

        toe = Eph(18,k);
        toc = Eph(21,k);
elseif isBDS
        Eph = input.Eph_BDS;
        idx_sat = find(Eph(1,:) == sv);   	 % columns of satellites
        Eph_sat = Eph(:, idx_sat);          % broadcast data satellite
         % look for column of current satellite in brdc ephemeris
        if ~isempty(idx_sat)                    % check if satellite is included in Broadcast-Ephemeris
            r_toc = 21;             % row of time-stamp
            dt_eph = abs(t - Eph_sat(r_toc,:));      % diff. transmission time to times of satellite ephemeris
            k = idx_sat(dt_eph == min(dt_eph)); 	% column of ephemeris, take nearest
            if ~isempty(k)
                k = k(1);                           % in case of multiple suitable datasets take first
            end
        end        
        toe = Eph(18,k);
        toc = Eph(21,k);
end

    % --- calculate clock correction from navigation message
    % coefficients for navigation clock correction
    if isGPS || isGAL || isBDS
        a2 = Eph(2,k);        a1 = Eph(20,k);        a0 = Eph(19,k);
        % if isBDS; Ttr = Ttr - 14; end       % somehow necessary to convert GPST to BDT, ||| check!!!
        dT = check_t(Ttr - toc);            % time difference between transmission time and time of clock
        dT_clk = a2*dT^2 + a1*dT + a0;      % 2nd degree polynomial clock correctionyou
    end
    
end


