function [SD_fix,SD_float,SD1_fix,SD1_float]=readDDSF(settings,dd_ipath) 
%Reading GNSS double-differenced (DD) residuals for SF modeling, 
%and convert DD residuals into single-differenced (SD) residuals.

%INPUT:
%settings: settings of modeling parameters
%dd_ipath: relative path of DD residual file

%OUTPUT
%SD.fix: SD residuals of fixed solution
%SD.float: SD residuals of float solution

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
    SD_fix=[];SD1_fix=[];
    SD_float=[];SD1_float=[];
    
    list_dd=dir([dd_ipath '/*.ddres']); 
    len=length(list_dd);
    %GPS
    if settings.sys.gps==1
       %Read the residual of the day before the day to be corrected.
       pathname=[list_dd(len-1).folder '\']; 
       filename=list_dd(len-1).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.L1,DD.L2]=readGPSRes(fid,filename); 
       SD.L1=dd2sd(DD.L1);
       SD.L2=dd2sd(DD.L2);
       if settings.model.SFWin==0
          [SD_fix.L1,SD_float.L1]=extrFixedSDRes(SD.L1);
          [SD_fix.L2,SD_float.L2]=extrFixedSDRes(SD.L2);
       elseif settings.model.SFWin==1
          for k=1:size(SD.L1,1)
              SD.L1{k}(:,11)=var(SD.L1{k}(:,7));
              SD.L1{k}(:,12)=var(SD.L1{k}(:,8));
          end 
          for k=1:size(SD.L2,1)
              SD.L2{k}(:,11)=var(SD.L2{k}(:,7));
              SD.L2{k}(:,12)=var(SD.L2{k}(:,8));
          end 
          [SD_fix.L1,SD_float.L1]=extrFixedSDRes(SD.L1);
          [SD_fix.L2,SD_float.L2]=extrFixedSDRes(SD.L2);
       % If you choose to establish SF window matching model, 
       % continue to read the residual of the corrected day 
       % (the default last day in the file list is the residual of the corrected day).
          pathname=[list_dd(len).folder '\']; 
          filename=list_dd(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [DD1.L1,DD1.L2]=readGPSRes(fid,filename);
          SD1.L1=dd2sd(DD1.L1);
          SD1.L2=dd2sd(DD1.L2);
          for k=1:size(SD1.L1,1)
              SD1.L1{k}(:,11)=var(SD1.L1{k}(:,7));
              SD1.L1{k}(:,12)=var(SD1.L1{k}(:,8));
          end 
          for k=1:size(SD1.L2,1)
              SD1.L2{k}(:,11)=var(SD1.L2{k}(:,7));
              SD1.L2{k}(:,12)=var(SD1.L2{k}(:,8));
          end 
          [SD1_fix.L1,SD1_float.L1]=extrFixedSDRes(SD1.L1);
          [SD1_fix.L2,SD1_float.L2]=extrFixedSDRes(SD1.L2);
       end
    end
    %GAL
    if settings.sys.gal==1
       %Read the residual of the day 10th before the day to be corrected.
       pathname=[list_dd(len-10).folder '\']; 
       filename=list_dd(len-10).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.E1,DD.E5a]=readGALRes(fid,filename);
       SD.E1=dd2sd(DD.E1);
       SD.E5a=dd2sd(DD.E5a);
       if settings.model.SFWin==0
          [SD_fix.E1,SD_float.E1]=extrFixedSDRes(SD.E1);
          [SD_fix.E5a,SD_float.E5a]=extrFixedSDRes(SD.E5a);
       elseif settings.model.SFWin==1
          for k=1:size(SD.E1,1)
              SD.E1{k}(:,11)=var(SD.E1{k}(:,7));
              SD.E1{k}(:,12)=var(SD.E1{k}(:,8));
          end 
          for k=1:size(SD.E5a,1)
              SD.E5a{k}(:,11)=var(SD.E5a{k}(:,7));
              SD.E5a{k}(:,12)=var(SD.E5a{k}(:,8));
          end 
          [SD_fix.E1,SD_float.E1]=extrFixedSDRes(SD.E1);
          [SD_fix.E5a,SD_float.E5a]=extrFixedSDRes(SD.E5a);

          pathname=[list_dd(len).folder '\']; 
          filename=list_dd(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [DD1.E1,DD1.E5a]=readGALRes(fid,filename);
          SD1.E1=dd2sd(DD1.E1);
          SD1.E5a=dd2sd(DD1.E5a);
          for k=1:size(SD1.E1,1)
              SD1.E1{k}(:,11)=var(SD1.E1{k}(:,7));
              SD1.E1{k}(:,12)=var(SD1.E1{k}(:,8));
          end 
          for k=1:size(SD1.E5a,1)
              SD1.E5a{k}(:,11)=var(SD1.E5a{k}(:,7));
              SD1.E5a{k}(:,12)=var(SD1.E5a{k}(:,8));
          end 
          [SD1_fix.E1,SD1_float.E1]=extrFixedSDRes(SD1.E1);
          [SD1_fix.E5a,SD1_float.E5a]=extrFixedSDRes(SD1.E5a);
       end
    end  
    %BDS
    if settings.sys.bds==1
       %MEO
       %Read the residual of the day 7th before the day to be corrected. 
       pathname=[list_dd(len-7).folder '\']; 
       filename=list_dd(len-7).name;
       fid=fopen(strcat(pathname,filename),'rt' );
       [DD.B1I_1,DD.B3I_1,DD.B1C_1,DD.B2a_1]=readBDSRes(fid,filename);
       %GEO/IGSO
       %Read the residual of the day before the day to be corrected. 
       pathname_1=[list_dd(len-1).folder '\']; 
       filename_1=list_dd(len-1).name;
       fid_1=fopen(strcat(pathname_1,filename_1),'rt' );
       [DD.B1I_7,DD.B3I_7,DD.B1C_7,DD.B2a_7]=readBDSRes(fid_1,filename_1);
      
       SD.B1I_1=dd2sd(DD.B1I_1);   SD.B1I_7=dd2sd(DD.B1I_7);
       SD.B3I_1=dd2sd(DD.B3I_1);   SD.B3I_7=dd2sd(DD.B3I_7);
       SD.B1C_1=dd2sd(DD.B1C_1);   SD.B1C_7=dd2sd(DD.B1C_7);
       SD.B2a_1=dd2sd(DD.B2a_1);   SD.B2a_7=dd2sd(DD.B2a_7);
       if settings.model.SFWin==0
          [SD_fix.B1I_1,SD_float.B1I_1]=extrFixedSDRes(SD.B1I_1);
          [SD_fix.B1I_7,SD_float.B1I_7]=extrFixedSDRes(SD.B1I_7);
          [SD_fix.B3I_1,SD_float.B3I_1]=extrFixedSDRes(SD.B3I_1);
          [SD_fix.B3I_7,SD_float.B3I_7]=extrFixedSDRes(SD.B3I_7);
          [SD_fix.B1C_1,SD_float.B1C_1]=extrFixedSDRes(SD.B1C_1);
          [SD_fix.B1C_7,SD_float.B1C_7]=extrFixedSDRes(SD.B1C_7);
          [SD_fix.B2a_1,SD_float.B2a_1]=extrFixedSDRes(SD.B2a_1);
          [SD_fix.B2a_7,SD_float.B2a_7]=extrFixedSDRes(SD.B2a_7);
       elseif settings.model.SFWin==1
          for k=1:size(SD.B1I_1,1)
              SD.B1I_1{k}(:,11)=var(SD.B1I_1{k}(:,7));
              SD.B1I_1{k}(:,12)=var(SD.B1I_1{k}(:,8));
          end 
          for k=1:size(SD.B1I_7,1)
              SD.B1I_7{k}(:,11)=var(SD.B1I_7{k}(:,7));
              SD.B1I_7{k}(:,12)=var(SD.B1I_7{k}(:,8));
          end 
          for k=1:size(SD.B3I_1,1)
              SD.B3I_1{k}(:,11)=var(SD.B3I_1{k}(:,7));
              SD.B3I_1{k}(:,12)=var(SD.B3I_1{k}(:,8));
          end 
          for k=1:size(SD.B3I_7,1)
              SD.B3I_7{k}(:,11)=var(SD.B3I_7{k}(:,7));
              SD.B3I_7{k}(:,12)=var(SD.B3I_7{k}(:,8));
          end 
          for k=1:size(SD.B1C_1,1)
              SD.B1C_1{k}(:,11)=var(SD.B1C_1{k}(:,7));
              SD.B1C_1{k}(:,12)=var(SD.B1C_1{k}(:,8));
          end 
          for k=1:size(SD.B1C_7,1)
              SD.B1C_7{k}(:,11)=var(SD.B1C_7{k}(:,7));
              SD.B1C_7{k}(:,12)=var(SD.B1C_7{k}(:,8));
          end 
          for k=1:size(SD.B2a_1,1)
              SD.B2a_1{k}(:,11)=var(SD.B2a_1{k}(:,7));
              SD.B2a_1{k}(:,12)=var(SD.B2a_1{k}(:,8));
          end 
          for k=1:size(SD.B2a_7,1)
              SD.B2a_7{k}(:,11)=var(SD.B2a_7{k}(:,7));
              SD.B2a_7{k}(:,12)=var(SD.B2a_7{k}(:,8));
          end 
          [SD_fix.B1I_1,SD_float.B1I_1]=extrFixedSDRes(SD.B1I_1);
          [SD_fix.B1I_7,SD_float.B1I_7]=extrFixedSDRes(SD.B1I_7);
          [SD_fix.B3I_1,SD_float.B3I_1]=extrFixedSDRes(SD.B3I_1);
          [SD_fix.B3I_7,SD_float.B3I_7]=extrFixedSDRes(SD.B3I_7);
          [SD_fix.B1C_1,SD_float.B1C_1]=extrFixedSDRes(SD.B1C_1);
          [SD_fix.B1C_7,SD_float.B1C_7]=extrFixedSDRes(SD.B1C_7);
          [SD_fix.B2a_1,SD_float.B2a_1]=extrFixedSDRes(SD.B2a_1);
          [SD_fix.B2a_7,SD_float.B2a_7]=extrFixedSDRes(SD.B2a_7);
          
          pathname=[list_dd(len).folder '\']; 
          filename=list_dd(len).name;
          fid=fopen(strcat(pathname,filename),'rt' );
          [DD1.B1I,DD1.B3I,DD1.B1C,DD1.B2a]=readBDSRes(fid,filename);
          SD1.B1I=dd2sd(DD1.B1I);
          SD1.B3I=dd2sd(DD1.B3I);
          SD1.B1C=dd2sd(DD1.B1C);
          SD1.B2a=dd2sd(DD1.B2a);
          for k=1:size(SD1.B1I,1)
              SD1.B1I{k}(:,11)=var(SD1.B1I{k}(:,7));
              SD1.B1I{k}(:,12)=var(SD1.B1I{k}(:,8));
          end 
          for k=1:size(SD1.B3I,1)
              SD1.B3I{k}(:,11)=var(SD1.B3I{k}(:,7));
              SD1.B3I{k}(:,12)=var(SD1.B3I{k}(:,8));
          end 
          for k=1:size(SD1.B1C,1)
              SD1.B1C{k}(:,11)=var(SD1.B1C{k}(:,7));
              SD1.B1C{k}(:,12)=var(SD1.B1C{k}(:,8));
          end 
          for k=1:size(SD1.B2a,1)
              SD1.B2a{k}(:,11)=var(SD1.B2a{k}(:,7));
              SD1.B2a{k}(:,12)=var(SD1.B2a{k}(:,8));
          end 
          [SD1_fix.B1I,SD1_float.B1I]=extrFixedSDRes(SD1.B1I);
          [SD1_fix.B3I,SD1_float.B3I]=extrFixedSDRes(SD1.B3I);
          [SD1_fix.B1C,SD1_float.B1C]=extrFixedSDRes(SD1.B1C);
          [SD1_fix.B2a,SD1_float.B2a]=extrFixedSDRes(SD1.B2a);
       end
    end
end