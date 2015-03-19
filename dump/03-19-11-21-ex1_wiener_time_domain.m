function [HT] = ex1_wiener_time_domain()

iSNR = 10;

[x, fs] = audioread('twoMaleTwoFemale20Seconds.wav');
[v, fs] = audioread('babble30Seconds.wav');

y = smc_mix_with_noise_signal(x, v, iSNR);

L=20;
% split into subvector matrix
y = smc_split_signal(y, L/fs, 20, fs);
v = smc_split_signal(v, L/fs, 20, fs);

alpha_y = 0.985;
alpha_v = 0.995;
Ry = smc_R_recursive(y, alpha_y);
Rv = smc_R_recursive(v, alpha_v);

for k=1:length(y)
 	HT(:,:,k) = eye(L)-inv(Ry(:,:,k)*Rv(:,:,k));
end

end


function [sig_e] = smc_mix_with_noise_signal(sig, noise, iSNR)
    sig = sig(:);
    noise = noise(:);
    SNR = 10^(iSNR/10);         	        	% Calculate SNR

    N = length(sig);                    		% Length of signal
    noise = noise([1:N]);						% Fit length of noise

    Ps = sum(sig.^2)/N; 	                	% Average power of signal
    Pn = sum(noise.^2)/N;   	            	% Average power of noise    
    noise = noise./ sqrt(Pn);			        % Make average power (variance) one
    noise = sqrt(Ps/SNR).*noise;                % Scale noise to wanted level
    sig_e = sig + noise;                 		% Add noise to signal
end

function [R] = smc_R_recursive(sig, alpha);	
	R(:,:,1) = sig(:,1)*sig(:,1)';
	for k=2:length(sig)
		R(:,:,k) = alpha*R(:,:,k-1) + (1-alpha)*(sig(:,k)*sig(:,k)');
	end
end


% This function divides the input signal into matrix form
% where each column is shorter segment of the input.
% Each column has the length specified, with no overlap.
%
% INPUTS
%         sig           : Input signal
%         timeSlotSize  : length of each subvector in seconds   
%         duration      : length of full output signal in seconds
%         fs            : sample rate
%
% OUTPUTS
%         sigMatrix     : output signal divided into matrix form 
%                         with subvectors in each column
%         ndxSigMatrix  : indeces of the subvectors origins.
%
% --------------------------------------------------------------------------------
% [sigMatrix, ndxSigMatrix] = smc_signal_splitter(sig, timeSlotSize, duration, fs)
% --------------------------------------------------------------------------------
%
function [sigMatrix, ndxSigMatrix] = smc_split_signal(sig, timeSlotSize, duration, fs)
    if nargin < 2, timeSlotSize = 0.01; end;
    if nargin < 3, duration = 3; end;
    if nargin < 4, fs = 44100; end;

    % error handling
    if timeSlotSize > duration, 
        fprintf('\n** smc_signal_splitter() error **\nTimeSlotSize is larger than duration.\n\n'); return; end;
    if fs*duration > length(sig), 
        fprintf('\n** smc_signal_splitter() error **\nduration is too large. It should be max  %1.2f sec\n\n',length(sig)/fs); return; end;

    sig = sig(1:fs*duration);
    N = length(sig);
    numSegments = N/fs/timeSlotSize;
    if mod(N,numSegments) ~= 0
        segmentLength = ceil(N/numSegments);
        fprintf('\n\n\n** smc_signal_splitter() - message **\ntimeslotSize has been rounded up to %1.0f seconds \n\n\n',segmentLength/fs);
    else
        segmentLength = N/numSegments; % segment in samples
    end

    ndxSigMatrix(:,1) = [1:segmentLength];
    sigMatrix(:,1) = sig(ndxSigMatrix);
    for i = 1:numSegments-1
        sigMatrix(:,i+1) = sig(i*segmentLength+1:(i+1)*segmentLength);
        ndxSigMatrix(:,i+1) = [i*segmentLength+1:(i+1)*segmentLength];
    end
end


function [sig_e] = smc_add_white_noise(sig, iSNR)
    sig = sig(:);
    N = length(sig);                    % Length of signal
    Ps = sum(sig.^2)/N;                 % Average power of signal
    SNR = 10^(iSNR/10);                 % Calculate SNR
    e = randn(1,N);                     % Generate random noise vector
    e = e - sum(e)/N;                   % Ensure zero-mean
    e = e./ sqrt(sum(e.^2)/N);          % Make average power (variance) one
    e = sqrt(Ps/SNR).*e;                % Scale noise to wanted level
    sig_e = sig + e(:);                 % Add noise to signal
end