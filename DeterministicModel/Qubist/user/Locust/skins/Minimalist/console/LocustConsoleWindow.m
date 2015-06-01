%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function varargout = LocustConsoleWindow(varargin)
%LOCUSTCONSOLEWINDOW M-file for LocustConsoleWindow.fig
%      LOCUSTCONSOLEWINDOW, by itself, creates a new LOCUSTCONSOLEWINDOW or raises the existing
%      singleton*.
%
%      H = LOCUSTCONSOLEWINDOW returns the handle to a new LOCUSTCONSOLEWINDOW or the handle to
%      the existing singleton*.
%
%      LOCUSTCONSOLEWINDOW('Property','Value',...) creates a new LOCUSTCONSOLEWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LocustConsoleWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LOCUSTCONSOLEWINDOW('CALLBACK') and LOCUSTCONSOLEWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LOCUSTCONSOLEWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LocustConsoleWindow

% Last Modified by GUIDE v2.5 13-Mar-2008 03:28:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LocustConsoleWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @LocustConsoleWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before LocustConsoleWindow is made visible.
function LocustConsoleWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for LocustConsoleWindow
handles.output = hObject;

% update handles structure
guidata(hObject, handles);

% Drop boxes don't work well on Macs.
% comp=computer;
% if ~isempty([strfind(comp, 'MAC'), strfind(comp, 'GLNX')])
%     set(handles.plotSelect, 'Visible', 'off');
%     set(handles.plotSelectExternal, 'Visible', 'on');
% end

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject);

% Set the GUI type in the GUIData system.
setGUIData('LocustConsoleWindow', hObject);
updateLocustBackground(hObject, '', true);

% UIWAIT makes LocustConsoleWindow wait for user response (see UIRESUME)
% uiwait(handles.LocustConsoleWindow);


% --- Outputs from this function are returned to the command line.
function varargout = LocustConsoleWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startLocust.
function startLocust_Callback(hObject, eventdata, handles)
% hObject    handle to startLocust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startQubistRun;


% --- Executes on button press in abortLocust.
function abortLocust_Callback(hObject, eventdata, handles)
% hObject    handle to abortLocust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortLocust;


% --- Executes on button press in pauseLocust.
function pauseLocust_Callback(hObject, eventdata, handles)
% hObject    handle to pauseLocust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pauseLocust;


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotLocustResults;


% --- Executes on button press in analyze.
function analyze_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analyzeHistoryHandler(true);

% --- Executes on button press in freeze.
function freeze_Callback(hObject, eventdata, handles)
% hObject    handle to freeze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state=getGUIData('graphics');
if state == 1
    setGUIData('graphics', 0);
    set(hObject, 'String', 'Unfreeze Plot');
else
    setGUIData('graphics', 1);
    set(hObject, 'String', 'Freeze Plot');
end


% --- Executes on button press in statusButton.
function statusButton_Callback(hObject, eventdata, handles)
% hObject    handle to statusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statusButton


