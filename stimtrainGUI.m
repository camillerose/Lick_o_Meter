function varargout = stimtrainGUI(varargin)
% STIMTRAINGUI M-file for stimtrainGUI.fig
%      STIMTRAINGUI, by itself, creates a new STIMTRAINGUI or raises the existing
%      singleton*.
%
%      H = STIMTRAINGUI returns the handle to a new STIMTRAINGUI or the handle to
%      the existing singleton*.
%
%      STIMTRAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMTRAINGUI.M with the given input arguments.
%
%      STIMTRAINGUI('Property','Value',...) creates a new STIMTRAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stimtrainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stimtrainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stimtrainGUI

% Last Modified by GUIDE v2.5 19-Dec-2012 12:53:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stimtrainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @stimtrainGUI_OutputFcn, ...
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


% --- Executes just before stimtrainGUI is made visible.
function stimtrainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stimtrainGUI (see VARARGIN)

% Choose default command line output for stimtrainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stimtrainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stimtrainGUI_OutputFcn(hObject, eventdata, handles) 
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
elseif iscell(audioList) == 0 % one file is selected
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
hit_period = str2num(get(handles.hit_period, 'String'));


% change main gui strings
lickGUIdata.trial = 'stim'; 
lickGUIdata.rewardList = get(handles.reward_list, 'String'); 
lickGUIdata.amtR = get(handles.amt_edit, 'String'); 
lickGUIdata.rateR = get(handles.rate_edit, 'String'); 
lickGUIdata.latencyR = str2num(get(handles.food_latency, 'String')); 
lickGUIdata.rewardProb = str2num(get(handles.reward_prob, 'String'))./100;
behLatencyR = str2num(get(handles.behLatency_R, 'String')); 
lickGUIdata.behLatencyR = behLatencyR; 
lickGUIdata.behLatencyP = 0;
lickGUIdata.punishMI = 0; 
lickGUIdata.hit_period = hit_period;
% if behLatencyR > ISI
%     errodlg('Behvioral latencies must be less than or equal to ISI, change parameter in main window', 'Timing eror', 'modal'); 
%     return 
% end

if get(handles.punishER_check, 'Value') == get(handles.punishER_check, 'Max')
    lickGUIdata.punishER = 1;
else
    lickGUIdata.punishER = 0;
end

if get(handles.stopStim_check, 'Value') == get(handles.stopStim_check, 'Max')
    lickGUIdata.stopStim = 1; 
else
    lickGUIdata.stopStim = 0; 
end

if get(handles.air_puff_punish, 'Value') == get(handles.air_puff_punish, 'Max') %CT
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


lickGUIdata.lengthP = str2num(get(handles.lights_length, 'String'));
lickGUIdata.latencyP = str2num(get(handles.lights_latency, 'String'));
lickGUIdata.punishProb = (str2num(get(handles.punish_prob, 'String')))./100;
    
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


% --- Executes on button press in punishER_check.
function punishER_check_Callback(hObject, eventdata, handles)
% hObject    handle to punishER_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of punishER_check
if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.lights_length, 'Enable', 'on');
    set(handles.lights_latency, 'Enable', 'on');
    set(handles.punish_prob, 'Enable', 'on');
elseif get(hObject, 'Value') == get(hObject, 'Min')
    set(handles.lights_length, 'Enable', 'off');
    set(handles.lights_latency, 'Enable', 'off');
    set(handles.punish_prob, 'Enable', 'off');
end
guidata(hObject, handles);


% --- Executes on button press in stopStim_check.
function stopStim_check_Callback(hObject, eventdata, handles)
% hObject    handle to stopStim_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stopStim_check


% --- Executes on button press in stimEndReward_check.
function stimEndReward_check_Callback(hObject, eventdata, handles)
% hObject    handle to stimEndReward_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimEndReward_check


% --- Executes on button press in air_puff_punish.
function air_puff_punish_Callback(hObject, eventdata, handles)
% hObject    handle to air_puff_punish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of air_puff_punish


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
