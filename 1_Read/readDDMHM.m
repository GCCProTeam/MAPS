function [fixedSD,floatSD]=readDDMHM(settings,dd_ipath)
%Reading GNSS double-differenced (DD) residuals for MHM modeling, 
%and convert DD residuals into single-differenced (SD) residuals.

%INPUT:
%settings: settings of modeling parameters
%dd_ipath: relative path of DD residual file

%OUTPUT
%SD.fix: SD residuals of fixed solution
%SD.float: SD residuals of float solution

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
%List all .ddres files in the specified directory
list_dd=dir([dd_ipath '/*.ddres']);
len=length(list_dd);

%Process GPS data if enabled in settings
if settings.sys.gps==1
   %For GPS, the previous day's data is used for modeling.
   if len<1
      error('For GPS, MHM modeling needs at least one ddres file!!!');  
   end 

   %Initialize cell arrays for GPS L1 and L2 residuals
   DD.L1=cell(1,1); 
   DD.L2=cell(1,1);

   %Read DD residual file of the previous day's data
   pathname=[list_dd(len).folder '\']; 
   filename=list_dd(len).name;
   fid=fopen(strcat(pathname,filename),'rt' );
   [DD.L1{1,1},DD.L2{1,1}]=readGPSRes(fid,filename);

   %Convert DD residuals to SD residuals
   SD.L1{1,1}=dd2sd(DD.L1{1,1});
   SD.L2{1,1}=dd2sd(DD.L2{1,1});

   %Extract fixed and float SD residuals
   [fixedSD.L1{1,1},floatSD.L1{1,1}]=extrFixedSDRes(SD.L1{1,1});
   [fixedSD.L2{1,1},floatSD.L2{1,1}]=extrFixedSDRes(SD.L2{1,1});

   %Convert cell arrays to matrices for output
   fixedSD.L1=cell2mat(fixedSD.L1);
   fixedSD.L2=cell2mat(fixedSD.L2);
   floatSD.L1=cell2mat(floatSD.L1);
   floatSD.L2=cell2mat(floatSD.L2);
end

%Process GLONASS data if enabled in settings
if settings.sys.glo==1
   %For GLO, the first eight days of data to be corrected are used for modeling.
   if len<8
      error('For GLONASS, MHM modeling needs at least eight ddres files!!!');  
   end

   DD.G1=cell(8,1);  SD.G1=cell(8,1); 
   DD.G2=cell(8,1);  SD.G2=cell(8,1);

   for i=(len-7):len
       pathname=[list_dd(i).folder '\']; 
       filename=list_dd(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.G1{i-(len-8)},DD.G2{i-(len-8)}]=readGLORes(fid,filename);
   end

   for j=1:8
       SD.G1{j,1}=dd2sd(DD.G1{j,1});
       SD.G2{j,1}=dd2sd(DD.G2{j,1});
       [fixedSD.G1{j,1},floatSD.G1{j,1}]=extrFixedSDRes(SD.G1{j,1});
       [fixedSD.G2{j,1},floatSD.G2{j,1}]=extrFixedSDRes(SD.G2{j,1});
   end

   fixedSD.G1=cell2mat(fixedSD.G1);
   fixedSD.G2=cell2mat(fixedSD.G2);
   floatSD.G1=cell2mat(floatSD.G1);
   floatSD.G2=cell2mat(floatSD.G2);
end

% Process Galileo data if enabled in settings
if settings.sys.gal==1
   %For GAL, the first ten days of data to be corrected are used for modeling.
   if len<10
      error('For Galileo, MHM modeling needs at least ten ddres files!!!');  
   end

   DD.E1=cell(10,1);  SD.E1=cell(10,1); 
   DD.E5a=cell(10,1);  SD.E5a=cell(10,1);

   for i=(len-9):len
       pathname=[list_dd(i).folder '\']; 
       filename=list_dd(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.E1{i-(len-10)},DD.E5a{i-(len-10)}]=readGALRes(fid,filename);
   end

   for j=1:10
       SD.E1{j,1}=dd2sd(DD.E1{j,1});
       SD.E5a{j,1}=dd2sd(DD.E5a{j,1});
       [fixedSD.E1{j,1},floatSD.E1{j,1}]=extrFixedSDRes(SD.E1{j,1});
       [fixedSD.E5a{j,1},floatSD.E5a{j,1}]=extrFixedSDRes(SD.E5a{j,1});
   end

   fixedSD.E1=cell2mat(fixedSD.E1);
   fixedSD.E5a=cell2mat(fixedSD.E5a);
   floatSD.E1=cell2mat(floatSD.E1);
   floatSD.E5a=cell2mat(floatSD.E5a);
end

% Process BDS data if enabled in settings
if settings.sys.bds==1
   %For BDS, the first seven days of data to be corrected are used for modeling.
   if len<7
      error('For BDS, MHM modeling needs at least seven ddres files!!!');  
   end 

   DD.B1I=cell(7,1);  SD.B1I=cell(7,1); 
   DD.B3I=cell(7,1);  SD.B3I=cell(7,1);
   DD.B1C=cell(7,1);  SD.B1C=cell(7,1); 
   DD.B2a=cell(7,1);  SD.B2a=cell(7,1);

   for i=(len-6):len
       pathname=[list_dd(i).folder '\']; 
       filename=list_dd(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.B1I{i-(len-7)},DD.B3I{i-(len-7)},DD.B1C{i-(len-7)},...
       DD.B2a{i-(len-7)}]=readBDSRes(fid,filename);
   end

   for j=1:7
       SD.B1I{j,1}=dd2sd(DD.B1I{j,1});
       SD.B3I{j,1}=dd2sd(DD.B3I{j,1});
       SD.B1C{j,1}=dd2sd(DD.B1C{j,1});
       SD.B2a{j,1}=dd2sd(DD.B2a{j,1});
       [fixedSD.B1I{j,1},floatSD.B1I{j,1}]=extrFixedSDRes(SD.B1I{j,1});
       [fixedSD.B3I{j,1},floatSD.B3I{j,1}]=extrFixedSDRes(SD.B3I{j,1});
       [fixedSD.B1C{j,1},floatSD.B1C{j,1}]=extrFixedSDRes(SD.B1C{j,1});
       [fixedSD.B2a{j,1},floatSD.B2a{j,1}]=extrFixedSDRes(SD.B2a{j,1});
   end
   
   fixedSD.B1I=cell2mat(fixedSD.B1I);
   fixedSD.B3I=cell2mat(fixedSD.B3I);
   fixedSD.B1C=cell2mat(fixedSD.B1C);
   fixedSD.B2a=cell2mat(fixedSD.B2a);
   floatSD.B1I=cell2mat(floatSD.B1I);
   floatSD.B3I=cell2mat(floatSD.B3I);
   floatSD.B1C=cell2mat(floatSD.B1C);
   floatSD.B2a=cell2mat(floatSD.B2a);
end
end