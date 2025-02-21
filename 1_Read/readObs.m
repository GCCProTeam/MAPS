function [obs]=readObs(obs_ipath)
%read observations from RINEX 3 files

%INPUT: 
%path: path of observation files

%OUTPUT: 
%obs: struct of observation files

%Copyright (C) Michael R. Craymer
%Adapted by GCC Group
%--------------------------------------------------------------------------
%% ------------------------------------------------------------
list_obs=dir([obs_ipath '/*.obs']);
pathname=[list_obs.folder '\'];
filename=list_obs.name;
fid=fopen(strcat(pathname,filename),'rt' );
gpsmark=1;glomark=1;
galmark=1;bdsmark=1;
while 1
    line=fgetl(fid);
    if ~ischar(line), break, end      %-------the rinex file is null or end
    if length(line)>79 && strcmp(line(61:80),'RINEX VERSION / TYPE')
        if strcmp(line(6),'3')==0
            %obs=[];
            break;
        end
    end
    %% stationname 
    if length(line)>70 && strcmp(line(61:71),'MARKER NAME')
       obs.stationname=line(1:5);
    end
    %% APPROX POSITION XYZ
    if length(line)>78 && strcmp(line(61:79),'APPROX POSITION XYZ')
       X=str2double(line(2:14));
       Y=str2double(line(16:28));
       Z=str2double(line(30:42));
       obs.pos_approx(1,1:3)=[X,Y,Z];
    end

    %get the GPS observables' types
    if length(line)>78 && strcmp('G',line(1)) && strcmp('SYS / # / OBS TYPES',line(61:79))
        mark.gps=1;
        gpsloc=zeros(1,4);
        obsgps_n=str2double(line(4:6));
        if obsgps_n>39
            for i=1:13
                gpst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                gpst(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                gpst(i+26)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgps_n-39
                gpst(i+39)={line(4+4*i:6+4*i)};
            end
        elseif obsgps_n>26 && obsgps_n<=39
            for i=1:13
                gpst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                gpst(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgps_n-26
                gpst(i+26)={line(4+4*i:6+4*i)};
            end
        elseif obsgps_n>13 && obsgps_n<=26
            for i=1:13
                gpst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgps_n-13
                gpst(i+13)={line(4+4*i:6+4*i)};
            end
        else
            for i=1:obsgps_n
                gpst(i)={line(4+4*i:6+4*i)};
            end
        end
        for i=1:obsgps_n
            if (strcmp(gpst(1,i),'L1C')) || (strcmp(gpst(1,i),'L1 ')) %L1C -> L1
                gpsloc(1)=i;
                continue;
            end
            if strcmp(gpst(1,i),'C1C') %C1C -> P1
                gpsloc(2)=i;
                continue;
            end
            if (strcmp(gpst(1,i),'L2W')) || (strcmp(gpst(1,i),'L2 ')) %L1C -> L1
                gpsloc(3)=i;
                continue;
            end
            if strcmp(gpst(1,i),'C2W') %C1C -> P1
                gpsloc(4)=i;
                continue;
            end
            if strcmp(gpst(1,i),'L5X') || strcmp(gpst(1,i),'L5 ') %L5X -> L5
                gpsloc(5)=i;
                continue;
            end
            if strcmp(gpst(1,i),'C5X') %C5X -> P5
                gpsloc(6)=i;
                continue;
            end
        end
        if gpsloc(5)==0 || gpsloc(6)==0 || gpsloc(1)==0 || gpsloc(2)==0
            gpsmark=0;markf.gps=0;
        end
        continue; 
    end
     %get the GLONASS observables' types
    if length(line)>78 && strcmp('R',line(1)) && strcmp('SYS / # / OBS TYPES',line(61:79))
        mark.glo=1;
        gloloc=zeros(1,4);
        obsglo_n=str2double(line(4:6));
        if obsglo_n>39
            for i=1:13
                glot(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                glot(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                glot(i+26)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsglo_n-39
                glot(i+39)={line(4+4*i:6+4*i)};
            end
        elseif obsglo_n>26 && obsglo_n<=39
            for i=1:13
                glot(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                glot(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsglo_n-26
                glot(i+26)={line(4+4*i:6+4*i)};
            end
        elseif obsglo_n>13 && obsglo_n<=26
            for i=1:13
                glot(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsglo_n-13
                glot(i+13)={line(4+4*i:6+4*i)};
            end
        else
            for i=1:obsglo_n
                glot(i)={line(4+4*i:6+4*i)};
            end
        end
        for i=1:obsglo_n
            if strcmp(glot(1,i),'L1C') || strcmp(glot(1,i),'L1 ') %L1C -> L1
                gloloc(1)=i;
                continue;
            end
            if strcmp(glot(1,i),'C1C') %C1C -> P1
                gloloc(2)=i;
                continue;
            end
            if strcmp(glot(1,i),'L2C') || strcmp(glot(1,i),'L2 ') %L2C -> L2
                gloloc(3)=i;
                continue;
            end
            if strcmp(glot(1,i),'C2C') %C2C -> P2
                gloloc(4)=i;
                continue;
            end
        end
        if gloloc(3)==0 || gloloc(4)==0 || gloloc(1)==0 || gloloc(2)==0
            glomark=0;markf.glo=0;
        end
        continue; 
    end
     %get the GALILEO observables' types
    if length(line)>78 && strcmp('E',line(1)) && strcmp('SYS / # / OBS TYPES',line(61:79))
        mark.gal=1;
        galloc=zeros(1,4);
        obsgal_n=str2double(line(4:6));
        if obsgal_n>39
            for i=1:13
                galt(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                galt(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                galt(i+26)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgal_n-39
                galt(i+39)={line(4+4*i:6+4*i)};
            end
        elseif obsgal_n>26 && obsgal_n<=39
            for i=1:13
                galt(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                galt(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgal_n-26
                galt(i+26)={line(4+4*i:6+4*i)};
            end
        elseif obsgal_n>13 && obsgal_n<=26
            for i=1:13
                galt(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsgal_n-13
                galt(i+13)={line(4+4*i:6+4*i)};
            end
        else
            for i=1:obsgal_n
                galt(i)={line(4+4*i:6+4*i)};
            end
        end
        for i=1:obsgal_n
            if strcmp(galt(1,i),'L1X') || strcmp(galt(1,i),'L1 ')  %E1
                galloc(1)=i;
                continue;
            end
            if strcmp(galt(1,i),'C1X') || strcmp(galt(1,i),'C1 ')  
                galloc(2)=i;
                continue;
            end
            if strcmp(galt(1,i),'L5X') || strcmp(galt(1,i),'L5 ')  %E5a
                galloc(3)=i;
                continue;
            end
            if strcmp(galt(1,i),'C5X') || strcmp(galt(1,i),'C5 ')  
                galloc(4)=i;
                continue;
            end
            if strcmp(galt(1,i),'L7X') || strcmp(galt(1,i),'L7 ')  %E5b
                galloc(5)=i;
                continue;
            end
            if strcmp(galt(1,i),'C7X') || strcmp(galt(1,i),'C7 ')  
                galloc(6)=i;
                continue;
            end
        end
        if galloc(3)==0 || galloc(4)==0 || galloc(1)==0 || galloc(2)==0
                galmark=0;markf.gal=0;
        end
        continue; 
    end    
     %get the BDS observables' types
    if length(line)>78 && strcmp('C',line(1)) && strcmp('SYS / # / OBS TYPES',line(61:79))
        mark.bds=1;
        bdsloc=zeros(1,8);
        obsbds_n=str2double(line(4:6));
        if obsbds_n>39
            for i=1:13
                bdst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                bdst(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                bdst(i+26)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsbds_n-39
                bdst(i+39)={line(4+4*i:6+4*i)};
            end
        elseif obsbds_n>26 && obsbds_n<=39
            for i=1:13
                bdst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:13
                bdst(i+13)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsbds_n-26
                bdst(i+26)={line(4+4*i:6+4*i)};
            end
        elseif obsbds_n>13 && obsbds_n<=26
            for i=1:13
                bdst(i)={line(4+4*i:6+4*i)};
            end
            line=fgetl(fid);
            for i=1:obsbds_n-13
                bdst(i+13)={line(4+4*i:6+4*i)};
            end
        else
            for i=1:obsbds_n
                bdst(i)={line(4+4*i:6+4*i)};
            end
        end
        for i=1:obsbds_n
            if strcmp(bdst(1,i),'L2I') %L2I -> B1I
                bdsloc(1)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C2I') %C2I 
                bdsloc(2)=i;
                continue;
            end
            if strcmp(bdst(1,i),'L7I') %L2I -> B2I
                bdsloc(3)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C7I') %C2I 
                bdsloc(4)=i;
                continue;
            end
            if strcmp(bdst(1,i),'L6I') %L6I -> B3I
                bdsloc(5)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C6I') %C6I 
                bdsloc(6)=i;
                continue;
            end
            if strcmp(bdst(1,i),'L1X') %L2I -> B1C
                bdsloc(7)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C1X') %C2I 
                bdsloc(8)=i;
                continue;
            end
            if strcmp(bdst(1,i),'L5X') %L2I -> B2a
                bdsloc(9)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C5X') %C2I 
                bdsloc(10)=i;
                continue;
            end
            if strcmp(bdst(1,i),'L7D') %L2I -> B2b
                bdsloc(11)=i;
                continue;
            end
            if strcmp(bdst(1,i),'C7D') %C2I 
                bdsloc(12)=i;
                continue;
            end
        end
        if bdsloc(1)==0 || bdsloc(2)==0 || bdsloc(5)==0 || bdsloc(6)==0
        end
        continue; 
    end 
    
    if length(line)>76 && strcmp(line(61:77),'TIME OF FIRST OBS')
       year=str2double(line(3:6));
       month=str2double(line(10:12));
       day=str2double(line(16:18));
       h=str2double(line(22:24));
       m=str2double(line(28:30));
       s=str2double(line(33:43));
       obs.startdate(1,1:6)=[year,month,day,h,m,s];
    end

    if exist('mark','var') && exist('markf','var')
        field=fieldnames(mark);
        fieldf=fieldnames(markf);
        if length(field)==length(fieldf)
            obs=[];break;
        end
    end
        
    %start getting observables
    if(length(line)>72&&strcmp(line(61:73),'END OF HEADER')) 
        while 1                      
            line=fgetl(fid);
            if ~ischar(line)
                break;
            end     %come to end,break
            %get epoch number
            if length(line)>32 && strcmp(line(1),'>')
                year=str2double(line(3:6));
                month=str2double(line(8:9));
                day=str2double(line(11:12));
                h=str2double(line(14:15));
                m=str2double(line(17:18));
                s=str2double(line(20:29));
                ep=h*120+m*2+s/30+1;  
                jd = cal2jd_GT(year, month, day + h/24 + m/1440 + s/86400);
                [week,sow,~] = jd2gps_GT(jd);
                mjd = jd-2400000.5; 
            end 
            if ep~=fix(ep),continue,end
            obs.Week(ep,1)=week;
            obs.Time(ep,1)=sow;
            obs.mjd(ep,1)=mjd;
            if gpsmark~=0 && exist('gpsloc','var')
                if length(line)>max(gpsloc)*16 && strcmp(line(1),'G')
                    sv_G=str2double(line(2:3));
                    obs.GPS.L1(ep,sv_G)=str2double(line(16*gpsloc(1)-12:16*gpsloc(1)+1));
                    obs.GPS.C1(ep,sv_G)=str2double(line(16*gpsloc(2)-12:16*gpsloc(2)+1));
                    obs.GPS.L2(ep,sv_G)=str2double(line(16*gpsloc(3)-12:16*gpsloc(3)+1));
                    obs.GPS.C2(ep,sv_G)=str2double(line(16*gpsloc(4)-12:16*gpsloc(4)+1));
                    obs.GPS.L5(ep,sv_G)=str2double(line(16*gpsloc(5)-12:16*gpsloc(5)+1));
                    obs.GPS.C5(ep,sv_G)=str2double(line(16*gpsloc(6)-12:16*gpsloc(6)+1));
                end
            end
            if glomark~=0 && exist('gloloc','var')
                if length(line)>max(gloloc)*16 && strcmp(line(1),'R')
                    %sv_R=str2double(line(2:3));
                    %obs.GLOL1P(ep,sv_R)=str2double(line(16*gloloc(1)-12:16*gloloc(1)+1));
                    %obs.GLOL2P(ep,sv_R)=str2double(line(16*gloloc(2)-12:16*gloloc(2)+1));
                    %obs.GLOC1P(ep,sv_R)=str2double(line(16*gloloc(3)-12:16*gloloc(3)+1));
                    %obs.GLOC2P(ep,sv_R)=str2double(line(16*gloloc(4)-12:16*gloloc(4)+1));
                end
            end
            if galmark~=0 && exist('galloc','var')
                if length(line)>max(galloc)*16 && strcmp(line(1),'E')
                    sv_E=str2double(line(2:3));
                    obs.GAL.L1(ep,sv_E)=str2double(line(16*galloc(1)-12:16*galloc(1)+1));%E1
                    obs.GAL.C1(ep,sv_E)=str2double(line(16*galloc(2)-12:16*galloc(2)+1));
                    obs.GAL.L5a(ep,sv_E)=str2double(line(16*galloc(3)-12:16*galloc(3)+1));%E5a
                    obs.GAL.C5a(ep,sv_E)=str2double(line(16*galloc(4)-12:16*galloc(4)+1));
                    obs.GAL.L5b(ep,sv_E)=str2double(line(16*galloc(5)-12:16*galloc(5)+1));%E5b
                    obs.GAL.C5b(ep,sv_E)=str2double(line(16*galloc(6)-12:16*galloc(6)+1));
                end
            end
             if bdsmark~=0 && exist('bdsloc','var')
                if length(line)>max(bdsloc)*16 && strcmp(line(1),'C')
                    sv_C=str2double(line(2:3));
                    if sv_C<=46
                    obs.BDS.L1I(ep,sv_C)=str2double(line(16*bdsloc(1)-12:16*bdsloc(1)+1));%B1I
                    obs.BDS.C1I(ep,sv_C)=str2double(line(16*bdsloc(2)-12:16*bdsloc(2)+1));
                    obs.BDS.L2I(ep,sv_C)=str2double(line(16*bdsloc(3)-12:16*bdsloc(3)+1));%B2I
                    obs.BDS.C2I(ep,sv_C)=str2double(line(16*bdsloc(4)-12:16*bdsloc(4)+1));
                    obs.BDS.L3I(ep,sv_C)=str2double(line(16*bdsloc(5)-12:16*bdsloc(5)+1));%B3I
                    obs.BDS.C3I(ep,sv_C)=str2double(line(16*bdsloc(6)-12:16*bdsloc(6)+1));
                    obs.BDS.L1C(ep,sv_C)=str2double(line(16*bdsloc(7)-12:16*bdsloc(7)+1));%B1C
                    obs.BDS.C1C(ep,sv_C)=str2double(line(16*bdsloc(8)-12:16*bdsloc(8)+1));
                    obs.BDS.L2a(ep,sv_C)=str2double(line(16*bdsloc(9)-12:16*bdsloc(9)+1));%B2a
                    obs.BDS.C2a(ep,sv_C)=str2double(line(16*bdsloc(10)-12:16*bdsloc(10)+1));
                   end
                end
            end

        end
    end
end
fclose(fid);
disp(['read successfully  ',filename]);
end