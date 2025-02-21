% Class for all relevant geodetic constants

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

classdef CONST_EARTH
      
    properties (Constant = true)
         %% Constants for all GNSS
        F0 = 10.23*10^6;         % fundamental frequency of GPS and Galileo
        
        
        %% GPS specific Parameters
        % Frequency [Hz]
        GPS_F1 = 154 * CONST_EARTH.F0;
        GPS_F2 = 120 * CONST_EARTH.F0;
        GPS_F5 = 115 * CONST_EARTH.F0;
        %GPS_F  = [Const.GPS_F1 Const.GPS_F2 Const.GPS_F5 0];
        
        %% GALILEO specific Parameters c.f. GALILEO ICD 2010
        % frequency [Hz]
        GAL_F1  = 154   * CONST_EARTH.F0;
        GAL_F5a = 115   * CONST_EARTH.F0;
        GAL_F5b = 118   * CONST_EARTH.F0;
        %GAL_F5  = 116.5 * Const.F0;
        %GAL_F6  = 125   * Const.F0;
        %GAL_F   = [Const.GAL_F1 Const.GAL_F5a Const.GAL_F5b Const.GAL_F5 Const.GAL_F6 0];
      
        
        %% BEIDOU specific Parameters c.f. RINEX v3 specification
        % frequency [Hz]
        BDS_F1I = 1561.098 * 1e6;        % B1I
        BDS_F2I = 1207.14  * 1e6;        % B2I
        BDS_F3I = 1268.52  * 1e6;        % B3I
        BDS_F1C = 154 * CONST_EARTH.F0;        % B1C
        BDS_F2a = 115 * CONST_EARTH.F0;        % B2a
        %BDS_F2b = 118 * Const.F0;        % B2b
        %BDS_F  = [Const.BDS_F1I Const.BDS_F2I Const.BDS_F3I Const.BDS_F1C Const.BDS_F2a Const.BDS_F2b 0];
       
        % Earth rotation rate, [rad/s], [22]: Table 1.5
        WE = 7.2921151467e-5; 
        %% Reference systems
        % WGS84 parameters
        WGS84_A = 6378137.0;             % semimajor axis [m]
        WGS84_E_SQUARE = 6.69437999013 * 10^(-3);
        WGS84_B = CONST_EARTH.WGS84_A*sqrt(1-CONST_EARTH.WGS84_E_SQUARE);
        %WGS84_F = 1/298.257223563;       % flattening of ellipsoid
        %WGS84_WE = 7292115 * 10^(-11);   % Angular velocity of earth [rad/s]
        %WGS84_GM = 3986004.418 * 10^8;   % earth's gravitytional constant 
        % PZ90.2 according to GLONASS ICD 2008
        %PZ90_GM = 398600.4418e9;       	% earth's univ. gravitational constant [m^3/s^2]
        %PZ90_J20 = 1082625.75e-9;
        %PZ90_C20 = -Const.PZ90_J20;
        %PZ90_A = 6378136;                % Earth's equatorial radius
        %PZ90_WE = 7.292115e-5;           % Earth's rotation rate (z-component of vector omega)[1/s]
    end      % end of properties
    
%     Example method:
%     methods (Static = true, Access = public)
%         function return_var = function_name(input_var)
%             return_var = f(input_var)
%         end
%     end
end
