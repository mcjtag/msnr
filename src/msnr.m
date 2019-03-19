function [r,f] = msnr(x, fs, n)
% Signal-to-Noise Ratio calculation
% [input]
% x - signal
% fs - sample rate (in Hz)
% n - number of excluded harmonics
% [output]
% r - ratio, SNR (in dB)
% f - fundamental frequency (in Hz)

beta = 38; % beta coefficient (for Kaiser window)
exn = 1; % extremum number (for extremum finder, extrem2)

N = numel(x)/2;
w = kaiser(N*2, beta)';
x = x - mean(x);
x = abs(fft(x .* w));
x = x(1:N);
ref = abs(fft(w));
ref = ref(1:N);
xdb = -20*log10(max(ref)./(x*sqrt(2)));

pf(1:N)=inf; % Fundamental samples to plot
pe(1:N)=inf; % Excluded samples to plot

% Exclude DC
[~,I]= extrem2(x, 1, 'right', 'min', exn);
x(1:I) = 0;
pe(1:I)=xdb(1:I); %

% Power of fundamental 
[~,I_F] = max(x);
[~,I_L] = extrem2(x, I_F, 'left', 'min', exn);
[~,I_R] = extrem2(x, I_F, 'right', 'min', exn);
x_power = 0;
for i=I_L:1:I_R
	x_power = x_power + x(i) * x (i);
end
x_power = sqrt(x_power);
x(I_L:I_R) = 0;
pf(I_L:I_R) = xdb(I_L:I_R); %

% Exclude harmonics
for i=2:1:n
	z = 0;
	I_H = I_F*i;
	while I_H > N
		I_H = I_H - N;
		z = z + 1;
	end
	if mod(z,2)
		I_H = N - I_H;
	end
	if I_H < 1
		I_H = 1;
    end
	[~,I_L] = extrem2(x, I_H, 'left', 'min', exn);
	[~,I_R] = extrem2(x, I_H, 'right', 'min', exn);
	x(I_L:I_R) = 0;
	pe(I_L:I_R) = xdb(I_L:I_R); %
end

% Power of noise
n_power = 0;
for i=1:1:N
	n_power = n_power + x(i) * x (i);
end
n_power = sqrt(n_power);

% SNR & Frequency
r = 20*log10(x_power/n_power);
f = fs*I_F/(2*N);

% Plot results
figure; %
px = xdb; %
py = 0:fs/(2*numel(x)):fs/2*(1-1/numel(x)); %
plot(py, px, 'k', py, pf, 'g', py, pe, 'r'); grid; hold on; %
xlabel('Frequency (Hz)'); %
ylabel('Power (dBV)'); %
legend('Noise','Fundamental','DC and Harmonics (excluded)'); %
str = sprintf('SNR: %0.2f dB', r); %
title(str); %

end