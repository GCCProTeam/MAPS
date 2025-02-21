function []=plot2DSky(L1,L5,line,flag,model,type1,type2,Tsat)
%Plots a 2D sky map

%INPUT:
%L1:MHM of the first frequency
%L5:MHM of the second frequency
%line: Number of columns of residuals used for plotting.
%flag: Flag of residual type (phase or code)
%model: Types of hemispherical models
%type1: Name of the first frequency
%type2: Name of the second frequency
%Tsat: Satellite orbit type (GEO, IGSO, or MEO)

%Copyright (C) GCC Group
%--------------------------------------------------------------------------

figure;
if ~isempty(L1)
% Create polar axes for L1 data
pax1=polaraxes;
% Convert elevation and azimuth to polar coordinates
theta=L1(:,1)*pi/(-180);
rou=L1(:,2)/(-90)+1;

% Extract values based on the selected column (line)
if line==3 %Flag stands for phase column or code column.
   value1=L1(:,line)*1000;
elseif line==4
    value1=L1(:,line);
end

% Plot the scatter plot on polar axes
polarscatter(pax1,theta,rou,3,value1,'filled','s');hold on;
% Set polar axes properties
set(pax1,'rlim',[0,1]);
set(pax1,'rtick',[0,0.333,0.666,1]);
set(pax1,'rticklabel',{'90','60','30','0'},'FontName','Arial','FontSize',10);
set(pax1,'layer','top');
set(pax1,'ThetaTick',[0,30,60,90,120,150,180,210,240,270,300,330]);
set(pax1,'thetaticklabels',{'0','330','300','270','240','210','180','150','120','90','60','30'},'FontName','Arial','FontSize',10);
pax1.ThetaZeroLocation='top';
set(pax1,'Position',[0.05,0.15,0.4,0.4]);
% Set colormap and colorbar
colormap("jet");
c1 = colorbar; 
c1.Location = 'North'; 
if model==1||model==3||model==4
   if line==3
       caxis([-15, 15]); 
       c1.Ticks = [-15, -10,-5, 0, 5, 10, 15];
       c1.TickLabels = {'<-15', '-10', '-5','0', '5', '10', '>15'}; 
       c1.Label.String = 'Unit: mm'; 
       c1.TickLength = 0.02;
   elseif line==4
       caxis([-2, 2]); 
       c1.Ticks = [ -2, -1, 0, 1, 2];
       c1.TickLabels = {'<-2', '-1','0', '1', '>2'}; 
       c1.Label.String = 'Unit: m'; 
       c1.TickLength = 0.02;
   end
elseif model==2
    if line==3
       caxis([0, 1]); 
       c1.Ticks = [0, 0.25,0.5,0.75,1];
       c1.TickLabels = {'0','0.25','0.5','0.75', '>1'}; 
       c1.Label.String = 'Unit: mm'; 
       c1.TickLength = 0.02;
   elseif line==4
       caxis([0, 0.1]); 
       c1.Ticks = [0, 0.025,0.05,0.075,0.1];
       c1.TickLabels = {'0','0.025','0.05','0.075', '>0.1'}; 
       c1.Label.String = 'Unit: m'; 
       c1.TickLength = 0.02;
    end
end
set(c1, 'Position', [0.1,0.8,0.8,0.05]); 
set(c1, 'FontName', 'Arial', 'FontSize', 10); 
if model==1
   title(sprintf('MHM of %s (%s)', flag,type1), 'Color', 'b');  
elseif model==2
   title(sprintf('precision MHM of %s (%s)', flag,type1), 'Color', 'b');   
elseif model==3
   title(sprintf('%s MHM of %s (%s)', Tsat,flag,type1), 'Color', 'b'); 
elseif model==4
    %title(sprintf('Overlap frequency MHM of %s (%s)', flag,type1), 'Color', 'b'); 
   title(['Overlap frequency MHM of ', flag, newline, '(', type1, ')'], 'Color', 'b');
end
end
    
if ~isempty(L5)
pax2=polaraxes;
theta=L5(:,1)*pi/(-180);
rou=L5(:,2)/(-90)+1;
if line==3 %Flag stands for phase column or code column.
   value=L5(:,line)*1000;
elseif line==4
    value=L5(:,line);
end
polarscatter(pax2,theta,rou,3,value,'filled','s');hold on;
set(pax2,'rlim',[0,1]);
set(pax2,'rtick',[0,0.333,0.666,1]);
set(pax2,'rticklabel',{'90','60','30','0'},'FontName','Arial','FontSize',10);
set(pax2,'layer','top');
pax2.ThetaZeroLocation='top';
set(pax2,'ThetaTick',[0,30,60,90,120,150,180,210,240,270,300,330]);
set(pax2,'thetaticklabels',{'0','330','300','270','240','210','180','150','120','90','60','30'},'FontName','Arial','FontSize',10);
set(pax2,'Position',[0.55,0.15,0.4,0.4]);
colormap("jet");
c1=colorbar;
c1.Location='North';
if model==1||model==3||model==4
   if line==3
       caxis([-15, 15]); 
       c1.Ticks = [-15, -10,-5, 0, 5, 10, 15];
       c1.TickLabels = {'<-15', '-10', '-5','0', '5', '10', '>15'}; 
       c1.Label.String = 'Unit: mm'; 
       c1.TickLength = 0.02;
   elseif line==4
       caxis([-2, 2]); 
       c1.Ticks = [ -2, -1, 0, 1, 2];
       c1.TickLabels = {'<-2', '-1','0', '1', '>2'}; 
       c1.Label.String = 'Unit: m'; 
       c1.TickLength = 0.02;
   end
elseif model==2
    if line==3
       caxis([0, 1]); 
       c1.Ticks = [0, 0.25,0.5,0.75,1];
       c1.TickLabels = {'0','0.25','0.5','0.75', '>1'}; 
       c1.Label.String = 'Unit: mm'; 
       c1.TickLength = 0.02;
   elseif line==4
       caxis([0, 0.1]); 
       c1.Ticks = [0, 0.025,0.05,0.075,0.1];
       c1.TickLabels = {'0','0.025','0.05','0.075', '>0.1'}; 
       c1.Label.String = 'Unit: m'; 
       c1.TickLength = 0.02;
    end
end
% Adjust colorbar position and font
set(c1,'Position',[0.1,0.8,0.8,0.05]);
set(c1,'FontName','Arial','FontSize',10);
% Set title based on the model
if model==1
   title(sprintf('MHM of %s (%s)', flag,type2), 'Color', 'b'); 
elseif model==2
   title(sprintf('precision MHM of %s (%s)', flag,type2), 'Color', 'b');  
elseif model==3
   title(sprintf('%s MHM of %s (%s)', Tsat,flag,type2), 'Color', 'b'); 
elseif model==4
   %title(sprintf('Overlap frequency MHM of %s\n (%s)', flag,type2), 'Color', 'b'); 
   title(['Overlap frequency MHM of ', flag, newline, '(', type2, ')'], 'Color', 'b');
end
end
end




