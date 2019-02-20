% autoSave is automatic save function for lickometerGUI. autoSave can be
% queried with no input args to find the last session file created by autoSave 

function varargout = autoSave(varargin) 

persistent savename; 

if nargin>0 
    
    trial = varargin{1};
    ISI = varargin{2};
    rewardList = varargin{3};
    punishList = varargin{4};
    trialLength = varargin{5};
    subj = varargin{6};
    exp = varargin{7};
    
    c = clock;
    
    if ~isempty(subj)
        savename = [subj 'training_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(1)) ...
            '_' num2str(c(4)) '_' num2str(c(5)) '_auto.mat'];
    else
        savename = ['training_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(1)) ...
            '_' num2str(c(4)) '_' num2str(c(5)) '_auto.mat'];
    end
    
    [eventLog HI MI CR FA ER RC LO AP HI_new MI_new CR_new FA_new MI_probe HI_probe CR_dis FA_dis] = logEvents;  
    
    session_params = struct('trial_type', trial, 'ISI', ISI, 'target_stim', {rewardList},...
        'false_stim', {punishList});
    session_stats = struct('subject', subj, 'experimenter', exp, 'total_time', trialLength, 'trials_completed', (HI+MI+CR+FA), 'correct', (HI + CR),...
        'incorrect', (FA + MI), 'hits', HI, 'misses', MI, 'correct_reject', CR, 'false_alarms', FA, 'errors', ER, 'rewards', RC,...
        'lights_off', LO, 'air_puffs', AP, 'hits_new', HI_new, 'misses_new', MI_new, 'correct_rejects_new', CR_new, 'false_alarms_new', FA_new,...
        'misses_probe', MI_probe, 'hits_probe', HI_probe, 'correct_rejects_distracters', CR_dis, 'false_alarms_distracters', FA_dis);
    all_events = eventLog;
    
    
    currDir = cd;
    saveTarget = [cd '\data\autosave'];
    
    if isdir(saveTarget)
        cd(saveTarget)
    else
        mkdir(saveTarget)
        cd(saveTarget);
    end
    
    save(savename, 'session_params', 'session_stats', 'all_events');
    disp(['Session autosaved to ' saveTarget '\' savename]);
    cd(currDir);
    
else
    varargout{1} = savename;
end

