function [] = PlotGPSGFixIC(GPSP1SD,GPSP2SD,GPSL1SD,GPSL2SD)
%Plot multipath of GFixIC for GPS
    
%INPUT:
%GPSP1SD: Multipath data for GPS P1 
%GPSP2SD: Multipath data for GPS P2 
%GPSL1SD: Multipath data for GPS L1 
%GPSL2SD: Multipath data for GPS L2 

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
for i=1:32
    % Prepare data for GPS P1 multipath
    x=[1:2880]';
    y=GPSP1SD(:,i);
    xy=[x y];
    % Remove rows with zero or extreme multipath values
    xy(xy(:,2)==0,:)=[];
    xy(abs(xy(:,2))>5,:)=[];
     % Skip plotting if no valid data is left
    if isempty(xy)
        continue;
    end
    % Create a new figure for the current satellite
    figure
    scatter(xy(:,1),xy(:,2));
    istr=num2str(i);
    h=legend(istr);
    set(h, 'FontSize', 20);
    % Add labels and customize axes
    xlabel('Epoch [30s]', 'FontSize', 20)
    ylabel('GPSP1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:32
    % Prepare data for GPS P2 multipath
    x=[1:2880]';
    y=GPSP2SD(:,i);
    xy=[x y];
    xy(xy(:,2)==0,:)=[];
    xy(abs(xy(:,2))>5,:)=[];
    if isempty(xy)
        continue;
    end
    figure
    scatter(xy(:,1),xy(:,2));
    istr=num2str(i);
    h=legend(istr);
    set(h, 'FontSize', 20);
    xlabel('Epoch [30s]', 'FontSize', 20)
    ylabel('GPSP2 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:32
    % Prepare data for GPS L1 multipath
    x=[1:2880]';
    y=GPSL1SD(:,i);
    xy=[x y];

    xy(xy(:,2)==0,:)=[];
    xy(abs(xy(:,2))>2,:)=[];
    if isempty(xy)
        continue;
    end
    figure
    scatter(xy(:,1),xy(:,2));
    istr=num2str(i);
    h=legend(istr); 
    set(h, 'FontSize', 20);
    xlabel('Epoch [30s]', 'FontSize', 20)
    ylabel('GPSL1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);    
end

for i=1:32
    % Prepare data for GPS L2 multipath
    x=[1:2880]';
    y=GPSL2SD(:,i);
    xy=[x y]; 
    xy(xy(:,2)==0,:)=[];
    xy(abs(xy(:,2))>2,:)=[];
    if isempty(xy)
        continue;
    end
    figure
    scatter(xy(:,1),xy(:,2));
    istr=num2str(i);
    h=legend(istr);
    set(h, 'FontSize', 20);
    xlabel('Epoch [30s]', 'FontSize', 20)
    ylabel('GPSL2 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);    
end
end