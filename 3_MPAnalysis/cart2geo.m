function x = cart2geo(XYZ)
%Performs transformation from cartesian xyz to phi, lambda, h of WGS84

%INPUT:
%XYZ: vector, cartesian X,Y,Z-coordinate [m] (WGS84) 

%OUTPUT:
%x: struct with ellipsoidal coordinates
 %x.ph: phi, latitude [rad]
 %x.la: lambda, longitude [rad]
 %x.h: ellipsoidal height [m]

%Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------
% Extract X, Y, Z coordinates from the input vector
X = XYZ(1);
Y = XYZ(2);
Z = XYZ(3);
% Check for zero coordinates to avoid division by zero
if X == 0 || Y == 0 || Z == 0
    x.ph = 0; x.la = 0; x.h = 0;
end
% Define WGS84 ellipsoid parameters
a = CONST_EARTH.WGS84_A;
b = CONST_EARTH.WGS84_B;
e = sqrt(CONST_EARTH.WGS84_E_SQUARE);
e_strich = sqrt((a^2-b^2)/b^2);
% Calculate intermediate values
p = sqrt(X^2+Y^2);
theta = atan((Z*a)/(p*b));
% Calculate latitude (phi) using iterative formula    
x.ph = atan((Z+e_strich^2*b*(sin(theta))^3)/(p-e^2*a*(cos(theta))^3));
% Calculate longitude (lambda) using atan2 for correct quadrant handling
x.la = atan2(Y,X);

N = a^2/sqrt(a^2*cos(x.ph)^2+b^2*sin(x.ph)^2);
% Calculate ellipsoidal height (h)
x.h = p/cos(x.ph)-N;
