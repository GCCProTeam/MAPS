function v_recon = resDwt(v_series)
%Perform wavelet decomposition and denoising on a time series

%INPUT:
%v_series: A cell array where each cell contains a time series matrix

%OUTPUT:
%v_recon: A cell array containing the reconstructed (denoised) time series

% Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Initialize the output cell array
v_recon = cell(size(v_series,1),1);

% Loop through each time series in the input cell array
for i=1:size(v_series,1)
    if( size(v_series{i},1)>5 )
        %nois = v_series{i}'; 
        nois = v_series{i}; 
        N=size(nois,1);

        % Ensure the number of data points is even 
        % (required for wavelet transform)
        if mod(N,2)==1
           nois(end,:)=[]; 
        end

        % Initialize the reconstructed time series with NaN values
        recon = nois*nan;  
        recon(:,1) = nois(:,1);

        %Decompose by wavelet analysis and denoise by your 
        %inverse decomposition
        for j=3:4
            recon0=wden(nois(:,j));
            recon(:,j) = recon0(1:size(recon,1),1);
        end
        recon(:,2)=nois(:,2);
        recon(:,5)=nois(:,5);
        recon(:,6)=nois(:,6);
        v_recon{i} = recon;
    end  
end
end