function [dT_clk] = satelliteClock(sv, Ttr,input)
% Calculate (precise satellite) clock.
 
%INPUT:
%sv: satellite vehicle number
%Ttr: transmission time (GPStime)
%input: structure containing clock difference data

%OUTPUT:
%dT_clk: satellite clock correction, [s]

%uses lininterp1 (c) 2010, Jeffrey Wu

%Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

%% calculation of satellite clock
    % precise satellite clock enabled
    % --- calculate clock correction from precise clock file
    % Fast Interpolation of precise clock information:
    % cut noPoints sampling points around Ttr to accelerate interpolation
    points = 20;
    midPoints = points/2 + 1;
    % index of nearest precise clock 
    idx = find(abs(input.clk.t-Ttr) == min(abs(input.clk.t-Ttr)));    
    idx = idx(1);                                   % preventing errors 
    if idx < midPoints                              % not enough data before
        time_idxs = 1:points;                       % take data from beginning
    elseif idx > length(input.clk.t)- points/2     % not enough data afterwards
        no_el = numel(input.clk.t);                % take data until end 
        time_idxs = (no_el-points) : (no_el);       
    else                                            % enough data around
        time_idxs = (idx-points/2) : (idx+points/2);% take data around point in time
    end
    t_prec_clk = input.clk.t(time_idxs);           % time of precise clocks
    value_prec_clk = input.clk.dT(time_idxs,sv);   % values of precise clocks
    if any(value_prec_clk==0)
        % one of the values to interpolate is 0 -> do not use
        dT_clk = 0;         % satellite is excluded outside this function in modelErrorSources.m      
    else
%         dT_clk = interp1(t_prec_clk, value_prec_clk, Ttr, 'cubic', 'extrap');
        % Only linear but faster (results hardly change)
        dT_clk = lininterp1(t_prec_clk, value_prec_clk, Ttr);
    end
end     % end of satelliteClock.m
