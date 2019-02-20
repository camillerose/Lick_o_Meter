function varargout = reinforcementGUI(varargin)
% REINFORCEMENTGUI M-file for reinforcementGUI.fig
%      REINFORCEMENTGUI, by itself, creates a new REINFORCEMENTGUI or raises the existing
%      singleton*.
%
%      H = REINFORCEMENTGUI returns the handle to a new REINFORCEMENTGUI or the handle to
%      the existing singleton*.
%
%      REINFORCEMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REINFORCEMENTGUI.M with the given input arguments.
%
%      REINFORCEMENTGUI('Property','Value',...) creates a new REINFORCEMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reinforcementGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reinforcementGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reinforcementGUI

% Last Modified by GUIDE v2.5 10-May-2013 16:33:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reinforcementGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @reinforcementGUI_OutputFcn, ...
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


% --- Executes just before reinforcementGUI is made visible.
function reinforcementGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reinforcementGUI (see VARARGIN)

% Choose default command line output for reinforcementGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reinforcementGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reinforcementGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_reward.
function load_reward_Callback(hObject, eventdata, handles)
% hObject    handle to load_reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[audioList, path] = uigetfile('*.wav; *.WAV','Select files', 'MultiSelect', 'on');
rewardList = get(handles.reward_list, 'String');
addpath(path);
if isequal(audioList, 0) || isequal(path, 0)
    return 
elseif iscell(audioList) == 0 % one file is selected aka not a cell
    %add the most recent data file selected to the cell containing
    %all the data file names 
    rewardList{end+1} = audioList;
    %else, data will be in cell format
else 
    for n = 1:length(audioList)
        rewardList{end+1} = audioList{n};
    end
end
set(handles.reward_list, 'String', rewardList);
guidata(hObject, handles);


% --- Executes on button press in load_punish.
function load_punish_Callback(hObject, eventdata, handles)
% hObject    handle to load_punish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[audioList, path] = uigetfile('*.wav; *.WAV','Select files', 'MultiSelect', 'on');
punishList = get(handles.punish_list, 'String');
addpath(path);
if isequal(audioList, 0) || isequal(path, 0)
    return 
elseif iscell(audioList) == 0 % one file is selected
    %add the most recent data file selected to the cell containing
    %all the data file names
    punishList{end+1} = audioList;
    %else, data will be in cell format
else
    for n = 1:length(audioList)
        punishList{end+1} = audioList{n};
    end
end
set(handles.punish_list, 'String', punishList);
guidata(hObject, handles);


% --- Executes on selection change in punish_list.
function punish_list_Callback(hObject, eventdata, handles)
% hObject    handle to punish_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns punish_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from punish_list


% --- Executes during object creation, after setting all properties.
function punish_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to punish_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in reward_list.
function reward_list_Callback(hObject, eventdata, handles)
% hObject    handle to reward_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns reward_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reward_list


% --- Executes during object creation, after setting all properties.
function reward_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reward_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function food_latency_Callback(hObject, eventdata, handles)
% hObject    handle to food_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of food_latency as text
%        str2double(get(hObject,'String')) returns contents of food_latency as a double


% --- Executes during object creation, after setting all properties.
function food_latency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to food_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lights_latency_Callback(hObject, eventdata, handles)
% hObject    handle to lights_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lights_latency as text
%        str2double(get(hObject,'String')) returns contents of lights_latency as a double


% --- Executes during object creation, after setting all properties.
function lights_latency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lights_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in food_check.
function food_check_Callback(hObject, eventdata, handles)
% hObject    handle to food_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of food_check


% --- Executes on button press in lights_check.
function lights_check_Callback(hObject, eventdata, handles)
% hObject    handle to lights_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lights_check



function lights_length_Callback(hObject, eventdata, handles)
% hObject    handle to lights_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lights_length as text
%        str2double(get(hObject,'String')) returns contents of lights_length as a double


% --- Executes during object creation, after setting all properties.
function lights_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lights_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the main_gui handle (access to the gui)
lickGUIhandle = lickometerGUI;       
% get the data from the gui (all handles inside gui_main)
lickGUIdata  = guidata(lickGUIhandle);
 
ISI = str2double(get(lickGUIdata.ISI_edit, 'String')); 

% change main gui strings
lickGUIdata.trial = 'train'; 
lickGUIdata.rewardList = get(handles.reward_list, 'String'); 
lickGUIdata.punishList = get(handles.punish_list, 'String'); 
lickGUIdata.probeList = get(handles.probe_list, 'String');
lickGUIdata.distracterList = get(handles.distracter_list, 'String');
lickGUIdata.amtR = get(handles.amt_edit, 'String'); 
lickGUIdata.rateR = get(handles.rate_edit, 'String'); 
lickGUIdata.lengthP = str2num(get(handles.lights_length, 'String')); 
lickGUIdata.latencyP = str2num(get(handles.lights_latency, 'String')); 
lickGUIdata.latencyR = str2num(get(handles.food_latency, 'String')); 
lickGUIdata.punishProb = (str2num(get(handles.punish_prob, 'String')))./100; 
lickGUIdata.rewardProb = (str2num(get(handles.reward_prob, 'String')))./100;

behLatencyR = str2num(get(handles.behLatency_R, 'String')); 
behLatencyP = str2num(get(handles.behLatency_P, 'String'));
hit_period = str2num(get(handles.hit_period, 'String'));

if behLatencyR > ISI || behLatencyP > ISI 
    errordlg('Behvioral latencies must be less than or equal to ISI, change parameter in main window', 'Timing eror', 'modal'); 
    return 
end

lickGUIdata.behLatencyR = behLatencyR; 
lickGUIdata.behLatencyP = behLatencyP; 
lickGUIdata.hit_period = hit_period;

lickGUIdata.targetPercent = str2num(get(handles.percentTarget_edit, 'String'));
lickGUIdata.probePercent = str2num(get(handles.percent_probe, 'String'));
% 
% if get(handles.grace_check, 'Value') == get(handles.grace_check, 'Max')
%     lickGUIdata.rewardGrace = 1;
%     lickGUIdata.graceTime = str2num(get(handles.grace_edit, 'String'));
% else
%     lickGUIdata.rewardGrace = 0; 
% end

if get(handles.punishER_check, 'Value') == get(handles.punishER_check, 'Max')
    lickGUIdata.punishER = 1; 
    lickGUIdata.lengthER = str2num(get(handles.lightsER_length, 'String')); 
    lickGUIdata.latencyER = str2num(get(handles.lightsER_latency, 'String')); 
else
    lickGUIdata.punishER = 0; 
end

if get(handles.punishMI_check, 'Value') == get(handles.punishMI_check, 'Max')
    lickGUIdata.punishMI = 1; 
    lickGUIdata.lengthMI = str2num(get(handles.lightsMI_length, 'String')); 
    lickGUIdata.latencyMI = str2num(get(handles.lightsMI_latency, 'String')); 
else
    lickGUIdata.punishMI = 0; 
end

if get(handles.rewardCR_check, 'Value') == get(handles.rewardCR_check, 'Max')
    lickGUIdata.rewardCR = 1; 
else
    lickGUIdata.rewardCR = 0; 
end

if get(handles.stopStim_check, 'Value') == get(handles.stopStim_check, 'Max')
    lickGUIdata.stopStim = 1; 
else
    lickGUIdata.stopStim = 0; 
end

if get(handles.air_punish_check, 'Value') == get(handles.air_punish_check, 'Max') %CT
    lickGUIdata.airPunish = 1; %CT
else 
    lickGUIdata.airPunish = 0; %CT
end

if get(handles.noErrorReward, 'Value') == get(handles.noErrorReward, 'Max')
    lickGUIdata.noErrorReward = 1;
else
    lickGUIdata.noErrorReward = 0;
end

if get(handles.rewardHitsOnly, 'Value') == get(handles.rewardHitsOnly, 'Max') %CT
    lickGUIdata.rewardHitsOnly = 1; %CT
else
    lickGUIdata.rewardHitsOnly = 0; %CT
end


set(lickGUIdata.status_txt, 'String', 'session loaded'); 

% save changed data back into lickometerGUI
guidata(lickometerGUI, lickGUIdata);
 
  
function amt_edit_Callback(hObject, eventdata, handles)
% hObject    handle to amt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amt_edit as text
%        str2double(get(hObject,'String')) returns contents of amt_edit as a double


% --- Executes during object creation, after setting all properties.
function amt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rate_edit as text
%        str2double(get(hObject,'String')) returns contents of rate_edit as a double


% --- Executes during object creation, after setting all properties.
function rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ISI_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ISI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ISI_edit as text
%        str2double(get(hObject,'String')) returns contents of ISI_edit as a double


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



function numStim_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numStim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numStim_edit as text
%        str2double(get(hObject,'String')) returns contents of numStim_edit as a double


% --- Executes during object creation, after setting all properties.
function numStim_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numStim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reward_prob_Callback(hObject, eventdata, handles)
% hObject    handle to reward_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reward_prob as text
%        str2double(get(hObject,'String')) returns contents of reward_prob as a double


% --- Executes during object creation, after setting all properties.
function reward_prob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reward_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function punish_prob_Callback(hObject, eventdata, handles)
% hObject    handle to punish_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of punish_prob as text
%        str2double(get(hObject,'String')) returns contents of punish_prob as a double


% --- Executes during object creation, after setting all properties.
function punish_prob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to punish_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in punishER_check.
function punishER_check_Callback(hObject, eventdata, handles)
% hObject    handle to punishER_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of punishER_check

if get(hObject, 'Value') == get(hObject, 'Max')
   set(handles.lightsER_length, 'Enable', 'on'); 
   set(handles.lightsER_latency, 'Enable', 'on'); 
else 
   set(handles.lightsER_length, 'Enable', 'off'); 
   set(handles.lightsER_latency, 'Enable', 'off'); 
end
guidata(hObject, handles); 

function lightsER_latency_Callback(hObject, eventdata, handles)
% hObject    handle to lightsER_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lightsER_latency as text
%        str2double(get(hObject,'String')) returns contents of lightsER_latency as a double


% --- Executes during object creation, after setting all properties.
function lightsER_latency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightsER_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lightsER_length_Callback(hObject, eventdata, handles)
% hObject    handle to lightsER_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lightsER_length as text
%        str2double(get(hObject,'String')) returns contents of lightsER_length as a double


% --- Executes during object creation, after setting all properties.
function lightsER_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightsER_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function behLatency_P_Callback(hObject, eventdata, handles)
% hObject    handle to behLatency_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of behLatency_P as text
%        str2double(get(hObject,'String')) returns contents of behLatency_P as a double


% --- Executes during object creation, after setting all properties.
function behLatency_P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to behLatency_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function behLatency_R_Callback(hObject, eventdata, handles)
% hObject    handle to behLatency_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of behLatency_R as text
%        str2double(get(hObject,'String')) returns contents of behLatency_R as a double


% --- Executes during object creation, after setting all properties.
function behLatency_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to behLatency_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rewardCR_check.
function rewardCR_check_Callback(hObject, eventdata, handles)
% hObject    handle to rewardCR_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rewardCR_check


% --- Executes on button press in punishMI_check.
function punishMI_check_Callback(hObject, eventdata, handles)
% hObject    handle to punishMI_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of punishMI_check
if get(hObject, 'Value') == get(hObject, 'Max')
   set(handles.lightsMI_length, 'Enable', 'on'); 
   set(handles.lightsMI_latency, 'Enable', 'on'); 
else 
   set(handles.lightsMI_length, 'Enable', 'off'); 
   set(handles.lightsMI_latency, 'Enable', 'off'); 
end
guidata(hObject, handles); 



function lightsMI_latency_Callback(hObject, eventdata, handles)
% hObject    handle to lightsMI_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lightsMI_latency as text
%        str2double(get(hObject,'String')) returns contents of lightsMI_latency as a double


% --- Executes during object creation, after setting all properties.
function lightsMI_latency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightsMI_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lightsMI_length_Callback(hObject, eventdata, handles)
% hObject    handle to lightsMI_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lightsMI_length as text
%        str2double(get(hObject,'String')) returns contents of lightsMI_length as a double


% --- Executes during object creation, after setting all properties.
function lightsMI_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightsMI_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percentTarget_edit_Callback(hObject, eventdata, handles)
% hObject    handle to percentTarget_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percentTarget_edit as text
%        str2double(get(hObject,'String')) returns contents of percentTarget_edit as a double
percent = str2double(get(hObject, 'String'));

if isnan(percent) || ~(percent >= 0 && percent <= 100)
    errordlg('Enter numeric percent between 0 and 100', 'Percentage target', 'modal');
    return
end

% --- Executes during object creation, after setting all properties.
function percentTarget_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percentTarget_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stopStim_check.
function stopStim_check_Callback(hObject, eventdata, handles)
% hObject    handle to stopStim_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stopStim_check

% 
% % --- Executes on button press in grace_check.
% function grace_check_Callback(hObject, eventdata, handles)
% % hObject    handle to grace_check (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of grace_check
% 
% set(handles.grace_edit, 'Enable', 'on');
% 
% guidata(hObject, handles);
% 
% 
% 
% function grace_edit_Callback(hObject, eventdata, handles)
% % hObject    handle to grace_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of grace_edit as text
% %        str2double(get(hObject,'String')) returns contents of grace_edit as a double
% 

% --- Executes during object creation, after setting all properties.
function grace_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grace_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in air_punish_check.
function air_punish_check_Callback(hObject, eventdata, handles)
% hObject    handle to air_punish_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of air_punish_check


% --- Executes on button press in goEndReward.
function goEndReward_Callback(hObject, eventdata, handles)
% hObject    handle to goEndReward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of goEndReward


% --- Executes on button press in rewardHitsOnly.
function rewardHitsOnly_Callback(hObject, eventdata, handles)
% hObject    handle to rewardHitsOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rewardHitsOnly



function hit_period_Callback(hObject, eventdata, handles)
% hObject    handle to hit_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hit_period as text
%        str2double(get(hObject,'String')) returns contents of hit_period as a double


% --- Executes during object creation, after setting all properties.
function hit_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hit_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noErrorReward.
function noErrorReward_Callback(hObject, eventdata, handles)
% hObject    handle to noErrorReward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noErrorReward


% --- Executes on button press in airpuff_FA.
function airpuff_FA_Callback(hObject, eventdata, handles)
% hObject    handle to airpuff_FA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of airpuff_FA


% --- Executes on button press in load_probe.
function load_probe_Callback(hObject, eventdata, handles)
% hObject    handle to load_probe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[audioList, path] = uigetfile('*.wav; *.WAV','Select files', 'MultiSelect', 'on');
probeList = get(handles.probe_list, 'String');
addpath(path);
if isequal(audioList, 0) || isequal(path, 0)
    return 
elseif iscell(audioList) == 0 % one file is selected
    %add the most recent data file selected to the cell containing
    %all the data file names
    probeList{end+1} = audioList;
    %else, data will be in cell format
else
    for n = 1:length(audioList)
        probeList{end+1} = audioList{n};
    end
end
set(handles.probe_list, 'String', probeList);


% --- Executes on selection change in probe_list.
function probe_list_Callback(hObject, eventdata, handles)
% hObject    handle to probe_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns probe_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from probe_list


% --- Executes during object creation, after setting all properties.
function probe_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probe_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percent_probe_Callback(hObject, eventdata, handles)
% hObject    handle to percent_probe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percent_probe as text
%        str2double(get(hObject,'String')) returns contents of percent_probe as a double
percent_probe = str2double(get(hObject, 'String'));

if isnan(percent_probe) || ~(percent_probe >= 0 && percent_probe <= 100)
    errordlg('Enter numeric percent between 0 and 100', 'Percentage probe', 'modal');
    return
end


% --- Executes during object creation, after setting all properties.
function percent_probe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percent_probe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_distracter.
function load_distracter_Callback(hObject, eventdata, handles)
% hObject    handle to load_distracter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[audioList, path] = uigetfile('*.wav; *.WAV','Select files', 'MultiSelect', 'on');
distracterList = get(handles.distracter_list, 'String');
addpath(path);
if isequal(audioList, 0) || isequal(path, 0)
    return 
elseif iscell(audioList) == 0 % one file is selected
    %add the most recent data file selected to the cell containing
    %all the data file names
    distracterList{end+1} = audioList;
    %else, data will be in cell format
else
    for n = 1:length(audioList)
        distracterList{end+1} = audioList{n};
    end
end
set(handles.distracter_list, 'String', distracterList);

% --- Executes on selection change in distracter_list.
function distracter_list_Callback(hObject, eventdata, handles)
% hObject    handle to distracter_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distracter_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distracter_list


% --- Executes during object creation, after setting all properties.
function distracter_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distracter_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
