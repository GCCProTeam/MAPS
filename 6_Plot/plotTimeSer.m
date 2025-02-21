function []=plotTimeSer(settings,SF_sat,SF_W_sat) 
%Plots time series data for different satellite systems and frequencies
%This function generates time series plots for phase and code measurements
%based on the provided settings and satellite data.

%INPUT:
%settings: Structure containing configuration settings
%SF_sat: Structure containing satellite data for SF
%SF_W_sat: Structure containing satellite data for SF_W

%Copyright (C) GCC Group
%-------------------------------------------------------------------------- 
   if settings.model.SF==1
      if settings.sys.gps==1
         if settings.freq.L1==1&&~isempty(SF_sat.L1)
             freq=1;
             if settings.fig.phase==1 
                plotGPSSFTimeSer(SF_sat.L1,3,freq);
             end
             if settings.fig.code==1
                plotGPSSFTimeSer(SF_sat.L1,4,freq);
             end
          end
         if settings.freq.L2==1&&~isempty(SF_sat.L2)
             freq=2;
             if settings.fig.phase==1
                plotGPSSFTimeSer(SF_sat.L2,3,freq);
             end
             if settings.fig.code==1
                plotGPSSFTimeSer(SF_sat.L2,4,freq);
             end
          end
      end
      if settings.sys.gal==1
         if settings.freq.E1==1&&~isempty(SF_sat.E1)
             freq=1;
             if settings.fig.phase==1
                plotGALSFTimeSer(SF_sat.E1,3,freq);
             end
             if settings.fig.code==1
                plotGALSFTimeSer(SF_sat.E1,4,freq);
             end
          end
         if settings.freq.E5a==1&&~isempty(SF_sat.E5a)
             freq=2;
             if settings.fig.phase==1
                plotGALSFTimeSer(SF_sat.E5a,3,freq);
             end
             if settings.fig.code==1
                plotGALSFTimeSer(SF_sat.E5a,4,freq);
             end
          end
      end
      if settings.sys.bds==1
          if settings.freq.B1I==1&&~isempty(SF_sat.B1I)
              freq=1;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_sat.B1I,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_sat.B1I,4,freq);
             end
          end
          if settings.freq.B3I==1&&~isempty(SF_sat.B3I)
              freq=2;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_sat.B3I,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_sat.B3I,4,freq);
             end
          end
          if settings.freq.B1C==1&&~isempty(SF_sat.B1C)
              freq=3;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_sat.B1C,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_sat.B1C,4,freq);
             end
          end
          if settings.freq.B2a==1&&~isempty(SF_sat.B2a)
              freq=4;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_sat.B2a,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_sat.B2a,4,freq);
             end
          end
      end
   end
   %SF_W 
   if settings.model.SFWin==1
      if settings.sys.gps==1&&~isempty(SF_W_sat.L1)
         freq=1;
         if settings.freq.L1==1
             if settings.fig.phase==1
                plotGPSSFTimeSer(SF_W_sat.L1,3,freq);
             end
             if settings.fig.code==1
                plotGPSSFTimeSer(SF_W_sat.L1,4,freq);
             end
          end
         if settings.freq.L2==1&&~isempty(SF_W_sat.L2)
             freq=2;
             if settings.fig.phase==1
                plotGPSSFTimeSer(SF_W_sat.L2,3,freq);
             end
             if settings.fig.code==1
                plotGPSSFTimeSer(SF_W_sat.L2,4,freq);
             end
          end
      end
      if settings.sys.gal==1
         if settings.freq.E1==1&&~isempty(SF_W_sat.E1)
             freq=1;
             if settings.fig.phase==1
                plotGALSFTimeSer(SF_W_sat.E1,3,freq);
             end
             if settings.fig.code==1
                plotGALSFTimeSer(SF_W_sat.E1,4,freq);
             end
          end
         if settings.freq.E5a==1&&~isempty(SF_W_sat.E5a)
             freq=2;
             if settings.fig.phase==1
                plotGALSFTimeSer(SF_W_sat.E5a,3,freq);
             end
             if settings.fig.code==1
                plotGALSFTimeSer(SF_W_sat.E5a,4,freq);
             end
          end
      end
      if settings.sys.bds==1
          if settings.freq.B1I==1&&~isempty(SF_W_sat.B1I)
             freq=1;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_W_sat.B1I,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_W_sat.B1I,4,freq);
             end
          end
          if settings.freq.B3I==1&&~isempty(SF_W_sat.B3I)
             freq=2;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_W_sat.B3I,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_W_sat.B3I,4,freq);
             end
          end
          if settings.freq.B1C==1&&~isempty(SF_W_sat.B1C)
              freq=3;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_W_sat.B1C,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_W_sat.B1C,4,freq);
             end
          end
          if settings.freq.B2a==1&&~isempty(SF_W_sat.B2a)
              freq=4;
             if settings.fig.phase==1
                plotBDSSFTimeSer(SF_W_sat.B2a,3,freq);
             end
             if settings.fig.code==1
                plotBDSSFTimeSer(SF_W_sat.B2a,4,freq);
             end
          end
      end
   end
end