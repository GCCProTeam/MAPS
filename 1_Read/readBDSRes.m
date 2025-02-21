function [resB1I, resB3I,resB1C, resB2a] = readBDSRes(fid, filename)
%Reading BDS residual datas

%INPUT:
%fid: file identifier obtained from fopen
%filename: name of the file being read (for logging purposes)

%OUTPUT:
%resB1I；cell array containing B1I residual data
%resB3I；cell array containing B3I residual data
%resB1C；cell array containing B1C residual data
%resB2a；cell array containing B2a residual data

%Copyright (C) GCC Group
%-------------------------------------------------------------------------
%Check if the file ID is valid
if fid < 0
   disp('No file!');
   return;
end

%Read all lines from the file
lines = textscan(fid, '%s', 'Delimiter', '\n');
lines = lines{1};

%Initialize variables
max_rows = 86400;
resB1I = cell(max_rows, 1);
resB3I = cell(max_rows, 1);
resB1C = cell(max_rows, 1);
resB2a = cell(max_rows, 1);
count = 0;%Counter for valid data blocks

% Loop through each line in the file
for i = 1:length(lines)
    line = lines{i};

    % Check if the line starts with '$GPST' (time information)
    if startsWith(line, '$GPST')

        % Extract numerical data from the line
       data = regexp(line, '\d+\.?\d*', 'match');
       if numel(data) >= 3
          timeWeek = str2double(data{1});
          timeSow = str2double(data{2});
          stat = str2double(data{3});%Signs of fixed and float solutions
       end
          count = count + 1;
          i_1 = 0;i_2 = 0;
          i_3 = 0;i_4 = 0;%Reset row counters for L1 and L2 data
    
       %Check if the line starts with 'C' (satellite data) 
   elseif startsWith(line, 'C')
       data = regexp(line, '[-+]?\d*\.?\d+', 'match');
       satNum = str2double(data{1});
       az = str2double(data{2});
       el = str2double(data{3});

       % Process B1I data (4-7 fields)
       if numel(data)>3&&numel(data)<=7
          valid1 = str2double(data{4});%satellite valid flag of B1I
          resc1 = str2double(data{5});
          resp1 = str2double(data{6});
          cn01 = str2double(data{7}); 

          i_1 = i_1 + 1;
          resB1I{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
              el, resc1, resp1, cn01, stat]; 
     
        % Process B1I and B3I data (8-11 fields)    
      elseif numel(data)>7&&numel(data)<=11
          valid1 = str2double(data{4});
          resc1 = str2double(data{5});
          resp1 = str2double(data{6});
          cn01 = str2double(data{7});      
          valid2 = str2double(data{8});
          resc2 = str2double(data{9});
          resp2 = str2double(data{10});
          cn02 = str2double(data{11}); 

          i_1 = i_1 + 1;
          i_2 = i_2 + 1;
          resB1I{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
              el, resc1, resp1, cn01, stat];
          resB3I{count}(i_2, :) = [timeWeek, timeSow, satNum, valid2, az,...
              el, resc2, resp2, cn02, stat];

        % Process B1I, B3I, and B1C data (12-15 fields)  
      elseif numel(data)>11&&numel(data)<=15
          valid1 = str2double(data{4});
          resc1 = str2double(data{5});
          resp1 = str2double(data{6});
          cn01 = str2double(data{7});      
          valid2 = str2double(data{8});
          resc2 = str2double(data{9});
          resp2 = str2double(data{10});
          cn02 = str2double(data{11}); 
          valid3 = str2double(data{12});
          resc3 = str2double(data{13});
          resp3 = str2double(data{14});
          cn03 = str2double(data{15});  

          i_1 = i_1 + 1;
          i_2 = i_2 + 1;
          i_3 = i_3 + 1;
          resB1I{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
              el, resc1, resp1, cn01, stat];
          resB3I{count}(i_2, :) = [timeWeek, timeSow, satNum, valid2, az,...
              el, resc2, resp2, cn02, stat];
          resB1C{count}(i_3, :) = [timeWeek, timeSow, satNum, valid3, az,...
              el, resc3, resp3, cn03, stat];

       % Process B1I, B3I, B1C, and B2a data (16-19 fields)   
      elseif  numel(data)>15
          valid1 = str2double(data{4});
          resc1 = str2double(data{5});
          resp1 = str2double(data{6});
          cn01 = str2double(data{7});      
          valid2 = str2double(data{8});
          resc2 = str2double(data{9});
          resp2 = str2double(data{10});
          cn02 = str2double(data{11}); 
          valid3 = str2double(data{12});
          resc3 = str2double(data{13});
          resp3 = str2double(data{14});
          cn03 = str2double(data{15});      
          valid4 = str2double(data{16});
          resc4 = str2double(data{17});
          resp4 = str2double(data{18});
          cn04 = str2double(data{19}); 
          
          i_1 = i_1 + 1;
          i_2 = i_2 + 1;
          i_3 = i_3 + 1;
          i_4 = i_4 + 1;
          resB1I{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
              el, resc1, resp1, cn01, stat];
          resB3I{count}(i_2, :) = [timeWeek, timeSow, satNum, valid2, az,...
              el, resc2, resp2, cn02, stat];
          resB1C{count}(i_3, :) = [timeWeek, timeSow, satNum, valid3, az,...
              el, resc3, resp3, cn03, stat];
          resB2a{count}(i_4, :) = [timeWeek, timeSow, satNum, valid4, az,...
              el, resc4, resp4, cn04, stat];
       end
    end
end

% Remove empty cells from the results
resB1I = resB1I(~cellfun(@isempty, resB1I));
resB3I = resB3I(~cellfun(@isempty, resB3I));
resB1C = resB1C(~cellfun(@isempty, resB1C));
resB2a = resB2a(~cellfun(@isempty, resB2a));
fclose(fid);
disp(['Read successfully: ', filename,' BDS']);
end
