function [B,L]=xyz2blh(X,Y,Z)
%Convert XYZ coordinate system to BLH coordinate system

%INPUT:
%X, Y, Z: Satellite position in ECEF coordinates (meters)

%OUTPUT:
%B: Geodetic latitude [degree]
%L: Geodetic longitude [degree]

%Copyright (C) Yangling  2008/3/25
%Adapted by GCC Group
%--------------------------------------------------------------------------
%% ----------------------------------------------------------------------
a_WGS84 = 6378137.0000;	% earth semimajor axis in meters
b_WGS84 = 6356752.3142;	% earth semiminor axis in meters
ECCENTRICITY = sqrt (1-(b_WGS84/a_WGS84).^2);
e2 = ECCENTRICITY^2;        % e^2  flattening 
L=atan2(Y,X);
b0=atan(Z/sqrt(X^2+Y^2));
e=1.0e10;
while(e>0.00001/206265)
	W=sqrt(1-e2*(sin(b0)^2));
	M=a_WGS84*(1-e2)/(W^3);
	N=a_WGS84/W;
	nq=b0;
	b0=atan((Z+N*e2*sin(b0))/sqrt(X^2+Y^2));
	e=abs(b0-nq);
end
B=b0;
H=sqrt(X^2+Y^2)/cos(B)-N;
B=rad2deg_GT(B);
L=rad2deg_GT(L);
end
