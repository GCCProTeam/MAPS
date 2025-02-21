function [] = plotBDSGFIC(model)
%Plot multipath of GFIC for BDS

%INPUT:
%model: structure containing multipath of GFIC for BDS

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize matrices to store BeiDou multipath data for B1C, B2a, 
% B1I, B2I, and B3I frequencies
BDSF1=zeros(2880,46);
BDSF2=zeros(2880,46);
BDSF3=zeros(2880,46);
BDSF4=zeros(2880,46);
BDSF5=zeros(2880,46);
for i=2:2880
    BDSMultipath=model.BDSMultipath(i);
    length=size(BDSMultipath{1, 1});
    for j=1:length(1)
        BDSF1(i,j)=BDSMultipath{1, 1}(j,1);
        BDSF2(i,j)=BDSMultipath{1, 1}(j,2);
        BDSF3(i,j)=BDSMultipath{1, 1}(j,3);
        BDSF4(i,j)=BDSMultipath{1, 1}(j,4);
        BDSF5(i,j)=BDSMultipath{1, 1}(j,5);
    end
end
% Plot BeiDou B1C multipath time series for each satellite
for i=1:46
    x=[1:2880]';
    y=BDSF1(:,i);
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
    ylabel('BDSB1C MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end
% Plot BeiDou B2a multipath time series for each satellite
for i=1:46
    x=[1:2880]';
    y=BDSF2(:,i);
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
    ylabel('BDSB2a MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
% Plot BeiDou B1I multipath time series for each satellite
for i=1:46
    x=[1:2880]';
    y=BDSF3(:,i);
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
    ylabel('BDSB1I MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
% Plot BeiDou B2I multipath time series for each satellite
for i=1:46
    x=[1:2880]';
    y=BDSF4(:,i);
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
    ylabel('BDSB2I MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
% Plot BeiDou B3I multipath time series for each satellite
for i=1:46
    x=[1:2880]';
    y=BDSF5(:,i);
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
    ylabel('BDSB3I MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);   
end
end