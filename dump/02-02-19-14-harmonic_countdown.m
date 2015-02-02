fs = 44100;
L = 20;
l = 1:L;
f0 = 200;
w0 = 2*pi*f0;

dur = L;
t=1/fs:1/fs:dur;


x = zeros(fs*L,1);
n=1;
for i=L:-1:1
    x = x + [zeros(fs*n,1); sin(w0*i*(1/fs:1/fs:(i-1)))'];
    n=n+1;
end




x=x/max(x);
sound(x,fs)

figure(1)
subplot(211); plot(t,x);
subplot(212); specgram(x);

