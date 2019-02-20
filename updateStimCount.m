% updateStimCount is called during regular ISI sessions, trialsComplete_handles is 
% handles to trialsComplete_txt in lickometerGUI
% will reward after every kind of stimulus, if you want to use a
% non-varying ISI then you have to update this file accordingly

function updateStimCount(object, eventdata, trialsComplete_handles, numStim, guiH)
persistent counter
    
h = guidata(guiH);

% if h.stimEndReward
%     lick_reward(h.pump, h.latencyR, guiH, 0);
% end


if isempty(counter)
    counter = 0; 
end

counter = counter+1;

set(trialsComplete_handles, 'String', num2str(counter));

if counter == numStim
    tStop = timer('TimerFcn', {@stopGUI, guiH}, 'StartDelay', 5); % stop session automatically 5s after last stimulus output
    start(tStop);
end


function stopGUI(object, eventdata, guiH)
h = guidata(guiH); 
lickometerGUI('stop_button_Callback', guiH, eventdata, h);
