fs = 44100;
L = 20;
f0 = 400;
w0 = 2*pi*f0;

dur = L;
endNoteLength = 3;
t=1/fs:1/fs:dur+endNoteLength;
ampFactor = 1;

x = [zeros(fs*(L+endNoteLength),1)];
n=1;
for i=L:-1:1
    x = x + [zeros(fs*n,1); sin(w0*i*(1/fs:1/fs:(i-1)+endNoteLength))'];
    n=n+1;
end

x=x/max(x);
sound(x,fs)

figure(1)
subplot(211); plot(t,x);
subplot(212); specgram(x);
