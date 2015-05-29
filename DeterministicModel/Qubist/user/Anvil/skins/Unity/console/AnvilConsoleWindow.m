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

function varargout = AnvilConsoleWindow(varargin)
%ANVILCONSOLEWINDOW M-file for AnvilConsoleWindow.fig
%      ANVILCONSOLEWINDOW, by itself, creates a new ANVILCONSOLEWINDOW or raises the existing
%      singleton*.
%
%      H = ANVILCONSOLEWINDOW returns the handle to a new ANVILCONSOLEWINDOW or the handle to
%      the existing singleton*.
%
%      ANVILCONSOLEWINDOW('Property','Value',...) creates a new ANVILCONSOLEWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to AnvilConsoleWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ANVILCONSOLEWINDOW('CALLBACK') and ANVILCONSOLEWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ANVILCONSOLEWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnvilConsoleWindow

% Last Modified by GUIDE v2.5 25-Mar-2008 01:07:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnvilConsoleWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @AnvilConsoleWindow_OutputFcn, ...
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


% --- Executes just before AnvilConsoleWindow is made visible.
function AnvilConsoleWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for AnvilConsoleWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the GUI type in the GUIData system.
setGUIData('AnvilConsoleWindow', hObject);
setGUIData('AnvilConsoleType', 'AnvilConsoleWindow');
updateAnvilBackground(hObject);

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject)

% UIWAIT makes AnvilConsoleWindow wait for user response (see UIRESUME)
% uiwait(handles.AnvilConsoleWindow);

% --- Outputs from this function are returned to the command line.
function varargout = AnvilConsoleWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in solutions.
function solutions_Callback(hObject, eventdata, handles)
% hObject    handle to solutions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setQubistView(1);


% --- Executes on button press in progress.
function progress_Callback(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
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


% --- Executes on button press in startAnvil.
function startAnvil_Callback(hObject, eventdata, handles)
% hObject    handle to startAnvil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startQubistRun;


% --- Executes on button press in abortAnvil.
function abortAnvil_Callback(hObject, eventdata, handles)
% hObject    handle to abortAnvil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortAnvil;


% --- Executes on button press in pauseAnvil.
function pauseAnvil_Callback(hObject, eventdata, handles)
% hObject    handle to pauseAnvil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pauseAnvil;


% --- Executes on button press in freezePlot.
function freezePlot_Callback(hObject, eventdata, handles)
% hObject    handle to freezePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphics=~getGUIData('graphics');
setGUIData('graphics', graphics);
setGUIData('AnvilGraphicsUpdate', true);
if graphics
    set(hObject, 'String', 'Freeze');
else
    set(hObject, 'String', 'Un-Freeze');
    plotAnvilResults;
end

% --- Executes on button press in updatePlot.
function updatePlot_Callback(hObject, eventdata, handles)
% hObject    handle to updatePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Tell plotAnvilResults to ignore graphics on/off state and make plots
setGUIData('AnvilGraphicsUpdate', true);
%
% Make the plot.
plotAnvilResults;

% --- Executes on button press in CPD_plot.
function CPD_plot_Callback(hObject, eventdata, handles)
% hObject    handle to CPD_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CPD_plot
setAnvilView(1);

% --- Executes on button press in UserPlot.
function UserPlot_Callback(hObject, eventdata, handles)
% hObject    handle to UserPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UserPlot
setAnvilView(2);

% --- Executes on button press in statusButton.
function statusButton_Callback(hObject, eventdata, handles)
% hObject    handle to statusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
