function [iono] = calIon(input,az,el,Ttr,sv)
%Calculate ionospheric delay in meters for different satellite systems
 
%INPUT:
%input: A structure containing receiver information and Klobuchar coefficients
%az: Azimuth angle of the satellite in radians
%el: Elevation angle of the satellite in radians
%Ttr: Signal transmission time
%sv: Satellite number (used to determine the satellite system)

%OUTPUT:
%iono: A 1x5 array containing ionospheric delay values for different frequencies

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
%Ionospheric delay[m]
% Calculate ionospheric delay using the Klobuchar model for GPS
% Convert receiver latitude and longitude from radians to degrees
iono=[0,0,0,0,0];
iono(1) = ionoKlobuchar(input.rec_BLH.ph*(180/pi), input.rec_BLH.la*(180/pi), ...
    az, el, Ttr, input.klob_coeff);
if sv<=32
   % GPS satellites (G01 to G32)
   iono(2) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.GPS_F2^2 );
   iono(3) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.GPS_F5^2 );
elseif sv<=68
    % Galileo satellites (E01 to E36)
   iono(1) = iono(1) * (CONST_EARTH.GPS_F1^2 / CONST_EARTH.GAL_F1^2 );
   iono(2) = iono(1) * (CONST_EARTH.GPS_F1^2 / CONST_EARTH.GAL_F5a^2 );
else
     % BeiDou satellites (C01 to C46)
   iono(1) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.BDS_F1C^2 );
   iono(2) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.BDS_F2a^2 );
   iono(3) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.BDS_F1I^2 );
   iono(4) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.BDS_F2I^2 );
   iono(5) = iono(1) * (CONST_EARTH.GPS_F1^2 /CONST_EARTH.BDS_F3I^2 );
end
end