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

function varargout = FerretConsoleWindowNoGraphics(varargin)
%FERRETCONSOLEWINDOWNOGRAPHICS M-file for FerretConsoleWindowNoGraphics.fig
%      FERRETCONSOLEWINDOWNOGRAPHICS, by itself, creates a new FERRETCONSOLEWINDOWNOGRAPHICS or raises the existing
%      singleton*.
%
%      H = FERRETCONSOLEWINDOWNOGRAPHICS returns the handle to a new FERRETCONSOLEWINDOWNOGRAPHICS or the handle to
%      the existing singleton*.
%
%      FERRETCONSOLEWINDOWNOGRAPHICS('Property','Value',...) creates a new FERRETCONSOLEWINDOWNOGRAPHICS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to FerretConsoleWindowNoGraphics_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FERRETCONSOLEWINDOWNOGRAPHICS('CALLBACK') and FERRETCONSOLEWINDOWNOGRAPHICS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FERRETCONSOLEWINDOWNOGRAPHICS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FerretConsoleWindowNoGraphics

% Last Modified by GUIDE v2.5 30-May-2008 03:17:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FerretConsoleWindowNoGraphics_OpeningFcn, ...
                   'gui_OutputFcn',  @FerretConsoleWindowNoGraphics_OutputFcn, ...
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


% --- Executes just before FerretConsoleWindowNoGraphics is made visible.
function FerretConsoleWindowNoGraphics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for FerretConsoleWindowNoGraphics
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the GUI type in the GUIData system.
setGUIData('FerretConsoleWindow', hObject);
setGUIData('FerretConsoleType', 'FerretConsoleWindowNoGraphics');
updateFerretBackground(hObject);

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject);

% Read the notes pane BEFORE the figure is made visible.
readNotes;

% Window size.
setConsoleWindowSize(hObject, 'noGraphics');

% UIWAIT makes FerretConsoleWindowNoGraphics wait for user response (see UIRESUME)
% uiwait(handles.FerretConsoleWindowNoGraphics);


% --- Outputs from this function are returned to the command line.
function varargout = FerretConsoleWindowNoGraphics_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startFerretRun.
function startFerretRun_Callback(hObject, eventdata, handles)
% hObject    handle to startFerretRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startFerretRun;


% --- Executes on button press in abortFerret.
function abortFerret_Callback(hObject, eventdata, handles)
% hObject    handle to abortFerret (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortFerret;


% --- Executes on button press in pauseFerret.
function pauseFerret_Callback(hObject, eventdata, handles)
% hObject    handle to pauseFerret (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pauseFerret;


% --- Executes on button press in analyzeHistory.
function analyzeHistory_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analyzeHistoryHandler(true);


% --- Executes on button press in minimizeWindow.
function minimizeWindow_Callback(hObject, eventdata, handles)
% hObject    handle to minimizeWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hideNotes;


% --- Executes on button press in saveNotes.
function saveNotes_Callback(hObject, eventdata, handles)
% hObject    handle to saveNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(getGUIData('runType'), 'Demo')
    warndlg({'Demo notes can''t be edited through the interface.',...
        'If you really want to do this, edit the ''Notes.txt''',...
        'file in the appropriate demo directory manually.'},...
        'Note Pane Warning')
elseif strcmpi(getQubistMode, 'Launch')
    warndlg({'There are no notes to save until a project is initialized!'},...
        'Note Pane Warning');
elseif ~strcmpi(getGUIData('InfoFrame'), 'Notes')
    warndlg({'Only Notes can be saved through this interface.',...
        'Other info types are read-only.'},...
        'Note Pane Warning')
end
saveNotes;


% --- Executes on button press in toggleGraphics.
function toggleGraphics_Callback(hObject, eventdata, handles)
% hObject    handle to toggleGraphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggleGraphics;


function notesPane_Callback(hObject, eventdata, handles)
% hObject    handle to notesPane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesPane as text
%        str2double(get(hObject,'String')) returns contents of notesPane as a double


% --- Executes during object creation, after setting all properties.
function notesPane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesPane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in notesButton.
function notesButton_Callback(hObject, eventdata, handles)
% hObject    handle to notesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setGUIData('InfoFrame', 'notes');
readNotes;


% --- Executes on button press in setupButton.
function setupButton_Callback(hObject, eventdata, handles)
% hObject    handle to setupButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setGUIData('InfoFrame', 'setup');
readNotes;


% --- Executes on button press in initButton.
function initButton_Callback(hObject, eventdata, handles)
% hObject    handle to initButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setGUIData('InfoFrame', 'init');
readNotes;


% --- Executes on button press in fitnessButton.
function fitnessButton_Callback(hObject, eventdata, handles)
% hObject    handle to fitnessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setGUIData('InfoFrame', 'fitness');
readNotes;


% --- Executes on button press in runInfoButton.
function runInfoButton_Callback(hObject, eventdata, handles)
% hObject    handle to runInfoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setGUIData('InfoFrame', 'runInfo');
readNotes;
