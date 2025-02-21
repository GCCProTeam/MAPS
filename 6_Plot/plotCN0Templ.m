function []=plotCN0Templ(el,snr,coeff)
%Plots template C/N0 function

%INPUT:
%el: elevation
%snr: C/N0
%coeff: Coefficient of template C/N0 function

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Define the polynomial function for SNR fitting
% params(1)*x^3 + params(2)*x^2 + params(3)*x + params(4)
fun_snr = @(params, x) params(1)*x.^3 + params(2)*x.^2 + params(3)*x + params(4);
% Generate a smooth range of elevation for fitting
fit_el = linspace(min(el), max(el), 100);
% Calculate the fitted C/N0 values using the polynomial coefficients
fit_snr = fun_snr(coeff, fit_el);
% Create a new figure with specified position and size
figure('Position', [100, 100, 600, 250]);
scatter(el, snr,'b.','SizeData', 10);
hold on;  

plot(fit_el, fit_snr, 'k-', 'LineWidth', 1);
xlabel('Elevation (°)');
ylabel('C/N0 (dB-Hz)');
legend('C/N0',  'C/N0*','FontName', 'Arial', 'FontSize', 10);

ylim([0,90]);
ylim([10,60]);

xticks(0:10:90); 
yticks(10:10:60); 
grid on; 
ax = gca;
ax.Box = 'on';
end


