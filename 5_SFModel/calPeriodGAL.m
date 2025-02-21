function period=calPeriodGAL(broad_Para)
% Calculates the orbital period of GAL satellites based on broadcast parameters

% INPUT: 
% broad_Para：a cell array containing broadcast parameters for each satellite

% OUTPUT: 
% period： a vector containing the calculated orbital periods for each satellite

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
max_sat=36;
GM=3.986005E14;   % Earth's gravitational constant (m^3/s^2)             
period=zeros(max_sat,1);

for i=1:10
    broad=broad_Para{i}; 
     % Loop through each satellite
    for k=1:max_sat
        para=broad{k};
        for j=1:size(para,1)
            % Calculate the orbital period using the given formula
            para(j,5)=2*17*pi/(sqrt(GM)*para(j,3)^-3+para(j,4));
            para(j,6)=10*86400-para(j,5);
        end
        if k==14||k==18% E14 and E18 have been deactivated
           para=[];
        end
        broad{k}=para;
    end
    broad_Para{i}=broad;%Update the broadcast parameters for the current set
end

period_a=zeros(max_sat,10);

for i=1:10
    broad=broad_Para{i};
    for j=1:max_sat
        if(~isempty(broad{j}))
            period_a(j,i)=mean(broad{j}(:,6));
        end
    end
end
count=sum(period_a~=0,2);
sum_period_a=sum(period_a,2);
for i=1:max_sat
        if(count(i,1)~=0)
             % Calculate the mean period difference
            period(i,1)=round(sum_period_a(i,1)/count(i,1));
        end
end

end

