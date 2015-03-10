%%  This is a statistical testprogram to test the ANLS pitch estimator, used as a guitar tuner
%  There is a descripition in the worksheeti Chapter 3 
%  The subsection is called "General test program to use for many tests.
%  
%  The main loop (for p=1:P) creates the syntehtetic signal and calulates RMSE error.
%  it runs "I" iterations for each p.
%  In the end a file is saved in the folder mats containing the workspace.
%  The name of the file contains both P and I.
%
%  To get started choose your variable to test and input inot testVariable!
%  (maybe change the name of your output file)
%  That is it!
%
clear f; clear x;clear sig;clear f0;clear betaCoeff;clear X;
clear f0Hat;clear f0Area;clear SE;clear MSE;clear RMSE;clear testVariable;
fs = 44100;
duration = 1;
LSynth = 18;
SNR = 40;
f0Area = [82 660];

LForTest = [1 2 3 4 5 6 7 8 9 10 11 12];

testVariable = LForTest;
P  = length(testVariable);
numberOfIterations = 1000;
I = numberOfIterations;


for p=1:P
	for i=1:I
		[ x(:,i,p), sig(:,i,p), f0(i,p), betaCoeff(i,p)] ...
		= smc_synthetic_guitar_with_white_noise_inharmonic(fs, duration, LSynth, SNR);
		[f,X(:,i,p)] = smc_fft(x(:,i,p),fs);
		[f0Hat(i,p)] = smc_harmonic_summation_tuner(X(:,i,p), f0Area, testVariable(p), fs);

		SE(i,p) = (f0(i,p)-f0Hat(i,p))^2;
	end
	MSE(p) = mean(SE(:,p));
	RMSE(p) = sqrt(MSE(p));
	fprintf('.');
end
save(sprintf('mats/test_RMSE_L0%1.0f_%1.0fi.mat',P,I));

figure(runs)
	plot(testVariable,RMSE, '--',testVariable,RMSE,'o');
	xlabel('L');ylabel('RMSE (Hz)');
% end
