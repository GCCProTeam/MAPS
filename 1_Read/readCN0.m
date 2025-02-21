function [SNR] = readCN0(fid, filename)
    if fid < 0
        disp('No file!');
        return;
    end
    lines = textscan(fid, '%s', 'Delimiter', '\n');
    lines = lines{1};
    max_rows = 86400;
    SNR = cell(max_rows, 1);
    count_1 = 0;
    for i = 1:length(lines)
        line = lines{i};
        if startsWith(line, '$GPST')
            data = regexp(line, '\d+\.?\d*', 'match');
            if numel(data) >= 3
                time_week = str2double(data{1});
                time = str2double(data{2});
                stat = str2double(data{3});
            end
            count_1 = count_1 + 1;
            i_1 = 0;
        elseif startsWith(line, 'G')
            data = regexp(line, '[-+]?\d*\.?\d+', 'match');
            s_num = str2double(data{1});
            az = str2double(data{2});
            el = str2double(data{3});
            if numel(data) >= 11
               fix1 = str2double(data{4});
               snr1 = str2double(data{7});      
               i_1 = i_1 + 1;
               SNR{count_1}(i_1, :) = [time_week, time, s_num, fix1, az, el, 0, 0, snr1, stat];
            elseif  numel(data) < 11&&numel(data) >= 7
               fix1 = str2double(data{4});
               snr1 = str2double(data{7}); 
               i_1 = i_1 + 1;
               SNR{count_1}(i_1, :) = [time_week, time, s_num, fix1, az, el, 0, 0, snr1, stat];   
            end
        end
    end
    % Delete empty cells
    SNR = SNR(~cellfun(@isempty, SNR));
    fclose(fid);
    disp(['Read successfully: ', filename,' GPS']);
end
