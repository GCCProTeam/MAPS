function rad=deg2rad_GT(deg)
% deg2rad_GT  Converts decimal degrees to radians. Vectorized.

% Input:   
% deg: vector of angles in decimal degrees

% Output:  
% rad: vector of angles in radians

% Copyright (C) 2011, Michael R. Craymer
%Adapted by GCC Group
%--------------------------------------------------------------------------

rad=deg.*pi./180;
end
