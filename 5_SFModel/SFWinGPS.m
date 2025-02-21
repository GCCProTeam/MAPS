function SF_W=SFWinGPS(res,res1,win)
%A function to model Window Matching SF for GPS

%INPUT:
%res： residuals of the day before the data to be corrected
%res1：residual of the data to be corrected on that day
%win: window size for the matching process

%OUTPUT:
%SF_W: Window Matching SF for GPS

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
%Judge whether the residual is empty or not.
if ~isempty(res)&&~isempty(res1)
   %Step1 The residual time series of each satellite is obtained
   res_series = resSeriesGPS(res);
   res1_series = resSeriesGPS(res1);

   %Step2 The residual time series of each satellite is processed 
   %by wavelet filtering
   res_series = resDwt(res_series);
   res1_series = resDwt(res1_series);

   %Step3 Obtaining a corrected value of the observed value to be corrected
   SF_W = resCorrectSFWin(res_series, res1_series,win);
   SF_W=cell2mat(SF_W);
else
   SF_W=[];
end
end
