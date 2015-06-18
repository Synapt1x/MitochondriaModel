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

function varargout = FerretConsoleWindow(varargin)
%FERRETCONSOLEWINDOW M-file for FerretConsoleWindow.fig
%      FERRETCONSOLEWINDOW, by itself, creates a new FERRETCONSOLEWINDOW or raises the existing
%      singleton*.
%
%      H = FERRETCONSOLEWINDOW returns the handle to a new FERRETCONSOLEWINDOW or the handle to
%      the existing singleton*.
%
%      FERRETCONSOLEWINDOW('Property','Value',...) creates a new FERRETCONSOLEWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to FerretConsoleWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FERRETCONSOLEWINDOW('CALLBACK') and FERRETCONSOLEWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FERRETCONSOLEWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above notesPane to modify the response to help FerretConsoleWindow

% Last Modified by GUIDE v2.5 12-Mar-2008 03:24:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FerretConsoleWindow_OpeningFcn, ...
    'gui_OutputFcn',  @FerretConsoleWindow_OutputFcn, ...
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


% --- Executes just before FerretConsoleWindow is made visible.
function FerretConsoleWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FerretConsoleWindow (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for FerretConsoleWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the GUI type in the GUIData system.
setGUIData('FerretConsoleWindow', hObject);
setGUIData('FerretConsoleType', 'FerretConsoleWindow');
updateFerretBackground(hObject, '', true);

% Drop boxes don't work well on Macs.
comp=computer;
if ~isempty([strfind(comp, 'MAC'), strfind(comp, 'GLNX')])
    set(handles.plotSelect, 'Visible', 'off');
    set(handles.plotSelectExternal, 'Visible', 'on');
end

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject);

% Check whether or not the pan and zoom icons should be disabled.  These
% are dangerous to use if Ferret is running or if 3D plots are enabled.
checkKillPan(handles.FerretConsoleWindow);
checkKillZoom(handles.FerretConsoleWindow);
checkKillRotate(handles.FerretConsoleWindow);

% Read the notes pane BEFORE the figure is made visible.
readNotes;

% Window size.
setConsoleWindowSize(hObject, 'withGraphics');

% UIWAIT makes FerretConsoleWindow wait for user response (see UIRESUME)
% uiwait(handles.FerretConsoleWindow);


% --- Outputs from this function are returned to the command line.
function varargout = FerretConsoleWindow_OutputFcn(hObject, eventdata, handles)
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
comp=computer;
if isempty([strfind(comp, 'MAC'), strfind(comp, 'GLNX')])
    set(handles.plotSelect, 'Visible', 'on');
end
pauseFerret;


% --- Executes on button press in analyzeHistory.
function analyzeHistory_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analyzeHistoryHandler(true);


% --- Executes on button press in BBPlot.
function BBPlot_Callback(hObject, eventdata, handles)
% hObject    handle to BBPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setFerretView(3);


% --- Executes on button press in CPDPlot.
function CPDPlot_Callback(hObject, eventdata, handles)
% hObject    handle to CPDPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setFerretView(2);


% --- Executes on button press in userPlot.
function userPlot_Callback(hObject, eventdata, handles)
% hObject    handle to userPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setFerretView(1);


% --- Executes on button press in hideNotes.
function hideNotes_Callback(hObject, eventdata, handles)
% hObject    handle to hideNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hideNotes;


% --- Executes on button press in showMovie.
function showMovie_Callback(hObject, eventdata, handles)
% hObject    handle to showMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showMovieHandler;


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


% --- Executes on selection change in plotSelect.
function plotSelect_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSelect
plotType=get(hObject, 'Value');
choices=get(hObject, 'String');
checkKillPan(handles.FerretConsoleWindow);
checkKillZoom(handles.FerretConsoleWindow);

if isempty(strfind(choices{plotType}, 'HIDE ME'))
    % Set the plot type.
    setGUIData('XFPlotType', plotType);
    makeFerretPlots(3);
else
    % The choice is '*** HIDE ME ***'.
    set(hObject, 'Visible', 'off', 'Value', getGUIData('XFPlotType'));
end


% --- Executes during object creation, after setting all properties.
function plotSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
setGUIData('XFPlotType', get(hObject,'Value'));


% --- Executes on button press in plotSelectExternal.
function plotSelectExternal_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelectExternal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try %#ok
    plotSelectExternal;
end


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


% --- Executes on button press in trackerButton.
function trackerButton_Callback(hObject, eventdata, handles)
% hObject    handle to trackerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trackerConsole;


% --- Executes on button press in statusButton.
function statusButton_Callback(hObject, eventdata, handles)
% hObject    handle to statusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statusButton
