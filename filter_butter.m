%-------------------------------------------------------------------------------
% filter_butter: IIR bandpass filter (zero-phase)
%
% Syntax: y=filter_butter(x,F3db_lowpass,F3db_highpass,order)
%
% Inputs: 
%     x,F3db_lowpass,F3db_highpass,order - 
%
% Outputs: 
%     y - 
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 07-10-2013
%-------------------------------------------------------------------------------
function y=filter_butter(x,Fs,F3db_lowpass,F3db_highpass,order)
if(nargin<2 || isempty(Fs)), Fs=1; end
if(nargin<3 || isempty(F3db_lowpass) || F3db_lowpass==0), F3db_lowpass=[]; end
if(nargin<4 || isempty(F3db_highpass) || F3db_highpass==0), F3db_highpass=[]; end
if(nargin<5 || isempty(order)), order=18; end

DB=0;

% check values:
if(F3db_lowpass<=0 | F3db_lowpass>=(Fs/2) | ...
   F3db_highpass<=0 | F3db_highpass>=(Fs/2))
    disp('invalid filter value; ignoring');
    y=x;
    return;
end

if(F3db_lowpass==0),  F3db_lowpass=[];  end
if(F3db_highpass==0), F3db_highpass=[]; end


% $$$ dispVars(F3db_highpass,F3db_lowpass,order,order*2+1);
if(isempty(F3db_highpass))
    h=fdesign.lowpass('N,F3dB',order*2+1,F3db_lowpass,Fs);
    
elseif(isempty(F3db_lowpass))
    h=fdesign.highpass('N,F3dB',order,F3db_highpass,Fs);
    
else
    y=filter_butter(x,Fs,F3db_lowpass,[],order*2+1);
    y=filter_butter(y,Fs,[],F3db_highpass,order);    
    return;    
% $$$     h=fdesign.bandpass('N,F3dB1,F3dB2',order,F3db_highpass,F3db_lowpass,Fs);
end


% $$$ [b,a]=butter(order,[F3db_highpass,F3db_lowpass]./(Fs/2));
% $$$ y=filtfilt(b,a,x);
% $$$ fvtool(b,a,'frequencyscale','log');
% $$$ return;

d=design(h,'butter');
y=filtfilt(d.sosMatrix,d.ScaleValues,x);


% $$$ 
% $$$ dispVars(isstable(d.sosMatrix));
% $$$ 
% $$$ [z,p,k]=sos2zp(d.sosMatrix);
% $$$ 
% $$$ [b,a]=residuez(z,p,k);
% $$$ 
% $$$ y=filter(b,a,x);
% $$$ 
% $$$ zplane(z,p);

if(DB)
    fvtool(d,'frequencyscale','log');
    figure(9); clf; hold all;
    plot(1:length(x),x,1:length(x),y);
    legend({'original','filtered'});
end

    
