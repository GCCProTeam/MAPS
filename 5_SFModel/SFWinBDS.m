function SF_W=SFWinBDS(res1,res7,res_1,win)
%A function to model Window Matching SF for BDS

%INPUT:
%res1：residuals of the day before the data to be corrected
%res7：residual of the seventh day before the date of data to be corrected
%res_1：residual of the data to be corrected on that day
%win: window size for the matching process

%OUTPUT:
%SF_W: Window Matching SF for BDS

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
%Judge whether the residual is empty or not.
if ~isempty(res1)&&~isempty(res7)&&~isempty(res_1)
   %Step1 The residual time series of each satellite is obtained.
   res7_series = resSeriesBDS(res7);
   res1_series = resSeriesBDS(res1);
   MEO = [11, 12, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,...
         32, 33, 34, 35, 36, 37, 41, 42, 43, 44, 45, 46, 57, 58];
   res7_series(MEO) = res1_series(MEO);
   res_series=res7_series;

   res_1_series = resSeriesBDS(res_1);
   %Step2 The residual time series of each satellite is processed 
   %by wavelet filtering
   res_series = resDwt(res_series);
   res_1_series = resDwt(res_1_series);

   %Step3 Obtaining a corrected value of the observed value to be corrected
   SF_W = resCorrectSFWin(res_series, res_1_series,win);
   SF_W=cell2mat(SF_W);
else
   SF_W=[];
end
end