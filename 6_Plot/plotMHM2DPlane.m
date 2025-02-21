function []=plotMHM2DPlane(settings,MHM,PMHM,SMHM,FMHM) 
%This function plots 2D sky maps for different types of MHM

%INPUT:
%settings: Configuration structure containing model and system settings.
%MHM: Traditional MHM 
%PMHM: Precision MHM 
%SMHM: Satellite-dependent MHM 
%FMHM: Overlapping MHM

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Plot Traditional MHM (MHM)  
   if settings.model.Trad==1
       model=1;
      if settings.sys.gps==1
          if settings.freq.L1==1
             type='L1'; 
             % Plot phase data
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.L1,3,flag,model,type); 
             end
              % Plot code data
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.L1,4,flag,model,type);
             end
          end
         if settings.freq.L2==1
             type='L2\5'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.L2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.L2,4,flag,model,type);
             end
          end
      end
      if settings.sys.glo==1
         if settings.freq.G1==1
             type='G1'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.G1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.G1,4,flag,model,type);
             end
          end
         if settings.freq.G2==1
             type='G2'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.G2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.G2,4,flag,model,type);
             end
          end
      end
      if settings.sys.gal==1
         if settings.freq.E1==1
             type='E1'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.E1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.E1,4,flag,model,type);
             end
          end
         if settings.freq.E5a==1
             type='E5a'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.E5a,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.E5a,4,flag,model,type);
             end
          end
      end
      if settings.sys.bds==1
          if settings.freq.B1I==1
             type='B1I'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.B1I,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.B1I,4,flag,model,type);
             end
          end
         if settings.freq.B3I==1
             type='B3I'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(MHM.B3I,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(MHM.B3I,4,flag,model,type);
             end
          end
      end
   end
   % Plot Precision MHM (PMHM) 
   if settings.model.Prec==1
      model=2;
      if settings.sys.gps==1
          if settings.freq.L1==1
             type='L1'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.L1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.L1,4,flag,model,type);
             end
          end
         if settings.freq.L2==1
             type='L2\5'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.L2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.L2,4,flag,model,type);
             end
          end
      end
      if settings.sys.glo==1
         if settings.freq.G1==1
            type='G1'; 
            if settings.fig.phase==1
               flag='phase';
               plot2DPlane(PMHM.G1,3,flag,model,type); 
            end
            if settings.fig.code==1
               flag='code';
               plot2DPlane(PMHM.G1,4,flag,model,type);
            end
         end
         if settings.freq.G2==1
             type='G2'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.G2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.G2,4,flag,model,type);
             end
         end
      end
      if settings.sys.gal==1
         if settings.freq.E1==1
             type='E1'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.E1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.E1,4,flag,model,type);
             end
          end
         if settings.freq.E5a==1
             type='E5a'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.E5a,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.E5a,4,flag,model,type);
             end
          end
      end
      if settings.sys.bds==1
          if settings.freq.B1I==1
             type='B1I'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.B1I,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.B1I,4,flag,model,type);
             end
          end
         if settings.freq.B3I==1
             type='B3I'; 
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(PMHM.B3I,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(PMHM.B3I,4,flag,model,type);
             end
          end
      end
   end
   % Plot Satellite-dependent MHM (SMHM)
   if settings.model.Sat==1
       model=3;
       if settings.sys.bds==1
          if settings.freq.B1I==1
             type='B1I';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(SMHM.B1I.GEO,3,flag,model,type,'GEO'); 
                plot2DPlane(SMHM.B1I.IGSO,3,flag,model,type,'IGSO'); 
                plot2DPlane(SMHM.B1I.MEO,3,flag,model,type,'MEO'); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(SMHM.B1I.GEO,4,flag,model,type,'GEO');
                plot2DPlane(SMHM.B1I.IGSO,4,flag,model,type,'IGSO'); 
                plot2DPlane(SMHM.B1I.MEO,4,flag,model,type,'MEO');
             end
          end
          if settings.freq.B3I==1
             type='B3I';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(SMHM.B3I.GEO,3,flag,model,type,'GEO'); 
                plot2DPlane(SMHM.B3I.IGSO,3,flag,model,type,'IGSO'); 
                plot2DPlane(SMHM.B3I.MEO,3,flag,model,type,'MEO'); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(SMHM.B3I.GEO,4,flag,model,type,'GEO');
                plot2DPlane(SMHM.B3I.IGSO,4,flag,model,type,'IGSO'); 
                plot2DPlane(SMHM.B3I.MEO,4,flag,model,type,'MEO');
             end
          end
       end
   end
   % Plot Overlapping MHM (FMHM)
   if settings.model.Freq==1
       model=4;
      if settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.bds~=1
          if settings.freq.L1==1&&settings.freq.E1==1&&settings.freq.B1I~=1
             type='L1/E1';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GE_1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GE_1,4,flag,model,type);
             end
          end
          if settings.freq.L2==1&&settings.freq.E5a==1&&settings.freq.B3I~=1
             type='L5/E5a';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GE_2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GE_2,4,flag,model,type);
             end
          end
      end
      if settings.sys.gps==1&&settings.sys.bds==1&&settings.sys.gal~=1
          if settings.freq.L1==1&&settings.freq.B1I==1&&settings.freq.E1~=1
             type='L1/B1C';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GC_1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GC_1,4,flag,model,type);
             end
          end
          if settings.freq.L2==1&&settings.freq.B3I==1&&settings.freq.E5a~=1
             type='L5/B2a';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GC_2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GC_2,4,flag,model,type);
             end
          end
      end
      if settings.sys.bds==1&&settings.sys.gal==1&&settings.sys.gps~=1
         if settings.freq.B1I==1&&settings.freq.E1==1&&settings.freq.L1~=1
             type='B1C/E1';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.EC_1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.EC_1,4,flag,model,type);
             end
          end
          if settings.freq.B3I==1&&settings.freq.E5a==1&&settings.freq.L2~=1
             type='B2a/E5a';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.EC_2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.EC_2,4,flag,model,type);
             end
          end
      end
      if settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.gal==1
         if settings.freq.L1==1&&settings.freq.E1==1&&settings.freq.B1I==1
             type='L1/E1/B1C';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GEC_1,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GEC_1,4,flag,model,type);
             end
          end
          if settings.freq.L2==1&&settings.freq.E5a==1&&settings.freq.B3I==1
             type='L5/E5a/B2a';
             if settings.fig.phase==1
                flag='phase';
                plot2DPlane(FMHM.GEC_2,3,flag,model,type); 
             end
             if settings.fig.code==1
                flag='code';
                plot2DPlane(FMHM.GEC_2,4,flag,model,type);
             end
          end
      end
   end
end