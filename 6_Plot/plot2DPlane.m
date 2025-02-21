function []=plot2DPlane(L1,line,flag,model,type,Tsat)
%Plots a 2D sky map

%INPUT:
%L1:MHM
%line: Number of columns of residuals used for plotting.
%flag: Flag of residual type (phase or code)
%model: Types of hemispherical models
%type1: Name of the frequency
%Tsat: Satellite orbit type (GEO, IGSO, or MEO)

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
figure;
set(gcf, 'Position', [100, 100, 600, 400]); 

x = L1(:,1);
y = L1(:,2);
if line==3 %flag stands for phase column or code column.
   val=L1(:,line)*1000;
elseif line==4
    val=L1(:,line);
end

scatter(x, y, 5, val, 'filled', 's');
hold on;
xlabel('Azimuth(°)');
ylabel('Elevation(°)');
xlim([0, 360]);
ylim([0, 90]);
xticks(0:60:360); 
yticks(0:30:90); 
grid on;
ax = gca;
ax.Box = 'on';
colormap("jet"); 
c1 = colorbar; 
c1.Location = 'EastOutside'; 
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
set(c1, 'Position', [0.88, 0.15, 0.02, 0.75]); 
set(c1, 'Ticks', c1.Ticks);
set(gca, 'Position', [0.1, 0.15, 0.75, 0.75]);

if model==1
   title(sprintf('sky plot of %s (%s)', flag,type), 'Color', 'b'); 
elseif model==2
   title(sprintf('precision sky plot of %s (%s)', flag,type), 'Color', 'b');  
elseif model==3
   title(sprintf('%s sky plot of %s (%s)', Tsat,flag,type), 'Color', 'b'); 
elseif model==4
   %title(sprintf('Overlap frequency MHM of %s\n (%s)', flag,type2), 'Color', 'b'); 
   title(['Overlap frequency sky plot of ', flag, newline, '(', type, ')'], 'Color', 'b');
end
end
