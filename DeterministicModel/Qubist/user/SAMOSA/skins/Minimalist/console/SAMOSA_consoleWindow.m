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

function varargout = SAMOSA_consoleWindow(varargin)
%SAMOSA_CONSOLEWINDOW M-file for SAMOSA_consoleWindow.fig
%      SAMOSA_CONSOLEWINDOW, by itself, creates a new SAMOSA_CONSOLEWINDOW or raises the existing
%      singleton*.
%
%      H = SAMOSA_CONSOLEWINDOW returns the handle to a new SAMOSA_CONSOLEWINDOW or the handle to
%      the existing singleton*.
%
%      SAMOSA_CONSOLEWINDOW('Property','Value',...) creates a new SAMOSA_CONSOLEWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SAMOSA_consoleWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SAMOSA_CONSOLEWINDOW('CALLBACK') and SAMOSA_CONSOLEWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SAMOSA_CONSOLEWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAMOSA_consoleWindow

% Last Modified by GUIDE v2.5 19-Apr-2009 04:06:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAMOSA_consoleWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @SAMOSA_consoleWindow_OutputFcn, ...
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


% --- Executes just before SAMOSA_consoleWindow is made visible.
function SAMOSA_consoleWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for SAMOSA_consoleWindow
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
setGUIData('SAMOSA_consoleWindow', hObject);
updateSAMOSA_background(hObject, '', true);

% UIWAIT makes SAMOSA_consoleWindow wait for user response (see UIRESUME)
% uiwait(handles.SAMOSA_consoleWindow);


% --- Outputs from this function are returned to the command line.
function varargout = SAMOSA_consoleWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startSAMOSA.
function startSAMOSA_Callback(hObject, eventdata, handles)
% hObject    handle to startSAMOSA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startQubistRun;


% --- Executes on button press in abortSAMOSA.
function abortSAMOSA_Callback(hObject, eventdata, handles)
% hObject    handle to abortSAMOSA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortSAMOSA;


% --- Executes on button press in pauseSAMOSA.
function pauseSAMOSA_Callback(hObject, eventdata, handles)
% hObject    handle to pauseSAMOSA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pauseSAMOSA;

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
