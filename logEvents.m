
% Called by checkLick1 or  checkLick2, stimCall

function varargout = logEvents(varargin) 

global startTime
persistent eventInd eventLog HIcount MIcount CRcount FAcount ERcount rewardCt lightsCt airPuffCt...
    HIcount_new MIcount_new CRcount_new FAcount_new MIcount_probe HIcount_probe CRcount_dis FAcount_dis

if nargin >= 1 %
    guiH = varargin{1}; 
    h = guidata(guiH);
else % called without inputs
    varargout{1} = eventLog;
    varargout{2} = HIcount;
    varargout{3} = MIcount;
    varargout{4} = CRcount;
    varargout{5} = FAcount;
    varargout{6} = ERcount;
    varargout{7} = rewardCt; 
    varargout{8} = lightsCt; 
    varargout{9} = airPuffCt; 
    varargout{10} = HIcount_new;
    varargout{11} = MIcount_new;
    varargout{12} = CRcount_new;
    varargout{13} = FAcount_new;
    varargout{14} = MIcount_probe;
    varargout{15} = HIcount_probe;
    varargout{16} = CRcount_dis;
    varargout{17} = FAcount_dis;
    return
end

if nargin == 1 
    if isempty(eventInd)
        eventInd = 1; 
        HIcount = 0; 
        MIcount = 0; 
        CRcount = 0; 
        FAcount = 0; 
        ERcount = 0;
        rewardCt = 0; 
        lightsCt = 0; 
        airPuffCt = 0; 
        HIcount_new = 0;
        MIcount_new = 0;
        CRcount_new = 0;
        FAcount_new = 0;
        MIcount_probe = 0;
        HIcount_probe = 0;
        CRcount_dis = 0;
        FAcount_dis = 0;
    end 

    if isempty(eventLog)
        t = etime(clock, startTime); 
        eventLog = struct('type', 'START', 'time', t, 'str', ['start at ' num2str(t)], 'info', []); 
    end 
    
elseif nargin == 2 % stimulus, punish or reward, only has two args 
    newEvents = varargin{2}; 
    eventInd = eventInd + 1; 
    eventLog(eventInd).type = newEvents.type;
    eventLog(eventInd).time = newEvents.time;
    eventLog(eventInd).str = newEvents.str;
    if strcmp(newEvents.type, 'Punish') || strcmp(newEvents.type, 'Punish reset')
        lightsCt = lightsCt + 1; 
        set(h.lightsCt_txt, 'String', num2str(lightsCt));
    elseif strcmp(newEvents.type, 'Reward') || strcmp(newEvents.type, 'Reward, manual')
        rewardCt = rewardCt + 1; 
        set(h.rewardCt_txt, 'String', num2str(rewardCt));
    elseif strcmp(newEvents.type, 'Air puff') 
        airPuffCt  = airPuffCt + 1; 
        set(h.airPuffCt_txt, 'String', num2str(airPuffCt));
    end

    if isfield(newEvents, 'info')
        eventLog(eventInd).info = newEvents.info; 
    end
elseif nargin == 3 % response event, has associatied eventCode as third arg 
    newEvents = varargin{2}; 
    eventCode = varargin{3}; 
    eventInd = eventInd + 1; 
    eventLog(eventInd).type = newEvents.type;
    eventLog(eventInd).time = newEvents.time;
    eventLog(eventInd).str = newEvents.str;
    
    stimuli = getappdata(0, 'stimuli');
    
    switch eventCode
        case 0 
        case 1 % hit (HI), a lick during a GO stimulus period
            if strcmp(h.goTimer.running, 'on') % first lick after GO
                HIcount = HIcount + 1;
                set(h.hitPercent_txt, 'String', num2str(round((HIcount)/(HIcount + MIcount)*100)));
                set(h.missPercent_txt, 'String', num2str(round((MIcount)/(HIcount + MIcount)*100)));
                set(h.hitNo_txt, 'String', HIcount);
                if strcmp(stimuli, 'new')
                    HIcount_new = HIcount_new + 1;
                    set(h.hit_percent_new, 'String', num2str(round((HIcount_new)/(HIcount_new + MIcount_new)*100)));
                    set(h.miss_percent_new, 'String', num2str(round((MIcount_new)/(HIcount_new + MIcount_new)*100)));
                    set(h.hit_number_new, 'String', HIcount_new);
                end
                stop(h.goTimer); 
                    
                
            else
                return
            end
        case 2 % false alarm (FA), a lick during a NO-GO stimulus period
            if strcmp(h.noGoTimer.running, 'on') % first lick after NO-GO
                FAcount =FAcount + 1;
                set(h.falseAlarmPercent_txt, 'String', num2str(round((FAcount)/(FAcount+CRcount)*100)));
                set(h.correctRejPercent_txt, 'String', num2str(round((CRcount)/(FAcount+CRcount)*100)));
                set(h.FANo_txt, 'String', FAcount);
                if strcmp(stimuli, 'new')
                    FAcount_new = FAcount_new + 1;
                    set(h.FA_percent_new, 'String', num2str(round((FAcount_new)/(FAcount_new + CRcount_new)*100)));
                    set(h.CR_percent_new, 'String', num2str(round((CRcount_new)/(CRcount_new + FAcount_new)*100)));
                    set(h.FA_number_new, 'String', FAcount_new);
                end
                stop(h.noGoTimer);
            else
                return
            end
        case 3 % error (ER), a lick outside of any stimulus period 
            ERcount = ERcount + 1;
            set(h.errorTotal_txt, 'String', num2str(ERcount));
        case 4 % miss (MI), a failure to lick during a GO stimulus period
            MIcount = MIcount + 1; 
            set(h.missPercent_txt, 'String', num2str(round((MIcount)/(MIcount+HIcount)*100)));
            set(h.hitPercent_txt, 'String', num2str(round((HIcount)/(MIcount+HIcount)*100)));
            set(h.missNo_txt, 'String', num2str(MIcount));
            if strcmp(stimuli, 'new')
                    MIcount_new = MIcount_new + 1;
                    set(h.hit_percent_new, 'String', num2str(round((HIcount_new)/(HIcount_new + MIcount_new)*100)));
                    set(h.miss_percent_new, 'String', num2str(round((MIcount_new)/(HIcount_new + MIcount_new)*100)));
                    set(h.miss_number_new, 'String', MIcount_new);
            end
        case 5 % CR
            CRcount = CRcount + 1;
            set(h.correctRejPercent_txt, 'String', num2str(round((CRcount/(CRcount + FAcount))*100)));
            set(h.falseAlarmPercent_txt, 'String', num2str(round((FAcount/(CRcount + FAcount))*100)));
            set(h.CRNo_txt, 'String', num2str(CRcount));
            if strcmp(stimuli, 'new')
                    CRcount_new = CRcount_new + 1;
                    set(h.FA_percent_new, 'String', num2str(round((FAcount_new)/(FAcount_new + CRcount_new)*100)));
                    set(h.CR_percent_new, 'String', num2str(round((CRcount_new)/(CRcount_new + FAcount_new)*100)));
                    set(h.CR_number_new, 'String', CRcount_new);
            end
        case 6 % miss (MI) for probes
            
            MIcount_probe = MIcount_probe + 1; 
            set(h.probe_miss, 'String', num2str(round((MIcount_probe)/(MIcount_probe+HIcount_probe)*100)));
            set(h.probe_hit, 'String', num2str(round((HIcount_probe)/(MIcount_probe+HIcount_probe)*100)));
            set(h.probe_miss_num, 'String', num2str(MIcount_probe));
        case 7 % CR for distracters
           
            CRcount_dis = CRcount_dis + 1;
            set(h.dis_CR, 'String', num2str(round((CRcount_dis/(CRcount_dis + FAcount_dis))*100)));
            set(h.dis_FA, 'String', num2str(round((FAcount_dis/(CRcount_dis + FAcount_dis))*100)));
            set(h.dis_CR_num, 'String', num2str(CRcount_dis));   
        case 8  % hit for probes
            
            if strcmp(h.probeTimer.running, 'on') % first lick after GO
                HIcount_probe = HIcount_probe + 1;
                set(h.probe_hit, 'String', num2str(round((HIcount_probe)/(HIcount_probe + MIcount_probe)*100)));
                set(h.probe_miss, 'String', num2str(round((MIcount_probe)/(HIcount_probe + MIcount_probe)*100)));
                set(h.probe_hit_num, 'String', HIcount_probe);
            end   
            stop(h.probeTimer); 
        case 9 %FA for distracters
         
            if strcmp(h.disTimer.running, 'on') % first lick after NO-GO
                FAcount_dis =FAcount_dis + 1;
                set(h.dis_FA, 'String', num2str(round((FAcount_dis)/(FAcount_dis+CRcount_dis)*100)));
                set(h.dis_CR, 'String', num2str(round((CRcount_dis)/(FAcount_dis+CRcount_dis)*100)));
                 set(h.dis_FA_num, 'String', FAcount_dis);
            end
            stop(h.disTimer); 

    end
    
%             CR_percentage_new = str2double(get(h.CR_percent_new, 'String'));
%             CR_percentage_overall = str2double(get(h.correctRejPercent_txt, 'String'));
%             CR_num_new = str2double(get(h.CRNo_txt, 'String'));
%             CR_num_overall = str2double(get(h.CR_number_new, 'String'));
            
            setappdata(0, 'CR_percent_new', round((CRcount_new)/(CRcount_new + FAcount_new)*100));
            setappdata(0, 'CR_percent_overall', round((CRcount/(CRcount + FAcount))*100));
            setappdata(0, 'CR_num_new', CRcount_new);
            setappdata(0, 'CR_num_overall', CRcount);
end
set(h.event_list, 'String', char(eventLog.str));
guidata(guiH, h);
