cd /Users/OSX/Documents/MATLAB/miditoolbox
% help readmidi_java
% help miditoolbox
close all; clear all;
laksin = readmidi_java('laksin.mid');
only_in_channel1 = getmidich(laksin,1);
tempo = gettempo(laksin);
laksin_128bpm = settempo(laksin,128);

figure;
    subplot(311); pianoroll(laksin);% pause
    subplot(312); pianoroll(laksin,'num');% pause
    subplot(313); pianoroll(laksin,'sec');% pause
    title('Pianoroll(laksin)', 'fontsize', 16);
figure;
    subplot(311); plotdist(pcdist1(laksin)); title('plotdist(pcdist(laksin))', 'fontsize', 16);
    subplot(312); plotdist(ivdist1(laksin)); title('plotdist(ivdist(laksin))', 'fontsize', 16);
    subplot(313); plotdist(durdist1(laksin)); title('plotdist(durdist(laksin))', 'fontsize', 16);
figure;
    plotmelcontour(laksin,0.25,'abs',':r.'); hold on;
    plotmelcontour(laksin,1,'abs','-bo'); hold off;
    legend(['resolution in beats=.25'; 'resolution in beats=1.0']);
    title('plotmelcontour(laksin)', 'fontsize', 16);

keyname(kkkey(laksin));
% Closer look to the distribution
keystrengths = kkcc(laksin); % corr. to all keys 
figure;
    plotdist(keystrengths); % plot all corr. coefficients
    title('plotdist(kkkey(laksin))', 'fontsize', 16);
% nm = onsetwindow(nmat,mintime,maxtime,<timetype>: 'beat'/'sec');
% laksin8 = onsetwindow(laksin,0,24,'beat');

% y = movewindow(nmat,wlength,wstep,timetype,varargin: function applied);
keys = movewindow(laksin,3,2,'beat','maxkkcc');

label=keyname(movewindow(laksin,3,2,'beat','kkkey'));
time = 0:2:16;
figure; 
    plot(time,keys,':ko','LineWidth',1.25); axis([-0.2 16.2 .55 .85]);
    for i=1:length(label)
        text(time(i),keys(i)+.025,label(i),...
        'HorizontalAlignment','center','FontSize',12);
    end
    title('plot(time, keys) and text(time,keys)', 'fontsize', 16);
figure; 
    onsetdist(laksin,3,'fig');
    title('onsetdist(laksin)', 'fontsize', 16);

bestmeter = meter(laksin);
% Surprise: with melodic accent
bestmeter = meter(laksin,'optimal');

figure; 
    onsetacorr(laksin,4,'fig');
figure; 
    plothierarchy(laksin);
    title('plothierarchy(laksin)', 'fontsize', 16);
% Surpise: syncopated start
figure; 
    segmentgestalt(laksin,'fig');
    title('segmentstalt(laksin)', 'fontsize', 16);
figure; 
    boundary(laksin,'fig');
    title('boundary(laksin)', 'fontsize', 16);
figure; 
    segmentprob(laksin,.6,'fig');
    subplot(211); title('segmentprob(laksin)', 'fontsize', 16);

    
    
% IV chord in C major (F A C) that lasts for 0.5 seconds
IV = createnmat([65 69 72],0.5);
% Start at 0
IV = setvalues(IV,'onset',0);
% Transpose up, shift time
V = shift(IV,'pitch',2);
V = shift(V,'onset',0.75,'sec');
% Third chord 
I = shift(V,'pitch',-7);
I = shift(I,'onset',0.75,'sec');
% Probe tone
probe = createnmat([61],0.5);
probe = shift(probe,'onset', 3, 'sec'); 

% Full sequence
sequence = [IV; V; I; probe];
signal = nmat2snd(sequence); % default FS = 22050, fm synth
soundsc(signal,22050);
showfigs;
