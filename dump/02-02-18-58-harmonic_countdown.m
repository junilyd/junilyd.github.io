fs = 44100;
L = 12;
l = 1:L;
f0 = 200;
w0 = 2*pi*f0;

dur = 1;
t=1/fs:1/fs:dur;

sig = sin(w0*t);

figure(1)
plot(t, sig)



x = zeros(fs*L);
for i=12:-1:1
    x(fs*i:end) = x + sin(w0*i*(1/fs:1/fs:(i-1)));
end

