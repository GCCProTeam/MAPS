clc;
clear;
%% ---------------------------【Settings】---------------------------
%SFmodel
%Satellite revisiting period; GEC
%1.GPS: 1day; 2.GAL: 10day;  3.BDS: 1day(GEO/IGSO)  7day(MEO)
%---navsys
%Please select satellite systems you want to support.        0:NO  1:YES
settings.sys.gps=1;    
settings.sys.gal=1; 
settings.sys.bds=1;
%---frequency
%Please select the frequencies you want to support.            0:NO  1:YES
%GPS
settings.freq.L1=1;    
settings.freq.L2=1;  %When it is DD residual, L2 actually represents L5.
%GAL
settings.freq.E1=1;    
settings.freq.E5a=1;
%BDS
settings.freq.B1I=1;    
settings.freq.B3I=1;
settings.freq.B1C=1;    
settings.freq.B2a=1;
%Please select the SF model you want to establish. 
%SF refers to the traditional SF model.                      0:NO  1:YES
%SF_Win refers to the window matching SF model.              0:NO  1:YES
settings.model.SF=1;   
settings.model.SFWin=0; 
%---resType
%Please select the residual type to use.
%0: mat  1:ddres  2:udifres  3:uducres
%When resType is 0, it means that the sample data (res_SF.mat) 
%that has been read is used
settings.resType=1;  
%---Q
%Please choose to use the residual of fixed solution or float solution.   
%1:fixed  2:float 
settings.Q=1;   
%---Window size
%Please set the size of the window.
%eg:window = 60 * 10, which means every 10 minutes.
settings.Win=60*10;
%---Plot
%Please select the type of plotting you want.                0:NO  1:YES                                              
settings.figure=1;
%Please choose whether to plot a figure of code residuals.   0:NO  1:YES
settings.fig.code=1;
%Please choose whether to plot a figure of phase residuals.  0:NO  1:YES
settings.fig.phase=1;
%% ---------------------------【Addpath】----------------------------
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
%brdm files
n_ipath='0_Input\1_MHMSFmodel\3_nav';
%---Addpath
addpath('1_Read\');
addpath('2_Preprocess\');
addpath('5_SFmodel\');
addpath('6_Plot\');
addpath('8_Tool\');
%addpath('8_Tool\wavelet');
%% ----------------【First step:reading residual】----------------
   % ---------------Loading sample data that has been read-----------------
   if settings.resType==0
      load('0_Input\1_MHMSFmodel\res_SF.mat'); 
      settings.freq.B1C=0;
      settings.freq.B2a=0;
   % ------------------------Reading DD residuals--------------------------
   elseif settings.resType==1
      %Unzip the DD residual compressed file
      %unzip(zipddres,dd_ipath); 

      [fixedSD,floatSD,fixedSD1,floatSD1]=readDDSF(settings,dd_ipath);

      %Delete DD residual folder
      %rmdir(dd_ipath,'s');
      if settings.Q==1
         res=fixedSD; 
         res1=fixedSD1;  
      elseif settings.Q==2
         res=floatSD; 
         res1=floatSD1;  
      end  
   % -----------------------Reading UDIF residuals------------------------- 
   elseif settings.resType==2
      %Unzip the UDIF residual compressed file
      %unzip(zipudifres,udif_ipath); 

      [UDIF,UDIF1]=readUDIFSF(settings,udif_ipath);

      %Delete UDIF residual folder
      %rmdir(udif_ipath,'s');
      res=UDIF;
      res1=UDIF1;
      settings.freq.L2=0;
      settings.freq.E5a=0;
      settings.freq.B3I=0;
      settings.freq.B1C=0;
      settings.freq.B2a=0;
   % -----------------------Reading UDUC residuals-------------------------
   elseif settings.resType==3
      %Unzip the UDUC residual compressed file
      %unzip(zipuducres,uduc_ipath); 

      [UDUC,UDUC1]=readUDUCSF(settings,uduc_ipath);

      %Delete UDUC residual folder
      %rmdir(uduc_ipath,'s');
      res=UDUC;
      res1=UDUC1;
      settings.freq.B1C=0;
      settings.freq.B2a=0;
   end
%% -----------------【Second step:reading brdm】------------------
if settings.model.SF==1
    if settings.resType==0
        load('0_Input\1_MHMSFmodel\NAV.mat');
    else
        [NAV]=readBrdm(settings,n_ipath);
    end
end
%% -------------------【Third step:modeling】---------------------
   % --------------------------------SF------------------------------------
if settings.model.SF==1
    [SF,SFsat]=modelSF(settings,res,NAV);
else
    SF=[];
    SFsat=[];
end
save('7_Output\SF_result\SF.mat','SF','SFsat');
   %-------------------------------SF_Win----------------------------------
if settings.model.SFWin==1
    [SFW,SFWsat]=modelSFWin(settings,res,res1);
else
    SFW=[];
    SFWsat=[];
end
save('7_Output\SF_result\SFW.mat','SFW','SFWsat');
%% ----------------------【Fourth step:plotting】------------------------
if settings.figure==1 
   plotTimeSer(settings,SFsat,SFWsat); 
end











