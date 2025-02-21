function [TMHM]=modelTrendSurfAnalysisMHM(res,resType)
% This function performs Trend Surface Analysis on satellite data (res) 
% based on elevation and azimuth divisions. It supports phase and code 
% residuals

% INPUT:
% res: Satellite data matrix, with columns for azimuth, elevation, and residuals.
% resType: Residual type (1: DD, 2:UDIF, 3: UDUC).

% OUTPUT:
% TMHM: A cell array containing the trend surface analysis results for each grid.

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
% Initialize parameters
el = 1;
az = 1;
flag1 = 0;%PHASE
flag2 = 0;%CODE
TMHM=cell(90,1);
count1=0;
for i = 0:el:(90-el)
    count2=0;
    count1=count1+1;
    % elevation division
    D3 = res(res(:, 6)>=i,:);%The column where the elevation is located
    D4 = D3(D3(:, 6)<(i+el),:); 
    for j = 0:az:(360-az)
        count2=count2+1;
        % azimuth division  
        D7 = D4(D4(:, 5)>=j,:);%The column where the azimuth is located
        D8 = D7(D7(:, 5)<(j+az),:);
        
        DEl(1,1) = i;
        DEl(1,2) = i+el;
        DEl(1,3) = j;
        DEl(1,4) = j+az;
        %PHASE
        %The first step is consistency test to eliminate gross errors in large grids.
        PHASEoutputArg2=stdRefiData(D8,7);
        [PHASErow,~]=size(PHASEoutputArg2);
        %The second step is quality control, the minimum number of values ​​in the grid
        if PHASErow < 15  %The minimum number of grids is 15
            flag1 = 1;
        end
        if isempty(PHASEoutputArg2) || flag1    
            index1  = 0;
            X1 = zeros(3,1);
        else
            B2 = zeros(PHASErow,3);
            for k = 1:PHASErow
                B2(k, 1) = 1;                              
                B2(k, 2) = PHASEoutputArg2(k, 5)* (pi/180);%Convert to radian
                B2(k, 3) = PHASEoutputArg2(k, 6)* (pi/180);
            end         
            NBB2 = B2'*B2;
            ConditionB2 = cond(NBB2);        
            if ConditionB2 > 10^11
                PhaseR = 10000;
            else
                L2 = PHASEoutputArg2(:, 7);
                X1 = (NBB2)\(B2'*L2); 
                SSR    = sum(((B2 * X1) - (L2)).^2);
                PhaseR = sqrt(SSR/(PHASErow-3));
            end
            %The correlation coefficient requirements are met before use
            if (PhaseR < 200)
                index1 = 1;
            else
                index1 = 0;
                X1 = zeros(3,1);
            end
        end
        %CODE
        if resType==2||resType==3
           %The first step is consistency test to eliminate gross errors in large grids.
            CODEoutputArg2=stdRefiData(D8,8);
            [CODErow,~]=size(CODEoutputArg2);
           %The second step is quality control, the minimum number of values ​​in the grid
            if CODErow < 15  %The minimum number of grids is 15
               flag2 = 1;
            end
            if isempty(CODEoutputArg2) || flag2    
               index2  = 0;
               X2 = zeros(3,1);
            else
               B2 = zeros(CODErow,3);
               for k = 1:CODErow
                   B2(k, 1) = 1;                              
                   B2(k, 2) = CODEoutputArg2(k, 5)* (pi/180);%Convert to radian
                   B2(k, 3) = CODEoutputArg2(k, 6)* (pi/180);
               end         
               NBB2 = B2'*B2;
               ConditionB2 = cond(NBB2);        
               if ConditionB2 > 10^11
                  CodeR = 10000;
               else
                  L2 = CODEoutputArg2(:, 7);
                  X2 = (NBB2)\(B2'*L2); 
                  SSR    = sum(((B2 * X2) - (L2)).^2);
                  CodeR = sqrt(SSR/(CODErow-3));
               end
               %The correlation coefficient requirements are met before use
               if (CodeR < 200)
                  index2 = 1;
               else
                   index2 = 0;
                   X2 = zeros(3,1);
               end
           end 
        elseif resType==1
            index2 = 0;
            X2 = zeros(3,1);
        end
        
        if index1 == 1
            DEl(1,1) = min(PHASEoutputArg2(:,6));
            DEl(1,2) = max(PHASEoutputArg2(:,6));
            DEl(1,3) = min(PHASEoutputArg2(:,5));
            DEl(1,4) = max(PHASEoutputArg2(:,5));
        end
       TMHM{count1,1}(count2,1:12)=[DEl(1,1),DEl(1,2),DEl(1,3),DEl(1,4),index1,X1(1),X1(2),X1(3),index2,X2(1),X2(2),X2(3)];
       flag1 = 0;
       flag2 = 0;
    end 
end
end