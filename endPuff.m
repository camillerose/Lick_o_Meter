function endPuff(hobj, events, d)
global startTime

disp(['End puff at ' num2str(etime(clock, startTime))]); 

putvalue(d.Line(3), 0);

