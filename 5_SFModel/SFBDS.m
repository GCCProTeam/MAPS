function SF=SFBDS(RES1,RES7,NAV)
%Function to process BDS residuals and compute the SF corrections

%INPUT:
%RES1: Residuals of the previous day of data to be corrected from BDS 
%RES1: Residuals of the seventh day before the data to be corrected from BDS
%NAV: Navigation data

%OUTPUT:
%SF：SF computed from the residuals

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
if isempty(RES1)||isempty(RES7)
    fprintf('The residual of BDS is empty.');
    SF=[];
end
if ~isempty(RES1)&&~isempty(RES7)
   % step1 the SD residual time series of each satellite is obtained.
   RES7_series = resSeriesBDS(RES7);
   RES1_series = resSeriesBDS(RES1);
   MEO = [11, 12, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,...
          32, 33, 34, 35, 36, 37, 41, 42, 43, 44, 45, 46, 57, 58];
   if isempty(RES1_series)||isempty(RES7_series)
      fprintf('BDS residual matrix is empty, so SF of BDS cannot be modeled!!!!!!');
   end
   if ~isempty(RES1_series)&&~isempty(RES7_series)
      RES7_series(MEO) = RES1_series(MEO);
   end
   RES_series=RES7_series;

   %step2 wavelet denoising
   RES_series = resDenoise(RES_series);
   %step3 Calculate the period from the navigation data
   period=calPeriodBDS(NAV);
   for k=1:size(RES_series)
       if ~isempty(RES_series{k})
          internal=RES_series{k}(2,1)-RES_series{k}(1,1);
          break;
       end
   end
   for i=1:size(period)
       period(i)=internal*(round((period(i)/internal)*2)/2); 
   end
   %step4 according to the residual data sequence and orbit period, 
   %the correction value is calculated
   SF = resCorrectSF(RES_series,period);
   SF=cell2mat(SF);
end
end