function pump = makePump

% Create digital i/o object for lickometer, house lights, air puff systems 
d = digitalio('nidaq', 'Dev1');
%handles.d = d;

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

pump

end