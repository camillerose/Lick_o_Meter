function makePureTone(cf, fs, dur, freq)

% cf = carrier freq
% fs = sampling freq
% dur = duration of tone

n = fs * dur;               % number of samples
s = (1:n) / fs;             % sound data preparation
y = sin(2 * pi * cf * s);   % sinusoidal modulation


wavwrite(y, fs, 8, freq);


end