function varargout = highlight_channels(varargin)
% HIGHLIGHT_CHANNELS MATLAB code for highlight_channels.fig
%      HIGHLIGHT_CHANNELS, by itself, creates a new HIGHLIGHT_CHANNELS or raises the existing
%      singleton*.
%
%      H = HIGHLIGHT_CHANNELS returns the handle to a new HIGHLIGHT_CHANNELS or the handle to
%      the existing singleton*.
%
%      HIGHLIGHT_CHANNELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIGHLIGHT_CHANNELS.M with the given input arguments.
%
%      HIGHLIGHT_CHANNELS('Property','Value',...) creates a new HIGHLIGHT_CHANNELS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before highlight_channels_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to highlight_channels_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help highlight_channels

% Last Modified by GUIDE v2.5 08-Jan-2014 16:36:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @highlight_channels_OpeningFcn, ...
                   'gui_OutputFcn',  @highlight_channels_OutputFcn, ...
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

% --- Executes just before highlight_channels is made visible.
function highlight_channels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to highlight_channels (see VARARGIN)

% Choose default command line output for highlight_channels
handles.output = hObject;


%---------------------------------------------------------------------
% PARSE input arguments and pass the 'handles' structure
%---------------------------------------------------------------------
inarg_options=struct('channel_labels',[],'fs',[],'parent_handle',[], ...
                     'highlight_channels',[]);

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
handles.channel_labels=inarg_options.channel_labels; 
handles.parent_handle=inarg_options.parent_handle;
already_highlighted=inarg_options.highlight_channels;


if( isempty(handles.channel_labels) )
    handles.channel_labels={'F4-C4','F3-C3','C4-T4','C3-T3','C4-Cz',...
                        'Cz-C3','C4-O2','C3-O1'};  
end
%setappdata(hObject,'channel_labels',channel_names);

N_channels=length(handles.channel_labels);
handles.N_channels=N_channels;

for n=1:N_channels
    set(handles.(['rb_channel' num2str(n)]),'String',handles.channel_labels{n});
end
handles.channel_select=zeros(1,N_channels);

hall_channel=findobj('-regexp','Tag','rb_channel*');
hall_channel=hall_channel(end:-1:1);

for n=(N_channels+1):length(hall_channel)
    set(hall_channel(n),'String','--');
    set(hall_channel(n),'Enable','off');
end


% set all radio buttons to zero ....
for n=1:length(hall_channel)
    set(hall_channel(n),'Value',0);
end

% ... or if there should be some already highlighed:
if(~isempty(already_highlighted))
    iones=find( ismember(handles.channel_labels,already_highlighted)==1 );
    for n=1:length(iones)
        set(handles.(['rb_channel' num2str(iones(n))]),'Value',1);
    end
end

        


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes highlight_channels wait for user response (see UIRESUME)
% uiwait(handles.select_channels_gui);




% --- Outputs from this function are returned to the command line.
function varargout = highlight_channels_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% initialize_gui(gcbf, handles, true);


% --- Executes on button press in select_button.
function select_button_Callback(hObject, eventdata, handles)
% hObject    handle to select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% find out which channels were selected:
handles.channel_select=check_which_channels_selected(handles);
guidata(handles.select_channels_gui,handles);

if(~isempty(handles.parent_handle))
    setappdata(handles.parent_handle,'highlight_channels',handles.channel_select);
    
    hReplot_fn=getappdata(handles.parent_handle,'fn_highlight_channels');
    hParent=handles.parent_handle;
    hReplot_fn( hParent );
end



% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for n=1:handles.N_channels
    set(handles.(['rb_channel' num2str(n)]),'Value',0);
end
guidata(handles.select_channels_gui,handles);

if(~isempty(handles.parent_handle))
    setappdata(handles.parent_handle,'highlight_channels',[]);
    
    hReplot_fn=getappdata(handles.parent_handle,'fn_highlight_channels');
    hParent=handles.parent_handle;
    hReplot_fn( hParent );
end

    

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.channel_select=check_which_channels_selected(handles);
guidata(handles.select_channels_gui,handles);

if(~isempty(handles.parent_handle))
    setappdata(handles.parent_handle,'highlight_channels',handles.channel_select);
    
    hReplot_fn=getappdata(handles.parent_handle,'fn_highlight_channels');
    hParent=handles.parent_handle;
    hReplot_fn( hParent );
end

delete(handles.select_channels_gui);


% --- Executes on button press in rb_channel1.
function rb_channel1_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel1


% --- Executes on button press in rb_channel2.
function rb_channel2_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel2


% --- Executes on button press in rb_channel3.
function rb_channel3_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel3


% --- Executes on button press in rb_channel4.
function rb_channel4_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel4


% --- Executes on button press in rb_channel5.
function rb_channel5_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel5


% --- Executes on button press in rb_channel6.
function rb_channel6_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel6


% --- Executes on button press in rb_channel7.
function rb_channel7_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel7


% --- Executes on button press in rb_channel8.
function rb_channel8_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel8



function channel_select_labels=check_which_channels_selected(handles)
%---------------------------------------------------------------------
% get all the values from the radio buttons:
%---------------------------------------------------------------------
channel_select=zeros(1,handles.N_channels);

for n=1:handles.N_channels
     channel_select(n)=get(handles.(['rb_channel' num2str(n)]),'Value');
end

iones=find(channel_select==1);
if(~isempty(iones))
    for n=1:length(iones)
        channel_select_labels{n}=handles.channel_labels{iones(n)};
    end
else
    channel_select_labels=[];
end



% --- Executes on button press in rb_channel9.
function rb_channel9_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel9


% --- Executes on button press in rb_channel10.
function rb_channel10_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel10


% --- Executes on button press in rb_channel11.
function rb_channel11_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel11


% --- Executes on button press in rb_channel12.
function rb_channel12_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel12


% --- Executes on button press in rb_channel13.
function rb_channel13_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel13


% --- Executes on button press in rb_channel14.
function rb_channel14_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel14


% --- Executes on button press in rb_channel15.
function rb_channel15_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel15


% --- Executes on button press in rb_channel16.
function rb_channel16_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel16


% --- Executes on button press in rb_channel17.
function rb_channel17_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel17


% --- Executes on button press in rb_channel18.
function rb_channel18_Callback(hObject, eventdata, handles)
% hObject    handle to rb_channel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_channel18
