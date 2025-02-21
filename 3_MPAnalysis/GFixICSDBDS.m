function [BDSP1SD,BDSP2SD,BDSL1SD,BDSL2SD] = GFixICSDBDS(model,EleMin)
%Computes single-difference (SD) values for BDS code and phase measurements

%Inputs:
%model: Structure containing BDS code and phase measurements
%EleMin: Minimum elevation angle threshold for valid measurements

%Outputs:
%BDSP1SD: Single-difference values for BDS P1 code measurements
%BDSP2SD: Single-difference values for BDS P2 code measurements
%BDSL1SD: Single-difference values for BDS L1 phase measurements
%BDSL2SD: Single-difference values for BDS L2 phase measurements

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize output matrices
    BDSP1SD = zeros(2880, 46);
    BDSP2SD = zeros(2880, 46);
    BDSL1SD = zeros(2880, 46);
    BDSL2SD = zeros(2880, 46);

    % Compute single-difference for P1 and P2 code measurements
    for i = 1:2880
        Code = model.BDSCode(i, 1); % Extract code measurements for the current epoch
        Ele = Code{1, 1}(:, 3);    % Extract elevation angles
        EleMaxIndex = find(Ele == max(Ele)); % Find the index of the satellite with the highest elevation

        for j = 1:46
            if j == EleMaxIndex
                continue; % Skip the reference satellite
            end
            if Code{1, 1}(j, 1) == 0
                continue; % Skip invalid P1 measurements
            else
                BDSP1SD(i, j) = Code{1, 1}(EleMaxIndex, 1) - Code{1, 1}(j, 1); % Compute P1 single-difference
            end
            if Code{1, 1}(j, 2) == 0
                continue; % Skip invalid P2 measurements
            else
                BDSP2SD(i, j) = Code{1, 1}(EleMaxIndex, 2) - Code{1, 1}(j, 2); % Compute P2 single-difference
            end
        end
    end

    % Compute single-difference for L1 phase measurements
    start = 1;
    startFlag = 0;
    for i = 1:2881
        if i < 2881
            Phase = model.BDSPhase(i, 1); % Extract phase measurements for the current epoch
            Ele = Phase{1, 1}(:, 3);     % Extract elevation angles
            EleMaxIndex = find(Ele == max(Ele)); % Find the index of the satellite with the highest elevation
        end

        for j = 1:46
            if (i > 1 && EleMaxIndex ~= LastRefSat) || (i == 2881)
                % Remove NaN values and adjust for reference satellite change
                BDSL1SD(isnan(BDSL1SD)) = 0;
                A = BDSL1SD(start:i-1, j);
                nonZeroElements = A(A ~= 0);
                if isempty(nonZeroElements)
                    continue;
                end
                meanNonZero = mean(nonZeroElements); % Compute mean of non-zero elements
                result = zeros(size(A));
                result(A ~= 0) = nonZeroElements - meanNonZero; % Adjust for mean
                A = result;
                BDSL1SD(start:i-1, j) = A;
                startFlag = 1;
            end
            if i == 2881
                continue; % Skip the last iteration
            end
            if Phase{1, 1}(j, 1) == 0
                continue; % Skip invalid L1 measurements
            else
                if max(Ele) < EleMin
                    continue; % Skip measurements below the elevation threshold
                end
                BDSL1SD(i, j) = Phase{1, 1}(EleMaxIndex, 1) - Phase{1, 1}(j, 1); % Compute L1 single-difference
            end
        end

        if startFlag
            start = i; % Update the start index for the next segment
        end
        startFlag = 0;
        LastRefSat = EleMaxIndex; % Store the current reference satellite
    end

    % Compute single-difference for L2 phase measurements
    start = 1;
    startFlag = 0;
    for i = 1:2881
        if i < 2881
            Phase = model.BDSPhase(i, 1); % Extract phase measurements for the current epoch
            Ele = Phase{1, 1}(:, 3);     % Extract elevation angles
            EleMaxIndex = find(Ele == max(Ele)); % Find the index of the satellite with the highest elevation
        end

        for j = 1:46
            if (i > 1 && EleMaxIndex ~= LastRefSat) || (i == 2881)
                % Remove NaN values and adjust for reference satellite change
                BDSL2SD(isnan(BDSL2SD)) = 0;
                A = BDSL2SD(start:i-1, j);
                nonZeroElements = A(A ~= 0);
                if isempty(nonZeroElements)
                    continue;
                end
                meanNonZero = mean(nonZeroElements); % Compute mean of non-zero elements
                result = zeros(size(A));
                result(A ~= 0) = nonZeroElements - meanNonZero; % Adjust for mean
                A = result;
                BDSL2SD(start:i-1, j) = A;
                startFlag = 1;
            end
            if i == 2881
                continue; % Skip the last iteration
            end
            if Phase{1, 1}(j, 2) == 0
                continue; % Skip invalid L2 measurements
            else
                if max(Ele) < EleMin
                    continue; % Skip measurements below the elevation threshold
                end
                BDSL2SD(i, j) = Phase{1, 1}(EleMaxIndex, 2) - Phase{1, 1}(j, 2); % Compute L2 single-difference
            end
        end

        if startFlag
            start = i; % Update the start index for the next segment
        end
        startFlag = 0;
        LastRefSat = EleMaxIndex; % Store the current reference satellite
    end
end