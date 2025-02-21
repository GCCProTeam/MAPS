function [fixedSD, floatSD] = extrFixedSDRes(SD)
%Single-differenced (SD) residuals are divided into two categories: 
%SD residuals of fixed solutions and SD residuals of float solutions

%INPUT:
%SD: All SD residuals, including SD residuals of fixed solutions and 
%SD residuals of float solutions

%OUTPUT:
%fixedSD: SD residuals of fixed solutions
%floatSD: SD residuals of float solutions

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
SD = cell2mat(SD); % Convert input cell array to matrix
    
if isempty(SD)  % Check if the  matrix is empty
   fixedSD = [];
   floatSD = [];
else
   %For DD residuals, when Q is 1, the residuals are fixed solution residuals
   condition = (SD(:, 10) == 1);   
   fixedSD = SD(condition, :);
   floatSD = SD(~condition, :);
end
end