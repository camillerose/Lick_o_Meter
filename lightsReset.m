    
function lightsReset(obj, eventdata, guiH)
h = guidata(guiH); 
punish(h.darkTimer, h.latencyP, guiH, 0); 