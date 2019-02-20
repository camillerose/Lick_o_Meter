function startPuff(hobj, events, d, guiH)
global startTime


et = etime(clock, startTime);
et2 = num2str(et);
event.type = 'Air puff';
event.time = et;
event.str = ['Air puff @ ' et2];
logEvents(guiH, event)

disp(['Start puff at ' num2str(etime(clock, startTime))]); 

putvalue(d.Line(3), 1);

