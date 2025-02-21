function tt = check_t(t)
%Repairs over- and underflow of GPS time

%INPUT:
%t: time in seconds of week

%OUPUT:
%tt: repaired time

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------
% ||| check if necessary at all!

half_week = 302400;
tt = t;

if t >  half_week
    tt = t-2*half_week; 
end
if t < -half_week
    tt = t+2*half_week;
end


end

