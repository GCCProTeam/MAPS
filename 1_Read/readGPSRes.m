function [resL1, resL2] = readGPSRes(fid, filename)
%Reading GPS residual datas

%INPUT:
%fid: file identifier obtained from fopen
%filename: name of the file being read (for logging purposes)

%OUTPUT:
%resL1；cell array containing L1 residual data
%resL2；cell array containing L2 residual data

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
resL1 = cell(max_rows, 1);
resL2 = cell(max_rows, 1);
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
       i_1 = 0;i_2 = 0;%Reset row counters for L1 and L2 data
    
    %Check if the line starts with 'G' (satellite data)   
    elseif startsWith(line, 'G')
        data = regexp(line, '[-+]?\d*\.?\d+', 'match');
        satNum = str2double(data{1});
        az = str2double(data{2});
        el = str2double(data{3});

        %Check if the line contains L1 and L2 data
        if numel(data) >= 11
           valid1 = str2double(data{4});%satellite valid flag of L1
           resc1 = str2double(data{5});
           resp1 = str2double(data{6});
           cn01 = str2double(data{7});      
           valid2 = str2double(data{8});
           resc2 = str2double(data{9});
           resp2 = str2double(data{10});
           cn02 = str2double(data{11}); 

           %Store L1 and L2 data
           i_1 = i_1 + 1;
           i_2 = i_2 + 1;
           resL1{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
               el, resc1, resp1, cn01, stat];
           resL2{count}(i_2, :) = [timeWeek, timeSow, satNum, valid2, az,...
               el, resc2, resp2, cn02, stat];
        
           %Check if the line contains only L1 data
        elseif  numel(data) < 11&&numel(data) >= 7
            valid1 = str2double(data{4});
            resc1 = str2double(data{5});
            resp1 = str2double(data{6});
            cn01 = str2double(data{7}); 

             %Store L1 data
            i_1 = i_1 + 1;
            resL1{count}(i_1, :) = [timeWeek, timeSow, satNum, valid1, az,...
                el, resc1, resp1, cn01, stat];   
        end
    end
end

% Remove empty cells from the results
resL1 = resL1(~cellfun(@isempty, resL1));
resL2 = resL2(~cellfun(@isempty, resL2));

fclose(fid);
disp(['Read successfully: ', filename,' GPS']);
end
