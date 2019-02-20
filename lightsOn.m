% turns on house lights, takes input d digitalio
% lights must be line 1 

function lightsOn(obj, eventdata, guiH)
h = guidata(guiH);
disp('PUNISH OFF!')
putvalue(h.d.Line(1), 1);
h.darkTimer.TasksToExecute = 1; 
guidata(guiH, h); 

% start stimulus timer at end of punishment
st = timerfind('Tag', 'StimulusTimer');
if ~isempty(st)
    if strcmp(st.Running, 'off')
        start(st);
    end
end

