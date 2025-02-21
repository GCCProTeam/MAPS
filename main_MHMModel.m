clc;
clear;
%% -------------------------【Settings】---------------------------
%MHMmodel
%Satellite revisiting period; GREC
%1.GPS: 1day; 2.GLO: 8day; 3.GAL: 10day;  4.BDS: 1day(GEO/IGSO)  7day(MEO)
%---navsys
%Please select satellite systems you want to support.        0:NO  1:YES
settings.sys.gps=1;    
settings.sys.glo=1; 
settings.sys.gal=1; 
settings.sys.bds=1; 
%---frequency
%Please select the frequencies you want to support.            0:NO  1:YES
%GPS
settings.freq.L1=1;    
settings.freq.L2=1;  %When it is DD residual, L2 actually represents L5.
%GLO
settings.freq.G1=1;    
settings.freq.G2=1;
%GAL
settings.freq.E1=1;    
settings.freq.E5a=1;
%BDS
settings.freq.B1I=1;    
settings.freq.B3I=1;
settings.freq.B1C=1;    
settings.freq.B2a=1;
%Please select the MHM model you want to establish.  
%MHM refers to traditional MHM.                              0:NO  1:YES
%SMHM refers to GEO, IGSO and MEO satellite MHM of BDS.      0:NO  1:YES
%FMHM refers to GPS/Galileo/BDS3 overlapping frequency MHM.  0:NO  1:YES
%PMHM refers to precision MHM.                               0:NO  1:YES
%TMHM refers to the trend surface analysis of MHM.           0:NO  1:YES
settings.model.Trad=1; 
settings.model.Prec=1; 
settings.model.Sat=1; 
settings.model.Freq=1; 
settings.model.Tre=1; 
%---Tres
%Please select the residual type to use.
%0: mat  1:ddres  2:udifres  3:uducres
%When Tres is 0, it means that the sample data (res_MHM.mat) 
%that has been read is used
settings.resType=1;  
%---Q
%Please choose to use the residual of fixed solution or float solution.   
%1:fixed  2:float 
settings.Q=1; 
%---Grid resolution of MHM.                 
%Please select the grid resolution of MHM.    1:0.5°×0.5°    2:1°×1°
settings.gridReso=2; 
%---Plot
%Please select the type of plotting you want.  0：No plot  1:2D sky plot  
%                                              2:2D plane  3:3D sky plot
settings.figure=1;
%Please choose whether to plot a figure of code residuals.   0:NO  1:YES
 settings.fig.code=1;
%Please choose whether to plot a figure of phase residuals.  0:NO  1:YES
 settings.fig.phase=1;
%% -------------------------【Addpath】----------------------------
%---Compressed data files 
%ddres files
%zipddres='0_Input\1_MHMSFmodel\0_ddres.zip';
%udifres files
%zipudifres='0_Input\1_MHMSFmodel\1_udifres.zip';
%uducres files
%zipuducres='0_Input\1_MHMSFmodel\2_uducres.zip';

%---File path 
%ddres files
dd_ipath='0_Input\1_MHMSFmodel\0_ddres';
%udifres files
udif_ipath='0_Input\1_MHMSFmodel\1_udifres';
%uducres files
uduc_ipath='0_Input\1_MHMSFmodel\2_uducres';
%---Addpath
addpath('1_Read\');
addpath('2_Preprocess\');
addpath('4_MHMmodel\');
addpath('6_Plot\');
addpath('8_Tool\');
%% ----------------【First step:reading residual】----------------
   % ---------------Loading sample data that has been read-----------------
   if settings.resType==0
      load('0_Input\1_MHMSFmodel\res_MHM.mat'); 
      %Because it is an example of double difference residuals.
      settings.resType=1;
   % ------------------------Reading DD residuals--------------------------
   elseif settings.resType==1
     %Unzip the DD residual compressed file
     %unzip(zipddres,dd_ipath); 

     [fixedSD,floatSD]=readDDMHM(settings,dd_ipath);
     %Delete DD residual folder
     %rmdir(dd_ipath,'s');
      if settings.Q==1   
         res=fixedSD; 
      else 
         res=floatSD; 
      end

   % -----------------------Reading UDIF residuals------------------------- 
   elseif settings.resType==2
      %Unzip the UDIF residual compressed file
      %unzip(zipudifres,udif_ipath);

      [UDIF]=readUDIFMHM(settings,udif_ipath);

      %Delete UDIF residual folder
      %rmdir(udif_ipath,'s');
      res=UDIF;
      settings.model.Freq=0;   %Unable to eatablish overlapping model
      settings.freq.L2=0;
      settings.freq.B3I=0;
      settings.freq.G2=0;
      settings.freq.E5a=0;
   % -----------------------Reading UDUC residuals-------------------------
   elseif settings.resType==3
      %Unzip the UDUC residual compressed file
      %unzip(zipuducres,uduc_ipath);

      [UDUC]=readUDUCMHM(settings,uduc_ipath);

      %Delete UDUC residual folder
      %rmdir(uduc_ipath,'s');
      res=UDUC;
      settings.model.Freq=0;   %Unable to eatablish overlapping model.
   end
%% -------------------【Second step:modeling】--------------------
   % --------------------------------MHM----------------------------------
   if settings.model.Trad==1
      [MHM]=modelMHM(settings,res);
   else
       MHM=[];
   end
   save('7_Output\MHM_result\MHM.mat','MHM');
   % ----------------------------Precise_MHM-------------------------------
   if settings.model.Prec==1
      [PMHM]=modelPMHM(settings,res); 
   else
       PMHM=[];
   end
   save('7_Output\MHM_result\PMHM.mat','PMHM');
   % -----------------------------Sat_MHM----------------------------------
   if settings.model.Sat==1
      [SMHM]=modelSMHM(settings,res); 
   else
       SMHM=[];
   end
   save('7_Output\MHM_result\SMHM.mat','SMHM');
   % -----------------------------Fre_MHM----------------------------------
   if settings.model.Freq==1
      [FMHM]=modelFMHM(settings,res);
   else
      FMHM=[]; 
   end
   save('7_Output\MHM_result\FMHM.mat','FMHM');
   % ----------------------------Trend_MHM---------------------------------
   if settings.model.Tre==1
      [TMHM]=modelTMHM(settings,res);
   else
       TMHM=[];
   end
   save('7_Output\MHM_result\TMHM.mat','TMHM');
%% --------------------【Third step:plotting】--------------------
   % ---------------------------2D sky plot--------------------------------
   if settings.figure==1
      plotMHM2DSky(settings,MHM,PMHM,SMHM,FMHM);
   % ----------------------------2D plane----------------------------------
   elseif settings.figure==2
      plotMHM2DPlane(settings,MHM,PMHM,SMHM,FMHM);
   % ---------------------------3D sky plot--------------------------------
   elseif settings.figure==3
      plotMHM3DSky(settings,MHM,PMHM,SMHM,FMHM); 
   end

   
