% stimCall is the TimerFcn for stimTimer

function stimCall(obj, eventdata, guiH) 
h = guidata(guiH);
global startTime
global stimStartTime

if strcmp(h.trial, 'train')
    [newEvent, lastStim] = lick_stimPlayer(h.audio_out, h.rewardList, h.punishList, h.probeList, h.distracterList, h.probePercent, h.targetPercent, h.numStim, guiH);
elseif strcmp(h.trial, 'stim')
    [newEvent, lastStim] = lick_stimTrainer(h.audio_out, h.rewardList, h.pump, h.latencyR, guiH);
end

if lastStim == 1 % go stim
    if strcmp(h.goTimer.Running, 'on'); 
        stop([h.goTimer h.goTimer2]); 
    end
    
    start([h.goTimer h.goTimer2]);
    stimStartTime = etime(clock, startTime);
    
elseif lastStim == 0 % noGo stim
    if strcmp(h.noGoTimer.Running, 'on');
        stop([h.noGoTimer h.noGoTimer2]); 
    end
    start([h.noGoTimer h.noGoTimer2]); 

elseif lastStim == 2
    if strcmp(h.probeTimer.Running, 'on'); 
        stop([h.probeTimer h.probeTimer2]); 
    end
    
    start([h.probeTimer h.probeTimer2]);

elseif lastStim == 3
    if strcmp(h.disTimer.Running, 'on'); 
        stop([h.disTimer h.disTimer2]); 
    end
    
    start([h.disTimer h.disTimer2]);
end 

guidata(guiH, h);

logEvents(guiH, newEvent); 
