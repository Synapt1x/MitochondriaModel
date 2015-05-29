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

function varargout = trackerConsole(varargin)
% TRACKERCONSOLE M-file for trackerConsole.fig
%      TRACKERCONSOLE, by itself, creates a new TRACKERCONSOLE or raises the existing
%      singleton*.
%
%      H = TRACKERCONSOLE returns the handle to a new TRACKERCONSOLE or the handle to
%      the existing singleton*.
%
%      TRACKERCONSOLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKERCONSOLE.M with the given input arguments.
%
%      TRACKERCONSOLE('Property','Value',...) creates a new TRACKERCONSOLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trackerConsole_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trackerConsole_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trackerConsole

% Last Modified by GUIDE v2.5 13-Jul-2008 21:56:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trackerConsole_OpeningFcn, ...
                   'gui_OutputFcn',  @trackerConsole_OutputFcn, ...
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


% --- Executes just before trackerConsole is made visible.
function trackerConsole_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trackerConsole (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for trackerConsole
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This is just an easy fix because the fontsize keeps changing in Linux.
g=guidata(hObject);
fontSize=8;
set(g.trackerText, 'FontSize', fontSize);
set(g.trackerMenu, 'FontSize', fontSize);
set(g.adaptTrackerButton, 'FontSize', fontSize);
set(g.freezeTrackerButton, 'FontSize', fontSize);
set(g.gaussianButton, 'FontSize', fontSize);

setGUIData('trackerConsole', hObject);
showBackground(hObject);
updateTrackerConsole;

% UIWAIT makes trackerConsole wait for user response (see UIRESUME)
% uiwait(handles.trackerConsole);


% --- Outputs from this function are returned to the command line.
function varargout = trackerConsole_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function trackerText_Callback(hObject, eventdata, handles)
% hObject    handle to trackerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trackerText as text
%        str2double(get(hObject,'String')) returns contents of trackerText as a double


% --- Executes during object creation, after setting all properties.
function trackerText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trackerMenu.
function trackerMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trackerMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns trackerMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trackerMenu
updateTrackerConsole;

% --- Executes during object creation, after setting all properties.
function trackerMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackerMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in freezeTrackerButton.
function freezeTrackerButton_Callback(hObject, eventdata, handles)
% hObject    handle to freezeTrackerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setAdaptationStatus(handles.trackerMenu, 0);


% --- Executes on button press in adaptTrackerButton.
function adaptTrackerButton_Callback(hObject, eventdata, handles)
% hObject    handle to adaptTrackerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setAdaptationStatus(handles.trackerMenu, 1);


% --- Executes on button press in gaussianButton.
function gaussianButton_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setAdaptationStatus(handles.trackerMenu, -1);
updateTrackerConsole;

% --- Executes on button press in maxUpButton.
function maxUpButton_Callback(hObject, eventdata, handles)
% hObject    handle to maxUpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modifyTrackerRange(handles.trackerMenu, 1, 1);

% --- Executes on button press in maxDownButton.
function maxDownButton_Callback(hObject, eventdata, handles)
% hObject    handle to maxDownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modifyTrackerRange(handles.trackerMenu, 1, -1);

% --- Executes on button press in minUpButton.
function minUpButton_Callback(hObject, eventdata, handles)
% hObject    handle to minUpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modifyTrackerRange(handles.trackerMenu, -1, -1);

% --- Executes on button press in minDownButton.
function minDownButton_Callback(hObject, eventdata, handles)
% hObject    handle to minDownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modifyTrackerRange(handles.trackerMenu, -1, 1);


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
close(handles.trackerConsole);

