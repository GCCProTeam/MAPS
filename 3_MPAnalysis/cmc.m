function CMC=cmc(L1,C1,L2,C2,f1,f2,ARC)
%Computes CMC multipath values for GNSS data

%INPUT:
%L1: Phase observation value of the first frequency
%C1: Code observation value of the first frequency
%L2: Phase observation value of the second frequency
%C2: Code observation value of the second frequency
%f1: Frequency of L1
%f2: Frequency of L2
%ARC: Cell array containing arc information for each satellite

%Output:
%CMC: Cell array containing CMC values for each epoch and satellite

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
   
 % Speed of light in meters per second
    c = 299792458;

    % Convert carrier phase measurements from cycles to meters
    L1 = c * L1 / f1;
    L2 = c * L2 / f2;

    % Number of satellites
    s = size(L1, 2);

    % Initialize CMC matrix
    CMC1 = zeros(2880, 3);

    % Loop through each satellite
    for i = 1:s
        % Get arc information for the current satellite
        arc = ARC{i};
        [arc_n, ~] = size(arc);

        % Loop through each arc for the current satellite
        for j = 1:arc_n
            % Extract L1, C1, L2, and C2 measurements for the current arc
            L_1 = L1(arc(j, 1):arc(j, 2), i);
            C_1 = C1(arc(j, 1):arc(j, 2), i);
            L_2 = L2(arc(j, 1):arc(j, 2), i);
            C_2 = C2(arc(j, 1):arc(j, 2), i);

            % Compute pre-CMC values for the current arc
            [CMC1(arc(j, 1):arc(j, 2), i), ind] = pre_cmc(L_1, C_1, L_2, C_2, f1, f2);

            % Remove the mean value from the CMC values
            ave = sum(CMC1(arc(j, 1):arc(j, 2), i)) / ind;
            CMC1(arc(j, 1):arc(j, 2), i) = CMC1(arc(j, 1):arc(j, 2), i) - ave;
        end
    end

    % Initialize output cell array
    CMC = cell(2880, 1);

    % Organize CMC values into the output cell array
    for i = 1:size(CMC1, 1)
        for j = 1:size(CMC1, 2)
            % Assign satellite ID and CMC values based on the number of satellites
            if size(L1, 2) == 32
                CMC{i}(j, 1:6) = [0, 0, j, 0, 0, CMC1(i, j)];
            elseif size(L1, 2) == 36
                CMC{i}(j, 1:6) = [0, 0, j + 32, 0, 0, CMC1(i, j)];
            elseif size(L1, 2) == 46
                CMC{i}(j, 1:6) = [0, 0, j + 68, 0, 0, CMC1(i, j)];
            end
        end

        % Remove rows with zero or NaN values
        index = CMC{i}(:, 6) == 0;
        CMC{i}(index, :) = [];
        rowsWithNaN = any(isnan(CMC{i}), 2);
        CMC{i}(rowsWithNaN, :) = [];
    end
end

%% --------------------------- Subfunction ---------------------------
function [CMC_pre, ind] = pre_cmc(L1, C1, L2, C2, f1, f2)
%pre_cmc - Computes preliminary CMC values for a given arc.

%INPUT:
%L1: Phase observation value of the first frequency
%C1: Code observation value of the first frequency
%L2: Phase observation value of the second frequency
%C2: Code observation value of the second frequency
%f1: Frequency of L1
%f2: Frequency of L2

%OUTPUT:
%CMC_pre: Preliminary CMC values for the arc
%ind: Number of valid measurements in the arc

%Copyright (C) GCC Group
%--------------------------------------------------------------------------

    % Initialize variables
    ind = 0;
    CMC_pre = zeros(size(L1, 1), 1);

    % Loop through each measurement in the arc
    for i = 1:size(L1, 1)
        % Check if all measurements are valid
        if L1(i, 1) ~= 0 && L2(i, 1) ~= 0 && C1(i, 1) ~= 0 && C2(i, 1) ~= 0
            ind = ind + 1;

            % Compute CMC value using the formula
            A = (f1^2 + f2^2) / (f1^2 - f2^2);
            B = 2 * f2^2 / (f1^2 - f2^2);
            CMC_pre(i, 1) = C1(i, 1) - A * L1(i, 1) + B * L2(i, 1);
        else
            % Assign zero for invalid measurements
            CMC_pre(i, 1) = 0;
        end
    end
end


