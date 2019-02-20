function varargout = lickometerGUI(varargin)
% LICKOMETERGUI M-file for lickometerGUI.fig
%      LICKOMETERGUI, by itself, creates a new LICKOMETERGUI or raises the existing
%      singleton*.
%
%      H = LICKOMETERGUI returns the handle to a new LICKOMETERGUI or the
%      handle to
%      the existing singleton*.
%
%      LICKOMETERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LICKOMETERGUI.M with the given input arguments.
%
%      LICKOMETERGUI('Property','Value',...) creates a new LICKOMETERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lickometerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lickometerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lickometerGUI

% Last Modified by GUIDE v2.5 22-Nov-2011 10:53:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @lickometerGUI_OpeningFcn, ...
    'gui_OutputFcn',  @lickometerGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before lickometerGUI is made visible.
function lickometerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lickometerGUI (see VARARGIN)

clear appdata
% Choose default command line output for lickometerGUI
handles.output = hObject;

addpath('C:\Users\ryanmorrill\Documents\MATLAB\marmoset_training\lickometerGUI');

% Create digital i/o object for lickometer, house lights, air puff systems 
d = digitalio('nidaq', 'Dev1');
handles.d = d;

% Find pump in serial line 
pump = instrfind('Type', 'serial', 'Port', 'COM1', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(pump)
    pump = serial('COM1');
else
    fclose(pump);
    pump = pump(1);
end

% Set terminator bit
fopen(pump);
set(pump, 'Terminator', {'ETX','CR'});
set(pump, 'BaudRate', 19200);
fprintf(pump, 'DIA 19.05');
fprintf(pump, 'VOL UL');
handles.pump = pump;

% Audio output
audio_out = analogoutput('winsound');
chan_out = addchannel(audio_out, 1);
set(audio_out, 'SampleRate', 44100);
handles.audio_out = audio_out;

set(handles.figure1, 'CloseRequestFcn', {@closeGUI, handles});

% disable stop and save buttons until start button callback
set(handles.stop_button, 'Enable', 'off');
set(handles.save_button, 'Enable', 'off');
set(handles.retract_reward, 'Enable', 'off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lickometerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lickometerGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function event_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to event_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global startTime;


clear logEvents lick_stimPLayer

setappdata(0, 'stimuli', 'none');

d = handles.d; % Handles to digitalio
pump = handles.pump;

handles.numStim = str2double(get(handles.noTrials_edit, 'String'));
if isnan(handles.numStim)
    errordlg('Enter a whole numeric value for number of trials', 'Trials', 'modal');
    return
end

if ~isfield(handles, 'trial')
    errordlg('Select trial type before start', 'Trial type', 'modal');
    return
else
    % get the values from each of the inputs
    latencyR = handles.latencyR;
    rateR = handles.rateR
    amtR = handles.amtR
    % print values to pump
    query(pump, 'VOL UL');
    query(pump, ['RAT ' rateR ' MH']);
    query(pump, ['VOL ' amtR]);
end

trials = str2double(get(handles.noTrials_edit, 'String'));
if isnan(trials)
    errordlg('Enter whole numeric for number of trials', 'No. trials', 'modal');
end
trialsStr = num2str(trials);
set(handles.totalTrials_txt, 'String', trialsStr);

set(handles.manualReward_button, 'Enable', 'on');
set(handles.manualLightsOff_button, 'Enable', 'on'); 
set(handles.manualAirPuff_button, 'Enable', 'on'); 
set(handles.retract_reward, 'Enable', 'on');

% Get line and port values for all
lineL = str2num(get(handles.lineL, 'String'));
portL = str2num(get(handles.portL, 'String'));
lineAV = str2num(get(handles.lineAV, 'String'));
portAV = str2num(get(handles.portAV, 'String'));
lineHL = str2num(get(handles.lineHL, 'String'));
portHL = str2num(get(handles.portHL, 'String'));
    
if isempty(d.Line)
    addline(handles.d, lineHL, portHL, 'Out', 'House_lights'); % add house lights line, Line 1
    putvalue(handles.d, 1);
end
addline(handles.d, lineL, portL, 'In', 'Lickometer'); % add lickometer line, Line 2 
addline(handles.d, lineAV, portAV, 'Out', 'Air_valve'); % add air valve line, Line 3


% Define some initial parameters
d.TimerPeriod = 0.01; % check for event every 0.01 sec
startTime = clock;

guidata(hObject, handles);
handles.box = timer('StartDelay', 0.3, 'TimerFcn', {@boxFcn, handles});
guiH = handles.figure1;

ISI = str2double(get(handles.ISI_edit, 'String'));
handles.ISI = ISI;

if isnan(ISI)
    errordlg('Enter a whole numeric value for inter-stimulus interval', 'ISI', 'modal');
    return
end

% Define GUI timer
handles.a = timer('TimerFcn', {@updateTimer, handles}, 'ExecutionMode', 'fixedRate');

if strcmp(handles.trial, 'tube');
    guiH = handles.figure1; 
    d.TimerFcn = {@checkLick1, guiH}; % define timer for tube train
    handles.tubeTimer = timer('StartFcn', {@goMonitor, guiH}, 'StartDelay', handles.lickReset,...
        'TimerFcn', {@back2black, guiH});
    % Define punishment timer for manual punishment only, 2 sec lights off
    handles.darkTimer = timer('StartFcn', {@lightsOff, d, guiH}, 'StartDelay', ...
        2, 'TimerFcn', @darkDummy, 'StopFcn', {@lightsOn, guiH}, 'TasksToExecute', 1, 'BusyMode',...
        'Error', 'ErrorFcn', {@lightsReset, guiH}, 'Tag', 'PunishmentTimer',...
        'ExecutionMode', 'fixedRate');
    
elseif strcmp(handles.trial, 'train') || strcmp(handles.trial, 'stim');
    
    guidata(hObject, handles);
    guiH = handles.figure1;
    
    % Define timer for lights off punishment
    handles.darkTimer = timer('StartFcn', {@lightsOff, handles.d, guiH}, 'StartDelay', ...
        handles.lengthP, 'TimerFcn', @darkDummy, 'StopFcn', {@lightsOn, guiH}, 'TasksToExecute', 1, 'BusyMode',...
        'Error', 'ErrorFcn', {@lightsReset, guiH}, 'Tag', 'PunishmentTimer', ...
        'ExecutionMode', 'fixedRate');
    
     % Define timer for air valve punishment
    handles.airTimer = timer('TimerFcn', {@endPuff, handles.d}, 'ExecutionMode', 'singleShot', 'StartDelay', 0.25, 'StartFcn', {@startPuff, handles.d, guiH},...
        'ErrorFcn', {@endPuff, handles.d});
    
    guidata(hObject, handles);
    guiH = handles.figure1;
    
    % Timers for GO stim   
    handles.goTimer = timer('TimerFcn', {@checkGo, guiH} , 'StartDelay', handles.behLatencyR,...
        'StartFcn', {@goMonitor, guiH},  'ExecutionMode', 'singleShot');
    handles.goTimer2 = timer('TimerFcn', {@back2black, guiH}, 'ExecutionMode', 'singleShot', 'StartDelay', handles.behLatencyR);
    

    % Timers for NO-GO stim
    handles.noGoTimer = timer('TimerFcn', {@checkNoGo, guiH}, 'StartDelay', handles.behLatencyP,...
        'StartFcn', {@noGoMonitor, guiH}, 'ExecutionMode', 'singleShot');
    handles.noGoTimer2 = timer('TimerFcn', {@back2black, guiH}, 'ExecutionMode', 'singleShot', 'StartDelay', handles.behLatencyP);
    
    % Timers for probe stim
    handles.probeTimer = timer('TimerFcn', {@checkProbe, guiH} , 'StartDelay', handles.behLatencyR,...
        'StartFcn', {@probeMonitor, guiH},  'ExecutionMode', 'singleShot');
    handles.probeTimer2 = timer('TimerFcn', {@back2black, guiH}, 'ExecutionMode', 'singleShot', 'StartDelay', handles.behLatencyR);
    
    % Timers for distracter stim
    handles.disTimer = timer('TimerFcn', {@checkDis, guiH}, 'StartDelay', handles.behLatencyP,...
        'StartFcn', {@disMonitor, guiH}, 'ExecutionMode', 'singleShot');
    handles.disTimer2 = timer('TimerFcn', {@back2black, guiH}, 'ExecutionMode', 'singleShot', 'StartDelay', handles.behLatencyP);
    
    
    guidata(hObject, handles);
    guiH = handles.figure1;
    
    % Define timer for stim playback
    if get(handles.varISI_check, 'Value') == get(handles.varISI_check, 'Max')   % variable ISI
        
        timeHi = str2double(get(handles.ISImax_edit, 'String'));
        if isnan(timeHi)
            errordlg('Enter a whole numeric value for inter-stimulus interval high', 'ISI', 'modal');
            return
        end
        t = ISI + round(abs(timeHi-ISI)*rand*1000)/1000;
        handles.stimTimer = timer('TimerFcn', {@stimCall, guiH}, 'StartDelay', t,...
            'ExecutionMode', 'singleShot', 'Tag', 'StimulusTimer');
        clear newStimTimer
        set(handles.audio_out, 'StopFcn', {@newStimTimer, handles.stimTimer, ISI, timeHi, handles.numStim, guiH, handles.rewardHitsOnly});
    else % constant ISI
        handles.stimTimer = timer('TimerFcn', {@stimCall, guiH}, 'Period', ISI,...
            'TasksToExecute', handles.numStim, 'ExecutionMode', 'fixedRate', 'StartDelay', ISI, 'Tag', 'StimulusTimer');
        clear updateStimCount
        set(handles.audio_out, 'StopFcn', {@updateStimCount, handles.trialsComplete_txt, handles.numStim, guiH});
    end
    
    % Define photobeam check
    d.TimerFcn = {@checkLick2, guiH};
    % Start stimulus call

    start(handles.stimTimer); % start stimulus schedule

end
 
logEvents(guiH);


start(handles.d); % start photobeam check
start(handles.a); % start GUI timer

% enable stop and save buttons
set(handles.stop_button, 'Enable', 'on');
set(handles.save_button, 'Enable', 'on');
set(handles.status_txt, 'String', 'running'); 
guidata(hObject, handles);

% % Photobeam check for tube training, no stimulus check
function checkLick1(obj, eventdata, guiH)
persistent lastInput;
global startTime

h = guidata(guiH);
if isempty(lastInput)
    lastInput = 0;
end
currentInput = getvalue(h.d.Line(2));

if (lastInput == 0 && currentInput == 1) % Lick onset
    set(h.lick_box, 'Color', 'b');
    if strcmp(h.box.Running, 'off')
        start(h.box);
    end
    % Log training event
    newEvents = trainingEvent(h.tubeTimer, h.rewardProb, h.pump, h.latencyR, guiH);
    logEvents(guiH, newEvents);
end

lastInput = currentInput;
guidata(guiH, h);

% Photobeam detector for reward training and testing, uses stimulus check
function checkLick2(obj, ~, guiH)
persistent lastInput;
%handles.d = d; %ct
global startTime
et = etime(clock,startTime);
h = guidata(guiH);

if isempty(lastInput)
    lastInput = 0;
end
currentInput = getvalue(h.d.Line(2));

if (lastInput == 0 && currentInput == 1) % Lick onset
    set(h.lick_box, 'Color', 'b');
    if strcmp(h.box.Running, 'off')
        start(h.box);
    end
    
%this is where the constraint needs to be made

    [newEvents eventCode] = evalEvent(h.noGoTimer.running, h.noGoTimer2.running, h.punishProb, h.goTimer.running, ...
        h.goTimer2.running, h.rewardProb, h.punishER, h.stopStim, ...
        h.pump, h.darkTimer, h.latencyP, h.latencyR, guiH, h.airPunish, h.airTimer, h.d, h.rewardHitsOnly, h.noErrorReward,...
        h.probeTimer.running, h.probeTimer2.running, h.disTimer.running, h.disTimer2.running); %CT airPunish & d
    
    if length(newEvents) == 2
        logEvents(guiH, newEvents(1), eventCode);
        logEvents(guiH, newEvents(2));
    else
        logEvents(guiH, newEvents, eventCode);
    end
end

clear newEvents eventCode
lastInput = currentInput;
guidata(guiH, h);

function updateTimer(obj, eventdata, handles)
global startTime

et = etime(clock,startTime);
hr=floor(et/3600);
mn = floor((et-hr*3600)/60);
se=round(et-hr*3600-mn*60);

set(handles.hh_txt, 'String', num2str(hr));
set(handles.mm_txt, 'String', num2str(mn));
set(handles.ss_txt, 'String', num2str(se));


function boxFcn(obj, eventdata, h)
set(h.lick_box, 'Color', 'k');

function noGoMonitor(obj, eventdata, guiH)
h = guidata(guiH);
set(h.stimulus_box, 'Color', 'r');


function goMonitor(obj, eventdata, guiH)
h = guidata(guiH);
set(h.stimulus_box, 'Color', 'g');

function probeMonitor(obj, eventdata, guiH)
h= guidata(guiH);
set(h.stimulus_box, 'Color', 'm');

function disMonitor(obj, eventdata, guiH)
h = guidata(guiH);
set(h.stimulus_box, 'Color', 'y');


function checkGo(obj, eventdata, guiH)
global startTime;
h = guidata(guiH);

et = etime(clock, startTime);
newEvent.type = 'Miss';
newEvent.time = et;
newEvent.str = ['Miss at ' num2str(et)];
setappdata(0,'last_trial', 'MISS')
lasttrial = getappdata(0, 'last_trial');
sprintf('App data is %s ', lasttrial)
eventCode = 4;
set(h.response_type, 'String', 'MISS') %CT
ResType = get(h.response_type, 'String');
sprintf('Response type is %s ', ResType)
logEvents(guiH, newEvent, eventCode);
if h.punishMI == 1
    manualCall = 0; 
    punish(h.darkTimer, h.latencyP, guiH, manualCall);
end
guidata(guiH, h);

function checkProbe(obj, eventdata, guiH)
global startTime;
h = guidata(guiH);

et = etime(clock, startTime);
newEvent.type = 'Miss probe';
newEvent.time = et;
newEvent.str = ['Miss probe at ' num2str(et)];
setappdata(0,'last_trial', 'MISS')
lasttrial = getappdata(0, 'last_trial');
sprintf('App data is %s ', lasttrial)
eventCode = 6;
set(h.response_type, 'String', 'MISS') %CT
ResType = get(h.response_type, 'String');
sprintf('Response type is %s ', ResType)
logEvents(guiH, newEvent, eventCode);
guidata(guiH, h);


function checkNoGo(obj, eventdata, guiH)
global startTime;
h = guidata(guiH);
et = etime(clock, startTime);
newEvent.type = 'Correct reject';
set(h.response_type, 'String', 'C/R') %CT
ResType = get(h.response_type, 'String');
sprintf('Response type is %s ', ResType)
newEvent.time = et;
newEvent.str = ['Corr rej at ' num2str(et)];
eventCode = 5;
logEvents(guiH, newEvent, eventCode);
if h.rewardCR == 1
    manualCall = 0; 
    lick_reward(h.pump, h.latencyR, guiH, manualCall);
    logEvents(guiH, outcome);
end
guidata(guiH, h);

function checkDis(obj, eventdata, guiH)
global startTime;
h = guidata(guiH);
et = etime(clock, startTime);
newEvent.type = 'Correct reject dis';
set(h.response_type, 'String', 'C/R') %CT
ResType = get(h.response_type, 'String');
sprintf('Response type is %s ', ResType)
newEvent.time = et;
newEvent.str = ['Corr rej dis at ' num2str(et)];
eventCode = 7;
logEvents(guiH, newEvent, eventCode);
guidata(guiH, h);

function back2black(obj, eventdata, guiH)
h = guidata(guiH);
set(h.stimulus_box, 'Color', 'k');
guidata(guiH, h); 

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global startTime;

putvalue(handles.d.Line(1), 1); % turn on house lights (if off)
stop(handles.d);

stop(handles.audio_out); % stop stimulus output

if strcmp(handles.a.Running, 'on') % stop GUI timer
    stop(handles.a);
end

st = timerfind('Tag', 'StimulusTimer'); % find any stimulus timers not deleted
if ~isempty(st) 
    if strcmp(st.Running, 'on') % stop stimulus timer if running
        stop(st);
    end
end

if isfield(handles, '') && strcmp(handles.goTimer.running, 'on') % stop
    stop([handles.goTimer handles.goTimer2]);
elseif isfield(handles, 'noGoTimer') && strcmp(handles.noGoTimer.running, 'on') % stop
    stop([handles.noGoTimer handles.noGoTimer2]);
end

if isfield(handles, '') && strcmp(handles.probeTimer.running, 'on') % stop
    stop([handles.probeTimer handles.probeTimer2]);
elseif isfield(handles, 'disTimer') && strcmp(handles.disTimer.running, 'on') % stop
    stop([handles.disTimer handles.disTimer2]);
end

% Stop stimulus timer
st = timerfind('Tag', 'StimulusTimer');
if ~isempty(st)
    stop(st);
end


handles.trialLength = etime(clock, startTime);

if strcmp(handles.trial, 'train') 
    autoSave(handles.trial, handles.ISI, handles.rewardList, handles.punishList,...
        handles.trialLength, get(handles.subj_edit, 'String'), get(handles.exp_edit, 'String'));
elseif strcmp(handles.trial, 'stim')
    autoSave(handles.trial, handles.ISI, handles.rewardList, [], handles.trialLength, get(handles.subj_edit, 'String'), get(handles.exp_edit, 'String'));
end

set(handles.status_txt, 'String', 'session stopped'); 

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lineL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'a') && strcmp(handles.a.running, 'on')
    errordlg('Stop before save', 'Stop', 'modal');
    return
elseif ~isfield(handles, 'a')
    errordlg('No session available', 'Run before saving', 'modal');
    return
else
    currDir = cd;
    saveDir = [cd '\data'];
    cd(saveDir);
    [file path] = uiputfile('*.mat', 'Save session as...');
    keyboard
    [eventLog HI MI CR FA ER RC LO AP] = logEvents;
    session_params = struct('subject', get(handles.subj_edit, 'String'), 'Experimenter', ...
        get(handles.exp_edit, 'String'), 'trial_type', handles.trial, 'ISI', handles.ISI,...
        'target_stim', {handles.rewardList}, 'false_stim', {handles.punishList});
    session_stats = struct('total_time', handles.trialLength, 'trials_completed', (HI+MI+CR+FA), 'correct', (HI + CR),...
        'incorrect', (FA + MI), 'hits', HI, 'misses', MI, 'correct_reject', CR, 'false_alarms', FA, 'errors', ER, 'rewards', RC,...
        'lights_off', LO, 'air_puffs', AP);
    all_events = eventLog;
    save([path file], 'session_params', 'session_stats', 'all_events');
    disp(['Session saved to ' path file]);
    cd(currDir);
end

handles.sessionSaved = 1;


% autoSaveName = autoSave; 
% delete(autoSaveName); 
% disp('Session autosave file deleted');

set(handles.status_txt, 'String', 'session saved'); 

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lineHL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function portL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function portHL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in lightsOn_push.
function lightsOn_push_Callback(hObject, eventdata, handles)
% hObject    handle to lightsOn_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject, 'String'), 'Lights on')
    if isempty(handles.d.Line)
        lineHL = str2num(get(handles.lineHL, 'String'));
        portHL = str2num(get(handles.portHL, 'String'));
        addline(handles.d, lineHL, portHL, 'Out'); % add house lights line
    end
    putvalue(handles.d.Line(1), 1);
    set(hObject, 'String', 'Lights off');
else
    putvalue(handles.d, 0);
    set(hObject, 'String', 'Lights on');
end 

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function session_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in configure_push.
function configure_push_Callback(hObject, eventdata, handles)
% hObject    handle to configure_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gets the selected option

switch get(handles.session_popup,'Value')
    case 1
        errordlg('Select session type before continuing', 'Select type', 'modal');
    case 2
        tubetrainGUI;
        set(handles.sessionType, 'String', 'Tube train');
        set(handles.HI_txt, 'Enable', 'off');
        set(handles.MI_txt, 'Enable', 'off');
        set(handles.CR_txt, 'Enable', 'off');
        set(handles.FA_txt, 'Enable', 'off');
        set(handles.ER_txt, 'Enable', 'off');
        set(handles.noTrials_edit, 'Enable', 'off');
        set(handles.trialsComplete_txt, 'Enable', 'off');
        set(handles.totalTrials_txt, 'Enable', 'off');
        set(handles.ISI_edit, 'Enable', 'off');
        set(handles.ISImax_edit, 'Enable', 'off');
        set(handles.varISI_check, 'Enable', 'off');
    case 3
        stimtrainGUI;
        set(handles.sessionType, 'String', 'Stimulus training');
        set(handles.HI_txt, 'Enable', 'on');
        set(handles.MI_txt, 'Enable', 'on');
        set(handles.CR_txt, 'Enable', 'off');
        set(handles.FA_txt, 'Enable', 'off');
        set(handles.ER_txt, 'Enable', 'on');
        set(handles.noTrials_edit, 'Enable', 'on');
        set(handles.trialsComplete_txt, 'Enable', 'on');
        set(handles.totalTrials_txt, 'Enable', 'on');
        set(handles.ISI_edit, 'Enable', 'on');
        if get(handles.varISI_check, 'Value') == get(handles.varISI_check, 'Max')
            set(handles.ISImax_edit, 'Enable', 'on');
        end
        set(handles.varISI_check, 'Enable', 'on');
    case 4
        reinforcementGUI;
        set(handles.sessionType, 'String', 'Reinforcement');
        set(handles.HI_txt, 'Enable', 'on');
        set(handles.MI_txt, 'Enable', 'on');
        set(handles.CR_txt, 'Enable', 'on');
        set(handles.FA_txt, 'Enable', 'on');
        set(handles.ER_txt, 'Enable', 'on');
        set(handles.noTrials_edit, 'Enable', 'on');
        set(handles.trialsComplete_txt, 'Enable', 'on');
        set(handles.totalTrials_txt, 'Enable', 'on');
        set(handles.ISI_edit, 'Enable', 'on');
        if get(handles.varISI_check, 'Value') == get(handles.varISI_check, 'Max')
            set(handles.ISImax_edit, 'Enable', 'on');
        end
        set(handles.varISI_check, 'Enable', 'on');
    otherwise
        return
end


function closeGUI(src, event, handles)

if ~isfield(handles, 'sessionSaved')|| ~handles.sessionSaved
end

d = handles.d;
if isvalid(d) && isempty(d.Line)
    lineHL = str2num(get(handles.lineHL, 'String'));
    portHL = str2num(get(handles.portHL, 'String'));
    addline(d, lineHL, portHL, 'Out'); % add house lights line
    putvalue(d, 0);
    delete(instrfind);
    delete(handles.d);
    delete(gcf);
end
%%% REMOVE IN LATER VER
delete(daqfind);
delete(timerfind);


% --- Executes during object creation, after setting all properties.
function noTrials_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noTrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ISI_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ISI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in session_popup.
function session_popup_Callback(hObject, eventdata, handles)
% hObject    handle to session_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_popup



function noTrials_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noTrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noTrials_edit as text
%        str2double(get(hObject,'String')) returns contents of noTrials_edit as a double

trials = str2double(get(hObject, 'String'));
if isnan(trials)
    errordlg('Enter whole numeric for number of trials', 'No. trials', 'modal');
end
trialsStr = num2str(trials);
set(handles.totalTrials_txt, 'String', trialsStr);

function ISI_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ISI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ISI_edit as text
%        str2double(get(hObject,'String')) returns contents of ISI_edit as a double


% --- Executes on button press in manualReward_button.
function manualReward_button_Callback(hObject, eventdata, handles)
% hObject    handle to manualReward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiH = handles.figure1;
manualCall = 1; 
lick_reward(handles.pump, handles.latencyR, guiH, manualCall);
guidata(hObject, handles);

function ISImax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ISImax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ISImax_edit as text
%        str2double(get(hObject,'String')) returns contents of ISImax_edit as a double


% --- Executes during object creation, after setting all properties.
function ISImax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ISImax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in varISI_check.
function varISI_check_Callback(hObject, eventdata, handles)
% hObject    handle to varISI_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of varISI_check

if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.ISImax_edit, 'Enable', 'on');
else
    set(handles.ISImax_edit, 'Enable', 'off');
end



function lineAV_Callback(hObject, eventdata, handles)
% hObject    handle to lineAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lineAV as text
%        str2double(get(hObject,'String')) returns contents of lineAV as a double


% --- Executes during object creation, after setting all properties.
function lineAV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function portAV_Callback(hObject, eventdata, handles)
% hObject    handle to portAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of portAV as text
%        str2double(get(hObject,'String')) returns contents of portAV as a double


% --- Executes during object creation, after setting all properties.
function portAV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manualLightsOff_button.
function manualLightsOff_button_Callback(hObject, eventdata, handles)
% hObject    handle to manualLightsOff_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiH = handles.figure1;
manualCall = 1; 
punish(handles.darkTimer, handles.latencyP, guiH, manualCall);
guidata(hObject, handles);



% --- Executes on button press in manualAirPuff_button.
function manualAirPuff_button_Callback(hObject, eventdata, handles)
% hObject    handle to manualAirPuff_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.d
start(handles.airTimer);



function exp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to exp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exp_edit as text
%        str2double(get(hObject,'String')) returns contents of exp_edit as a double


% --- Executes during object creation, after setting all properties.
function exp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subj_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subj_edit as text
%        str2double(get(hObject,'String')) returns contents of subj_edit as a double


% --- Executes during object creation, after setting all properties.
function subj_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in retract_reward.
function retract_reward_Callback(hObject, eventdata, handles)
% hObject    handle to retract_reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Manually retraction of reward
guiH = handles.figure1;
manualCall = 1; 
lick_retract(handles.pump, handles.latencyR, guiH, manualCall);
guidata(hObject, handles);
