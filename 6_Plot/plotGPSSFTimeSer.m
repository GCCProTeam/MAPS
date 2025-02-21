function []=plotGPSSFTimeSer(MAT,line,freq)
%Plots GPS satellite phase or code multipath time series

%INPUT:
%MAT: Cell array containing data for each satellite
%line: Integer (3 or 4) to specify whether to plot phase or code multipath
%freq: Integer (1 or 2) to specify the frequency

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Create a figure with a specific position and size
figure('Position', [100, 100, 1000, 500]);
for i=1:size(MAT,1)
    %Create a subplot for each satellite
    subplot(8,4,i);
    if line==3
       scatter(MAT{i}(:,1), MAT{i}(:,3)*100, 'b.','SizeData', 10);
    elseif line==4
       scatter(MAT{i}(:,1), MAT{i}(:,4), 'b.','SizeData', 10);
    end
    title(num2str(i));
    if line==3
       ylim([-2,2]);
    elseif line==4
       ylim([-2,2]);
    end    
    xlim([0,86400]);
    ax = gca;
    ax.Box = 'on';
    if i==13
        if line==3
            ylabel('Phase multipath (cm)');
        elseif line==4
            ylabel('Code multipath (m)');
        end
    end
    if i==1||i==5||i==9||i==13||i==17||i==21||i==25||i==29
        yticks(-2:2:2); 
    else
        yticks([]);
    end
    if i==29||i==30||i==31||i==32
        xlabel('Epoch (s)');
        xticks(0:14400:86400); 
     else
        xticks([]);
    end
end
% Set the super title based on the type of data and frequency band
if line==3
    if freq==1
       sgtitle('Phase multipath of each GPS satellite L1');
    elseif freq==2
       sgtitle('Phase multipath of each GPS satellite L2');
    end
elseif line==4
   if freq==1
      sgtitle('Code multipath of each GPS satellite L1');
   elseif freq==2
      sgtitle('Code multipath of each GPS satellite L2');
   end
end
end





