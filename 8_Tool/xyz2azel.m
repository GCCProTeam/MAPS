function[E,A]=xyz2azel(pos_r,X,Y,Z)
%Converts satellite position from ECEF coordinates to 
%azimuth (A) and elevation (E) angles

%INPUT:
%pos_r: Receiver position in ECEF coordinates [X; Y; Z] (meters)
%X, Y, Z: Satellite position in ECEF coordinates (meters)

%OUTPUT:
%E: Elevation [degree]
%A: Azimuth [degree]

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Extract receiver coordinates
sx=pos_r(1);
sy=pos_r(2);
sz=pos_r(3);

% Convert receiver position from ECEF to geodetic coordinates (latitude, longitude)
[sb,sl]=xyz2blh(sx,sy,sz);
sb=deg2rad_GT(sb);
sl=deg2rad_GT(sl);

% Transition matrix (XYZ to NEU: North-East-Up)
T=[-sin(sb)*cos(sl) -sin(sb)*sin(sl) cos(sb);
    -sin(sl)               cos(sl)         0;
    cos(sb)*cos(sl) cos(sb)*sin(sl)  sin(sb)];%transition matrix(XYZ to NEU)
deta_xyz=[X,Y,Z]-[sx,sy,sz];

% Transform the vector from ECEF to NEU coordinates
NEU=T*(deta_xyz)';

E=atan(NEU(3)/sqrt(NEU(1)*NEU(1)+NEU(2)*NEU(2)));

A=atan(abs(NEU(2)/NEU(1)));
if NEU(1)>0
    if NEU(2)>0
    else
        A=2*pi-A;
    end
else
    if NEU(2)>0
        A=pi-A;
    else
        A=pi+A;
    end 
end
E=rad2deg_GT(E);
A=rad2deg_GT(A);
end
