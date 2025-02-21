function [GPSP1SD,GPSP2SD,GPSL1SD,GPSL2SD] = GFixICSDGPS(model,EleMin)
%Calculate GPS single-difference (SD) values for code and phase observations

%INPUT:
%model: A structure containing GPS code and phase observations
%EleMin: Minimum elevation angle threshold (in degrees) for including observations

%OUTPUT:
%GPSP1SD: Single-difference values for GPS P1 code observations (2880x32 matrix).
%GPSP2SD: Single-difference values for GPS P2 code observations (2880x32 matrix).
%GPSL1SD: Single-difference values for GPS L1 phase observations (2880x32 matrix).
%GPSL2SD: Single-difference values for GPS L2 phase observations (2880x32 matrix).

%Notes:
%The function processes 2880 epochs (1 day at 30-second intervals).
%Single-difference values are calculated relative to the satellite with the highest elevation.
%Observations below the minimum elevation angle (`EleMin`) are excluded.

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
 % Initialize output matrices for code single-differences
    GPSP1SD = zeros(2880, 32);
    GPSP2SD = zeros(2880, 32); 

    % Loop through all epochs
    for i = 1:2880
        % Extract code observations for the current epoch
        Code = model.GPSCode(i, 1);
        Ele = Code{1, 1}(:, 3); % Elevation angles for all satellites
        EleMaxIndex = find(Ele == max(Ele)); % Index of the satellite with the highest elevation

        % Loop through all 32 GPS satellites
        for j = 1:32
            if j == EleMaxIndex
                continue; % Skip the reference satellite
            end
            if Code{1, 1}(j, 1) == 0
                continue; % Skip if no P1 observation is available
            else
                % Calculate single-difference for P1 code
                GPSP1SD(i, j) = Code{1, 1}(EleMaxIndex, 1) - Code{1, 1}(j, 1);
            end
            if Code{1, 1}(j, 2) == 0
                continue; % Skip if no P2 observation is available
            else
                % Calculate single-difference for P2 code
                GPSP2SD(i, j) = Code{1, 1}(EleMaxIndex, 2) - Code{1, 1}(j, 2);
            end
        end
    end

    % Initialize output matrices for phase single-differences
    GPSL1SD = zeros(2880, 32); 
    GPSL2SD = zeros(2880, 32); 

    % Process L1 phase observations
    start = 1; % Start index for the current reference satellite
    startFlag = 0; % Flag to indicate a change in the reference satellite
    LastRefSat = 0; % Last reference satellite index
    for i = 1:2881
        if i < 2881
            % Extract phase observations for the current epoch
            Phase = model.GPSPhase(i, 1);
            Ele = Phase{1, 1}(:, 3); % Elevation angles for all satellites
            EleMaxIndex = find(Ele == max(Ele)); % Index of the satellite with the highest elevation
        end

        % Loop through all 32 GPS satellites
        for j = 1:32
            if (i > 1 && EleMaxIndex ~= LastRefSat) || (i == 2881)
                % Handle reference satellite change or end of data
                GPSL1SD(isnan(GPSL1SD)) = 0; % Replace NaN values with 0
                A = GPSL1SD(start:i-1, j); % Extract non-zero elements for the current satellite
                nonZeroElements = A(A ~= 0); % Find non-zero elements
                if isempty(nonZeroElements)
                    continue; % Skip if no valid observations are available
                end
                meanNonZero = mean(nonZeroElements); % Calculate mean of non-zero elements
                result = zeros(size(A)); % Initialize result array
                result(A ~= 0) = nonZeroElements - meanNonZero; % Subtract mean from non-zero elements
                GPSL1SD(start:i-1, j) = result; % Update the single-difference values
                startFlag = 1; % Set flag to indicate a change in reference satellite
            end
            if i == 2881
                continue; % Skip processing for the end-of-loop case
            end
            if Phase{1, 1}(j, 1) == 0
                continue; % Skip if no L1 observation is available
            else
                if max(Ele) < EleMin
                    continue; % Skip if the maximum elevation is below the threshold
                end
                % Calculate single-difference for L1 phase
                GPSL1SD(i, j) = Phase{1, 1}(EleMaxIndex, 1) - Phase{1, 1}(j, 1);
            end
        end

        if startFlag
            start = i; % Update start index for the new reference satellite
        end
        startFlag = 0; % Reset flag
        LastRefSat = EleMaxIndex; % Update last reference satellite index
    end

    % Process L2 phase observations (similar to L1 phase processing)
    start = 1;
    startFlag = 0;
    LastRefSat = 0;
    for i = 1:2881
        if i < 2881
            Phase = model.GPSPhase(i, 1);
            Ele = Phase{1, 1}(:, 3);
            EleMaxIndex = find(Ele == max(Ele));
        end
        for j = 1:32
            if (i > 1 && EleMaxIndex ~= LastRefSat) || (i == 2881)
                GPSL2SD(isnan(GPSL2SD)) = 0;
                A = GPSL2SD(start:i-1, j);
                nonZeroElements = A(A ~= 0);
                if isempty(nonZeroElements)
                    continue;
                end
                meanNonZero = mean(nonZeroElements);
                result = zeros(size(A));
                result(A ~= 0) = nonZeroElements - meanNonZero;
                GPSL2SD(start:i-1, j) = result;
                startFlag = 1;
            end
            if i == 2881
                continue;
            end
            if Phase{1, 1}(j, 2) == 0
                continue;
            else
                if max(Ele) < EleMin
                    continue;
                end
                GPSL2SD(i, j) = Phase{1, 1}(EleMaxIndex, 2) - Phase{1, 1}(j, 2);
            end
        end
        if startFlag
            start = i;
        end
        startFlag = 0;
        LastRefSat = EleMaxIndex;
    end
end