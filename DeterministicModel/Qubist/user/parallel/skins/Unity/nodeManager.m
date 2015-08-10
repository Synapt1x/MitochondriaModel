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

function varargout = nodeManager(varargin)
% NODEMANAGER M-file for nodeManager.fig
%      NODEMANAGER, by itself, creates a new NODEMANAGER or raises the existing
%      singleton*.
%
%      H = NODEMANAGER returns the handle to a new NODEMANAGER or the handle to
%      the existing singleton*.
%
%      NODEMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODEMANAGER.M with the given input arguments.
%
%      NODEMANAGER('Property','Value',...) creates a new NODEMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nodeManager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nodeManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nodeManager

% Last Modified by GUIDE v2.5 30-Jul-2009 13:10:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nodeManager_OpeningFcn, ...
                   'gui_OutputFcn',  @nodeManager_OutputFcn, ...
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


% --- Executes just before nodeManager is made visible.
function nodeManager_OpeningFcn(hObject, eventdata, handles, varargin)
global currentComponent_
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nodeManager (see VARARGIN)

% Choose default command line output for nodeManager
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set default colours for all components.
matchColours(hObject);
showBackground(hObject);

% Is the nodeManager called from the launcher or from an optimizer?
% currentComponent='FerretNodeManager' or 'LocustNodeManager' if called
% directly from the launcher, else the currentComponent_ is not changed.
if isempty(varargin)
    isCalledFromLauncher=false;
else
    isCalledFromLauncher=varargin{1};
end

% Toggle current node manager component (Ferret or Locust).
if isCalledFromLauncher
    set(handles.FerretNodeButton, 'Value', 1, 'Enable', 'on');
    set(handles.LocustNodeButton, 'Enable', 'on');
    currentComponent_='FerretNodeManager';
else
    set(handles.FerretNodeButton, 'Enable', 'off');
    set(handles.LocustNodeButton, 'Enable', 'off');
end
%
% Set the radio button.
if findstr(currentComponent_, 'Locust')
    set(handles.LocustNodeButton, 'Value', 1);
else
    set(handles.FerretNodeButton, 'Value', 1);
end
%
% Set parallel computing mode.
parallel=getGUIData('parallel');
if isempty(parallel)
    parallel=false;
end
toggleEvalMode(handles, parallel);

% Enable some GUI components that may have been turned off previously.
set(handles.startNodes, 'Enable', 'on');
set(handles.stopNode, 'Enable', 'on');
set(handles.launchCommand, 'Enable', 'on');
set(handles.evalMode, 'Enable', 'on');
set(handles.JavaBox, 'Enable', 'on');
set(handles.controlMenu, 'Enable', 'on');

% Update the worker list.
getWorkerNodes(handles);

% UIWAIT makes nodeManager wait for user response (see UIRESUME)
% uiwait(handles.nodeManager);

% --- Outputs from this function are returned to the command line.
function varargout = nodeManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in nodeMenu.
function nodeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to nodeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nodeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nodeMenu


% --- Executes during object creation, after setting all properties.
function nodeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startNodes.
function startNodes_Callback(hObject, eventdata, handles)
% hObject    handle to startNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initializeWorkerNodes(handles);


% --- Executes when selected object is changed in cmdPanel.
function cmdPanel_SelectionChangeFcn(hObject, eventdata, handles)
global currentComponent_
% hObject    handle to the selected object in cmdPanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
optimizer=get(hObject, 'String');
if strcmpi(optimizer, 'Locust')
    currentComponent_='LocustNodeManager';
else
    currentComponent_='FerretNodeManager';
end

% --- Executes on button press in JavaBox.
function JavaBox_Callback(hObject, eventdata, handles)
% hObject    handle to JavaBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of JavaBox


function launchCommand_Callback(hObject, eventdata, handles)
% hObject    handle to launchCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of launchCommand as text
%        str2double(get(hObject,'String')) returns contents of launchCommand as a double
setpref('Qubist', 'matlabLaunchCommand', get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function launchCommand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to launchCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ispref('Qubist', 'matlabLaunchCommand')
    matlabLaunchCommand=getpref('Qubist', 'matlabLaunchCommand');
else
    matlabLaunchCommand=strrep(which('addpath'), 'toolbox/matlab/general/addpath.m', 'bin/matlab');
end
if isempty(matlabLaunchCommand)
    matlabLaunchCommand='matlab';
end
set(hObject, 'String', matlabLaunchCommand);


% --- Executes on button press in evalMode.
function evalMode_Callback(hObject, eventdata, handles)
% hObject    handle to evalMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of evalMode
toggleEvalMode(handles);


% --- Executes on selection change in nodeList.
function nodeList_Callback(hObject, eventdata, handles)
% hObject    handle to nodeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nodeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nodeList
getWorkerNodes(handles);


% --- Executes during object creation, after setting all properties.
function nodeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on nodeManager or any of its controls.
function nodeManager_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to nodeManager (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
getWorkerNodes(handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function nodeManager_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to nodeManager (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getWorkerNodes(handles);


% --- Executes on button press in stopNode.
function stopNode_Callback(hObject, eventdata, handles)
% hObject    handle to stopNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stopSelectedWorkerNode(handles);


% --------------------------------------------------------------------
function controlMenu_Callback(hObject, eventdata, handles)
% hObject    handle to controlMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function stopAllNodes_Callback(hObject, eventdata, handles)
% hObject    handle to stopAllNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
par=getGUIData('par');
if ~isempty(par)
    stopWorkerNodes('all', par);
end
getWorkerNodes(handles);


% --------------------------------------------------------------------
function releaseLock_Callback(hObject, eventdata, handles)
% hObject    handle to releaseLock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
releaseScratchLock(handles);


% --------------------------------------------------------------------
function killAllNodes_Callback(hObject, eventdata, handles)
% hObject    handle to killAllNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
par=getGUIData('par');
if ~isempty(par)
    killAllWorkerNodes(par, handles);
end


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
close(handles.nodeManager);
