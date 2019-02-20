% turns off house lights, takes input d digitalio
% lights must be line 1 

function lightsOff(obj, eventdata, d, guiH)
global startTime 

disp('PUNISH ON!');
putvalue(d.Line(1), 0);

et = etime(clock, startTime);
et2 = num2str(et); 
event.time = et;
event.type = 'Punish';
event.str = ['Punish @ ' et2];
logEvents(guiH, event); 

% stop stimulus timer at beginning of punishment
st = timerfind('Tag', 'StimulusTimer');
if ~isempty(st)
    if strcmp(st.Running, 'on')
        stop(st);
        % if timer for constant ISI, update TasksToExecute
        if strcmp(st.ExecutionMode, 'fixedRate')
            st.TasksToExecute = st.TasksToExecute - st.TasksExecuted;
        end
    end
end

