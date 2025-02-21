function [] = PlotBDSGFixIC(BDSP1SD,BDSP2SD,BDSL1SD,BDSL2SD)
%Plot multipath of GFixIC for BDS

%INPUT:
%BDSP1SD: Multipath data for BDS P1 
%BDSP2SD: Multipath data for BDS P2 
%BDSL1SD: Multipath data for BDS L1 
%BDSL2SD: Multipath data for BDS L2 

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
for i=1:46
    x=[1:2880]';
    y=BDSP1SD(:,i);
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
    ylabel('BDSP1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:46
    x=[1:2880]';
    y=BDSP2SD(:,i);
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
    ylabel('BDSP3 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:46
    x=[1:2880]';
    y=BDSL1SD(:,i);
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
    ylabel('BDSL1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end

for i=1:46
    x=[1:2880]';
    y=BDSL2SD(:,i);
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
    xlabel('Epoch [30s]', 'FontSize', 20)
    ylabel('BDSL3 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);    
end
end