function []=plotCMCSky(sys,MAT,k)
%Plot CMC sky map

%INPUT:
%sys: Symbol of system
%MAT: CMC values
%k: satellite number

%Copyright (C) GCC Group
%--------------------------------------------------------------------------

figure;
% Create polar axes
pax1=polaraxes;
% Convert azimuth from degrees to radians and invert the direction
theta=MAT(:,4)*pi/(-180);
 % Convert elevation to a range of [0, 1] for radial distance
rou=MAT(:,5)/(-90)+1;
% Extract the values to be plotted
value1=MAT(:,6);
polarscatter(pax1,theta,rou,3,value1,'filled','s');hold on;
set(pax1,'rlim',[0,1]);
set(pax1,'rtick',[0,0.333,0.666,1]);
set(pax1,'rticklabel',{'90','60','30','0'},'FontName','Arial','FontSize',10);
set(pax1,'layer','top');
set(pax1,'ThetaTick',[0,30,60,90,120,150,180,210,240,270,300,330]);
set(pax1,'thetaticklabels',{'0','330','300','270','240','210','180','150','120','90','60','30'},'FontName','Arial','FontSize',10);
pax1.ThetaZeroLocation='top';
set(pax1,'Position',[0.25,0.35,0.5,0.5]);
%grid minor;
colormap("jet"); 
c1 = colorbar;
c1.Location = 'South'; 
caxis([-1.0,1.0]);
c1.Ticks=[-1.0,-0.5,0,0.5,1.0]; 
c1.TickLabels={'<-1.0','-0.5','0','0.5','>1.0'};
c1.Label.String = 'Unit: m'; 
c1.TickLength = 0.02;
% Adjust the position and font of the colorbar
set(c1, 'Position', [0.10, 0.1, 0.8, 0.05]); 
set(c1, 'FontName', 'Arial', 'FontSize', 10); 
% Determine the title based on the system type and data
if sys==1
   if numel(unique(MAT(:, 3))) ~= 1&&~isempty(MAT)
      title('CMC of GPS ','Color','b');
   else
       title(sprintf('CMC of G%02d', k), 'Color', 'b'); 
   end 
elseif sys==2
   if numel(unique(MAT(:, 3))) ~= 1&&~isempty(MAT)
      title('CMC of GAL ','Color','b');
   else
       title(sprintf('CMC of E%02d', k), 'Color', 'b'); 
   end 
elseif sys==3
    if numel(unique(MAT(:, 3))) ~= 1&&~isempty(MAT)
      title('CMC of BDS ','Color','b');
    else
       title(sprintf('CMC of C%02d', k), 'Color', 'b'); 
   end 
end
end




