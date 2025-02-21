function [] = plotGPSGFIC(model)
%Plot multipath of GFIC for GPS

%INPUT:
%model: structure containing multipath of GFIC for GPS

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize matrices to store GPS multipath data for L1, L2, and L5 frequencies
GPSF1=zeros(2880,32);
GPSF2=zeros(2880,32);
GPSF3=zeros(2880,32);
for i=2:2880
    GPSMultipath=model.GPSMultipath(i);
    length=size(GPSMultipath{1, 1});
    for j=1:length(1)
        GPSF1(i,j)=GPSMultipath{1, 1}(j,1);
        GPSF2(i,j)=GPSMultipath{1, 1}(j,2);
        GPSF3(i,j)=GPSMultipath{1, 1}(j,3);
    end
end
% Plot GPS L1 multipath time series for each satellite
for i=1:32
    x=[1:2880]';
    y=GPSF1(:,i);
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
    ylabel('GPSL1 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end
 % Plot GPS L2 multipath time series for each satellite
for i=1:32
    x=[1:2880]';
    y=GPSF2(:,i);
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
    ylabel('GPSL2 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);    
end
 % Plot GPS L5 multipath time series for each satellite
for i=1:32
    x=[1:2880]';
    y=GPSF3(:,i);
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
    ylabel('GPSL5 MP [m]', 'FontSize', 20)
    xlim([0 2881]);  
    ylim([-2 2]);   
    box on;
    grid on;
    set(gca,'FontSize',20);
end
end