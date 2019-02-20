function event = lick_reward(pump, latencyR, guiH, manualCall)
global startTime

if latencyR>0 && ~manualCall
    query(pump, 'DIR INF')%
    rewardTimer = timer('TimerFcn', {@startReward, pump, guiH}, 'StartDelay', latencyR, 'ExecutionMode', 'singleShot');
    start(rewardTimer);
else
    et = etime(clock, startTime);
    et2 = num2str(et);
    event.time = et;
    if manualCall
        event.type = 'Reward, manual'; 
        event.str = ['Reward, manual @ ' et2];
    else
        event.type = 'Reward';
        event.str = ['Reward @ ' et2];
    end
    logEvents(guiH, event)
    query(pump, 'DIR INF');
    fprintf(pump, 'RUN');
end


function startReward(object, eventdata, pump, guiH) 
global startTime

sprintf('in startReward of lickReward')
et = etime(clock, startTime);
et2 = num2str(et);
event.type = 'Reward';
event.time = et;
event.str = ['Reward @ ' et2];
logEvents(guiH, event)
fprintf(pump, 'RUN');