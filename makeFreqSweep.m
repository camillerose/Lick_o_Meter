function makeFreqSweep(t0, tEnd, f0, f1, fs, name)

% make a LINEAR frequency sweep (can easily be modified to log or quad)
% http://www.mathworks.com/help/signal/ref/chirp.html


% t0 = starting time
% fs = sampling freq HZ
% tEnd = ending time
% f0 = starting freq HZ 
% f1 = ending freq HZ
% name = name of file

t = t0:1/fs:tEnd;

y = chirp(t,f0,tEnd,f1);

wavwrite(y, fs, 8, name)


end