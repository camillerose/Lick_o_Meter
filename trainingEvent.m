function newEvents = trainingEvent(tubeTimer, reward, pump, latencyR, guiH)
global startTime;

et = etime(clock, startTime);
et2 = num2str(et);
event.type = 'Lick';
event.time = et;
event.str = ['Lick at' et2];
    
if strcmp(tubeTimer.running, 'off')  
    x = rand; % random number to determine reward based on var reward

    if x <= reward % punish only if above threshold
        lick_reward(pump, latencyR, guiH, 0);
        start(tubeTimer);
    end
    
end

newEvents = event;