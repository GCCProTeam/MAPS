function []=plotGPSCMCTimeSer(MAT)
%Plot CMC time series figure of GPS

%INPUT:
%MAT:Matrix containing CMC values and epochs

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
figure('Position', [100, 100, 1000, 500]);
for i=1:size(MAT,1)
    % Create a subplot for each satellite
    subplot(8,4,i);
    % Plot the CMC time series as scatter points
    scatter(MAT{i}(:,2), MAT{i}(:,6), 'b.','SizeData', 10);
    title(num2str(i));
    ylim([-2,2]);
    xlim([0,86400]);
    ax = gca;
    ax.Box = 'on';
    if i==13
        ylabel('CMC (m)');
    end
    % Set y-ticks for specific subplots (leftmost column)
    if i==1||i==5||i==9||i==13||i==17||i==21||i==25||i==29
        yticks(-2:2:2); 
    else
        yticks([]);
    end
     % Set x-ticks and x-label for the bottom row of subplots
    if i==29||i==30||i==31||i==32
        xlabel('Epoch (s)');
        xticks(0:14400:86400); 
     else
        xticks([]);
    end
end
sgtitle('CMC time series of each GPS satellite');
end





