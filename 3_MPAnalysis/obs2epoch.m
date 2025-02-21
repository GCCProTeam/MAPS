function [Epoch]=obs2epoch(obs,input)
%Converts observation data into epoch-wise structured data for GPS, GAL,
%and BDS satellites

%INPUT:
%obs: Observation data structure containing GPS, GAL, and BDS measurements
%input: Additional input parameters (not used in this function but included
%for compatibility)

%OUTPUT:
%Epoch: Structured data containing code, phase, satellite IDs, week,
% and time information

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Loop through each time epoch
for i=1:size(obs.Time,1)
    % Process GPS satellites
    for j=1:DEF.SATS_GPS
        Epoch.code{i,1}(j,1:3)=[obs.GPS.C1(i,j),obs.GPS.C2(i,j),obs.GPS.C5(i,j)];%L1/L2/L5
        Epoch.code{i,1}(j,7)=j;
        Epoch.phase{i,1}(j,1:3)=[obs.GPS.L1(i,j),obs.GPS.L2(i,j),obs.GPS.L5(i,j)];%L1/L2/L5 PHASE
        Epoch.phase{i,1}(j,7)=j;
    end
     % Process Galileo satellites
    for j=1:DEF.SATS_GAL
        Epoch.code{i,1}(j+DEF.SATS_GPS,1:3)=[obs.GAL.C1(i,j),obs.GAL.C5a(i,j),obs.GAL.C5b(i,j)];%E1/E5a/E5b
        Epoch.code{i,1}(j+DEF.SATS_GPS,7)=j+DEF.SATS_GPS;
        Epoch.phase{i,1}(j+DEF.SATS_GPS,1:3)=[obs.GAL.L1(i,j),obs.GAL.L5a(i,j),obs.GAL.L5b(i,j)];%E1/E5a/E5b
        Epoch.phase{i,1}(j+DEF.SATS_GPS,7)=j+DEF.SATS_GPS;
    end
    % Process BDS satellites
    for j=1:DEF.SATS_BDS
        Epoch.code{i,1}(j+DEF.SATS_GPS+DEF.SATS_GAL,1:5)=[obs.BDS.C1C(i,j),obs.BDS.C2a(i,j),...
            obs.BDS.C1I(i,j),obs.BDS.C2I(i,j),obs.BDS.C3I(i,j)];%B1C/B2a/B1I/B2I/B3I
        Epoch.code{i,1}(j+DEF.SATS_GPS+DEF.SATS_GAL,7)=j+DEF.SATS_GPS+DEF.SATS_GAL;
        Epoch.phase{i,1}(j+DEF.SATS_GPS+DEF.SATS_GAL,1:5)=[obs.BDS.L1C(i,j),obs.BDS.L2a(i,j),...
            obs.BDS.L1I(i,j),obs.BDS.L2I(i,j),obs.BDS.L3I(i,j)];%B1C/B2a/B1I/B2I/B3I
        Epoch.phase{i,1}(j+DEF.SATS_GPS+DEF.SATS_GAL,7)=j+DEF.SATS_GPS+DEF.SATS_GAL;
    end
    rowsToDelete = all((Epoch.code{i,1}(:, 1:5) == 0) | isnan(Epoch.code{i,1}(:, 1:5)), 2);
    Epoch.code{i,1}(rowsToDelete, :) = [];
    Epoch.phase{i,1}(rowsToDelete, :) = [];
    Epoch.sat{i,1}=Epoch.code{i,1}(:,7);
    Epoch.code{i,1}=Epoch.code{i,1}(:,1:5);
    Epoch.phase{i,1}=Epoch.phase{i,1}(:,1:5);
end

% Loop through each epoch to further process satellite data
for i=1:size(Epoch.sat,1)
    sv=Epoch.sat{i};
    L=Epoch.phase{i};
    P=Epoch.code{i};
    Epoch.sat{i}=sv;
    Epoch.phase{i}=L;
    Epoch.code{i}=P;
end
% Add week, seconds of week (sow), and GPS time to the Epoch structure
Epoch.week=obs.Week;
Epoch.sow=obs.Time;
Epoch.gps_time = obs.Time;
end

