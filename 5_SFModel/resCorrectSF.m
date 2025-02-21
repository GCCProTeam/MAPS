function  v_correct8 = resCorrectSF(v_recon7,period)
% According to the input residual data sequence and orbit period, 
% the correction value is calculated

% INPUT:
% v_recon7: a cell array containing reconstructed data for each satellite
% period: A vector containing the orbital periods for each satellite

% OUTPUT:
% v_correct8: a cell array containing the corrected data for each satellite

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the output cell array with the same size as the input
v_correct8 = cell( size(v_recon7,1),1 );
max_sat=size(v_recon7,1);

for i=1:max_sat
    if(~isempty(v_recon7{i}) && period(i,1)~=0)
        v1 = v_recon7{i};  
        % Adjust the time values to be within a 24-hour range (86400 seconds)
        v1(:,1)=round( v1(:,1)-86400*floor(v1(:,1)/86400) );
        v1_trans=v1;
        % Adjust the time values by subtracting the orbital period
        v1_trans(:,1)=v1_trans(:,1)-period(i,1);
        % Store the corrected data in the output cell array
        v_correct8{i}=v1_trans;
    end
end
end
