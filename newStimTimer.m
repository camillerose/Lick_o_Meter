% newStimTimer is the StopFcn for audio_out and generates a new stim timer at
% the end of each sound output, allowing for variable intervals 

function newStimTimer(object, eventdata, stimTimer, timeLo, timeHi, numStim, guiH, rewardHitsOnly)
persistent counter
h = guidata(guiH); 

setappdata(0, 'errorTrial', 'cleared');

sprintf('in the newStimTimer file')

% Only reward at end of stimulus for GO stimuli. (Rewards every time,
% regardless of correct hit or miss - association training). %CT

 lastTrial = getappdata(0, 'last_trial');
 sprintf('last trial type is %s', lastTrial)

stimType = get(h.stim_type_txt, 'String'); %CT

% access to lick reward
if  strcmp('GO', stimType) && ~rewardHitsOnly  %CT
    lick_reward(h.pump, h.latencyR, guiH, 0);
end

% Reward at end of stimulus for hits only.
respType = get(h.response_type, 'String'); %CT
% 
%  % access to lick reward
%    if  strcmp('GO',stimType) && rewardHitsOnly && strcmp('HIT', respType) && strcmp(lastTrial, 'GO')
%         lick_reward(h.pump, h.latencyR, guiH, 0);
%    end


% access to lick reward for stimulus training
% if strcmp(h.trial, 'stim') && strcmp('HIT', respType) && rewardHitsOnly
%    lick_reward(h.pump, h.latencyR, guiH, 0);
%    set(h.response_type, 'String', ''); %reset response box
% end

if strcmp(h.trial, 'stim') && strcmp('HIT', respType) && ~rewardHitsOnly
   lick_reward(h.pump, h.latencyR, guiH, 0);
   set(h.response_type, 'String', ''); %reset response box
end


setappdata(0, 'last_trial', '');
lastTrial = getappdata(0,'last_trial');
sprintf('last trial type is %s', lastTrial)
lasttrial = getappdata(0, 'last_trial');
sprintf('App data is %s ', lasttrial)

if isempty(counter) 
    counter = 1; 
end 

r = timeLo + round(abs(timeHi-timeLo)*rand(1)*1000)/1000; 

set(h.trialsComplete_txt, 'String', num2str(counter));
 
if counter == numStim 
    tStop = timer('TimerFcn', {@stopGUI, guiH}, 'StartDelay', 5); % stop session automatically 5s after last stimulus output
    start(tStop);
end
    
if counter < numStim
    delete(timerfind('Tag', 'StimulusTimer'));
    counter = counter + 1;
    stimTimer = timer('TimerFcn', {@stimCall, guiH}, 'StartDelay', ...
        r, 'ExecutionMode', 'singleShot', 'Tag', 'StimulusTimer');
    start(stimTimer);  
end

%reset response type box
if strcmp('HI', respType) || strcmp('F/A', respType)
    set(h.response_type, 'String', ' ')
end

function stopGUI(object, eventdata, guiH)
h = guidata(guiH); 
lickometerGUI('stop_button_Callback', guiH, eventdata, h);
