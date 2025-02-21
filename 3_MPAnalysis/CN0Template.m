function [coeff_cn0]=CN0Template(el,snr)
%Establishing a template function of C/N0

%INPUT:
%el: elevation [dgree]
%snr: C/N0 values [dB-Hz]

%OUTPUT:
%coeff_cn0: Coefficient of C/N0 template function

%Copyright (C) GCC Group
%--------------------------------------------------------------------------

%Enter the matrix and the number of columns to be refined.
[min_el,~]=min(el);
[max_el,~]=max(el);
a=fix(min_el);
b=fix(max_el);
% use polyfit()
coeff = polyfit(el, snr, 3);
a1 = coeff(1);
a2 = coeff(2);
a3 = coeff(3);
a4 = coeff(4);

% Set the standard deviation multiplier to be used for deletion
d = 1; 
k = 3;

% Create the ele interval
el_bins = a:d:b;

% Initialize the results
el_cleaned = [];
snr_cleaned = [];
std_by_bin = zeros(length(el_bins), 2);

% Loop through each ele interval
for i = 1:length(el_bins)
    % Get the current bin's ele and snr values 
    el_in_bin = el(el >= el_bins(i) & el < el_bins(i)+1);
    snr_in_bin = snr(el >= el_bins(i) & el < el_bins(i)+1);
    % Calculate the fitted snr values for the current bin
    snr_fit = a4 + a3 * el_in_bin + a2 * el_in_bin .* el_in_bin + a1 * el_in_bin .* el_in_bin .* el_in_bin;
    
    % Calculate the standard deviation for the current bin
    std_by_bin(i,1) = std(snr_in_bin - snr_fit);
    std_by_bin(i,2) = el_bins(i);
end

% Fit a polynomial model to the standard deviation
p = polyfit(std_by_bin(:,2), std_by_bin(:,1), 3);
b1 = p(1);
b2 = p(2);
b3 = p(3);
b4 = p(4);

% Clean the data by removing outliers
for i = 1:length(el)
    snr_fit = a4 + a3 * el(i) + a2 * el(i)^2 + a1 * el(i)^3;
    std_fit = b4 + b3 * el(i) + b2 * el(i)^2 + b1 * el(i)^3;
    if abs(snr(i) - snr_fit) <= k * std_fit
        el_cleaned = [el_cleaned, el(i)];
        snr_cleaned = [snr_cleaned, snr(i)];
    end
end

% Fit the final model to the cleaned data
coeff_cn0 = polyfit(el_cleaned, snr_cleaned, 3);
end