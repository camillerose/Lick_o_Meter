function event = lick_retract(pump, latencyR, guiH, manualCall)

%Retracts reward
global startTime

    et = etime(clock, startTime);
    et2 = num2str(et);
    event.time = et;
    if manualCall
        event.type = 'Retract, manual'; 
        event.str = ['Retract, manual @ ' et2];
      else
        event.type = 'Retract';
        event.str = ['Retract @ ' et2];
    end
        logEvents(guiH, event);
        query(pump, 'DIR WDR'); 
        fprintf(pump, 'RUN');
        query(pump, 'DIR WDR'); 
        fprintf(pump, 'RUN'); 
        query(pump, 'DIR WDR'); 
        fprintf(pump, 'RUN');
end