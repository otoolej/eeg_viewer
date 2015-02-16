function varargout = eeg_plotgui_withannos(varargin)
% EEG_PLOTGUI_WITHANNOS MATLAB code for eeg_plotgui_withannos.fig
%      EEG_PLOTGUI_WITHANNOS, by itself, creates a new EEG_PLOTGUI_WITHANNOS or raises the existing
%      singleton*.
%
%      H = EEG_PLOTGUI_WITHANNOS returns the handle to a new EEG_PLOTGUI_WITHANNOS or the handle to
%      the existing singleton*.
%
%      EEG_PLOTGUI_WITHANNOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEG_PLOTGUI_WITHANNOS.M with the given input arguments.
%
%      EEG_PLOTGUI_WITHANNOS('Property','Value',...) creates a new EEG_PLOTGUI_WITHANNOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eeg_plotgui_withannos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eeg_plotgui_withannos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%
% $$$ inarg_options=struct('signals',[],'fs',[],'annotations',[], ...
% $$$                      'channel_labels',[],'amplitude_scale',300, ...
% $$$                      'hard_limit_voltage',[],'highlight_channel',[],...
% $$$                      'bipolar_montage',1,'message_string',[],...
% $$$                      'full_screen',0,'lpf_cutoff',0,'hpf_cutoff',0,...
% $$$                      'annotation_labels',[],'epoch_length',[]);


% Edit the above text to modify the response to help eeg_plotgui_withannos

% Last Modified by GUIDE v2.5 08-Jan-2014 15:16:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eeg_plotgui_withannos_OpeningFcn, ...
                   'gui_OutputFcn',  @eeg_plotgui_withannos_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eeg_plotgui_withannos is made visible.
function eeg_plotgui_withannos_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eeg_plotgui_withannos (see VARARGIN)

% Choose default command line output for eeg_plotgui_withannos
handles.output = hObject;

%---------------------------------------------------------------------
% PARSE input arguments and pass the 'handles' structure
%---------------------------------------------------------------------
inarg_options=struct('signals',[],'fs',[],'annotations',[], ...
                     'channel_labels',[],'amplitude_scale',300, ...
                     'hard_limit_voltage',[],'highlight_channel_bi',[],...
                     'highlight_channel_mono',[],...
                     'bipolar_montage',1,'message_string',[],...
                     'full_screen',0,'lpf_cutoff',0,'hpf_cutoff',0,...
                     'annotation_labels',[],'epoch_length',[], ...
                     'mask',[],'parent_handle',[]);

%# read the acceptable names
inarg_option_names=fieldnames(inarg_options);

%# count arguments
nArgs=length(varargin);
if(round(nArgs/2)~=nArgs/2)
   error('Input arguments need propertyName:propertyValue pairs')
end

for pair=reshape(varargin,2,[]) %# pair is {propName;propValue}
   inpName=lower(pair{1}); 

   if( any(strmatch(inpName,inarg_option_names)) )
      inarg_options.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName);
   end
end

% pass the default values to the 'handles' structure:
handles.sig=inarg_options.signals; 
handles.Fs=inarg_options.fs;
handles.annos=inarg_options.annotations;
handles.channel_labs=inarg_options.channel_labels; 
handles.amplitude_scale=inarg_options.amplitude_scale;
handles.HARD_LIMIT_VOLT=inarg_options.hard_limit_voltage; 
handles.highlight_chan_bi=inarg_options.highlight_channel_bi;
handles.highlight_chan_mono=inarg_options.highlight_channel_mono;
handles.bipolar=inarg_options.bipolar_montage; 
handles.message_str=inarg_options.message_string;
handles.full_screen=inarg_options.full_screen;
handles.lfp_fc=inarg_options.lpf_cutoff; 
handles.hfp_fc=inarg_options.hpf_cutoff;
handles.annos_labels=inarg_options.annotation_labels;
if(~isempty(inarg_options.epoch_length))
    handles.x_limit(1)=0; handles.x_limit(2)=inarg_options.epoch_length;
else
    handles.x_limit=[];
end
handles.hObject_labels=[];
handles.fill_area_xpos=[];
handles.mask=inarg_options.mask;
handles.open_win_HC=[];
handles.parent_handle=inarg_options.parent_handle;



% keep backup of data (for filtering later, if needed):
handles.sig_original=handles.sig;


% message (if any)
if(~isempty(handles.message_str))
  info_handle=findobj(hObject,'Tag','info_panel');
  set(info_handle,'String',handles.message_str);
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eeg_plotgui_withannos wait for user response (see UIRESUME)
% uiwait(handles.eeg_plotgui);

% do the plot on initialize:
cla(handles.plot_axes);

eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale, ...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan_bi, ...
           handles.highlight_chan_mono,handles.x_limit,handles.bipolar);

% plot the annotations (on top of EEG plot) and link to EEG axis:
% $$$ keyboard;
if(~isempty(handles.annos))
    cla(handles.anno_axis);    
    eplot_annos(handles.annos,handles.anno_axis,handles.Fs,handles.annos_labels);
    linkaxes([handles.plot_axes,handles.anno_axis],'x');
else
    set(handles.anno_axis,'Visible','off');
   
    p=get(handles.plot_axes,'Position');
    set(handles.plot_axes,'Position',[p(1:3) 0.85]);
end

% plot the user-specificed 'mask', i.e annotations (over the EEG plot):
if(~isempty(handles.mask))
    hold on;    
    for n=1:length(handles.mask)
        ipos=sort(handles.mask{n});

        h=fill([ipos(1) ipos(1) ipos(2) ipos(2)], ...
               [ylim(handles.plot_axes)  fliplr(ylim(handles.plot_axes))], ...
               [0.8984 0.8984 0.9792], 'EdgeColor', 'none' );

        set(h,'ButtonDownFcn',@remove_fill_area);
        uistack(h,'bottom');


        L_hl=length(handles.hObject_labels);
        handles.hObject_labels{L_hl+1}=h;
    end
    guidata(hObject,handles);
    hold off;
end

handles.output=[handles.plot_axes handles.anno_axis];


handles.x_limit=get(handles.plot_axes,'xlim');

guidata(hObject, handles);


%---------------------------------------------------------------------
% Update the values on the GUI:
%---------------------------------------------------------------------
montage_handle=findobj(hObject,'Tag','montage_list');
contents=cellstr(get(montage_handle,'String'));

if(handles.bipolar==1)
  ivalue=find( strcmp(contents(:),'bipolar')==1 );
  set(montage_handle,'Value',ivalue);
elseif(handles.bipolar==2)
  ivalue=find( strcmp(contents(:),'bipolar hems')==1 );
  set(montage_handle,'Value',ivalue);
else
  ivalue=find( strcmp(contents(:),'monopolar')==1 );
  set(montage_handle,'Value',ivalue);
end


amp_handle=findobj(hObject,'Tag','amplitude_scale');
str=get(amp_handle,'String');
[~,istr]=min(abs( cellfun(@str2num,str) - handles.amplitude_scale ));
if(~isempty(istr))
    set(amp_handle,'Value',istr);
end

length_epoch=floor(handles.x_limit(2)-handles.x_limit(1));

time_handle=findobj(hObject,'Tag','time_scale');
str=get(time_handle,'String');
[~,istr]=min(abs( cellfun(@str2num,str) - length_epoch ));
if(~isempty(istr))
    set(time_handle,'Value',istr);
end
epoch_handle=findobj(hObject,'Tag','epoch_size');
set(epoch_handle,'String',num2str(length_epoch));



%---------------------------------------------------------------------
% full-size ?
%---------------------------------------------------------------------
if(handles.full_screen)
% $$$   scrsz = get(0,'ScreenSize');
% $$$   set(hObject,'Position',[1 1 scrsz(3) scrsz(4)]); 
  set(hObject,'Units','normalized','position',[0,0,1,0.7]);
end





% --- Outputs from this function are returned to the command line.
function varargout = eeg_plotgui_withannos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% $$$ varargout{2}=hObject; %handles.eeg_plotgui;

% --- Executes on button press in replot_data.
function replot_data_Callback(hObject, eventdata, handles)
% hObject    handle to replot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
replot_data(handles);


% --- Executes on selection change in amplitude_scale.
function amplitude_scale_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
str = get(hObject, 'String');
handles.amplitude_scale=str2num(str{val});
% Hints: contents = cellstr(get(hObject,'String')) returns amplitude_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from amplitude_scale
redraw_eeg(handles);




% --- Executes during object creation, after setting all properties.
function amplitude_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in back_scroll.
function back_scroll_Callback(hObject, eventdata, handles)
% hObject    handle to back_scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.x_limit=handles.x_limit-5;
set(handles.plot_axes,'xlim',handles.x_limit);
guidata(handles.eeg_plotgui,handles);



function epoch_size_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epoch_size as text
%        str2double(get(hObject,'String')) returns contents of epoch_size as a double

L_epoch=str2double( get(hObject,'String') );
handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];

set(handles.plot_axes,'xlim',handles.x_limit);
guidata(handles.eeg_plotgui,handles);




% --- Executes during object creation, after setting all properties.
function epoch_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in forward_scroll.
function forward_scroll_Callback(hObject, eventdata, handles)
% hObject    handle to forward_scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.x_limit=handles.x_limit+5;
set(handles.plot_axes,'xlim',handles.x_limit);
guidata(handles.eeg_plotgui,handles);



% --- Executes on key press with focus on amplitude_scale and none of its controls.
function amplitude_scale_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on eeg_plotgui and none of its controls.
function eeg_plotgui_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to eeg_plotgui (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if( strcmp(eventdata.Key,'uparrow')==1 )
  amp_handle=findobj(gcbf,'Tag','amplitude_scale');

  val=get(amp_handle,'Value');
  str=get(amp_handle, 'String');
  val=val-1;
  if(val<1), val=1; end
  set(amp_handle,'Value',val);  
  
  % and replot with new amplitude value:
  handles.amplitude_scale=str2num(str{val});
  guidata(hObject,handles);

  redraw_eeg(handles);

elseif( strcmp(eventdata.Key,'downarrow')==1 )
  amp_handle=findobj(gcbf,'Tag','amplitude_scale');

  val=get(amp_handle,'Value');
  str=get(amp_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=L; end
  set(amp_handle,'Value',val);  
  
  % and replot with new amplitude value:
  handles.amplitude_scale=str2num(str{val});
  guidata(hObject,handles);
  
  redraw_eeg(handles);
  
  
% CHANGE montage:
elseif( strcmp(eventdata.Key,'m')==1 )
  montage_handle=findobj(gcbf,'Tag','montage_list');

  val=get(montage_handle,'Value');
  str=get(montage_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=1; end
  set(montage_handle,'Value',val);  
  
  
  if(strcmp(str{get(montage_handle,'Value')},'monopolar')==1)
    handles.bipolar=0;
  elseif(strcmp(str{get(montage_handle,'Value')},'bipolar hems')==1)
    handles.bipolar=2;
  else
    handles.bipolar=1;
  end

  redraw_eeg(handles);
  
  
elseif( strcmp(eventdata.Key,'leftarrow')==1 )

  x_length=abs( handles.x_limit(2) - handles.x_limit(1) );
  
  handles.x_limit=handles.x_limit-(x_length*0.1);
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

elseif( strcmp(eventdata.Key,'rightarrow')==1 )

  x_length=abs( handles.x_limit(2) - handles.x_limit(1) );
  
  handles.x_limit=handles.x_limit+(x_length*0.1);
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

  
elseif( strcmp(eventdata.Key,'pagedown')==1 )
    
  x_length=abs( handles.x_limit(2) - handles.x_limit(1) );
  
  handles.x_limit=handles.x_limit+(x_length*0.8);
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

elseif( strcmp(eventdata.Key,'pageup')==1 )
    
  x_length=abs( handles.x_limit(2) - handles.x_limit(1) );
  
  handles.x_limit=handles.x_limit-(x_length*0.8);
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

elseif( strcmp(eventdata.Key,'i')==1 )  

    [p1,p2]=ginput(2);

    hold on;    
    h=fill([p1(1) p1(1) p1(2) p1(2)], ...
           [ylim(handles.plot_axes)  fliplr(ylim(handles.plot_axes))], ...
           [0.8984 0.8984 0.9792], 'EdgeColor', 'none' );

    set(h,'ButtonDownFcn',@remove_fill_area);
    uistack(h,'bottom');


    L_hl=length(handles.hObject_labels);
    handles.hObject_labels{L_hl+1}=h;
    guidata(hObject,handles);
    hold off;
    
elseif( strcmp(eventdata.Key,'v')==1 )  

    [x1,y1]=ginput(1);
    hold on;            
    h1=plot(x1,y1,'k+','markersize',8,'linewidth',2);
    [x2,y2]=ginput(1);
    xx=[x1 x2]; yy=[y1 y2];
    delete(h1);
    
    a_scale=handles.amplitude_scale;

    xl=xlim; xl=abs(xl(2)-xl(1));
    line([xx(2),xx(2)],[yy(1),yy(2)],'color','k','linewidth',2);
    line([xx(2),xx(2)+2],[min(yy),min(yy)],'color','k','linewidth',2);    
    text(xx(2)+xl.*0.01,min(yy)+abs(yy(2)-yy(1))./2, ...
         [num2str( round(abs(yy(2)-yy(1)).*(a_scale/100)) ) ' \mu V'],'fontsize',16);

    hold off;
    

elseif( strcmp(eventdata.Key,'d')==1 )  

    L_hl=length(handles.hObject_labels);
    nn=1; label_start_stop=zeros(L_hl,2); buf_str=['{ '];
    Fs=handles.Fs;
    for n=1:L_hl
        if(ishandle(handles.hObject_labels{n}))
            x_pos=get(handles.hObject_labels{n},'XData');
            
            label_start_stop(nn,:)=[x_pos(1) x_pos(3)];
            if(nn>1),  buf_str=[buf_str ','];  end
            buf_str=[buf_str ...
                     sprintf(' [%.6f,%.6f]', x_pos(1),x_pos(3))];            
                
            nn=nn+1;
        end
    end
    buf_str=[buf_str ' };'];
    dispVars(label_start_stop);
    disp(buf_str);
    
    % and copy to clipboard too:
    if(exist('mat2clip','file'))
        mat2clip(buf_str);
    end
  
elseif( strcmp(eventdata.Key,'a')==1 )
  time_handle=findobj(hObject,'Tag','time_scale');

  val=get(time_handle,'Value');
  str=get(time_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=1; end
  set(time_handle,'Value',val);  
  L_epoch=str2double(str{val});
  
  handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];
  set(handles.plot_axes,'xlim',handles.x_limit);

  % and put this number for display in the 'epoch box':
  epoch_handle=findobj(hObject,'Tag','epoch_size');
  set(epoch_handle,'String',num2str(L_epoch));
  guidata(hObject,handles);

  
elseif( strcmp(eventdata.Key,'s')==1 )
  time_handle=findobj(hObject,'Tag','time_scale');

  val=get(time_handle,'Value');
  str=get(time_handle, 'String');
  L=length(str);
  val=val-1;
  if(val<1), val=L; end
  set(time_handle,'Value',val);  
  L_epoch=str2double(str{val});
  
  handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];
  set(handles.plot_axes,'xlim',handles.x_limit);

  % and put this number for display in the 'epoch box':
  epoch_handle=findobj(hObject,'Tag','epoch_size');
  set(epoch_handle,'String',num2str(L_epoch));
  guidata(hObject,handles);
  
  
elseif( strcmp(eventdata.Key,'c')==1 )  
    %---------------------------------------------------------------------
    % call the 'highlight channel' dialog box
    %---------------------------------------------------------------------
    highlight_channels_button_Callback(hObject, [], handles);
    
  
end


% --- Executes on selection change in montage_list.
function montage_list_Callback(hObject, eventdata, handles)
% hObject    handle to montage_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns montage_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from montage_list
contents=cellstr(get(hObject,'String'));
if(strcmp(contents{get(hObject,'Value')},'monopolar')==1)
  handles.bipolar=0;
elseif(strcmp(contents{get(hObject,'Value')},'bipolar hems')==1)
  handles.bipolar=2;
else
  handles.bipolar=1;
end

redraw_eeg(handles);



% --- Executes during object creation, after setting all properties.
function montage_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to montage_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function info_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in time_scale.
function time_scale_Callback(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns time_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from time_scale
contents=cellstr(get(hObject,'String'));
val=contents{get(hObject,'Value')};

L_epoch=str2double(val);

handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];

set(handles.plot_axes,'xlim',handles.x_limit);

% and put this number for display in the 'epoch box':
epoch_handle=findobj(gcbf,'Tag','epoch_size');
set(epoch_handle,'String',num2str(L_epoch));


guidata(gcbf,handles);




% --- Executes during object creation, after setting all properties.
function time_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in HPF_box.
function HPF_box_Callback(hObject, eventdata, handles)
% hObject    handle to HPF_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HPF_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HPF_box
contents=cellstr(get(hObject,'String'));
val=contents{get(hObject,'Value')};


if( strcmp(val,'off')==1 )
    
    handles.sig=handles.sig_original;
    
    handles.hfp_fc=0;
else
    
    fc=str2double(val);
    handles.hfp_fc=fc;
% $$$     dispVars(handles.Fs,handles.lfp_fc,handles.hfp_fc);
    
    L=size(handles.sig,1);

    dispVars(handles.lfp_fc,handles.hfp_fc);

    info_handle=findobj(handles.eeg_plotgui,'Tag','info_panel');
    set(info_handle,'String','filtering.....');
    watchon;
    
    for l=1:L
        handles.sig(l,:)=filter_butter(handles.sig_original(l,:),handles.Fs,...
                                       handles.lfp_fc,handles.hfp_fc,5);
% $$$         handles.sig(l,:)=filter_zerophase(handles.sig_original(l,:), ...
% $$$                                           handles.Fs,handles.lfp_fc,handles.hfp_fc,101);
    end
    watchoff;    
    set(info_handle,'String',handles.message_str);
end

redraw_eeg(handles);


% --- Executes during object creation, after setting all properties.
function HPF_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HPF_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LFP_box.
function LFP_box_Callback(hObject, eventdata, handles)
% hObject    handle to LFP_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LFP_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LFP_box

contents=cellstr(get(hObject,'String'));
val=contents{get(hObject,'Value')};

if( strcmp(val,'off')==1 )
    
    handles.sig=handles.sig_original;
    
    handles.lfp_fc=0;
else
    fc=str2double(val);
    handles.lfp_fc=fc;
    
% $$$     dispVars(handles.Fs,handles.lfp_fc,handles.hfp_fc);    
    info_handle=findobj(handles.eeg_plotgui,'Tag','info_panel');
    set(info_handle,'String','filtering.....');

    
    L=size(handles.sig,1);
    watchon;
    dispVars(handles.lfp_fc,handles.hfp_fc);    
    for l=1:L
        handles.sig(l,:)=filter_butter(handles.sig_original(l,:),handles.Fs,...
                                       handles.lfp_fc,handles.hfp_fc,5);
% $$$         handles.sig(l,:)=filter_zerophase(handles.sig_original(l,:), ...
% $$$                                           handles.Fs,handles.lfp_fc,handles.hfp_fc,1001);
    end
    watchoff;
    set(info_handle,'String',handles.message_str);
end

redraw_eeg(handles);


function remove_fill_area(hObject,event)
%---------------------------------------------------------------------
% Annotating, if clicked remove
%---------------------------------------------------------------------
delete(hObject);



function label_start_stop=save_fill_area_details(handles)
%---------------------------------------------------------------------
% save fill-area objects before updating axis
%---------------------------------------------------------------------

L_hl=length(handles.hObject_labels);
nn=1; label_start_stop=[];
for n=1:L_hl
    if(ishandle(handles.hObject_labels{n}))
        x_pos=get(handles.hObject_labels{n},'XData');
            
        label_start_stop(nn,1:2)=sort([x_pos(1) x_pos(3)]);
        nn=nn+1;
    end
end


function hObject_labels=reinstate_fill_areas(handles)
%---------------------------------------------------------------------
% redraw fill-areas (annotations)
%---------------------------------------------------------------------
hold on;

hObject_labels=[];
for n=1:size(handles.fill_area_xpos,1)
    h=fill([handles.fill_area_xpos(n,1) handles.fill_area_xpos(n,1) ...
            handles.fill_area_xpos(n,2) handles.fill_area_xpos(n,2)], ...
           [ylim(handles.plot_axes)  fliplr(ylim(handles.plot_axes))], ...
           [0.8984 0.8984 0.9792], 'EdgeColor', 'none' );

    set(h,'ButtonDownFcn',@remove_fill_area);
    uistack(h,'bottom');

    hObject_labels{n}=h;
end
hold off;



% --- Executes during object creation, after setting all properties.
function LFP_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LFP_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help_eeg_plotgui;


% --- Executes on button press in highlight_channels_button.
function highlight_channels_button_Callback(hObject, eventdata, handles)
% hObject    handle to highlight_channels_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.eeg_plotgui,'fn_highlight_channels',@highlight_channels_plot);


% get the montage labels:
[REF_MONT,BI_MONT,BI_MONT_LABS,BI_MONT_HEMS]=set_montage(length(handles.channel_labs));
if(handles.bipolar==0)
    channel_labels=REF_MONT;
    already_highlighted=handles.highlight_chan_mono;
else
    channel_labels=BI_MONT_LABS;
    already_highlighted=handles.highlight_chan_bi;    
end



% call the external dialog box:
h=highlight_channels('parent_handle',handles.eeg_plotgui, ...
                     'channel_labels',channel_labels, ...
                     'highlight_channels',already_highlighted);

% grab the handle so can close later (if still open)
handles.open_win_HC=h;
guidata(handles.eeg_plotgui,handles);


% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(~isempty(handles.open_win_HC) && ishandle(handles.open_win_HC))
    close(handles.open_win_HC);
end

if(~isempty(handles.parent_handle))
    setappdata(handles.parent_handle,'highlighted_channels_bi', ...
                             handles.highlight_chan_bi);
    setappdata(handles.parent_handle,'highlighted_channels_mono', ...
                             handles.highlight_chan_mono);
    
    [REF_MONT,BI_MONT,BI_MONT_LABS,BI_MONT_HEMS]=set_montage(length(handles.channel_labs));
    setappdata(handles.parent_handle,'ch_labels_bi',BI_MONT_LABS);
    setappdata(handles.parent_handle,'ch_labels_mono',REF_MONT);    
end


delete(handles.eeg_plotgui);


function highlight_channels_plot(gui_handle)
%---------------------------------------------------------------------
% force highlighing of channels (called from 'highligh_channels.m' )
%---------------------------------------------------------------------

% retrive all data from 'guidata':
handles=guidata(gui_handle);

if(handles.bipolar==0)
    handles.highlight_chan_mono=getappdata(gui_handle,'highlight_channels');
else
    handles.highlight_chan_bi=getappdata(gui_handle,'highlight_channels');
end

guidata(gui_handle,handles);
redraw_eeg(handles);


function redraw_eeg(handles)
%---------------------------------------------------------------------
% replot, according to data set in 'handles'
%---------------------------------------------------------------------

% save state of fill-areas (annotations):
handles.fill_area_xpos=save_fill_area_details(handles);

eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale,...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan_bi,...
           handles.highlight_chan_mono,handles.x_limit,handles.bipolar);

% restore fill-areas
handles.hObject_labels=reinstate_fill_areas(handles);
guidata(handles.eeg_plotgui,handles);


% set focus to plot (for shortcut keys)
% HACK:
% NOT WORKING:
% $$$ axes(handles.plot_axes);
% $$$ set(handles.plot_axes,'Selected','on');

