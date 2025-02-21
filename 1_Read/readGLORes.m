function [resG1, resG2] = readGLORes(fid, filename)
%Reading GLONASS residual datas

%INPUT:
%fid: file identifier obtained from fopen
%filename: name of the file being read (for logging purposes)

%OUTPUT:
%resG1；cell array containing G1 residual data
%resG2；cell array containing G2 residual data

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
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
resG1 = cell(max_rows, 1);
resG2 = cell(max_rows, 1);
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
          stat = str2double(data{3});%Signs of VALIDed and float solutions
       end
       count = count + 1;
       i_1 = 0;i_2 = 0;%Reset row counters for G1 and G2 data

    %Check if the line starts with 'R' (satellite data)   
    elseif startsWith(line, 'R')
        data = regexp(line, '[-+]?\d*\.?\d+', 'match');
        satNum = str2double(data{1});
        az = str2double(data{2});
        el = str2double(data{3});

        %Check if the line contains G1 and G2 data
        if numel(data) >= 11
           fix1 = str2double(data{4});
           resc1 = str2double(data{5});
           resp1 = str2double(data{6});
           cn01 = str2double(data{7});      
           fix2 = str2double(data{8});
           resc2 = str2double(data{9});
           resp2 = str2double(data{10});
           cn02 = str2double(data{11}); 

           %Store G1 and G2 data
           i_1 = i_1 + 1;
           i_2 = i_2 + 1;
           resG1{count}(i_1, :) = [timeWeek, timeSow, satNum, fix1, az,...
               el, resc1, resp1, cn01, stat];
           resG2{count}(i_2, :) = [timeWeek, timeSow, satNum, fix2, az,...
               el, resc2, resp2, cn02, stat];
        
           %Check if the line contains only G1 data 
        elseif  numel(data) < 11&&numel(data) >= 7
            fix1 = str2double(data{4});
            resc1 = str2double(data{5});
            resp1 = str2double(data{6});
            cn01 = str2double(data{7}); 

            %Store G1 data
            i_1 = i_1 + 1;
            resG1{count}(i_1, :) = [timeWeek, timeSow, satNum, fix1, az,...
                el, resc1, resp1, cn01, stat];   
        end
    end
end

% Remove empty cells from the results
resG1 = resG1(~cellfun(@isempty, resG1));
resG2 = resG2(~cellfun(@isempty, resG2));

fclose(fid);
disp(['Read successfully: ', filename,' GLO']);
end
