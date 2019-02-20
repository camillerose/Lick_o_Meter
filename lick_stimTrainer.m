function [events, lastStim] = lick_stimTrainer(audio_out, rewardList, pump,...
    latencyR, guiH)

global startTime
% persistent allRand tRand i2

h = guidata(guiH);

et = etime(clock, startTime);
et2 = num2str(et);

if length(rewardList) == 1
    y = wavread(char(rewardList));
end

if length(rewardList) > 1
    ind = 1; 
    tRand = randperm(length(rewardList));
    y = wavread(rewardList{tRand(ind)});  
end

if h.behLatencyR > (length(y)/44100) %indicating a grace period
   newZeros =  zeros(h.behLatencyR*44100,1);
   newData = [y' newZeros'];
   y = newData';
end
    

putdata(audio_out, y);

lastStim = 1;
events.type = 'Target stim';
events.str = ['Target @ ' et2];
events.time = et;
events.info = rewardList;

if strcmp(audio_out.Running, 'Off')
    start(audio_out);
end

% if ~stimEndReward
%     lick_reward(pump, latencyR, guiH, 0);
% end

clear y