
function punish(darkTimer, latencyP, guiH, manualCall)
global startTime;

    
if latencyP > 0 && strcmp(darkTimer.Running, 'off') && ~manualCall
    t = timer('TimerFcn', {@startDarkTimer, darkTimer}, 'StartDelay', latencyP, 'ExecutionMode', 'singleShot'); 
    start(t) 
elseif strcmp(darkTimer.Running, 'off')
    start(darkTimer);
else 
    darkTimer.TasksToExecute = darkTimer.TasksToExecute+1;
    et = etime(clock, startTime);
    event.time = et;
    et2 = num2str(et); 
    event.type = 'Punish reset'; 
    event.str = ['Punish reset @ ' et2];  
    logEvents(guiH, event); 
end


function startDarkTimer(object, eventdata, darkTimer); 
start(darkTimer); 