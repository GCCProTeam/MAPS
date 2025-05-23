function [X, V] = precSatpos(precEph, sv, Ttr)
%Interpolation of precise ephemerides (position and velocity) to the time
%of the emission of the observation with a polynom degree 11.

%INPUT:
%precEph: struct with precise ephemerides from .sp3-file
%sv: satellite number [0, 99]
%Ttr: time of observation in seconds of week

%OUTPUT:
%X:           vector with XYZ coordinates
%V:           vector with XYZ velocities

%Copyright (c) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------
% check if interpolation is possible at all
if all(precEph.t(:,sv) == 0)     % no precise ephemeris data for this satellite at all
%     if bool_print
%         fprintf('\nNo precise orbit data for satellite %d in SOW %.3f              \n', prn, Ttr);
%     end
    X = NaN(3,1); V = NaN(3,1);
    % cutoff = true;
    % status = 6;
    return
end

% Preparations
X = zeros(3,1);     V = zeros(3,1);
n = size(precEph.t,1);          % number of rows (epochs) of precise Ephemeris
dt = precEph.t(:,sv)-Ttr;       % time difference to precise orbits
dt_abs = abs(dt);
bool = dt_abs == min(dt_abs);
idx = find(bool);               % index of timely nearest orbit data

% select 12 nearest epochs for interpolation
start_epoch = idx - 5;          % assume: nearest point is after current point in time
end_epoch   = idx + 6;
if dt(bool) < 0                 % nearest point is before current point in time
    start_epoch = idx - 6;      % -> change indices
    end_epoch   = idx + 5;
end
if idx <= 7                     % beginning of day, take first 12 epochs
    start_epoch = 1;
    end_epoch   = 12;
elseif idx + 7 >= n             % end of day, take last 12 epochs
    start_epoch = n - 11;
    end_epoch   = n;
end

% epochs which will be interpolated
epochs = start_epoch:end_epoch;

% get data for interpolation
T_ipol = precEph.t(epochs,sv);
X_ipol = precEph.X(epochs,sv);
Y_ipol = precEph.Y(epochs,sv);
Z_ipol = precEph.Z(epochs,sv);

% check for missing data and if interpolation is possible
if isempty(epochs) || any((X_ipol == 0) | (Y_ipol == 0) | (Z_ipol == 0))
    % interpolation is not possible (one zero makes degree 12 impossible)
    % if bool_print
    %     fprintf('\nNo precise orbit data for satellite %d in SOW %.3f              \n', prn, Ttr);
    % end
    X = NaN(3,1); V = NaN(3,1);
    % cutoff = true;
    % status = 6;
    return
end

% Ttr=-0.06835461392735942;
OMGE=7.2921151467E-5;
Myt=T_ipol-Ttr;
for kk=1:size(Myt)
    tt=Myt(kk);
    sinl=sin(OMGE*tt);
    cosl=cos(OMGE*tt);
    X_(kk)=(cosl.*X_ipol(kk))-(sinl.*Y_ipol(kk));
    Y_(kk)=sinl*X_ipol(kk)+cosl*Y_ipol(kk);
    Z_(kk)=Z_ipol(kk);
end

% interpolate orbit with Langrange Interpolation Degree 11
[X(1),X(2),X(3)] = polyInterp11(Ttr, T_ipol, X_, Y_, Z_);
% [X(1),X(2),X(3)] = poly_interp11(Ttr, T_ipol, X_ipol, Y_ipol, Z_ipol);

if ~isfield(precEph,'t_vel')
    % no velocity information, interpolate velocity from positions
    dt_ = 0.001;     % [s]
    % [X_prev(1),X_prev(2),X_prev(3)] = poly_interp11(Ttr-dt_, T_ipol, X_ipol, Y_ipol, Z_ipol );
    [X_prev(1),X_prev(2),X_prev(3)] = polyInterp11(Ttr-dt_, T_ipol, X_, Y_, Z_);
    V = (X - X_prev')/dt_;
else
    [V(1),V(2),V(3)] = polyInterp11(Ttr, precEph.t_vel(epochs,sv), precEph.X_vel(epochs,sv), precEph.Y_vel(epochs,sv), precEph.Z_vel(epochs,sv) );
end


