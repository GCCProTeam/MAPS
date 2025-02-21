function [SD] = dd2sd(DD)
% Conversion from double-differenced (DD) Residual to
% single-differenced (SD) Residual

% INPUT:
% DD: DD Residual

% OUTPUT:
% SD: SD Residual

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize a cell array to store the single-differenced data
SD = cell(size(DD, 1), 1);
    
% Loop through each row of the input cell array DD
for i = 1:size(DD, 1)
    % Skip if the current cell has fewer than 2 rows
    if size(DD{i}, 1) <= 1
       continue; 
    end
        
    % Extract the current data matrix from the cell
    vv = DD{i}; 
        
    % Find the reference satellite (the one with the highest elevation)
    [~, refer] = max(vv(:, 6)); % Marked reference satellite
    satNum = vv(refer, 3);         % Satellite PRN number
    az = vv(refer, 5);          % Azimuth of the reference satellite
    el = vv(refer, 6);          % Elevation of the reference satellite
    cn0 = vv(refer, 9);         % Carrier-to-noise density ratio of the 
                                % reference satellite
        
    % Remove the reference satellite from the data matrix
    vv(refer, :) = [];
        
    % Get the number of remaining satellites
    n = size(vv, 1);
        
    % Construct the design matrix D for single-difference calculation
    D = [(sind([el, vv(:, 6)'])).^2; [ones(n, 1), -eye(n)]];
        
    % Construct the observation matrix L
    L = [0, 0; vv(:, 7:8)];
        
    % Solve for the single-difference parameters using least squares
    X = D \ L;
        
    % Store the results in the SD cell array
    SD{i} = [vv(1, 1) * ones(n + 1, 1), ...  % Time tag
             vv(1, 2) * ones(n + 1, 1), ...  
             [satNum; vv(:, 3)], ...         % Satellite PRN numbers
             vv(1, 4) * ones(n + 1, 1), ...  % Satellite valid flag
             [[az, el]; vv(:, 5:6)], ...     % Azimuth and elevation
             X, ...                          % Single-difference parameters
             [cn0; vv(:, 9)], ...            % Carrier-to-noise density ratio
             vv(1, 10) * ones(n + 1, 1)];    % Solution state (1: fixed 2: float)
end 
end