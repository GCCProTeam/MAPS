function [UDIF,UDIF1]=readUDIFSF(settings,udif_ipath)
%Reading GNSS undifferenced and ionosphere_free (UDIF) residuals
%for SF modeling

%INPUT:
%settings: settings of modeling parameters
%udif_ipath: relative path of UDIF residual file

%OUTPUT
%UDIF: UDIF residuals

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
    UDIF=[];   UDIF1=[];
    list_udif=dir([udif_ipath '/*.udifres']); 
    len=length(list_udif);
    if settings.sys.gps==1
       %Modeling SF of GPS/GEO/IGSO using the data of the 10th day.
       pathname=[list_udif(len-1).folder '\']; 
       filename=list_udif(len-1).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.L1,~]=readGPSRes(fid,filename);
       if settings.model.SFWin==0
          UDIF.L1=cell2mat(UDIF.L1); 
       elseif settings.model.SFWin==1
          for k=1:size(UDIF.L1,1)
              UDIF.L1{k}(:,11)=var(UDIF.L1{k}(:,7));
              UDIF.L1{k}(:,12)=var(UDIF.L1{k}(:,8));
          end 
          UDIF.L1=cell2mat(UDIF.L1);

          pathname=[list_udif(len).folder '\']; 
          filename=list_udif(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDIF1.L1,~]=readGPSRes(fid,filename);
          for k=1:size(UDIF1.L1,1)
              UDIF1.L1{k}(:,11)=var(UDIF1.L1{k}(:,7));
              UDIF1.L1{k}(:,12)=var(UDIF1.L1{k}(:,8));
          end 
          UDIF1.L1=cell2mat(UDIF1.L1);
       end
    end
    if settings.sys.bds==1
       pathname=[list_udif(len-7).folder '\']; 
       filename=list_udif(len-7).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.B1I_1,~,~,~]=readBDSRes(fid,filename);
       
       pathname=[list_udif(len-1).folder '\']; 
       filename=list_udif(len-1).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.B1I_7,~,~,~]=readBDSRes(fid,filename);
       if settings.model.SFWin==0
          UDIF.B1I_1=cell2mat(UDIF.B1I_1);
          UDIF.B1I_7=cell2mat(UDIF.B1I_7);
       elseif settings.model.SFWin==1
          for k=1:size(UDIF.B1I_1,1)
              UDIF.B1I_1{k}(:,11)=var(UDIF.B1I_1{k}(:,7));
              UDIF.B1I_1{k}(:,12)=var(UDIF.B1I_1{k}(:,8));
          end 
          for k=1:size(UDIF.B1I_7,1)
              UDIF.B1I_7{k}(:,11)=var(UDIF.B1I_7{k}(:,7));
              UDIF.B1I_7{k}(:,12)=var(UDIF.B1I_7{k}(:,8));
          end 
          UDIF.B1I_1=cell2mat(UDIF.B1I_1);
          UDIF.B1I_7=cell2mat(UDIF.B1I_7);
          pathname=[list_udif(len).folder '\']; 
          filename=list_udif(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDIF1.B1I,~,~,~]=readBDSRes(fid,filename);
          for k=1:size(UDIF1.B1I,1)
              UDIF1.B1I{k}(:,11)=var(UDIF1.B1I{k}(:,7));
              UDIF1.B1I{k}(:,12)=var(UDIF1.B1I{k}(:,8));
          end 
          UDIF1.B1I=cell2mat(UDIF1.B1I);
       end
    end
    if settings.sys.gal==1
       %Modeling SF of GPS using the data of the 1st day.
       pathname=[list_udif(len-10).folder '\']; 
       filename=list_udif(len-10).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDIF.E1,~]=readGALRes(fid,filename);
       if settings.model.SFWin==0
          UDIF.E1=cell2mat(UDIF.E1);
       elseif settings.model.SFWin==1
          for k=1:size(UDIF.E1,1)
              UDIF.E1{k}(:,11)=var(UDIF.E1{k}(:,7));
              UDIF.E1{k}(:,12)=var(UDIF.E1{k}(:,8));
          end 
          UDIF.E1=cell2mat(UDIF.E1);
          
          pathname=[list_udif(len).folder '\']; 
          filename=list_udif(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDIF1.E1,~]=readGALRes(fid,filename);
          for k=1:size(UDIF1.E1,1)
              UDIF1.E1{k}(:,11)=var(UDIF1.E1{k}(:,7));
              UDIF1.E1{k}(:,12)=var(UDIF1.E1{k}(:,8));
          end 
          UDIF1.E1=cell2mat(UDIF1.E1);
       end
    end 
end