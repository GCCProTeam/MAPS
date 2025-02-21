function [] = PlotGALGFixIC(GALP1SD,GALP2SD,GALL1SD,GALL2SD)
%Plot multipath of GFixIC for GAL

%INPUT:
%GALP1SD: Multipath data for GAL P1 
%GALP2SD: Multipath data for GAL P2 
%GALL1SD: Multipath data for GAL L1 
%GALL2SD: Multipath data for GAL L2 

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
for i=1:36
    x=[1:2880]';
    y=GALP1SD(:,i);
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
    ylabel('GALP1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:36
    x=[1:2880]';
    y=GALP2SD(:,i);
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
    ylabel('GALP5 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-4 4]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end

for i=1:36
    x=[1:2880]';
    y=GALL1SD(:,i);
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
    ylabel('GALL1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end

for i=1:36
    x=[1:2880]';
    y=GALL2SD(:,i);
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
    ylabel('GALL5 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-1 1]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
end