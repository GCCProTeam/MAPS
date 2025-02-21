function []=plotMHM3DSky(settings,MHM,PMHM,SMHM,FMHM)
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
         type1='L1';
         type2='L2\5';
         % Plot phase data
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(MHM.L1,MHM.L2,3,flag,model,type1,type2); 
          end
           % Plot code data
          if settings.fig.code==1
             flag='code';
             plot3DSky(MHM.L1,MHM.L2,4,flag,model,type1,type2);
          end
      end
      if settings.sys.glo==1
         type1='G1';
         type2='G2';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(MHM.G1,MHM.G2,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(MHM.G1,MHM.G2,4,flag,model,type1,type2); 
          end
      end
      if settings.sys.gal==1
         type1='E1';
         type2='E5a';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(MHM.E1,MHM.E5a,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(MHM.E1,MHM.E5a,4,flag,model,type1,type2); 
          end
      end
      if settings.sys.bds==1
         type1='B1I';
         type2='B3I';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(MHM.B1I,MHM.B3I,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(MHM.B1I,MHM.B3I,4,flag,model,type1,type2); 
          end
      end
   end
  % Plot Precision MHM (PMHM) 
   if settings.model.Prec==1
       model=2;
      if settings.sys.gps==1
         type1='L1';
         type2='L2\5';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(PMHM.L1,PMHM.L2,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(PMHM.L1,PMHM.L2,4,flag,model,type1,type2);
          end
      end
      if settings.sys.glo==1
         type1='G1';
         type2='G2';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(PMHM.G1,PMHM.G2,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(PMHM.G1,PMHM.G2,4,flag,model,type1,type2); 
          end
      end
      if settings.sys.gal==1
         type1='E1';
         type2='E5a';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(PMHM.E1,PMHM.E5a,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(PMHM.E1,PMHM.E5a,4,flag,model,type1,type2); 
          end
      end
      if settings.sys.bds==1
         type1='B1I';
         type2='B3I';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(PMHM.B1I,PMHM.B3I,3,flag,model,type1,type2); 
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(PMHM.B1I,PMHM.B3I,4,flag,model,type1,type2); 
          end
      end
   end
   % Plot Satellite-dependent MHM (SMHM)
   if settings.model.Sat==1
       model=3;
       if settings.sys.bds==1
          type1='B1I';
          type2='B3I';
          if settings.fig.phase==1
             flag='phase';
             plot3DSky(SMHM.B1I.GEO,SMHM.B3I.GEO,3,flag,model,type1,type2,'GEO');
             plot3DSky(SMHM.B1I.IGSO,SMHM.B3I.IGSO,3,flag,model,type1,type2,'IGSO');
             plot3DSky(SMHM.B1I.MEO,SMHM.B3I.MEO,3,flag,model,type1,type2,'MEO');
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(SMHM.B1I.GEO,SMHM.B3I.GEO,4,flag,model,type1,type2,'GEO');
             plot3DSky(SMHM.B1I.IGSO,SMHM.B3I.IGSO,4,flag,model,type1,type2,'IGSO');
             plot3DSky(SMHM.B1I.MEO,SMHM.B3I.MEO,4,flag,model,type1,type2,'MEO');
          end 
       end
   end
   % Plot Overlapping MHM (FMHM)
   if settings.model.Freq==1
       model=4;
      if settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.bds~=1
         type1='L1/E1';
         type2='L5/E5a';
          if settings.fig.phase==1
             flag=3;
             plot3DSky(FMHM.GE_1,FMHM.GE_2,3,flag,model,type1,type2);
          end
          if settings.fig.code==1
             flag=4;
             plot3DSky(FMHM.GE_1,FMHM.GE_2,4,flag,model,type1,type2);
          end
      end
      if settings.sys.gps==1&&settings.sys.bds==1&&settings.sys.gal~=1
         type1='L1/B1C';
         type2='L5/B2a';
          if settings.fig.phase==1
             flag=3;
             plot3DSky(FMHM.GC_1,FMHM.GC_2,3,flag,model,type1,type2);
          end
          if settings.fig.code==1
             flag=4;
             plot3DSky(FMHM.GC_1,FMHM.GC_2,4,flag,model,type1,type2);
          end
      end
      if settings.sys.bds==1&&settings.sys.gal==1&&settings.sys.gps~=1
         type1='E1/B1C';
         type2='E5a/B2a';
          if settings.fig.phase==1
             flag=3;
             plot3DSky(FMHM.EC_1,FMHM.EC_2,3,flag,model,type1,type2);
          end
          if settings.fig.code==1
             flag=4;
             plot3DSky(FMHM.EC_1,FMHM.EC_2,4,flag,model,type1,type2);
          end
      end
      if settings.sys.gps==1&&settings.sys.gal==1&&settings.sys.gal==1
         type1='L1/E1/B1C';
         type2='L5/E5a/B2a';
         if settings.fig.phase==1
             flag='phase';
             plot3DSky(FMHM.GEC_1,FMHM.GEC_2,3,flag,model,type1,type2);
          end
          if settings.fig.code==1
             flag='code';
             plot3DSky(FMHM.GEC_1,FMHM.GEC_2,4,flag,model,type1,type2);
          end
      end
   end
end