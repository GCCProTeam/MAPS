function e = calPartialPressureWaterVapor(T, rh)
% calulate partial pressure of water vapor from temperature with Magnus' 
% formula

%INPUT:
%T:Temperature [°C]
%rh: relative humidity [%]

%OUTPUT:
%e: partial pressure of water vapor [hPa]

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

% saturation pressure of water vapor with Magnus' formula
% constants between 0 and 100 °C
C1 = 6.112;     % [hPa]
C2 = 17.62;
C3 = 234.12;    % [°C] 

% saturation pressure
E = C1 * exp((C2*T)/(C3+T)); % [hPa]

% partial pressure of water vapor [hPa]
e = rh/100 * E;

end
