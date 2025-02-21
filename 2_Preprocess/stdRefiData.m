function stdre_MAT = stdRefiData(MAT, x)
% Refinement of the matrix based on standard deviation (STD)

% INPUT:
% MAT: input matrix to be refined
% x: column index in the matrix to apply the refinement

% OUTPUT:
% stdre_MAT: refined matrix

% Copyright (C) GCC Group
%--------------------------------------------------------------------------

% Calculate the STD and mean of the specified column
std_L = std(MAT(:, x));  % STD of the column
mean_L = mean(MAT(:, x));  % Mean of the column

% Remove rows where the absolute deviation from the mean exceeds 3 times
% the STD
MAT(abs(MAT(:,x)-mean_L)>3*std_L,:)=[]; %delete gross errors
stdre_MAT=MAT;

end