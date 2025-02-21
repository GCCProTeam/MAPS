clc;
clear;
%% ----------------------------【Constants】-------------------------------
CONST.clight=299792458;                      %speed of light (m/s)
CONST.GPS_F1 = 1.57542E9;                    %L1   frequency (Hz)
CONST.GPS_F2 = 1.22760E9;                    %L2   frequency (Hz)
CONST.GPS_F5 = 1.17645E9;                    %L5   frequency (Hz)
CONST.GAL_F1  = 1.57542E9;                   %E1   frequency (Hz)
CONST.GAL_F5a = 1.17645E9;                   %E5a  frequency (Hz)
CONST.GAL_F5b = 1.20714E9;                   %E5b  frequency (Hz)
CONST.BDS_F1I = 1.561098E9;                  %B1I  frequency (Hz)
CONST.BDS_F2I = 1.20714E9;                   %B2I  frequency (Hz)
CONST.BDS_F3I = 1.26852E9;                   %B3I  frequency (Hz)
CONST.BDS_F1C = 1.57542E9;                   %B1C  frequency (Hz)
CONST.BDS_F2a = 1.17645E9;                   %B2a  frequency (Hz)

CONST.GPS_L1=CONST.clight/CONST.GPS_F1;      %wavelength (m)
CONST.GPS_L2=CONST.clight/CONST.GPS_F2;
CONST.GPS_L5=CONST.clight/CONST.GPS_F5;
CONST.GAL_L1=CONST.clight/CONST.GAL_F1;
CONST.GAL_L5a=CONST.clight/CONST.GAL_F5a;
CONST.GAL_L5b=CONST.clight/CONST.GAL_F5b;
CONST.BDS_L1C=CONST.clight/CONST.BDS_F1C;
CONST.BDS_L2a=CONST.clight/CONST.BDS_F2a;
CONST.BDS_L1I=CONST.clight/CONST.BDS_F1I;
CONST.BDS_L2I=CONST.clight/CONST.BDS_F2I;
CONST.BDS_L3I=CONST.clight/CONST.BDS_F3I;
%% -----------------------------【Settings】-------------------------------
%---model
%Please select whether to perform CMC/GFixIC/GFIC analysis and estimation. 
%1:CMC  2:GFixIC  3:GFIC  4；CN0
settings.model=1;  
%---plot
%Please choose whether to plot figure.                         0:NO  1:YES                                      
settings.fig=1;

%***************************【Settings of CMC】****************************
%If settings.model=1, the following settings are required;
%if not, the following settings can be ignored.
%---navsys
%Please select satellite systems you want to support.          0:NO  1:YES
settings.sys.gps=1;    
settings.sys.gal=1; 
settings.sys.bds=1; 
%---frequency
%Please set which two frequencies are used to calculate the CMC of GPS.              
%(GPS_F1/GPS_F2/GPS_F5)
gpsf1=CONST.GPS_F1;       gpsf2=CONST.GPS_F2;
%Please set which two frequencies are used to calculate the CMC of GAL.  
%(GAL_F1/GAL_F5a/GAL_F5b)
galf1=CONST.GAL_F1;       galf2=CONST.GAL_F5a;
%Please set which two frequencies are used to calculate the CMC of BDS.
%Note: frequencies without common satellites cannot be selected at the same time.
%For example, CONST.BDS_F2I and CONST.BDS_F1C, or CONST.BDS_F2I and const.BDS_F2a.
%(BDS_F1I/BDS_F2I/BDS_F3I/BDS_F1C/BDS_F2a)
bdsf1=CONST.BDS_F1I;      bdsf2=CONST.BDS_F3I;
%% -----------------------------【Addpath】--------------------------------
%---File path
%obs files
o_ipath='0_Input\0_MPanalysis\0_obs';
%sp3 files
s_ipath='0_Input\0_MPanalysis\1_sp3';
%clk files
c_ipath='0_Input\0_MPanalysis\2_clk';
%nav files
n_ipath='0_Input\0_MPanalysis\3_nav';
%dcb files
d_ipath='0_Input\0_MPanalysis\4_dcb';
%atx files
a_ipath='0_Input\0_MPanalysis\5_atx';
%C/N0 file
cn0_ipath='0_Input\0_MPanalysis\6_cn0';
%position of rover
p_ipath='0_Input\0_MPanalysis\pos_rover.mat';
%---Addpath
addpath('1_Read');
addpath('2_Preprocess');
addpath('3_MPanalysis');
addpath('6_Plot');
addpath('8_Tool');
%% -------------------------------【CMC】----------------------------------
if settings.model==1
   %--------------------------Reading obs file-----------------------------
   [obs]=readObs(o_ipath);
   %--------Calculating the azimuth and elevation of the satellite.--------
   load(p_ipath);
   [SAT_AEBL] = readSP3(s_ipath,pos_rover);
   clear pos_rover; 
   %---------------------------Calculating CMC-----------------------------
   %GPS
   if settings.sys.gps==1
      if gpsf1==gpsf2
         error('The first frequency cannot be the same as the second frequency.'); 
      end
      %first frequency
      if gpsf1~=CONST.GPS_F1&&gpsf1~=CONST.GPS_F2&&gpsf1~=CONST.GPS_F5
         error('GPS first frequency input error');
      end
      if gpsf1==CONST.GPS_F1
         L1=obs.GPS.L1;   C1=obs.GPS.C1;
      elseif gpsf1==CONST.GPS_F2
         L1=obs.GPS.L2;   C1=obs.GPS.C2;
      elseif gpsf1==CONST.GPS_F5  
         L1=obs.GPS.L5;   C1=obs.GPS.C5;
      end
      %second frequency
      if gpsf2~=CONST.GPS_F1&&gpsf2~=CONST.GPS_F2&&gpsf2~=CONST.GPS_F5
         error('GPS second frequency input error');
      end
      if gpsf2==CONST.GPS_F1
         L2=obs.GPS.L1;   C2=obs.GPS.C1;
      elseif gpsf2==CONST.GPS_F2
         L2=obs.GPS.L2;   C2=obs.GPS.C2;
      elseif gpsf2==CONST.GPS_F5  
         L2=obs.GPS.L5;   C2=obs.GPS.C5;
      end
      % detecting cycle slip
      [L1,C1,L2,C2,obs.gpsARC]=detslp(L1,C1,L2,C2,gpsf1,gpsf2);
      CMC.GPS=cmc(L1,C1,L2,C2,gpsf1,gpsf2,obs.gpsARC);
      CMC.GPS=matchAZEL(CMC.GPS,SAT_AEBL,obs); 
   end
   %GAL
   if settings.sys.gal==1
   %first frequency
      if galf1~=CONST.GAL_F1&&galf1~=CONST.GAL_F5a&&galf1~=CONST.GAL_F5b
          error('GAL first frequency input error');
      end
      if galf1==galf2
         error('The first frequency cannot be the same as the second frequency.'); 
      end
      if galf1==CONST.GAL_F1
          L1=obs.GAL.L1;    C1=obs.GAL.C1;
      elseif galf1==CONST.GAL_F5a
          L1=obs.GAL.L5a;   C1=obs.GAL.C5a;
      elseif galf1==CONST.GAL_F5b
          L1=obs.GAL.L5b;   C1=obs.GAL.C5b;
      end
   %second frequency
      if galf2~=CONST.GAL_F1&&galf2~=CONST.GAL_F5a&&galf2~=CONST.GAL_F5b
          error('GAL second frequency input error');
      end
      if galf2==CONST.GAL_F1
          L2=obs.GAL.L1;    C2=obs.GAL.C1;
      elseif galf2==CONST.GAL_F5a
          L2=obs.GAL.L5a;   C2=obs.GAL.C5a;
      elseif galf2==CONST.GAL_F5b
          L2=obs.GAL.L5b;   C2=obs.GAL.C5b;
      end
      % detecting cycle slip
      [L1,C1,L2,C2,obs.galARC]=detslp(L1,C1,L2,C2,galf1,galf2);
      CMC.GAL=cmc(L1,C1,L2,C2,galf1,galf2,obs.galARC); 
      CMC.GAL=matchAZEL(CMC.GAL,SAT_AEBL,obs);
   end
   %BDS
   if settings.sys.bds==1
      if bdsf1==bdsf2
         error('The first frequency cannot be the same as the second frequency.'); 
      end
       %first frequency
      if bdsf1~=CONST.BDS_F1I&&bdsf1~=CONST.BDS_F2I&&bdsf1~=CONST.BDS_F3I...
          &&bdsf1~=CONST.BDS_F1C&&bdsf1~=CONST.BDS_F2a
          error('BDS first frequency input error');
      end
      if bdsf1==CONST.BDS_F1I
          L1=obs.BDS.L1I;   C1=obs.BDS.C1I;
      elseif bdsf1==CONST.BDS_F2I
          L1=obs.BDS.L2I;   C1=obs.BDS.C2I;
      elseif bdsf1==CONST.BDS_F3I 
          L1=obs.BDS.L3I;   C1=obs.BDS.C3I;
      elseif bdsf1==CONST.BDS_F1C 
          L1=obs.BDS.L1C;   C1=obs.BDS.C1C;
      elseif bdsf1==CONST.BDS_F2a 
          L1=obs.BDS.L2a;   C1=obs.BDS.C2a;
      end
   %second
      if bdsf2~=CONST.BDS_F1I&&bdsf2~=CONST.BDS_F2I&&bdsf2~=CONST.BDS_F3I...
          &&bdsf2~=CONST.BDS_F1C&&bdsf2~=CONST.BDS_F2a
          error('BDS second frequency input error');
      end
      if bdsf2==CONST.BDS_F1I
          L2=obs.BDS.L1I;   C2=obs.BDS.C1I;
      elseif bdsf2==CONST.BDS_F2I
          L2=obs.BDS.L2I;   C2=obs.BDS.C2I;
      elseif bdsf2==CONST.BDS_F3I 
          L2=obs.BDS.L3I;   C2=obs.BDS.C3I;
      elseif bdsf2==CONST.BDS_F1C 
          L2=obs.BDS.L1C;   C2=obs.BDS.C1C;
      elseif bdsf2==CONST.BDS_F2a 
          L2=obs.BDS.L2a;   C2=obs.BDS.C2a;
      end
      % detecting cycle slip
      [L1,C1,L2,C2,obs.bdsARC]=detslp(L1,C1,L2,C2,bdsf1,bdsf2);
      CMC.BDS =cmc(L1,C1,L2,C2,bdsf1,bdsf2,obs.bdsARC); 
      if bdsf1==CONST.BDS_F2I||bdsf2==CONST.BDS_F2I %excluding satellites of BDS3
          for i=1:size(CMC.BDS,1)
              CMC.BDS{i}((CMC.BDS{i}(:,3)>87),:)=[];
          end
      end
      %excluding satellites of BDS2
      if bdsf1==CONST.BDS_F1C||bdsf2==CONST.BDS_F1C||bdsf1==CONST.BDS_F2a...
          ||bdsf2==CONST.BDS_F2a 
          for i=1:size(CMC.BDS,1)
              CMC.BDS{i}((CMC.BDS{i}(:,3)<=87),:)=[];
          end
      end
      CMC.BDS =matchAZEL(CMC.BDS,SAT_AEBL,obs);
   end
   %----------------------------Plotting CMC-------------------------------
   if settings.fig==1
      if settings.sys.gps==1
         sys=1;
         CMC.GPS=cell2mat(CMC.GPS);
         CMC_sat.GPS=cell(32,1);
         for i=1:32
             CMC_sat.GPS{i,1}=CMC.GPS(CMC.GPS(:,3) == i, :);          
         end
          plotGPSCMCTimeSer(CMC_sat.GPS);%绘制时序图
          plotCMCSky(sys,CMC.GPS);%绘制天空图
          for i=1:32
              plotCMCSky(sys,CMC_sat.GPS{i,1},i);%绘制单颗卫星天空图
          end
      end
      %GAL
      if settings.sys.gal==1
         sys=2;
         CMC.GAL=cell2mat(CMC.GAL);
         CMC_sat.GAL=cell(36,1);
         for i=1:36
             CMC_sat.GAL{i,1}=CMC.GAL((CMC.GAL(:,3)-32) == i, :);    
             CMC_sat.GAL{i,1}(:,3)=CMC_sat.GAL{i,1}(:,3)-32;
         end
         plotGALCMCTimeSer(CMC_sat.GAL);
         plotCMCSky(sys,CMC.GAL);
         for i=1:36
             plotCMCSky(sys,CMC_sat.GAL{i,1},i);
         end
     end
     %BDS
     if settings.sys.bds==1
        sys=3;
        CMC.BDS=cell2mat(CMC.BDS);
        CMC_sat.BDS=cell(46,1);
        for i=1:46
            CMC_sat.BDS{i,1}=CMC.BDS((CMC.BDS(:,3)-68) == i, :);    
            CMC_sat.BDS{i,1}(:,3)=CMC_sat.BDS{i,1}(:,3)-68;
        end
        plotBDSCMCTimeSer(CMC_sat.BDS);
        plotCMCSky(sys,CMC.BDS);
        for i=1:46
            plotCMCSky(sys,CMC_sat.BDS{i,1},i);
        end
     end
  end
elseif settings.model==2 
%% -----------------------------【GFix+IC】--------------------------------
input.f1(1:32,1)=CONST.GPS_F1;
input.f1(33:68,1)=CONST.GAL_F1;
input.f1(69:114,1)=CONST.BDS_F1I;
input.f2(1:32,1)=CONST.GPS_F2;
input.f2(33:68,1)=CONST.GAL_F5a;
input.f2(69:114,1)=CONST.BDS_F3I;

input.freq.GPS=[CONST.GPS_F1,CONST.GPS_F2];%L1/L2
input.freq.GAL=[CONST.GAL_F1,CONST.GAL_F5a];%E1/E5a
input.freq.BDS=[CONST.BDS_F1I,CONST.BDS_F3I];%B1I/B3I

input.wavelen.GPS=[CONST.GPS_L1,CONST.GPS_L2];%L1/L2    
input.wavelen.GAL=[CONST.GAL_L1,CONST.GAL_L5a];%E1/E5a
input.wavelen.BDS=[CONST.BDS_L1I,CONST.BDS_L3I];%B1I/B3I

%Only support the following frequencies
input.fGPS.C1='C1C';%L1/L2
input.fGPS.C2='C2W';
input.fGAL.C1='C1X';%E1/E5a
input.fGAL.C2='C5X';
input.fBDS.C1='C2I';%B1/B3
input.fBDS.C2='C6I';

%receiver pos_XYZ
load(p_ipath);
input.rec_XYZ=pos_rover;
clear pos_rover;
%read obs
[obs]=readObs(o_ipath);
%get az and el
[input] = readPreciseEph(s_ipath,input);
%clock bias
[input] = readPreciseClk(c_ipath,input); %[s]
%Ionospheric delay
[input] = readBrdc(n_ipath, input);
input.rec_BLH = cart2geo(input.rec_XYZ);
%code bias
BIAS=[];
[input.bias] = readSinexBias(d_ipath,BIAS);
% Read ANTEX/atx-file
obsjdstart=cal2jd_GT(obs.startdate(1), obs.startdate(2), obs.startdate(3)...
    + obs.startdate(4)/24);
[input] = readAntex(a_ipath, input, obsjdstart);
%obs2epoch
[Epoch]=obs2epoch(obs,input);
%Epoch
for i=1:size(Epoch.sat,1)
    Epoch.gpstime{i,1}=obs.Time(i,1);
    Epoch.mjd{i,1}=obs.mjd(i,1);
    gpstime=Epoch.gpstime{i,1};
    mjd=Epoch.mjd{i,1};
    week=obs.Week(i,1);
    for j=1:size(Epoch.sat{i},1)
        sv=Epoch.sat{i}(j);
        model.sv{i,1}(j,1)  = sv;
        % Sat position and clock
        valid_data = Epoch.code{i,1}(j,:); 
        index = ~isnan(valid_data) & valid_data ~= 0;  
        code_dist = mean(valid_data(index));
        tau = code_dist/CONST.clight;
        [Ttr,X,V] = calSatPos(sv,gpstime,tau,input);
        X_rot = X;       
        % --- Calculate hour and approximate sun and moon position for epoch ---
        h = mod(Epoch.gps_time(i),86400)/3600;
        model.sunECEF  = sunPositionECEF(obs.startdate(1),obs.startdate(2),obs.startdate(3),h);
        model.moonECEF = moonPositionECEF(obs.startdate(1),obs.startdate(2),obs.startdate(3),h);
        % --- Satellite Orientation ---
              % satellite orientation in ECEF
        SatOr_ECEF = getSatelliteOrientation(X_rot, model.sunECEF*1000);    
        [X_rot] = calPCOCorr(input,X_rot,SatOr_ECEF,sv);
        [dT_clk] = satelliteClock(sv, Ttr,input);
        % --- Relativistic correction ---
        dT_rel = -2/CONST.clight^2 * dot2(X_rot, V);
        dT_clk=dT_clk+dT_rel;
        model.dT_clk{i,1}(j,1)  = dT_clk; 
        model.Ttr{i,1}(j,1)  = Ttr;
        % Sat-Rec range
        deltaX=X_rot(1)-input.rec_XYZ(1);
        deltaY=X_rot(2)-input.rec_XYZ(2);
        deltaZ=X_rot(3)-input.rec_XYZ(3);
        rho=sqrt(deltaX.^2+deltaY.^2+deltaZ.^2);
        rho=rho+CONST_EARTH.WE*(X_rot(1)*input.rec_XYZ(2)-X_rot(2)*input.rec_XYZ(1))/CONST.clight;
        model.rho{i,1}(j,1)  = rho;

        % Ion and Tro correction
        [E,A]=xyz2azel(input.rec_XYZ,X_rot(1),X_rot(2),X_rot(3));
        az=A;el=E;
        Epoch.az{i,1}(j,1)=az;
        Epoch.el{i,1}(j,1)=el;
        iono(1) = ionoKlobuchar(input.rec_BLH.ph*(180/pi), input.rec_BLH.la*(180/pi), az, el, Ttr, input.klob_coeff);
        if sv<=32
            iono(2) = iono(1)*(CONST.GPS_F1^2 /CONST.GPS_F2^2 );
        elseif sv<=68
            iono(1) = iono(1)*(CONST.GPS_F1^2 / CONST.GAL_F1^2 );
            iono(2) = iono(1)*(CONST.GPS_F1^2 / CONST.GAL_F5a^2 );
        else
            iono(1) = iono(1)*(CONST.GPS_F1^2 / CONST.BDS_F1I^2 );
            iono(2) = iono(1) * (CONST.GPS_F1^2 / CONST.BDS_F3I^2 );
        end
        model.iono{i,1}(j,1:2)  = iono(1:2);
        p = 1013.25; T = 15; q = 48.14; % default values for pressure, temperature, relative humidity
        [std, mfw, ztd] = tropoHopfield(Ttr, el/180*pi, [T;p;q], 0);
        model.trop{i,1}(j,1)  = std;

        %solid tide
        pos_XYZ=input.rec_XYZ;
        pos_XYZ=pos_XYZ';
        los  = X_rot - pos_XYZ;         % vector from receiver to satellite, Line-of-sight-Vector
        rho  = norm(los);               % distance from receiver to satellite
        los0 = los/rho;                 % unit vector from receiver to satellite      
        pos_WGS84 = cart2geo(pos_XYZ);
        model.solid_tides_ECEF = solidTides(pos_XYZ, pos_WGS84.ph, model.sunECEF*1000, model.moonECEF);
        dX_solid_tides_corr = dot2(los0, model.solid_tides_ECEF);	% project onto line of sight
        model.dX_solid_tides_corr{i}(j) = dX_solid_tides_corr; 	% Solid tides range correction
        % --- Windup Correction ---
        % --- Rotation Matrix from Local Level to ECEF ---
        model.R_LL2ECEF = setupRotationLL2ECEF(pos_WGS84.ph, pos_WGS84.la);        
        % Wind-Up correction is enabled
        delta_windup = PhaseWindUp(sv, Epoch, i, model, SatOr_ECEF, los0);
        % Conversion of windup in cycles to frequency
        if sv<=32
            windupCorr_L1 = delta_windup * CONST.GPS_L1;    % [m]
            windupCorr_L2 = delta_windup * CONST.GPS_L2;    % [m]
        elseif sv<=68
            windupCorr_L1 = delta_windup * CONST.GAL_L1;    % [m]
            windupCorr_L2 = delta_windup * CONST.GAL_L5a;   % [m]
        else
            windupCorr_L1 = delta_windup * CONST.BDS_L1I;   % [m]
            windupCorr_L2 = delta_windup * CONST.BDS_L3I;   % [m]
            dX_GDV = calGDV(sv,el);
            model.GDV{i,1}(j,1:2)  = dX_GDV(1:2);
        end
        model.delta_windup{i}(j,1) = windupCorr_L1;
        model.delta_windup{i}(j,2) = windupCorr_L2;
        Epoch.delta_windup(j)=delta_windup;
    end
end

[DCBCorC1C_to_C1W,DCBCorC1W_to_C2W,DCBCorC1C_to_C5Q,DCBCorC2I_to_C6I] = calDCB(input);
%cut-off elevation
EleMin=20;
EpochNum=size(model.sv,1);
for i=1:EpochNum
    SatNum=size(model.sv{i},1);
    for j=1:SatNum
        s=model.sv{i}(j);
        if (Epoch.el{i,1}(j,1))<EleMin
            continue;
        end 
        if model.dT_clk{i}(j) == 0 || model.rho{i}(j)==0 || model.trop{i}(j)==0 || model.iono{i}(j,1)==0 || model.iono{i}(j,2)==0
            continue;
        end
        if isnan(model.dT_clk{i}(j)) || isnan(model.rho{i}(j)) || isnan(model.trop{i}(j)) || isnan(model.iono{i}(j,1))|| isnan(model.iono{i}(j,2))
            continue;
        end 
        % GPS
        if s<=32
            for k=1:2
                % L1
                if k==1
                    DCBCor=(1/((CONST.GPS_F1^2/CONST.GPS_F2^2)-1))*(DCBCorC1W_to_C2W(s,1)*1E-9*CONST.clight);
                end
                % L2
                if k==2
                    DCBCor=((CONST.GPS_F1^2/CONST.GPS_F2^2)/((CONST.GPS_F1^2/CONST.GPS_F2^2)-1))*(DCBCorC1W_to_C2W(s,1)*1E-9*CONST.clight);
                end
                %code
                model.code_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight+model.trop{i}(j)+model.iono{i}(j,k)-model.dX_solid_tides_corr{i}(j);
                prn=s;
                model.GPSCode{i,1}(32,k)=0;
                model.GPSCode{i,1}(32,3)=0;
                model.GPSCode{i,1}(prn,k)=Epoch.code{i,1}(j,k)-model.code_bias{i,1}(j,k);
                model.GPSCode{i,1}(prn,3)=Epoch.el{i,1}(j,1);
                %phase
                model.phase_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight+model.trop{i}(j)-model.iono{i}(j,k)-model.dX_solid_tides_corr{i}(j)+model.delta_windup{i}(j,k);
                model.GPSPhase{i,1}(32,k)=0;
                model.GPSPhase{i,1}(32,3)=0;
                model.GPSPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,k)*input.wavelen.GPS(1,k)-model.phase_bias{i,1}(j,k);%[m]
                model.GPSPhase{i,1}(prn,3)=Epoch.el{i,1}(j,1);    
            end
        % Galileo
        elseif s>32&&s<=68
            for k=1:2
                if k==1
                    DCBCor=(1/((CONST.GAL_F1^2/CONST.GAL_F5a^2)-1))*(DCBCorC1C_to_C5Q(s,1)*1E-9*CONST.clight);
                end
                if k==2
                    DCBCor=((CONST.GAL_F1^2/CONST.GAL_F5a^2)/((CONST.GAL_F1^2/CONST.GAL_F5a^2)-1))*(DCBCorC1C_to_C5Q(s,1)*1E-9*CONST.clight);
                end
                %code
                model.code_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight + model.trop{i}(j) + model.iono{i}(j,k)-model.dX_solid_tides_corr{i}(j);
                prn=s-32;
                model.GALCode{i,1}(36,k)=0;
                model.GALCode{i,1}(36,3)=0;
                model.GALCode{i,1}(prn,k)=Epoch.code{i,1}(j,k)-model.code_bias{i,1}(j,k);
                model.GALCode{i,1}(prn,3)=Epoch.el{i,1}(j,1);                
                %phase
                model.phase_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight + model.trop{i}(j) - model.iono{i}(j,k)-model.dX_solid_tides_corr{i}(j)+model.delta_windup{i}(j,k);
                model.GALPhase{i,1}(36,k)=0;
                model.GALPhase{i,1}(36,3)=0;                
                model.GALPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,k)*input.wavelen.GAL(1,k)-model.phase_bias{i,1}(j,k);%[m]
                model.GALPhase{i,1}(prn,3)=Epoch.el{i,1}(j,1); 
            end
        % BDS
        else
            for k=1:2
                if k==1
                    DCBCor=(1/((CONST.BDS_F1I^2/CONST.BDS_F3I^2)-1))*(DCBCorC2I_to_C6I(s,1)*1E-9*CONST.clight);
                    kk=3;
                end
                if k==2
                    DCBCor=((CONST.BDS_F1I^2/CONST.BDS_F3I^2)/((CONST.BDS_F1I^2/CONST.BDS_F3I^2)-1))*(DCBCorC2I_to_C6I(s,1)*1E-9*CONST.clight);
                    kk=5;
                end
                %code
                model.code_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight + model.trop{i}(j) + model.iono{i}(j,k) + model.GDV{i}(j,k)-model.dX_solid_tides_corr{i}(j);
                prn=s-68;
                model.BDSCode{i,1}(46,k)=0;
                model.BDSCode{i,1}(46,3)=0;
                model.BDSCode{i,1}(prn,k)=Epoch.code{i,1}(j,kk)-model.code_bias{i,1}(j,k);
                model.BDSCode{i,1}(prn,3)=Epoch.el{i,1}(j,1);                 
                %phase
                model.phase_bias{i,1}(j,k)=model.rho{i}(j)-DCBCor-model.dT_clk{i}(j)*CONST.clight + model.trop{i}(j)-model.iono{i}(j,k)-model.dX_solid_tides_corr{i}(j)+model.delta_windup{i}(j,k);
                model.BDSPhase{i,1}(46,k)=0;
                model.BDSPhase{i,1}(46,3)=0;
                model.BDSPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,kk)*input.wavelen.BDS(1,k)-model.phase_bias{i,1}(j,k);%[m]
                model.BDSPhase{i,1}(prn,3)=Epoch.el{i,1}(j,1);
            end
        end
    end
end
 [GPSP1SD,GPSP2SD,GPSL1SD,GPSL2SD] = GFixICSDGPS(model,60);
 [GALP1SD,GALP2SD,GALL1SD,GALL2SD] = GFixICSDGAL(model,60);
 [BDSP1SD,BDSP2SD,BDSL1SD,BDSL2SD] = GFixICSDBDS(model,60);
   %----------------------------Plotting CMC-------------------------------
   if settings.fig==1
      PlotGPSGFixIC(GPSP1SD,GPSP2SD,GPSL1SD,GPSL2SD);
      PlotGALGFixIC(GALP1SD,GALP2SD,GALL1SD,GALL2SD);
      PlotBDSGFixIC(BDSP1SD,BDSP2SD,BDSL1SD,BDSL2SD);
   end
elseif settings.model==3
%% ------------------------------【GF+IC】---------------------------------
input.wavelen.GPS=[CONST.GPS_L1,CONST.GPS_L2,CONST.GPS_L5];%L1/L2/L5
input.wavelen.GAL=[CONST.GAL_L1,CONST.GAL_L5a];%E1/E5a
input.wavelen.BDS=[CONST.BDS_L1C,CONST.BDS_L2a,CONST.BDS_L1I,...
                   CONST.BDS_L2I,CONST.BDS_L3I];%B1C/B2a/B1I/B2I/B3I
%receiver pos_XYZ
load(p_ipath);
input.rec_XYZ=pos_rover;
clear pos_rover;
%read obs
[obs]=readObs(o_ipath);
%get az and el
[input] = readPreciseEph(s_ipath,input);
%Ionospheric delay
[input] = readBrdc(n_ipath, input);
input.rec_BLH = cart2geo(input.rec_XYZ); %input.rec_BLH [rad] [rad] [m]
%obs2epoch
[Epoch]=obs2epoch(obs,input);
%Epoch
for i=1:size(Epoch.sat,1)
    Epoch.gpstime{i,1}=obs.Time(i,1);
    Epoch.mjd{i,1}=obs.mjd(i,1);
    gpstime=Epoch.gpstime{i,1};
    mjd=Epoch.mjd{i,1};
    week=obs.Week(i,1);
    for j=1:size(Epoch.sat{i},1)
        sv=Epoch.sat{i}(j);
        model.sv{i,1}(j,1) = sv;
        valid_data = Epoch.code{i,1}(j,:); 
        index = ~isnan(valid_data) & valid_data ~= 0;  
        code_dist = mean(valid_data(index));
        tau = code_dist/CONST.clight;
        [Ttr,X,V] = calSatPos(sv,gpstime,tau,input);
        if isnan(X)
            continue;
        end
        X_rot = X;
        % --- Calculate hour and approximate sun and moon position for epoch ---
        h = mod(Epoch.gps_time(i),86400)/3600;
        model.sunECEF  = sunPositionECEF(obs.startdate(1), obs.startdate(2), obs.startdate(3), h);
        % --- Satellite Orientation ---
        SatOr_ECEF = getSatelliteOrientation(X_rot, model.sunECEF*1000);    % satellite orientation in ECEF
        [E,A]=xyz2azel(input.rec_XYZ,X_rot(1),X_rot(2),X_rot(3));
        az=A;
        el=E;
        Epoch.az{i,1}(j,1)=az;
        Epoch.el{i,1}(j,1)=el;        
        [iono] = calIon(input,az,el,Ttr,sv);
        model.iono{i,1}(j,1:5)  = iono(1:5);
    end
end
%Cut-off elevation
EleMin=10;
EpochNum=size(model.sv,1);
for i=1:EpochNum
    SatNum=size(model.sv{i},1);
    for j=1:SatNum
        s=model.sv{i}(j);
        if (Epoch.el{i,1}(j,1))<EleMin
            continue;
        end
        if s<=32
            for k=1:3
                %code
                prn=s;
                model.GPSCode{i,1}(32,k)=0;
                model.GPSCode{i,1}(32,4)=0;
                if Epoch.code{i,1}(j,k)==0 || isnan(Epoch.code{i,1}(j,k))
                    continue;
                end
                model.GPSCode{i,1}(prn,k)=Epoch.code{i,1}(j,k)-model.iono{i}(j,k);
                model.GPSCode{i,1}(prn,4)=Epoch.el{i,1}(j,1);
                %phase
                model.GPSPhase{i,1}(32,k)=0;
                model.GPSPhase{i,1}(32,4)=0;
                if Epoch.phase{i,1}(j,k)==0 || isnan(Epoch.phase{i,1}(j,k))
                    continue;
                end 
                model.GPSPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,k)*input.wavelen.GPS(1,k)+ model.iono{i}(j,k);
                model.GPSPhase{i,1}(prn,4)=Epoch.el{i,1}(j,1);
                model.GPSMultipathLast{i,1}(prn,k)= (model.GPSCode{i,1}(prn,k) - model.GPSPhase{i,1}(prn,k));
                model.GPSMultipathLast{i,1}(32,k)=0;
                if i>1
                    if model.GPSMultipathLast{i-1,1}(prn,k)==0 || model.GPSCode{i,1}(prn,k)==0 || model.GPSPhase{i,1}(prn,k)==0
                        continue;
                    end
                    model.GPSMultipath{i,1}(prn,k) = (model.GPSCode{i,1}(prn,k) - model.GPSPhase{i,1}(prn,k)) - model.GPSMultipathLast{i-1,1}(prn,k);
                end
            end
        elseif s>32&&s<=68
            for k=1:2                
                %code
                prn=s-32;
                model.GALCode{i,1}(36,k)=0;
                model.GALCode{i,1}(36,3)=0;
                if Epoch.code{i,1}(j,k)==0 || isnan(Epoch.code{i,1}(j,k))
                    continue;
                end                
                model.GALCode{i,1}(prn,k)=Epoch.code{i,1}(j,k)-model.iono{i}(j,k);
                model.GALCode{i,1}(prn,3)=Epoch.el{i,1}(j,1);
                %phase
                model.GALPhase{i,1}(36,k)=0;
                model.GALPhase{i,1}(36,3)=0;  
                if Epoch.phase{i,1}(j,k)==0 || isnan(Epoch.phase{i,1}(j,k))
                    continue;
                end                 
                model.GALPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,k)*input.wavelen.GAL(1,k)+ model.iono{i}(j,k);
                model.GALPhase{i,1}(prn,3)=Epoch.el{i,1}(j,1);
                model.GALMultipathLast{i,1}(prn,k)= (model.GALCode{i,1}(prn,k) - model.GALPhase{i,1}(prn,k));
                model.GALMultipathLast{i,1}(36,k)=0;
                if i>1
                    if model.GALMultipathLast{i-1,1}(prn,k)==0 || model.GALCode{i,1}(prn,k)==0 || model.GALPhase{i,1}(prn,k)==0
                        continue;
                    end
                    model.GALMultipath{i,1}(prn,k) = (model.GALCode{i,1}(prn,k) - model.GALPhase{i,1}(prn,k)) - model.GALMultipathLast{i-1,1}(prn,k);
                end                
            end  
        else
            for k=1:5             
                %code
                prn=s-68;
                model.BDSCode{i,1}(46,k)=0;
                model.BDSCode{i,1}(46,6)=0;
                if Epoch.code{i,1}(j,k)==0 || isnan(Epoch.code{i,1}(j,k))
                    continue;
                end
                model.BDSCode{i,1}(prn,k)=Epoch.code{i,1}(j,k)-model.iono{i}(j,k);
                model.BDSCode{i,1}(prn,6)=Epoch.el{i,1}(j,1);                 
                %phase
                model.BDSPhase{i,1}(46,k)=0;
                model.BDSPhase{i,1}(46,6)=0;
                if Epoch.phase{i,1}(j,k)==0 || isnan(Epoch.phase{i,1}(j,k))
                    continue;
                end
                model.BDSPhase{i,1}(prn,k)=Epoch.phase{i,1}(j,k)*input.wavelen.BDS(1,k)+model.iono{i}(j,k);
                model.BDSPhase{i,1}(prn,6)=Epoch.el{i,1}(j,1);
                model.BDSMultipathLast{i,1}(prn,k)= (model.BDSCode{i,1}(prn,k) - model.BDSPhase{i,1}(prn,k));
                model.BDSMultipathLast{i,1}(46,k)=0;
                if i>1
                    if model.BDSMultipathLast{i-1,1}(prn,k)==0 || model.BDSCode{i,1}(prn,k)==0 || model.BDSPhase{i,1}(prn,k)==0
                        continue;
                    end
                    model.BDSMultipath{i,1}(prn,k) = (model.BDSCode{i,1}(prn,k) - model.BDSPhase{i,1}(prn,k)) - model.BDSMultipathLast{i-1,1}(prn,k);
                end                 
            end
        end
    end
end
%----------------------------Plotting CMC-------------------------------
   if settings.fig==1
      plotGPSGFIC(model);
      plotGALGFIC(model);
      plotBDSGFIC(model);
   end
elseif settings.model==4
     %Read el and CN0
    list_cn0=dir([cn0_ipath '/*.ddres']);
    len=length(list_cn0);   
    pathname=[list_cn0(len).folder '\'];
    filename=list_cn0(len).name;
    fid=fopen(strcat(pathname,filename),'rt' );
    [CN0] = readCN0(fid, filename);
    CN0=cell2mat(CN0); 
     %modeling CN0 template function
     [coeff_cn0]=CN0Template(CN0(:,6),CN0(:,9));% el   snr
     save('7_Output\coeff_cn0.mat','coeff_cn0');
     %---------------------------Plotting CMC------------------------------
     if settings.fig==1
        plotCN0Templ(CN0(:,6),CN0(:,9),coeff_cn0); 
     end
end
%save('7_Output\MP_result\CMC.mat','CMC');
%Plot

%% -----------------------C/N0 template function---------------------
