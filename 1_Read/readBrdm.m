function [NAV] = readBrdm(settings, n_ipath)
% Reading GNSS navigation data

%INPUT:
%settings: A structure containing system settings
%n_ipath: The directory path containing the .nav files

%OUTPUT:
%NAV: A structure containing navigation data for GPS, GAL, and BDS systems

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the NAV structure to store navigation data
NAV = [];    
    
% Get a list of all .nav files in the specified directory
list_n = dir([n_ipath '/*.nav']);
len = length(list_n);
    
% Check if GPS is sopported in the settings
if settings.sys.gps == 1
   % Initialize a cell array to store GPS navigation data
   NAV.GPS = cell(1, 1); 
        
  % Get the path and filename of the most recent .nav file, which is 
  % the navigation data of the previous day of GPS data to be corrected
   pathname = [list_n(len).folder '\'];
   filename = list_n(len).name;
        
   % Open the file for reading
   fid = fopen(strcat(pathname, filename), 'rt');
        
   % Read GPS navigation data from the file
   [NAV.GPS{1, 1}] = readGPSNav(fid, filename); 
        
end
    
% Check if Galileo is sopported in the settings
if settings.sys.gal == 1
   
   NAV.GAL = cell(10, 1);        
   % Loop through the last 10 .nav files
   for i = (len - 9) : len
       pathname = [list_n(i).folder '\'];
       filename = list_n(i).name;
             
       fid = fopen(strcat(pathname, filename), 'rt');
            
       [NAV.GAL{i - (len - 10), 1}] = readGALNav(fid, filename);
            
   end 
end
    
% Check if BDS is sopported in the settings
if settings.sys.bds == 1

   NAV.BDS = cell(7, 1);  
        % Loop through the last 7 .nav files
   for i = (len - 6) : len
       pathname = [list_n(i).folder '\'];
       filename = list_n(i).name;
            
       fid = fopen(strcat(pathname, filename), 'rt');
            
       [NAV.BDS{i - (len - 7), 1}] = readBDSNav(fid, filename);
            
   end  
end
end