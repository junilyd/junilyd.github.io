% This program reads from defaukt soundcard input and estimates the pitch from harmonic summation.
% NEW:  this version does not plot the cost function since the tuner 
%       is now rewritten to be a blackbox function, returning a pitch.    
% ---------------------------------------------------------------------------------------------
L = 4;
time=1; pitchgraph=0;

while 1==1
fs =44.1e3;

sig = smc_record(fs,0.4);
[f,X] = smc_fft(sig,fs);
f0Area = [65:0.1:340];
pitch = smc_harmonic_summation_tuner(X, f0Area, L, fs);

%------------------------ Plotting ----------------------------------------------------
% subplot(312); semilogx(f0Area,cost); title('String function to maximize','fontsize',18); xlabel('Hz'); ylabel('cost'); xlim([50 1000])
subplot(211); semilogx(f,X); title('FFT of signal','fontsize',18); xlabel('Hz'); ylabel('FFT size'); xlim([50 1000])

fprintf('\n\n----------------------------\nThe pitch is %1.3f Hz\n\n----------------------------\n',pitch);
pitchgraph  = [pitchgraph, pitch];
subplot(212); semilogy(pitchgraph,'o'); axis([time-40 time min(f0Area) max(f0Area)]); grid; title('Estimated Fundamental','fontsize',18);xlabel('Relative Time');ylabel('Hz');
time=time+1; drawnow;

end




%% 	The following code ar the functions to use
%	These are supposed to be saved to files, with respective file names


% -----------------------------------------------------------------
%   This function records from your built in microphone in your PC;
%   
%   INPUTS:
%           fs:         sample rate
%           duration:   duration of recording in seconds
%   OUTPUTS:
%           file:       Audio signal
% -----------------------------------
% [file,fs] = smc_record(fs,duration)
% -----------------------------------
%
function [file] = smc_record(fs,duration)
  recObj = audiorecorder(fs,16,1);
  recordblocking(recObj, duration);
  play(recObj);
  file = getaudiodata(recObj);
end










% ----------------------------------------------------------------------
% calcualates the FFT of the input signal. returns up to nyquist freq.
% It does the zeropadding up to next power of 2 with the built a MATLAB function.
%
% INPUT: 
%       sig: signal to analyse
%       Fs:  sample rate of that signal
% OUTPUT:
%       f_axis:     x-axis for plotting
%       fft_sig:    linear fft signal
%       fft_sig_dB: logarithmic fft signal in dB
%       NFFT:       the power of 2 used for the fft
%      
% EXAMPLE: 
%         For using this with an audio file:    [sig,fs] = audioread('testfiles/A_mid.wav');
%                                               [f,fft_sig, fft_dB] = smc_fft(sig,fs);
%                                               plot(f,fft_sig); figure;
%                                               plot(f,fft_dB);
%         
% -----------------------------------------------------------
% function [f_axis, fft_sig, fft_sig_dB] = smc_fft(sig,Fs)    
% -----------------------------------------------------------
function [f_axis,fft_sig, fft_sig_dB] = smc_fft(sig,Fs)    
    N = length(sig);
    NFFT     = 2^nextpow2(N);
    fft_long = fft(sig,NFFT);
    fft_sig  = 2*abs(fft_long(1:NFFT/2)).^2;
    fft_sig_dB = 10*log10(fft_sig);
    f_axis   = Fs/2 * linspace(0,1,NFFT/2);
end





%   ----------------------------------------------------------
%   Estimates the pitch from harmonic summation
%   Here the tuner also zooms in to get some calc. efficiency
%   --------------------------------------------------------------------------------
%   INPUTS:
%           X:       fft of input signal
%           f0_area: Vector of fundamental frequrncies in hertz (the search area)
%           L:       Number of Harmonics to use.
%           fs:      Sample rate to use (usually samplerate of input signal)
%   OUTPUTS:
%           pitch:   The pitch estimate
% --------------------------------------------------------
% pitch3 = smc_harmonic_summation_tuner(X, f0_area, L, fs)
% --------------------------------------------------------
% version 1.0 jmhh
% version 1.1 anch : if used in EM, high resolution f0_area as input
% lower resolution and faster computation
% 2nd search area has changed to +-0.5 from +-4 Hz.
function pitch3 = smc_harmonic_summation_tuner2(X, f0_area, L, fs,EM_f0Area)
if nargin < 5
f0_area = [min(f0_area):0.1:max(f0_area)];
end


i=1;
for f=f0_area
    [index] = smc_harmonic_index(X, fs, L, f);
    cost(i) = sum(X(index)); i = i+1;
end
[C, I] = smc_max(cost);
pitch = f0_area(I); 

f0_area2 = [pitch-4:0.01:pitch+4]; % changed from +-4 Hz
i=1;
for f=f0_area2
    [index] = smc_harmonic_index(X, fs, L, f);
    cost2(i) = sum(X(index));i=i+1;
end
[C,I] = smc_max(cost2);
pitch2 = f0_area2(I);

f0_area3 = [pitch2-0.01:0.001:pitch2+0.01];
i=1;
for f=f0_area3
    [index] = smc_harmonic_index(X, fs, L, f);
    cost3(i) = sum(X(index));i=i+1;
end
[C,I] = smc_max(cost3);
pitch3 = f0_area3(I);

% % extra under test
% f0_area4 = [pitch3-0.001:0.0001:pitch3+0.001];
% i=1;
% for f=f0_area4
%     [index] = smc_harmonic_index(X, fs, L, f);
%     cost4(i) = sum(X(index));i=i+1;
% end
% [C,I] = smc_max(cost4);
% pitch4 = f0_area4(I);
end


% ----------------------------------------------------------------------
%  This function creates a vector with indeces of the partials in the signal.
%   The indeces can then be used for sparse harmonic summation
% 
%   INPUTS:     
%               fft_sig:    fft-signal which is real valued. This is assumed to be cut at  
%                           Nyquist frequencu. (1:fs/2)
%               fs:         sample frequency used for FFT.
%               L:          The desired number of harmonics
%               f0Area:     Vector containg the search area
%
%   OUTPUTS:
%               index:    Index of L harmonics
%
% --------------------------------------------------------------
% function [index] = smc_harmonic_index(fft_sig, fs, L, f0Area)
% --------------------------------------------------------------
function [index] = smc_harmonic_index(fft_sig, fs, L, f0Area)
    l=1:L;
    f0Area = f0Area(:);
    NFFT = length(fft_sig);
    f = f0Area*l;
    index = round(f(l).*(2*NFFT/fs)+1);
    index = index(:);
end





