function [UDUC]=readUDUCMHM(settings,uduc_ipath)
%Reading GNSS undifferenced and uncombined (UDUC) residuals for MHM modeling

%INPUT:
%settings: settings of modeling parameters
%uduc_ipath: relative path of UDUC residual file

%OUTPUT
%UDUC: UDUC residuals

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
%List all .uducres files in the specified directory    
list_uduc=dir([uduc_ipath '/*.uducres']);    
len=length(list_uduc);

%Process GPS data if enabled in settings
if settings.sys.gps==1
   %For GPS, the previous day's data  is used for modeling.
   if len<1
      error('For GPS, MHM modeling needs at least one uducres file!!!');  
   end 

   %Initialize cell arrays for GPS L1 and L2 residuals
   UDUC.L1=cell(1,1); 
   UDUC.L2=cell(1,1); 

   %Read UDUC residual file of the previous day's data
   pathname=[list_uduc(len).folder '\']; 
   filename=list_uduc(len).name;
   fid=fopen(strcat(pathname,filename),'rt' );
   [UDUC.L1{1,1},UDUC.L2{1,1}]=readGPSRes(fid,filename);

   %Convert cell arrays to matrices for output
   UDUC.L1=cell2mat(UDUC.L1{1,1});
   UDUC.L2=cell2mat(UDUC.L2{1,1});
end

%Process GLONASS data if enabled in settings
if settings.sys.glo==1
   %For GLO, the first eight days of data to be corrected are used for modeling.
   if len<8
      error('For GLONASS, MHM modeling needs at least eight uducres files!!!');  
   end

   UDUC.G1=cell(8,1);  
   UDUC.G2=cell(8,1); 

   for i=(len-7):len
       pathname=[list_uduc(i).folder '\']; 
       filename=list_uduc(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.G1{i-(len-8)},UDUC.G2{i-(len-8)}]=readGLORes(fid,filename);
   end

   for i=1:8
       UDUC.G1{i,1}=cell2mat(UDUC.G1{i,1});
       UDUC.G2{i,1}=cell2mat(UDUC.G2{i,1});
   end

   UDUC.G1=cell2mat(UDUC.G1);
   UDUC.G2=cell2mat(UDUC.G2);
end

% Process Galileo data if enabled in settings
if settings.sys.gal==1
   %For GAL, the first ten days of data to be corrected are used for modeling.
   if len<10
      error('For Galileo, MHM modeling needs at least ten uducres files!!!');  
   end

   UDUC.E1=cell(10,1);  
   UDUC.E5a=cell(10,1);  

   for i=(len-9):len
       pathname=[list_uduc(i).folder '\']; 
       filename=list_uduc(i).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.E1{i-(len-10)},UDUC.E5a{i-(len-10)}]=readGALRes(fid,filename);
   end

   for i=1:10
       UDUC.E1{i,1}=cell2mat(UDUC.E1{i,1});
       UDUC.E5a{i,1}=cell2mat(UDUC.E5a{i,1});
   end

   UDUC.E1=cell2mat(UDUC.E1);
   UDUC.E5a=cell2mat(UDUC.E5a);
end
if settings.sys.bds==1
   %For BDS, the first seven days of data to be corrected are used for modeling.
   if len<7
      error('For BDS, MHM modeling needs at least seven uducres files!!!');  
   end 

   UDUC.B1I=cell(7,1);  
   UDUC.B3I=cell(7,1); 

   for i=(len-6):len
        pathname=[list_uduc(i).folder '\']; 
        filename=list_uduc(i).name;
        fid=fopen(strcat(pathname,filename),'rt' );
        [UDUC.B1I{i-(len-7)},UDUC.B3I{i-(len-7)},~,~]=readBDSRes(fid,filename);
   end

   for i=1:7
       UDUC.B1I{i,1}=cell2mat(UDUC.B1I{i,1});
       UDUC.B3I{i,1}=cell2mat(UDUC.B3I{i,1});
   end
   
   UDUC.B1I=cell2mat(UDUC.B1I);
   UDUC.B3I=cell2mat(UDUC.B3I);
end
end