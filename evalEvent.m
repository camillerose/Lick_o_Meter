% Determines punishment or reward 

function [events eventCode] = evalEvent(noGoStat, noGoStat2, noGoPunish, goStat, ...
    goStat2, goReward, punishER, stopStim, pump, darkTimer, latencyP, ...
    latencyR, guiH, airPunish, airTimer, d, rewardHitsOnly, noErrorReward,...
    probeStat, probeStat2, disStat, disStat2)
global startTime
global stimStartTime
% persistent noP noR % for use in future versions, prevents consecutive
% instances of no reward or no punishment 
h = guidata(guiH);
x = rand; % random number to determine punish or reward based on vars noGoPunish and goReward

et = etime(clock, startTime);
et2 = num2str(et);
event.type = 'Lick';
event.time = et;

good_hit = 0; 
begin_reward =  stimStartTime + h.hit_period; %ct
if et >= begin_reward %ct
   good_hit = 1; %ct
   sprintf('good hit = 1')
end    

manualCall = 0; % Indicator of manual (vs. automatic) call 

if strcmp(noGoStat, 'on') % False alarm
    event.str = ['Lick, NO-GO at ' et2];
    eventCode = 2; 
    setappdata(0,'last_trial', 'NOGO')
    lasttrial = getappdata(0, 'last_trial');
    sprintf('App data is %s ', lasttrial)
    set(h.response_type, 'String', 'F/A')
    ResType = get(h.response_type, 'String');
    sprintf('Response type is %s ', ResType)
    if x <= noGoPunish % punish only if below threshold
        punish(darkTimer, latencyP, guiH, manualCall);
    end
    
    if airPunish == 1
        start(airTimer)
    end
    
% For hits    
elseif strcmp(goStat, 'on') && good_hit == 1 % Hit %Ct
    sprintf('in hits')
    event.str = ['Lick, GO at ' et2];
    eventCode = 1;
    set(h.response_type, 'String', 'HIT');%CT
    ResType = get(h.response_type, 'String');
    sprintf('Response type is %s ', ResType)
    setappdata(0,'last_trial', 'GO')
    lasttrial = getappdata(0, 'last_trial');
    sprintf('App data is %s ', lasttrial)
    
    if stopStim % stop stimulus playback for lick
        h = guidata(guiH);
        stop(h.audio_out);
    end

    
    errorTrial = getappdata(0, 'errorTrial');
    
% access to lick reward                      goReward = reward probability
    if x <= goReward && ~noErrorReward
        lick_reward(pump, latencyR, guiH, manualCall);
    end
    
    if x <= goReward && noErrorReward && strcmp(errorTrial, 'cleared')
        lick_reward(pump, latencyR, guiH, manualCall);
    end

elseif strcmp(probeStat, 'on') && good_hit == 1
    sprintf('in probe hits')
    event.str = ['Lick, PROBE at ' et2];
    eventCode = 8;
    set(h.response_type, 'String', 'HIT');%CT
    ResType = get(h.response_type, 'String');
    sprintf('Response type is %s ', ResType)
    setappdata(0,'last_trial', 'PROBE_HIT')
    lasttrial = getappdata(0, 'last_trial');
    sprintf('App data is %s ', lasttrial)
elseif strcmp(disStat, 'on')
    sprintf('in dis f/as')
    event.str = ['Lick, DIS at ' et2];
    eventCode = 9;
    set(h.response_type, 'String', 'F/A');%CT
    ResType = get(h.response_type, 'String');
    sprintf('Response type is %s ', ResType)
    setappdata(0,'last_trial', 'DIS_FA')
    lasttrial = getappdata(0, 'last_trial');
    sprintf('App data is %s ', lasttrial)
    
% For secondary licks after hits  
elseif (strcmp(goStat2, 'on') && strcmp(goStat, 'off'))
    event.str = ['Lick(secondary) GO at ' et2];  
    event.type = 'Lick, secondary'; 
    eventCode = 0; 
% For secondary licks after false alarms
elseif (strcmp(noGoStat2, 'on') && strcmp(noGoStat, 'off'))
    event.str = ['Lick(secondary), NO-GO at ' et2];
    event.type = 'Lick, secondary'; 
    eventCode = 0; 
elseif (strcmp(probeStat2, 'on') && strcmp(probeStat, 'off'))
    event.str = ['Lick(secondary) PROBE at ' et2];  
    event.type = 'Lick, secondary'; 
    eventCode = 0; 
% For secondary licks after false alarms
elseif (strcmp(disStat2, 'on') && strcmp(disStat, 'off'))
    event.str = ['Lick(secondary), DIS at ' et2];
    event.type = 'Lick, secondary'; 
    eventCode = 0;  
    
% Error licks
else
    event.str = ['Lick, ER at ' et2];
    eventCode = 3;
    set(h.response_type, 'String', 'ERROR')
    ResType = get(h.response_type, 'String');
    sprintf('Response type is %s ', ResType)
    setappdata(0,'last_trial', 'ERROR')
    lasttrial = getappdata(0, 'last_trial');
    sprintf('App data is %s ', lasttrial)
    
    setappdata(0, 'errorTrial', 'error_noReward');
    
    if punishER == 1;
        punish(darkTimer, latencyP, guiH, manualCall);
    end
    
end

if exist('outcome', 'var')
    events = [event outcome];
else
    events = [event]; 
end 
    