function CMC=matchAZEL(CMC,input,obs)
%Matches azimuth and elevation data to the corresponding data

%Inputs:
%CMC: Cell array containing satellite data with placeholders for azimuth and elevation
%input: Structure containing azimuth and elevation data for each satellite
%obs: Structure containing observation data, including week and time

%Output:
%CMC: Updated cell array with matched azimuth and elevation data

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Loop through each row in the CMC cell array
for i=1:size(CMC,1)
    % Loop through each satellite entry in the current row of CMC
    for j=1:size(CMC{i},1)
        % Extract the satellite vehicle number (SV)
        sv=CMC{i}(j,3);
        CMC{i}(j,1)=obs.Week(i);
        CMC{i}(j,2)=obs.Time(i);
        CMC{i}(j,4)=input.az(i,sv);
        CMC{i}(j,5)=input.el(i,sv);
    end
end
end