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

function varargout = SemiGloSSConsoleWindow(varargin)
%SEMIGLOSSCONSOLEWINDOW M-file for SemiGloSSConsoleWindow.fig
%      SEMIGLOSSCONSOLEWINDOW, by itself, creates a new SEMIGLOSSCONSOLEWINDOW or raises the existing
%      singleton*.
%
%      H = SEMIGLOSSCONSOLEWINDOW returns the handle to a new SEMIGLOSSCONSOLEWINDOW or the handle to
%      the existing singleton*.
%
%      SEMIGLOSSCONSOLEWINDOW('Property','Value',...) creates a new SEMIGLOSSCONSOLEWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SemiGloSSConsoleWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SEMIGLOSSCONSOLEWINDOW('CALLBACK') and SEMIGLOSSCONSOLEWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SEMIGLOSSCONSOLEWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SemiGloSSConsoleWindow

% Last Modified by GUIDE v2.5 24-Jul-2007 17:58:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SemiGloSSConsoleWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @SemiGloSSConsoleWindow_OutputFcn, ...
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


% --- Executes just before SemiGloSSConsoleWindow is made visible.
function SemiGloSSConsoleWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for SemiGloSSConsoleWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the GUI type in the GUIData system.
setGUIData('SemiGloSSConsoleWindow', hObject);
setGUIData('SemiGloSSConsoleType', 'SemiGloSSConsoleWindow');
updateSemiGloSSBackground(hObject);

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject)

% UIWAIT makes SemiGloSSConsoleWindow wait for user response (see UIRESUME)
% uiwait(handles.SemiGloSSConsoleWindow);


% --- Outputs from this function are returned to the command line.
function varargout = SemiGloSSConsoleWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Tracks.
function Tracks_Callback(hObject, eventdata, handles)
% hObject    handle to Tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setQubistView(1);


% --- Executes on button press in CPDPlot.
function CPDPlot_Callback(hObject, eventdata, handles)
% hObject    handle to CPDPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setQubistView(2);


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startSemiGloSS.
function startSemiGloSS_Callback(hObject, eventdata, handles)
% hObject    handle to startSemiGloSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startQubistRun;


% --- Executes on button press in abortSemiGloSS.
function abortSemiGloSS_Callback(hObject, eventdata, handles)
% hObject    handle to abortSemiGloSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortSemiGloSS;


% --- Executes on button press in pauseSemiGloSS.
function pauseSemiGloSS_Callback(hObject, eventdata, handles)
% hObject    handle to pauseSemiGloSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pauseSemiGloSS;


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PolishedSolutions
setGUIData('PolishedSolutions',PolishedSolutions);
plotSemiGloSSResults;

