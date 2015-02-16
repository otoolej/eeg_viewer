%-------------------------------------------------------------------------------
% eeg_plot_channels: simple plot for EEG (many channels)
%
% Syntax: []=eeg_plot_channels(sig,Fs,fignum)
%
% Inputs: 
%     sig,Fs,fignum - 
%
% Outputs: 
%     [] - 
%
% Example:
%     
%

% John M. O' Toole, University of Deusto
% Started: 21-07-2012
%-------------------------------------------------------------------------------
function [hp]=eplot_data(sig,Fs,figaxes,channel_labs,amplitude_scale,HARD_LIMIT_VOLT,...
                         highlight_chan_bi,highlight_chan_mono,x_limit,BIPOLAR)
if(nargin<2 || isempty(Fs)) Fs=1; end
if(nargin<3 || isempty(figaxes)) figaxes=gca; end
if(nargin<4 || isempty(channel_labs)) channel_labs=[]; end
if(nargin<5 || isempty(amplitude_scale)), amplitude_scale=[]; end
if(nargin<6 || isempty(HARD_LIMIT_VOLT)), HARD_LIMIT_VOLT=[]; end
if(nargin<7 || isempty(highlight_chan_bi)), highlight_chan_bi=[]; end
if(nargin<8 || isempty(highlight_chan_mono)), highlight_chan_mono=[]; end
if(nargin<9 || isempty(x_limit)), x_limit=[]; end
if(nargin<10 || isempty(BIPOLAR)), BIPOLAR=1; end


% set axis:
axes(figaxes);


%---------------------------------------------------------------------
% arrange the montage:
%---------------------------------------------------------------------
if(BIPOLAR~=-1)
    [sig,channel_labs]=check_montage(sig,channel_labs,BIPOLAR);
end

    


AMP_SEPARATION=100; % standard amplitude separation;


[M,N]=size(sig);
max_time=N./Fs;


% hardlimit incase large amplitude artefacts:
if(HARD_LIMIT_VOLT>0)
    sig(sig<-HARD_LIMIT_VOLT)=-HARD_LIMIT_VOLT;
    sig(sig>HARD_LIMIT_VOLT)=HARD_LIMIT_VOLT;
end


t=linspace(0,max_time,N);

% $$$   shift=cumsum([0; ones(M-1,1).*amplitude_scale]);
shift_s=cumsum([0; ones(M-1,1).*AMP_SEPARATION]);  
shift = repmat(shift_s,1,N);


if(~isempty(amplitude_scale))
  scaled_data=sig.*(AMP_SEPARATION/amplitude_scale);
else
  scaled_data=sig;
end


% plot 'eeg' data
hp=plot(figaxes,t,scaled_data+shift);
if(isempty(x_limit))
  set(figaxes,'xlim',[t(1),t(end)]);
else
  set(figaxes,'xlim',x_limit);
end


% edit axes
set(figaxes,'ytick',shift_s.','yticklabel',1:M);
set(figaxes,'Xgrid','on');
ylim([min(shift_s)-(AMP_SEPARATION*0.75) max(shift_s)+(AMP_SEPARATION*0.75)])




if(~isempty(channel_labs))
    set(figaxes,'YTickLabel',channel_labs);
end


if(BIPOLAR==1 || BIPOLAR==-1)
  set(hp([1:2:M]),'color',[0.5 0 0]);
  set(hp([2:2:M]),'color',[0 0 0.5]);    
elseif(BIPOLAR==2)
  Mh=floor(M/2);
  set(hp([1:Mh]),'color',[0.5 0 0]);
  set(hp([(Mh+1):M]),'color',[0 0 0.5]);    
elseif(BIPOLAR==0)
  M_c=length(hp);
  Mh=floor(M_c/2);
  set(hp([2:Mh]),'color',[.0 0 0.5]);
  set(hp([(Mh+1):M_c]),'color',[0.5 0 0]);    
  set(hp([1]),'color',[0.5 0 0]);      
end


%---------------------------------------------------------------------
% Highlight one channel?
%---------------------------------------------------------------------
if(BIPOLAR>0 && ~isempty(highlight_chan_bi))
    
    for n=1:length(highlight_chan_bi)
        icc=find( strcmp(channel_labs,highlight_chan_bi{n})==1 );
        set(hp(icc),'color',[0 .5 0]);
    end
    
elseif(BIPOLAR==0 && ~isempty(highlight_chan_mono))

    for n=1:length(highlight_chan_mono)
        icc=find( strcmp(channel_labs,[highlight_chan_mono{n} '-Ref'])==1 );
        set(hp(icc),'color',[0 .5 0]);
    end

end


if(strcmp(channel_labs{1},'ECG')==1)
    set(hp(1),'color',[0.6 0.6 0.6]);
end

%---------------------------------------------------------------------
% Plot gird lines at 1 second intervals
%---------------------------------------------------------------------
gridxy([0:N/Fs],'color',[1 1 1].*0.85);





    
