fs = 44100;
L = 20;
f0 = 400;
w0 = 2*pi*f0;

dur = L;
endNoteLength = 3;
t=1/fs:1/fs:dur+endNoteLength;
ampFactor = 1/40;

x = [zeros(fs*(L+endNoteLength),1)];
for i=1:L
    x = x + [zeros(fs*i,1); i*ampFactor*sin(w0*i*(1/fs:1/fs:(L-i)+endNoteLength))'];
end

x=x/max(x);
sound(x,fs)

figure(1)
subplot(211); plot(t,x);
subplot(212); specgram(x);

