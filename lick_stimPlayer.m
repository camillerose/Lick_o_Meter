function [events, lastStim] = lick_stimPlayer(audio_out, rewardList, punishList, probeList, distracterList, probePercent, targetPercent, numStim, guiH)

global startTime
persistent allRand tRand fRand i1 i2 i3 i4 i5 numTarget
h = guidata(guiH);

if isempty(allRand)
    i1 = 1;
    i2 = 1; 
    i3 = 1; 
    i4 = 1;
    i5 = 1;
    numTarget = round(targetPercent/100 * numStim);
    numProbe = round(probePercent/100 * numStim);
    allRand = randperm(numStim); 
    tRand = randperm(length(rewardList)); 
    fRand = randperm(length(punishList)); 
end

CR_per_new = getappdata(0, 'CR_percent_new');
CR_per_overall = getappdata(0, 'CR_percent_overall');
CR_num_new = getappdata(0, 'CR_num_new');
CR_num_overall = getappdata(0, 'CR_num_overall');

disp(CR_per_new)
disp(CR_per_overall)
disp(CR_num_new)
disp(CR_num_overall)

if ~strcmp(CR_per_new, '')&& ~strcmp(CR_per_overall, '') && ~strcmp(CR_num_new, '') && ~strcmp(CR_num_overall, '')
    if CR_per_new >= 80 && CR_per_overall >= 80 && CR_num_new >= 5 && CR_num_overall >= 10
        setappdata(0, 'probe_status', 'play_probes');
    else
        setappdata(0, 'probe_status', 'halt_probes');
    end
else
    setappdata(0, 'probe_status', 'halt_probes');
end
    
    
et = etime(clock, startTime);
et2 = num2str(et);  

probe_status = getappdata(0, 'probe_status');

if ~strcmp(probe_status, 'play_probes')

    if allRand(i1) <= numTarget % play a target stim 
    if i2 == length(rewardList)
        i2 = 0; 
        tRand = randperm(length(rewardList)); 
    end
    i2 = i2+1; 
  
    y = wavread(rewardList{tRand(i2)});
    
    goStimName = rewardList{tRand(i2)};
    if strcmp(goStimName(1:8),'trainNew')
        setappdata(0, 'stimuli', 'new')
    elseif strcmp(goStimName(1:8),'trainOri')
        setappdata(0, 'stimuli', 'orig')
    end
  
    if h.behLatencyR > (length(y)/44100) %indicating a grace period
        newZeros =  zeros(h.behLatencyR*44100,1);
        newData = [y' newZeros'];
        y = newData';
    end
    
    putdata(audio_out, y); 
   
    lastStim = 1;
    sprintf('lastStim equals %d ', lastStim)
    events.type = 'Target stim';
    events.str = [goStimName '@' et2]; 
    set(h.stim_type_txt, 'String', 'GO'); %ct
    events.time = et;
    events.info = char((rewardList{tRand(i2)}));
    
else % play a negative stim
    if i3 >= length(punishList)
        i3 = 0;
        fRand = randperm(length(punishList)); 
    end
    i3 = i3+1;
    y = wavread(punishList{fRand(i3)});
    noGoStimName = punishList{fRand(i3)};
    if strcmp(noGoStimName(1:8),'trainNew')
        setappdata(0, 'stimuli', 'new')
    elseif strcmp(noGoStimName(1:8),'trainOri')
        setappdata(0, 'stimuli', 'orig')
    end
    
    if h.behLatencyP > (length(y)/44100) %indicating a grace period
       newZeros =  zeros(h.behLatencyP*44100,1);
       newData = [y' newZeros'];
       y = newData';
    end
    
    
    putdata(audio_out, y); 

    lastStim = 0;
    sprintf('lastStim equals %d ', lastStim)
    events.type = 'False stim';
    events.str = [noGoStimName '@' et2]; 
    set(h.stim_type_txt, 'String', 'NO-GO')%CT
    events.time = et; 
    events.info = char((punishList{fRand(i3)}));
    
    
  
    end
end

if strcmp(probe_status, 'play_probes')
   probe_prob = (probePercent/100);
   rand_num = rand(1);
  if rand_num > probe_prob %play a training stimulus
   
    if allRand(i1) <= numTarget % play a target stim 
    if i2 == length(rewardList)
        i2 = 0; 
        tRand = randperm(length(rewardList)); 
    end
    i2 = i2+1; 
  
    y = wavread(rewardList{tRand(i2)});
    
    goStimName = rewardList{tRand(i2)};
    if strcmp(goStimName(1:8),'trainNew')
        setappdata(0, 'stimuli', 'new')
    elseif strcmp(goStimName(1:8),'trainOri')
        setappdata(0, 'stimuli', 'orig')
    end
  
    if h.behLatencyR > (length(y)/44100) %indicating a grace period
        newZeros =  zeros(h.behLatencyR*44100,1);
        newData = [y' newZeros'];
        y = newData';
    end
    
    putdata(audio_out, y); 
   
    lastStim = 1;
    sprintf('lastStim equals %d ', lastStim)
    events.type = 'Target stim';
    events.str = [goStimName '@' et2]; 
    set(h.stim_type_txt, 'String', 'GO'); %ct
    events.time = et;
    events.info = char((rewardList{tRand(i2)}));
    
else % play a negative stim
    if i3 >= length(punishList)
        i3 = 0;
        fRand = randperm(length(punishList)); 
    end
    i3 = i3+1;
    y = wavread(punishList{fRand(i3)});
    noGoStimName = punishList{fRand(i3)};
    if strcmp(noGoStimName(1:8),'trainNew')
        setappdata(0, 'stimuli', 'new')
    elseif strcmp(noGoStimName(1:8),'trainOri')
        setappdata(0, 'stimuli', 'orig')
    end
    
    if h.behLatencyP > (length(y)/44100) %indicating a grace period
       newZeros =  zeros(h.behLatencyP*44100,1);
       newData = [y' newZeros'];
       y = newData';
    end
    
    
    putdata(audio_out, y); 

    lastStim = 0;
    sprintf('lastStim equals %d ', lastStim)
    events.type = 'False stim';
    events.str = [noGoStimName '@' et2]; 
    set(h.stim_type_txt, 'String', 'NO-GO')%CT
    events.time = et; 
    events.info = char((punishList{fRand(i3)}));
    
    end
    
  elseif rand_num <= probe_prob %play either probe or distracter stimulus

    rand_num2 = rand(1);
    if rand_num2 >= .5;
        if i4 == length(probeList)
            i4 = 0; 
            pRand = randperm(length(probeList)); 
        end
        i4 = i4+1; 
  
        y = wavread(probeList{pRand(i4)});
        probeStimName = probeList{pRand(i4)};
        setappdata(0, 'stimuli', 'probe')
    
        if h.behLatencyR > (length(y)/44100) %indicating a grace period
            newZeros =  zeros(h.behLatencyR*44100,1);
            newData = [y' newZeros'];
            y = newData';
        end
    
        putdata(audio_out, y); 
   
        lastStim = 2;
        sprintf('lastStim equals %d ', lastStim)
        events.type = 'Probe stim';
        events.str = [probeStimName '@' et2]; 
        set(h.stim_type_txt, 'String', 'PROBE'); %ct
        events.time = et;
        events.info = char((probeList{pRand(i4)}));
    else
        if i5 == length(distracterList)
            i5 = 0; 
            dRand = randperm(length(distracterList)); 
        end
        i5 = i5+1; 
  
        y = wavread(distracterList{dRand(i5)});
        distracterStimName = distracterList{dRand(i5)};
        setappdata(0, 'stimuli', 'distracter')
    
        if h.behLatencyP > (length(y)/44100) %indicating a grace period
            newZeros =  zeros(h.behLatencyP*44100,1);
            newData = [y' newZeros'];
            y = newData';
        end
    
        putdata(audio_out, y); 
   
        lastStim = 3;
        sprintf('lastStim equals %d ', lastStim)
        events.type = 'Distracter stim';
        events.str = [distracterStimName '@' et2]; 
        set(h.stim_type_txt, 'String', 'DIS'); %ct
        events.time = et;
        events.info = char((distracterList{dRand(i4)}));
    end
  end
end
i1 = i1+1;

if strcmp(audio_out.Running, 'Off')
    start(audio_out); % when audio out ends, jump into newStimTimer(stop fcn)
end 

clear y

