function [GPS]=readGPSNav(fid,filename)

if(fid<0)
    disp('No file!');
    return;
end

max_sat=32;               
max_hang=86400;
broad_Para=cell(max_sat,1);
for i=1:max_sat
    broad_Para{i}=zeros(max_hang,10);
end
count_hang=1;sat_num=0;

while 1
    line=fgetl(fid);
    if(line==-1), break; end
    if(line(1)=='G'&& ~strcmp(line(73:76), 'CORR'))
        sat_num=str2double(line(2:3));
        year=str2double(line(5:8));
        month=str2double(line(10:11));
        day=str2double(line(13:14));
        hour=str2double(line(16:17));
        minute=str2double(line(19:20));
        second=str2double(line(22:23));
        
        jd = cal2jd_GT(year, month, day + hour/24 + minute/1440 + second/86400);
        [GPSweek, GPStow,~] = jd2gps_GT(jd); 

        idx=round( GPStow-86400*floor(GPStow/86400) )+1;
        broad_Para{sat_num}(idx,1)=GPSweek;
        broad_Para{sat_num}(idx,2)=GPStow;
        count_hang=1;  
    end
    
    if(sat_num~=0 && count_hang ~=8)
        line=strrep(line,'D','e');
        if(count_hang==2)
            Dn=str2double(line(43:61));
            broad_Para{sat_num}(idx,4)=Dn;
        end
        if(count_hang==3)
            sqrtA=str2double(line(62:80));
            broad_Para{sat_num}(idx,3)=sqrtA;
        end
        count_hang=count_hang+1;
    end
end

for i=1:max_sat
    broad_Para{i}(all(broad_Para{i}==0,2),:)=[];
    broad_Para{i}(:,all(broad_Para{i}==0,1)) = [];
end
GPS=broad_Para;
fclose(fid);
disp(['read successfully ',filename,' GPS']);
end