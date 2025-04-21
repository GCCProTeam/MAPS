function [UDIF]=readUDIFMHM(settings,udif_ipath)
%Reading GNSS undifferenced and ionosphere_free (UDIF) residuals
%for MHM modeling

%INPUT:
%settings: settings of modeling parameters
%udif_ipath: relative path of UDIF residual file

%OUTPUT
%UDIF: UDIF residuals

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
%List all .udifres files in the specified directory
list_udif=dir([udif_ipath '/*.udifres']);
len=length(list_udif);

%Process GPS data if enabled in settings
if settings.sys.gps==1
   %For GPS, the previous day's data  is used for modeling.
   if len<1
      error('For GPS, MHM modeling needs at least one udifres file!!!');  
   end 

   %Initialize cell arrays for GPS L1 residuals
   UDIF.L1=cell(1,1); 

   %Read UDIF residual file of the previous day's data
   pathname=[list_udif(len).folder '\']; 
   filename=list_udif(len).name;
   fid=fopen(strcat(pathname,filename),'rt' );
   [UDIF.L1{1,1},~]=readGPSRes(fid,filename);

   %Convert cell arrays to matrices for output
   UDIF.L1=cell2mat(UDIF.L1{1,1});
end

%Process GLONASS data if enabled in settings
if settings.sys.glo==1
   %For GLO, the first eight days of data to be corrected are used for modeling.
   if len<8
      error('For GLONASS, MHM modeling needs at least eight udifres files!!!');  
   end

   UDIF.G1=cell(8,1);

   for i=(len-7):len
       pathname=[list_udif(i).folder '\']; 
       filename=list_udif(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.G1{i-(len-8)},~]=readGLORes(fid,filename);
   end

   for j=1:8
       UDIF.G1{j,1}=cell2mat(UDIF.G1{j,1});
   end

   UDIF.G1=cell2mat(UDIF.G1);
end

% Process Galileo data if enabled in settings
if settings.sys.gal==1
   %For GAL, the first ten days of data to be corrected are used for modeling.
   if len<10
      error('For Galileo, MHM modeling needs at least ten udifres files!!!');  
   end

   UDIF.E1=cell(10,1);  

   for i=(len-9):len
       pathname=[list_udif(i).folder '\']; 
       filename=list_udif(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.E1{i-(len-10)},~]=readGALRes(fid,filename);
   end

   for j=1:10
       UDIF.E1{j,1}=cell2mat(UDIF.E1{j,1});
   end

   UDIF.E1=cell2mat(UDIF.E1);
end

% Process BDS data if enabled in settings
if settings.sys.bds==1
   %For BDS, the first seven days of data to be corrected are used for modeling.
   if len<7
      error('For BDS, MHM modeling needs at least seven udifres files!!!');  
   end 

   UDIF.B1I=cell(7,1); 

   for i=(len-6):len
       pathname=[list_udif(i).folder '\']; 
       filename=list_udif(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.B1I{i-(len-7)},~,~,~]=readBDSRes(fid,filename);
   end

   for j=1:7
       UDIF.B1I{j,1}=cell2mat(UDIF.B1I{j,1});
   end
   
   UDIF.B1I=cell2mat(UDIF.B1I);
end
end