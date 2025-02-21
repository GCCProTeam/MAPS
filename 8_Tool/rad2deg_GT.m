function deg=rad2deg_GT(rad)
% rad2deg_GT  Converts radians to decimal degrees. Vectorized.

% Input:   
% rad: vector of angles in radians

% Output:  
% deg: vector of angles in decimal degrees

% Copyright (C) 2011, Michael R. Craymer
%Adapted by GCC Group
%--------------------------------------------------------------------------
deg=rad.*180./pi;

end
