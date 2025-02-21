function [UDUC,UDUC1]=readUDUCSF(settings,uduc_ipath)
%Reading GNSS undifferenced and uncombined (UDUC) residuals for SF modeling

%INPUT:
%settings: settings of modeling parameters
%uduc_ipath: relative path of UDUC residual file

%OUTPUT
%UDUC: UDUC residuals

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
    UDUC=[];   UDUC1=[];
    list_uduc=dir([uduc_ipath '/*.uducres']); 
    len=length(list_uduc);
    if settings.sys.gps==1
       %Modeling SF of GPS/GEO/IGSO using the data of the 10th day.
       pathname=[list_uduc(len-1).folder '\']; 
       filename=list_uduc(len-1).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.L1,UDUC.L2]=readGPSRes(fid,filename);
       if settings.model.SFWin==0
          UDUC.L1=cell2mat(UDUC.L1);
          UDUC.L2=cell2mat(UDUC.L2);
       elseif settings.model.SFWin==1
          for k=1:size(UDUC.L1,1)
              UDUC.L1{k}(:,11)=var(UDUC.L1{k}(:,7));
              UDUC.L1{k}(:,12)=var(UDUC.L1{k}(:,8));
          end 
          for k=1:size(UDUC.L2,1)
              UDUC.L2{k}(:,11)=var(UDUC.L2{k}(:,7));
              UDUC.L2{k}(:,12)=var(UDUC.L2{k}(:,8));
          end 
          UDUC.L1=cell2mat(UDUC.L1);
          UDUC.L2=cell2mat(UDUC.L2);

          pathname=[list_uduc(len).folder '\']; 
          filename=list_uduc(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDUC1.L1,UDUC1.L2]=readGPSRes(fid,filename);
          for k=1:size(UDUC1.L1,1)
              UDUC1.L1{k}(:,11)=var(UDUC1.L1{k}(:,7));
              UDUC1.L1{k}(:,12)=var(UDUC1.L1{k}(:,8));
          end 
          for k=1:size(UDUC1.L2,1)
              UDUC1.L2{k}(:,11)=var(UDUC1.L2{k}(:,7));
              UDUC1.L2{k}(:,12)=var(UDUC1.L2{k}(:,8));
          end 
          UDUC1.L1=cell2mat(UDUC1.L1);
          UDUC1.L2=cell2mat(UDUC1.L2);
       end
    end
    if settings.sys.bds==1
       pathname=[list_uduc(len-7).folder '\']; 
       filename=list_uduc(len-7).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.B1I_1,UDUC.B3I_1,~,~]=readBDSRes(fid,filename);
       
       pathname=[list_uduc(len-1).folder '\']; 
       filename=list_uduc(len-1).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.B1I_7,UDUC.B3I_7,~,~]=readBDSRes(fid,filename);
       if settings.model.SFWin==0
          UDUC.B1I_1=cell2mat(UDUC.B1I_1);
          UDUC.B1I_7=cell2mat(UDUC.B1I_7);
          UDUC.B3I_1=cell2mat(UDUC.B3I_1);
          UDUC.B3I_7=cell2mat(UDUC.B3I_7); 
       elseif settings.model.SFWin==1
          for k=1:size(UDUC.B1I_1,1)
              UDUC.B1I_1{k}(:,11)=var(UDUC.B1I_1{k}(:,7));
              UDUC.B1I_1{k}(:,12)=var(UDUC.B1I_1{k}(:,8));
          end 
          for k=1:size(UDUC.B3I_1,1)
              UDUC.B3I_1{k}(:,11)=var(UDUC.B3I_1{k}(:,7));
              UDUC.B3I_1{k}(:,12)=var(UDUC.B3I_1{k}(:,8));
          end  
          for k=1:size(UDUC.B1I_7,1)
              UDUC.B1I_7{k}(:,11)=var(UDUC.B1I_7{k}(:,7));
              UDUC.B1I_7{k}(:,12)=var(UDUC.B1I_7{k}(:,8));
          end 
          for k=1:size(UDUC.B3I_7,1)
              UDUC.B3I_7{k}(:,11)=var(UDUC.B3I_7{k}(:,7));
              UDUC.B3I_7{k}(:,12)=var(UDUC.B3I_7{k}(:,8));
          end 
          UDUC.B1I_1=cell2mat(UDUC.B1I_1);
          UDUC.B1I_7=cell2mat(UDUC.B1I_7);
          UDUC.B3I_1=cell2mat(UDUC.B3I_1);
          UDUC.B3I_7=cell2mat(UDUC.B3I_7);

          pathname=[list_uduc(len).folder '\']; 
          filename=list_uduc(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDUC1.B1I,UDUC1.B3I,~,~]=readBDSRes(fid,filename);
          for k=1:size(UDUC1.B1I,1)
              UDUC1.B1I{k}(:,11)=var(UDUC1.B1I{k}(:,7));
              UDUC1.B1I{k}(:,12)=var(UDUC1.B1I{k}(:,8));
          end 
          for k=1:size(UDUC1.B3I,1)
              UDUC1.B3I{k}(:,11)=var(UDUC1.B3I{k}(:,7));
              UDUC1.B3I{k}(:,12)=var(UDUC1.B3I{k}(:,8));
          end  
          UDUC1.B1I=cell2mat(UDUC1.B1I);
          UDUC1.B3I=cell2mat(UDUC1.B3I);
       end
    end
    if settings.sys.gal==1
       %Modeling SF of GPS using the data of the 1st day.
       pathname=[list_uduc(len-10).folder '\']; 
       filename=list_uduc(len-10).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [UDUC.E1,UDUC.E5a]=readGALRes(fid,filename);
       if settings.model.SFWin==0
          UDUC.E1=cell2mat(UDUC.E1);
          UDUC.E5a=cell2mat(UDUC.E5a);
       elseif settings.model.SFWin==1
          for k=1:size(UDUC.E1,1)
              UDUC.E1{k}(:,11)=var(UDUC.E1{k}(:,7));
              UDUC.E1{k}(:,12)=var(UDUC.E1{k}(:,8));
          end 
          for k=1:size(UDUC.E5a,1)
              UDUC.E5a{k}(:,11)=var(UDUC.E5a{k}(:,7));
              UDUC.E5a{k}(:,12)=var(UDUC.E5a{k}(:,8));
          end 
          UDUC.E1=cell2mat(UDUC.E1);
          UDUC.E5a=cell2mat(UDUC.E5a);
          pathname=[list_uduc(len).folder '\']; 
          filename=list_uduc(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [UDUC1.E1,UDUC1.E5a]=readGALRes(fid,filename);
          for k=1:size(UDUC1.E1,1)
              UDUC1.E1{k}(:,11)=var(UDUC1.E1{k}(:,7));
              UDUC1.E1{k}(:,12)=var(UDUC1.E1{k}(:,8));
          end 
          for k=1:size(UDUC1.E5a,1)
              UDUC1.E5a{k}(:,11)=var(UDUC1.E5a{k}(:,7));
              UDUC1.E5a{k}(:,12)=var(UDUC1.E5a{k}(:,8));
          end 
          UDUC1.E1=cell2mat(UDUC1.E1);
          UDUC1.E5a=cell2mat(UDUC1.E5a);
       end
    end 
end