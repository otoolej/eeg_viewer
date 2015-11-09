%---------------------------------------------------------------------
% test signal
%---------------------------------------------------------------------
Fs = 64;                     % sampling rate
mins = 60*Fs;
x = rand(9,3*mins).*rand(9,3*mins).*(100);         % 9-channels of 10 minute data
channel_labels = {'F3','F4','C3','C4','Cz','T3','T4','O1','O2'};

%---------------------------------------------------------------------
% bring up plot figure
%---------------------------------------------------------------------
eeg_plotgui_withannos('signals',x, ...
                      'fs',Fs, ...
                      'channel_labels',channel_labels, ...
                      'epoch_length',mins./60, ...
                      'insert_ta_scale',1 ...
                      );

%---------------------------------------------------------------------
% use left/right arrows to scroll and up/down arrows to change 
% amplitude scale
%---------------------------------------------------------------------

