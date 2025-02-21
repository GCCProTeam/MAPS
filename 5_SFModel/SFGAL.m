function SF=SFGAL(RES,NAV)
%Function to process GAL residuals and compute the SF corrections

%INPUT:
%RES: Residuals from GAL 
%NAV: Navigation data

%OUTPUT:
%SF：SF computed from the residuals

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
if isempty(RES)
    fprintf('The residual of GAL is empty.');
    SF=[];
else
    %step1 the SD residual time series of each satellite is obtained.
    RES_series = resSeriesGAL(RES);
    %step2 wavelet denoising
    RES_series = resDenoise(RES_series);
    %step3 calculate the period from the navigation data
    period=calPeriodGAL(NAV);
    for k=1:size(RES_series)
        if ~isempty(RES_series{k})
           internal=RES_series{k}(2,1)-RES_series{k}(1,1);
           break;
        end
    end
    % Adjust the period to align with the time interval
    for i=1:size(period)
        period(i)=internal*(round((period(i)/internal)*2)/2); 
    end
    %step4 according to the residual data sequence and orbit period, 
    %the correction value is calculated
    SF = resCorrectSF(RES_series,period);
    SF=cell2mat(SF);
end
end
