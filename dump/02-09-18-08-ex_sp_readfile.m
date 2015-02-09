%% Download and install the MATLAB toolbox for the book. 
% Make a MATLAB script for reading and analyzing wavefiles 
% using the non-parametric spectral estimation methods. 
% The script should operate on 
% 1) User-chosen segment lengths 
% 2) Show spectral estimates for each of those segments.
addpath('/home/hp8760w/Documents/uni/p8/courses/sp/exercises/soundfiles')

[sig,fs] = audioread('horn23_2.wav');
duration = 2;
sig=sig(1:fs*duration);
bins = 0.01;
freqDivider = 20;
freqRes = fs/freqDivider;

N = length(sig)
secs = N/fs/bins
segmentLength = round(N/secs) % segment in samples
numSegments = floor(secs)

sigMatrix(:,1) = sig(1:segmentLength);
for i = 1:numSegments-1
    sigMatrix(:,i) = sig(i*segmentLength+1:(i+1)*segmentLength);
    tmp = periodogramse(sigMatrix(:,i),ones(1,length(sigMatrix(:,i))),round(freqRes));
    phi(:,i) = tmp(1:round(freqRes/2));
end

    size(phi)
    figure(100)
        surf([1:size(phi,2)]*bins,[0:round(freqRes/2)-1]*freqDivider,phi,'edgecolor','none')
        axis xy; axis tight; colormap(jet); view(0,90);
        xlabel('Time [sec]'); ylabel('Frequency [Hz]');
% surf(t,f,phi)
sound(sig,fs)

