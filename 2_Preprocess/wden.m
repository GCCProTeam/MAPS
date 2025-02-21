function [denoised_signal] = wden(noisy_signal)
% Haar wavelet transform and threshold processing are used to denoise 
% the signal

% INPUT:
% noisy_signal: input noisy signal

% OUTPUT:
% denoised_signal: denoised signal after wavelet thresholding

% Copyright (C) GCC Group
%--------------------------------------------------------------------------

% Perform Discrete Wavelet Transform (DWT) using Haar wavelet
[cA, cD] = haar_dwt(noisy_signal);  

% Denoising step
% Determine the threshold using the Median Absolute Deviation criterion
threshold = median(abs(cD)) / 0.6745;  
cD_denoised = cD .* (abs(cD) > threshold);  

% Perform Inverse Discrete Wavelet Transform to reconstruct the denoised 
% signal
denoised_signal = haar_idwt(cA, cD_denoised);  
denoised_signal = denoised_signal'; 
end

%-----------------------------Subfunction----------------------------------
% Haar Discrete Wavelet Transform (DWT)
function [cA, cD] = haar_dwt(x)
% Computing the Haar wavelet transform of a signal

% INPUT:
%   x - Input signal
%

% OUTPUT:
%   cA - Approximation coefficients
%   cD - Detail coefficients

N = length(x);  % Length of the input signal
cA = zeros(1, floor(N/2));  % Initialize approximation coefficients
cD = zeros(1, floor(N/2));  % Initialize detail coefficients

% Compute approximation and detail coefficients
for k = 1:floor(N/2)
    cA(k) = (x(2*k-1) + x(2*k)) / sqrt(2);  
    cD(k) = (x(2*k-1) - x(2*k)) / sqrt(2);  
end
end

% Haar Inverse Discrete Wavelet Transform (IDWT)
function x_reconstructed = haar_idwt(cA, cD)
% Reconstructing a signal from Haar wavelet coefficients

% INPUT:
% cA: Approximation coefficients.
% cD: Detail coefficients.

% OUTPUT:
% x_reconstructed: Reconstructed signal.

N = length(cA) * 2;  % Length of the reconstructed signal
x_reconstructed = zeros(1, N);  % Initialize reconstructed signal

% Reconstruct the signal from approximation and detail coefficients
for k = 1:length(cA)
    x_reconstructed(2*k-1) = cA(k) / sqrt(2) + cD(k) / sqrt(2); 
    x_reconstructed(2*k) = cA(k) / sqrt(2) - cD(k) / sqrt(2);  
end
end