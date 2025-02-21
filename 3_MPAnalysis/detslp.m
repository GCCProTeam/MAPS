function [L1,C1,L5a,C5a,galARC]=detslp(L1,C1,L5a,C5a,f1,f2)
%Detecting cycle slip

%INPUT:
%L1: Phase observation value of the first frequency
%C1: Code observation value of the first frequency
%L5a: Phase observation value of the second frequency
%C5a: Code observation value of the second frequency
%f1: Frequency of L1
%f2: Frequency of L2

%OUTPUT:
%L1: Phase observation value of the first frequency after cycle slip detection
%C1: Code observation value of the first frequency after cycle slip detection
%L5a: Phase observation value of the second frequency after cycle slip detection
%C5a: Code observation value of the second frequency after cycle slip detection
%galARC: Number of arc segments of cycle slip

%Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

c=299792458;                                              %speed of light
lamda_w=c/(f1-f2);                                        %wide lane wavelength
L6=lamda_w*(L1-L5a)-(f1*C1+f2*C5a)/(f1+f2); %MW observable
Li=L1-f1*L5a/f2;
Nw=-L6;  
galARC=cell(size(C1,2),1);%wide lane ambiguity
for i=1:size(C1,2)  
    %divide arc
    arc=Get_arc(L6(:,i));
    [arc_n,~]=size(arc);
    %delete arc less than 10 epoches
    arc_d=[];
    for j=1:arc_n
        n_epoch=arc(j,2)-arc(j,1);
        if n_epoch<10
            for k=arc(j,1):arc(j,2)
                L1(k,i)=0;   C1(k,i)=0;
                L5a(k,i)=0;  C5a(k,i)=0;
                L6(k,i)=0;Nw(k,i)=0;
                Li(k,i)=0;
            end
            arc_d=[arc_d,j];
        end
    end
    arc(arc_d,:)=[];
    %mw detect cycle slip
    [arc_n,~]=size(arc);
    j=1;  
    while j<arc_n+1 
        %first epoch check
        e=arc(j,1);
        while 1
            if e+1==arc(j,2) || e==arc(j,2)
                break;
            end
            fir=Nw(e,i);sec=Nw(e+1,i);thi=Nw(e+2,i);
            firl=Li(e,i);secl=Li(e+1,i);thil=Li(e+2,i);
            sub=abs(fir-sec);sub2=abs(sec-thi);
            subl=abs(firl-secl);subl2=abs(secl-thil);
            if sub>1||sub2>1||subl>1||subl2>1  
                L1(e,i)=0;   C1(e,i)=0;
                L5a(e,i)=0;  C5a(e,i)=0;
                Nw(e,i)=0;L6(e,i)=0;Li(e,i)=0;
                e=e+1;
                arc(j,1)=e;
            else
                arc(j,1)=e;
                break;
            end
        end
        %detect
        if arc(j,2)-arc(j,1)<10
            for k=arc(j,1):arc(j,2)
                L1(k,i)=0;C1(k,i)=0;
                L5a(k,i)=0;C5a(k,i)=0;
                L6(k,i)=0;Nw(k,i)=0;Li(k,i)=0;
            end
            arc(j,:)=[];
            arc_n=arc_n-1;
            continue;
        end
        ave_N=linspace(0,0,arc(j,2)-arc(j,1)+1);
        sigma2=linspace(0,0,arc(j,2)-arc(j,1)+1);
        sigma=linspace(0,0,arc(j,2)-arc(j,1)+1);
        ave_N(1)=Nw(arc(j,1),i);
        sigma2(1)=0;
        sigma(1)=0;
        count=2;
        for k=arc(j,1)+1:arc(j,2)-1 %check epoch k+1
            ave_N(count)=ave_N(count-1)+(Nw(k,i)-ave_N(count-1))/count;
            sigma2(count)=sigma2(count-1)+((Nw(k,i)-ave_N(count-1))^2-sigma2(count-1))/count;
            sigma(count)=sqrt(sigma2(count));
            T=abs(Nw(k+1,i)-ave_N(count));
            I1=abs(Li(k+1,i)-Li(k,i));
            if T<4*sigma(count)&&I1<0.28   %no cycle slip
                count=count+1;
                continue;
            else
                if k+1==arc(j,2)            %arc end
                    if k+1-arc(j,1)>10
                        L1(k+1,i)=0;C1(k+1,i)=0;
                        L5a(k+1,i)=0;C5a(k+1,i)=0;
                        Nw(k+1,i)=0;L6(k+1,i)=0;
                        Li(k,i)=0;
                        arc(j,2)=k;
                    else                     %delete scatter epoches
                        for l=arc(j,1):k+1
                            L1(l,i)=0;C1(l,i)=0;
                            L5a(l,i)=0;C5a(l,i)=0;

                            Nw(l,i)=0;L6(l,i)=0;
                            Li(k,i)=0;
                        end
                        arc(j,:)=[];
                        j=j-1;
                        arc_n=arc_n-1;
                    end
                    break;
                end
                I2=abs(Li(k+2,i)-Li(k+1,i));
                if abs(Nw(k+2,i)-Nw(k+1,i))<1&&I2<1%cycle slip
                    if k+1-arc(j,1)>10
                        arc=[arc(1:j-1,:);[arc(j,1),k];[k+1,arc(j,2)];arc(j+1:arc_n,:)];
                        arc_n=arc_n+1;
                    else                    %delete scatter epoches
                        for l=arc(j,1):k
                            L1(l,i)=0;C1(l,i)=0;
                            L5a(l,i)=0;C5a(l,i)=0;
                            Nw(l,i)=0;L6(l,i)=0;
                            Li(k,i)=0;
                        end
                        arc(j,1)=k+1;
                        j=j-1;
                    end
                else                        %gross error
                    if k+1-arc(j,1)>10
                        L1(k+1,i)=0;C1(k+1,i)=0;
                        L5a(k+1,i)=0;C5a(k+1,i)=0;
   
                        Nw(k+1,i)=0;L6(k+1,i)=0;
                        Li(k,i)=0;
                        arc=[arc(1:j-1,:);[arc(j,1),k];[k+2,arc(j,2)];arc(j+1:arc_n,:)];
                        arc_n=arc_n+1;
                    else
                        for l=arc(j,1):k+1  %delete scatter epoches
                            L1(l,i)=0;C1(l,i)=0;
                            L5a(l,i)=0;C5a(l,i)=0;
                           
                            Nw(l,i)=0;L6(l,i)=0;
                            Li(k,i)=0;
                        end
                        arc(j,1)=k+2;
                        j=j-1;
                    end
                end
                break;
            end
        end
        j=j+1;
    end
    L1(isnan(L1)) = 0;
    C1(isnan(C1)) = 0;
    L5a(isnan(L5a)) = 0;
    C5a(isnan(C5a)) = 0;

    galARC{i,1}=arc;
end
end

%% 
function arc = Get_arc(array)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
len=length(array);
arc=[];
for i=1:len
         if i==len
             if array(i)~=0
                 arc=[arc,i];
             end
             continue;
         end
         if i==1&&array(i)~=0
             arc=[arc,i];
         end
         if array(i)==0&&array(i+1)~=0
             arc=[arc,i+1];
             continue;
         end
         if array(i)~=0&&array(i+1)==0
             arc=[arc,i];
             continue;
         end
end
if len==0,return,end
arc=reshape(arc,2,[]);
arc=arc';
end
