function [Ttr,X,V] = calSatPos(sv,gpstime,tau,input)
%Calculates satellite position and velocity at a given transmission time

%INPUT:
%sv: satellite vehicle number
%gpstime: GPS time at reception (seconds of week)
%tau: Signal travel time (seconds)
%input: Structure containing broadcast ephemeris and SP3 precise ephemeris

%OUTPUT:
%Ttr: transmission time (GPStime)
%X: vector with XYZ coordinates
%V: vector with XYZ velocities

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Check if the satellite is GPS (PRN 1-32)
if sv<=32 
   prn=sv;
   Ttr = gpstime - tau;
    % Calculate satellite clock correction
   [dT_clk] = satelliteClockBrdc(prn, gpstime, Ttr, input, 1, 0, 0);
   preciseEph = input.sp3gps;
   Ttr = gpstime - tau - dT_clk;
    % Calculate satellite position and velocity
   [X, V] = precSatpos(preciseEph, prn, Ttr);

   % Check if the satellite is GALILEO (PRN 33-68)
elseif sv>32&&sv<=68
     prn=sv-32;
     Ttr = gpstime - tau;
     [dT_clk] = satelliteClockBrdc(prn, gpstime, Ttr, input, 0, 1, 0);
     Ttr = gpstime - tau - dT_clk;
     preciseEph = input.sp3gal;
     [X, V] = precSatpos(preciseEph, prn, Ttr);

% Otherwise, assume the satellite is BEIDOU (PRN 69+)
else
     prn=sv-68;       
     Ttr = gpstime - tau;
     [dT_clk] = satelliteClockBrdc(prn, gpstime, Ttr, input, 0, 0, 1);
     Ttr = gpstime - tau - dT_clk;
     preciseEph = input.sp3bds;
     [X, V] = precSatpos(preciseEph, prn, Ttr);
end
end