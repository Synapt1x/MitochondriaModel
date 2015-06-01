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

function varargout = PaintedPointReport(varargin)
% PAINTEDPOINTREPORT M-file for PaintedPointReport.fig
%      PAINTEDPOINTREPORT, by itself, creates a new PAINTEDPOINTREPORT or raises the existing
%      singleton*.
%
%      H = PAINTEDPOINTREPORT returns the handle to a new PAINTEDPOINTREPORT or the handle to
%      the existing singleton*.
%
%      PAINTEDPOINTREPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAINTEDPOINTREPORT.M with the given input arguments.
%
%      PAINTEDPOINTREPORT('Property','Value',...) creates a new PAINTEDPOINTREPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PaintedPointReport_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PaintedPointReport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PaintedPointReport

% Last Modified by GUIDE v2.5 10-Mar-2015 18:56:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PaintedPointReport_OpeningFcn, ...
    'gui_OutputFcn',  @PaintedPointReport_OutputFcn, ...
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


% --- Executes just before PaintedPointReport is made visible.
function PaintedPointReport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PaintedPointReport (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

OptimalSolutions=getGUIData('OptimalSolutions');
if isempty(OptimalSolutions)
    return
end

% Choose default command line output for PaintedPointReport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    showBackground(hObject);
end

buildPaintedPointList(handles.pointList, handles);
if ~isempty(OptimalSolutions) && isfield(OptimalSolutions, 'paintedPoints') &&...
        isfield(OptimalSolutions.paintedPoints, 'cmdText')
    try %#ok
        set(handles.cmdText, 'String', OptimalSolutions.paintedPoints.cmdText);
    end
end

% This line ensures that no new axes are added to the user interface.
set(hObject, 'NextPlot', 'new');

% UIWAIT makes PaintedPointReport wait for user response (see UIRESUME)
% uiwait(handles.PaintedPointReport);


% --- Outputs from this function are returned to the command line.
function varargout = PaintedPointReport_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pointList.
function pointList_Callback(hObject, eventdata, handles)
% hObject    handle to pointList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pointList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pointList
selectPaintedPoint(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pointList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function XText_Callback(hObject, eventdata, handles)
% hObject    handle to XText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XText as text
%        str2double(get(hObject,'String')) returns contents of XText as a double


% --- Executes during object creation, after setting all properties.
function XText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FText_Callback(hObject, eventdata, handles)
% hObject    handle to FText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FText as text
%        str2double(get(hObject,'String')) returns contents of FText as a double


% --- Executes during object creation, after setting all properties.
function FText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cmdText_Callback(hObject, eventdata, handles)
% hObject    handle to cmdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmdText as text
%        str2double(get(hObject,'String')) returns contents of cmdText as a double

% --- Executes during object creation, after setting all properties.


function cmdText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

par=getGUIData('par');
cmd=getGUIData('PaintedPointsLastCommand');
try %#ok
    if ~isempty(cmd)
        set(hObject, 'String', cmd);
    elseif ~isempty(par) && isfield(par.interface, 'commands') &&...
            ~isempty(par.interface.commands)
        set(hObject, 'String', par.interface.commands{1});
    elseif ~isempty(par) && isfield(par.interface, 'myPlot') &&...
            ~isempty(par.interface.myPlot)
        set(hObject, 'String', par.interface.myPlot);
        
    end
end


% --- Executes on selection change in recentCommands.
function recentCommands_Callback(hObject, eventdata, handles)
% hObject    handle to recentCommands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns recentCommands contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recentCommands
command=get(hObject,'String');
if ~isempty(command)
    if iscell(command)
        command=command{get(hObject, 'Value')};
    end
    command=regexprep(command, '^(\*\s*)|(plot:\s*)', '');
    if ~strcmpi(command, 'Recent Commands')
        set(handles.cmdText, 'String', command);
    end
end


% --- Executes during object creation, after setting all properties.
function recentCommands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recentCommands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

par=getGUIData('par');
if ~isempty(par)
    cmd=getPaintedPointCommands(par);
    if ~isempty(cmd.plot)
        cmd.plot=strcat({'plot: '}, cmd.plot);
    end
    if ~isempty(cmd.par)
        cmd.par=strcat({'* '}, cmd.par);
    end
    commands=[cmd.par, cmd.plot, cmd.input];
    if isempty(commands)
        commands='Recent Commands';
    end
    set(hObject, 'String', commands);
end


% --- Executes on button press in savePoints.
function savePoints_Callback(hObject, eventdata, handles)
% hObject    handle to savePoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savePaintedPoints;

% --- Executes on button press in clearOnePoint.
function clearOnePoint_Callback(hObject, eventdata, handles)
% hObject    handle to clearOnePoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearOnePoint(handles);

% --- Executes on button press in clearAllPoints.
function clearAllPoints_Callback(hObject, eventdata, handles)
% hObject    handle to clearAllPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearAllPoints(handles)

% --- Executes on button press in evalCmd.
function evalCmd_Callback(hObject, eventdata, handles)
% hObject    handle to evalCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalPaintedPointCommand(handles);


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function closeWindow_Callback(hObject, eventdata, handles)
% hObject    handle to closeWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.PaintedPointReport);


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function instructions_Callback(hObject, eventdata, handles)
% hObject    handle to instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox({['This tool allows the user to select specific points in the ',...
    'solution set, view their parameters and fitness values, and evaluate ',...
    'external functions on the the selected values.'],...
    '',...
    'There are 2 ways to define external functions:',...
    '',...
    ['1. Simply type the name of a valid function that is on the current ',...
    'path in the text field.  If the evaluation is successful, the ',...
    'function name will be added to the ''Recent Commands'' drop box. ',...
    'Functions added by this method are purged at the start of each run.'],...
    '',...
    ['2. Include the names of all required functions to the ',...
    'par.interface.commands field in the setup file.  Commands added by ',...
    'this method are preceded by an asterisk (*) in the ''Recent Commands'' ',...
    'drop box.']},...
    'Instructions')


function addPoint_Callback(hObject, eventdata, handles)
% hObject    handle to addPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of addPoint as text
%        str2double(get(hObject,'String')) returns contents of addPoint as a double

% Add a manually selected point.
point=str2num(get(hObject, 'String'));
if ~isempty(point)
    ax=getGUIData('FerretAnalysisWindow');
    addPaintedPoints(ax, point)
end
 set(hObject, 'String', 'add_point');

 
% --- Executes during object creation, after setting all properties.
function addPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to addPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
