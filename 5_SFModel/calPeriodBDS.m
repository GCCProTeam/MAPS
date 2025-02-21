function period=calPeriodBDS(broad_Para)
% Calculates the orbital period of BDS satellites based on broadcast parameters

% INPUT: 
% broad_Para：a cell array containing broadcast parameters for each satellite

% OUTPUT: 
% period： a vector containing the calculated orbital periods for each satellite

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
max_sat=63;
GM=3.986005E14;% Earth's gravitational constant (m^3/s^2)
% List of MEO satellites in BDS
MEO=[11,12,14,19,20,21,22,23,24,25,26,27,28,29,30,...
        32,33,34,35,36,37,41,42,43,44,45,46,57,58];
period=zeros(max_sat,1);

for i=1:7
    broad=broad_Para{i}; 
    % Loop through each satellite
    for k=1:max_sat
        para=broad{k};
        for j=1:size(para,1)
            if(ismember(k,MEO))   
                % Calculate the orbital period for MEO satellites
                para(j,5)=2*13*pi/(sqrt(GM)*para(j,3)^-3+para(j,4));%ORTM
                para(j,6)=7*86400-para(j,5);
            else                  
                % Calculate the orbital period for GEO/IGSO satellites
                para(j,5)=2*1*pi/(sqrt(GM)*para(j,3)^-3+para(j,4));
                para(j,6)=1*86400-para(j,5);
            end
        end
        broad{k}=para; 
    end
    broad_Para{i}=broad;
end

period_a=zeros(max_sat,7);

for i=1:7
    broad=broad_Para{i};
    for j=1:max_sat
        if(~isempty(broad{j}))
            % Calculate the mean period difference
            period_a(j,i)=mean(broad{j}(:,6));
        end
    end
end
count=sum(period_a~=0,2);
sum_period_a=sum(period_a,2);

% Calculate the final orbital period for each satellite
for i=1:max_sat
    if(ismember(i,MEO))
        if(count(i,1)~=0)
            period(i,1)=round(sum_period_a(i,1)/count(i,1));
        end
    else
        period(i,1)=round(period_a(i,7));
    end
end

end

