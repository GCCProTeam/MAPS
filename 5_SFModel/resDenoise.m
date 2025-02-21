function v_denoise=resDenoise(v_series)
% Function to denoise a cell array of time series data

%INPUT: 
%v_series: a cell array where each cell contains a matrix of time series data

%OUTPUT: 
%v_denoise: a cell array containing denoised data

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the output cell array with the same size as v_series
v_denoise=cell(size(v_series,1),1); 

% Loop through each cell in the input cell array
for i=1:size(v_series,1)
     % Check if the current cell is not empty
    if(~isempty(v_series{i}))
        v=v_series{i};
        N=length(v);
        if mod(N,2)==1
           v(end,:)=[]; 
        end
        noise_P=v(:,4);
        noise_L=v(:,3);
        % Apply wavelet denoising to the noise components
        noise_P=wden(noise_P);
        noise_L=wden(noise_L);

        v(:,4)=noise_P;
        v(:,3)=noise_L;
        
        v_denoise{i}=v;
    else
        continue;
    end
end

end
