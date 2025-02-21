function []=plot3DSky(L1,L5,line,flag,model,type1,type2,Tsat)
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
ax1=axes;
len=size(L1);
for i=1:len/1
    az=L1(i,1);el=L1(i,2);
    if line==3 %flag stands for phase column or code column.
       value=L1(i,line)*1000;
    elseif line==4
       value=L1(i,line);
    end
    Mataz=[az,az;
        az+1.0,az+1.0];
    Matel=[el,el+1.0;
        el,el+1.0];
    X1=sind(pi/2-Matel).*cosd(2*pi-Mataz);
    Y1=sind(pi/2-Matel).*sind(2*pi-Mataz);
    Z1=cosd(pi/2-Matel);
    C =zeros(2,2)+value;
    s1=surf(ax1,X1,Y1,Z1,C,'FaceColor','flat');
    hold on;
end
set(ax1,'Position',[-0.05,0.01,0.53,0.7]);
s1.EdgeAlpha=0.1;
axis off;
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
       caxis([-3, 3]); 
       c1.Ticks = [-3, -2, -1, 0, 1, 2, 3];
       c1.TickLabels = {'<-3', '-2', '-1','0', '1', '2', '>3'}; 
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
set(c1, 'Position', [0.1,0.85,0.8,0.05]); 
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


ax2=axes;
len=size(L5);
for i=1:len/1
   az=L5(i,1);el=L5(i,2);
    if line==3 %flag stands for phase column or code column.
       value=L5(i,line)*1000;
    elseif line==4
       value=L5(i,line);
    end
    Mataz=[az,az;
        az+1.0,az+1.0];
    Matel=[el,el+1.0;
        el,el+1.0];
    X1=sind(pi/2-Matel).*cosd(2*pi-Mataz);
    Y1=sind(pi/2-Matel).*sind(2*pi-Mataz);
    Z1=cosd(pi/2-Matel);
    C =zeros(2,2)+value;
    s2=surf(ax2,X1,Y1,Z1,C,'FaceColor','flat');hold on;

end
set(ax2,'Position',[0.45,0.01,0.53,0.7]);
s2.EdgeAlpha=0.5;
axis off;
ax2.CLim=[0,1.5];

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
       caxis([-0.3, 0.3]); 
       c1.Ticks = [-0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3];
       c1.TickLabels = {'<-0.3', '-0.2', '-0.1','0', '0.1', '0.2', '>0.3'}; 
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
set(c1,'Position',[0.1,0.85,0.8,0.05]);
set(c1,'FontName','Arial','FontSize',10);
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



