function [] = plotGALGFIC(model)
%Plot multipath of GFIC for GAL

%INPUT:
%model: structure containing multipath of GFIC for GAL

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
 % Initialize matrices to store Galileo multipath data for E1 and E5a frequencies
GALF1=zeros(2880,36);
GALF2=zeros(2880,36);
for i=2:2880
    GALMultipath=model.GALMultipath(i);
    length=size(GALMultipath{1, 1});
    for j=1:length(1)
        GALF1(i,j)=GALMultipath{1, 1}(j,1);
        GALF2(i,j)=GALMultipath{1, 1}(j,2);
    end
end
 % Plot Galileo E1 multipath time series for each satellite
for i=1:36
    x=[1:2880]';
    y=GALF1(:,i);
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
    ylabel('GALE1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end
 % Plot Galileo E5a multipath time series for each satellite
for i=1:36
    x=[1:2880]';
    y=GALF2(:,i);
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
    ylabel('GALE5 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
end