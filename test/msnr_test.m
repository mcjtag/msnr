% msnr test
close all;
clear all;

fs=125000000; % sample rate
N=32000; % number of samples
dt=1/fs; % dt
t=0:dt:(N-1)*dt; % time

f0=25000000; % signal frequency (fundamental)
npwr=-74; % noise power

x=sin(2*pi*t*f0); 

x=x+wgn(1,N,npwr); % add some noise
r = snr(x,fs,2); % Matlab native function
fprintf(1, 'SNR = %.2f dB\n', r);

[r,f] = msnr(x,fs,2); % ---
fprintf(1, 'SNR = %.2f dB\n', r);
% fprintf(1, 'FREQ = %f Hz\n', f);
