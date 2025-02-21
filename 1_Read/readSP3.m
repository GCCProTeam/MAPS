function [input] = readSP3(s_ipath,rec_XYZ)
%read sp3 files to struct
%produced from 'read_sp3.m' in M_DCB

%INPUT:
%s_ipath: storage path of *.sp3 files
%rec_XYZ: receiver position

%OUTPUT:
%input: a structure for storing data of read Sp3 file

%Copyright (C) Jin R et al.
%Modified by Zhou C. et al., 2021/12/12
%Adapted by GCC Group
%--------------------------------------------------------------------------
list_obs=dir([s_ipath '/*.sp3']);
len=length(list_obs);
if len<3
 error('need at least three SP3 files !!!');
end
for i=1:len-2
    pr_obs=[s_ipath '/' list_obs(i).name];
    cu_obs=[s_ipath '/' list_obs(i+1).name];
    nx_obs=[s_ipath '/' list_obs(i+2).name];
    [~,~,gpsx1,gpsy1,gpsz1,~,~,glox1,gloy1,gloz1,~,~,galx1,galy1,galz1,~,~,bdsx1,bdsy1,bdsz1]=r_sp3(pr_obs);
    [gpstw2,gpsts2,gpsx2,gpsy2,gpsz2,glotw2,glots2,glox2,gloy2,gloz2,galtw2,galts2,galx2,galy2,galz2,bdstw2,bdsts2,bdsx2,bdsy2,bdsz2]=r_sp3(cu_obs);
    [~,~,gpsx3,gpsy3,gpsz3,~,~,glox3,gloy3,gloz3,~,~,galx3,galy3,galz3,~,~,bdsx3,bdsy3,bdsz3]=r_sp3(nx_obs);
    numgps=max([size(gpsx1,2),size(gpsx2,2),size(gpsx3,2)]);
    %numglo=max([size(glox1,2),size(glox2,2),size(glox3,2)]);
    numgal=max([size(galx1,2),size(galx2,2),size(galx3,2)]);
    numbds=max([size(bdsx1,2),size(bdsx2,2),size(bdsx3,2)]);
    [~,~,x.gps,y.gps,z.gps]=interplotation(numgps,gpsx1,gpsy1,gpsz1,gpstw2,gpsts2,gpsx2,gpsy2,gpsz2,gpsx3,gpsy3,gpsz3);
   %[glotw,glots,glox,gloy,gloz]=interplotation(numglo,glox1,gloy1,gloz1,glotw2,glots2,glox2,gloy2,gloz2,glox3,gloy3,gloz3);
    [~,~,x.gal,y.gal,z.gal]=interplotation(numgal,galx1,galy1,galz1,galtw2,galts2,galx2,galy2,galz2,galx3,galy3,galz3);
    [~,~,x.bds,y.bds,z.bds]=interplotation(numbds,bdsx1,bdsy1,bdsz1,bdstw2,bdsts2,bdsx2,bdsy2,bdsz2,bdsx3,bdsy3,bdsz3);
   %[sate_pos.GPS,sate_aebl.GPS]= save_data(gpstw,gpsts,gpsx,gpsy,gpsz,pos_r);
   %[sate_pos.GLO,sate_aebl.GLO]= save_data(glotw,glots,glox,gloy,gloz,pos_r);
   %[sate_pos.GAL,sate_aebl.GAL]= save_data(galtw,galts,galx,galy,galz,pos_r);
   %[sate_pos.BDS,sate_aebl.BDS]= save_data(bdstw,bdsts,bdsx,bdsy,bdsz,pos_r);
    [el.gps,az.gps] = save_data(x.gps,y.gps,z.gps,rec_XYZ);
    [el.gal,az.gal] = save_data(x.gal,y.gal,z.gal,rec_XYZ);
    [el.bds,az.bds] = save_data(x.bds,y.bds,z.bds,rec_XYZ);
    x=[x.gps,x.gal,x.bds];
    y=[y.gps,y.gal,y.bds];
    z=[z.gps,z.gal,z.bds];
    el=[el.gps,el.gal,el.bds];
    az=[az.gps,az.gal,az.bds];
    input.x=x;
    input.y=y;
    input.z=z;
    input.el=el;
    input.az=az;
end
end
%% -------------------------subfunction-----------------------------
function [GPSTW,GPSTS,GPSX,GPSY,GPSZ,GLOTW,GLOTS,GLOX,GLOY,GLOZ,GALTW,GALTS,GALX,GALY,GALZ,BDSTW,BDSTS,BDSX,BDSY,BDSZ] = r_sp3( path)
fid = fopen(path,'r');
line=fgetl(fid);
ep=0;%epoch number
day=line(12:13);
while 1
    if ~ischar(line), break, end
    line=fgetl(fid);
    if strcmp(line(1),'*') && strcmp(line(12:13),day)
        y=str2double(line(4:7));
        mou=str2double(line(9:10));
        d=str2double(line(12:13));
        h=str2double(line(15:16));
        m=str2double(line(18:19));
        s=str2double(line(21:22));
        ep=h*12+round(m/5)+1;
        jd = cal2jd_GT(y, mou, d + h/24 + m/1440 + s/86400);
        [week, sow,~] = jd2gps_GT(jd);         % increase epoch index
        continue;
    end
    if strcmp(line(1),'*') && ~strcmp(line(12:13),day)
        break;
    end
    if length(line)>1 && strcmp(line(1:2),'PG')
        sv=str2double(line(3:4));
        GPSTW(ep,sv) = week;
        GPSTS(ep,sv) = sow;
        GPSX(ep,sv) = str2double(line(5:18));
        GPSY(ep,sv) = str2double(line(19:32));
        GPSZ(ep,sv) = str2double(line(33:46));
        continue;
    end
    if length(line)>1 && strcmp(line(1:2),'PR')
        sv=str2double(line(3:4));
        GLOTW(ep,sv) = week;
        GLOTS(ep,sv) = sow;
        GLOX(ep,sv) = str2double(line(5:18));
        GLOY(ep,sv) = str2double(line(19:32));
        GLOZ(ep,sv) = str2double(line(33:46));
        continue;
    end
    if length(line)>1 && strcmp(line(1:2),'PE')
        sv=str2double(line(3:4));
        GALTW(ep,sv) = week;
        GALTS(ep,sv) = sow;
        GALX(ep,sv) = str2double(line(5:18));
        GALY(ep,sv) = str2double(line(19:32));
        GALZ(ep,sv) = str2double(line(33:46));
        continue;
    end
    if length(line)>1 && strcmp(line(1:2),'PC')
        sv=str2double(line(3:4));
        BDSTW(ep,sv) = week;
        BDSTS(ep,sv) = sow;
        BDSX(ep,sv) = str2double(line(5:18));
        BDSY(ep,sv) = str2double(line(19:32));
        BDSZ(ep,sv) = str2double(line(33:46));
        continue;
    end
end
fclose(fid);
end
%% -------------------------subfunction-----------------------------
function [interp_tw2,interp_ts2,interp_x2,interp_y2,interp_z2]=interplotation(satenum,x1,y1,z1,tw2,ts2,x2,y2,z2,x3,y3,z3)
tw2 = removeZeroColumns(tw2);
ts2 = removeZeroColumns(ts2);
tw2=tw2(:,1);
rows = [];
for i = 1:length(tw2) - 1
    if tw2(i + 1) == tw2(i) + 1
        rows = [rows; i];
    end
end
if isempty(rows)
  interp_tw2=tw2(1,1)*ones(2880,1);  
end
if ~isempty(rows)
tw2_1=tw2(1:rows,1);       len_1=length(tw2_1)*10;
tw2_2=tw2(rows+1:end,1);   len_2=length(tw2_2)*10;
interp_tw2=[tw2_1(1,1)*ones(len_1,1);tw2_2(1,1)*ones(len_2,1)];
end

m=1:1:size(ts2);          m=m';
p = polyfit(m, ts2(:,1), 1);
m1=1:1:size(ts2)*10;    m1=m1';
k=p(1)/10;      b=p(2)/10;
yjj=k*m1(:,1)+b;
interp_ts2=round(yjj);

interp_x2=zeros(2880,satenum);
interp_y2=zeros(2880,satenum);
interp_z2=zeros(2880,satenum);
x2=[x1(end-3:end,:);x2;x3(1:5,:)];
y2=[y1(end-3:end,:);y2;y3(1:5,:)];
z2=[z1(end-3:end,:);z2;z3(1:5,:)];
m_t=linspace(-40,2880+40,297);
for i=1:satenum
    for j=1:288     
        tt=m_t(j:j+9);
        x=x2((j:9+j),i)';
        y=y2((j:9+j),i)';
        z=z2((j:9+j),i)';
        t0=linspace(m_t(j+4),m_t(j+5)-1,10);
        interp_x2((10*j-9):10*j,i)=interp_lag(tt,x,t0)';
        interp_y2((10*j-9):10*j,i)=interp_lag(tt,y,t0)';
        interp_z2((10*j-9):10*j,i)=interp_lag(tt,z,t0)';
    end
end
end
%% -------------------------subfunction-----------------------------
function y0 = interp_lag (x, y, x0)
n=length(x);
y0=zeros(size(x0));
for k=1:n
    t=1;
    for i=1:n
        if i~=k
            t=t.*(x0-x(i))/(x(k)-x(i));
        end
    end
    y0=y0+t*y(k);
end
end
%% -------------------------subfunction-----------------------------
function [el,az] = save_data(x,y,z,pos_r)
for i=1:size(x,1)
    for j=1:size(x,2)
        X=x(i,j)*1000;
        Y=y(i,j)*1000;
        Z=z(i,j)*1000;
        [EL,AZ]=xyz2azel(pos_r,X,Y,Z);
        if EL>=0&&AZ>=0
           el(i,j)=EL;
           az(i,j)=AZ;
        end
    end
end
end
%% -------------------------subfunction-----------------------------
function matrix = removeZeroColumns(matrix)
    zeroColumns = all(matrix == 0, 1);
    matrix = matrix(:, ~zeroColumns);
end





