function varargout = help_eeg_plotgui(varargin)
% HELP_EEG_PLOTGUI MATLAB code for help_eeg_plotgui.fig
%      HELP_EEG_PLOTGUI, by itself, creates a new HELP_EEG_PLOTGUI or raises the existing
%      singleton*.
%
%      H = HELP_EEG_PLOTGUI returns the handle to a new HELP_EEG_PLOTGUI or the handle to
%      the existing singleton*.
%
%      HELP_EEG_PLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELP_EEG_PLOTGUI.M with the given input arguments.
%
%      HELP_EEG_PLOTGUI('Property','Value',...) creates a new HELP_EEG_PLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before help_eeg_plotgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to help_eeg_plotgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help help_eeg_plotgui

% Last Modified by GUIDE v2.5 08-Jan-2014 12:19:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @help_eeg_plotgui_OpeningFcn, ...
                   'gui_OutputFcn',  @help_eeg_plotgui_OutputFcn, ...
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


% --- Executes just before help_eeg_plotgui is made visible.
function help_eeg_plotgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to help_eeg_plotgui (see VARARGIN)

% Choose default command line output for help_eeg_plotgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes help_eeg_plotgui wait for user response (see UIRESUME)
% uiwait(handles.help_gui);


% --- Outputs from this function are returned to the command line.
function varargout = help_eeg_plotgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.help_gui);

% --- Executes on key press with focus on close_button and none of its controls.
function close_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
