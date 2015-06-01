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

function varargout = setAnalysisTolerances(varargin)
% SETANALYSISTOLERANCES M-file for setAnalysisTolerances.fig
%      SETANALYSISTOLERANCES, by itself, creates a new SETANALYSISTOLERANCES or raises the existing
%      singleton*.
%
%      H = SETANALYSISTOLERANCES returns the handle to a new SETANALYSISTOLERANCES or the handle to
%      the existing singleton*.
%
%      SETANALYSISTOLERANCES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETANALYSISTOLERANCES.M with the given input arguments.
%
%      SETANALYSISTOLERANCES('Property','Value',...) creates a new SETANALYSISTOLERANCES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setAnalysisTolerances_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setAnalysisTolerances_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setAnalysisTolerances

% Last Modified by GUIDE v2.5 12-Jul-2008 23:47:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setAnalysisTolerances_OpeningFcn, ...
                   'gui_OutputFcn',  @setAnalysisTolerances_OutputFcn, ...
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


% --- Executes just before setAnalysisTolerances is made visible.
function setAnalysisTolerances_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to setAnalysisTolerances (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for setAnalysisTolerances
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    showBackground(hObject);
end

% This line ensures that no new axes are added to the user interface.
set(hObject, 'NextPlot', 'new');

% UIWAIT makes SetAnalysisTolerances wait for user response (see UIRESUME)
% uiwait(handles.SetAnalysisTolerances);


% --- Outputs from this function are returned to the command line.
function varargout = setAnalysisTolerances_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function FAbsTolField_Callback(hObject, eventdata, handles)
% hObject    handle to FAbsTolField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FAbsTolField as text
%        str2double(get(hObject,'String')) returns contents of FAbsTolField as a double
if checkOptimizer
    setFAbsTolField(hObject);
end


% --- Executes during object creation, after setting all properties.
function FAbsTolField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FAbsTolField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if checkOptimizer
    setFAbsTolField(hObject, getGUIData('FAbsTol'));
end


function FRelTolField_Callback(hObject, eventdata, handles)
% hObject    handle to FRelTolField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FRelTolField as text
%        str2double(get(hObject,'String')) returns contents of FRelTolField as a double
if checkOptimizer
    setFRelTolField(hObject);
end


% --- Executes during object creation, after setting all properties.
function FRelTolField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FRelTolField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if checkOptimizer
    setFRelTolField(hObject, getGUIData('FRelTol'));
end


function FAbsTolLabel_Callback(hObject, eventdata, handles)
% hObject    handle to FAbsTolLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FAbsTolLabel as text
%        str2double(get(hObject,'String')) returns contents of FAbsTolLabel as a double


% --- Executes during object creation, after setting all properties.
function FAbsTolLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FAbsTolLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FRelTolLabel_Callback(hObject, eventdata, handles)
% hObject    handle to FRelTolLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FRelTolLabel as text
%        str2double(get(hObject,'String')) returns contents of FRelTolLabel as a double


% --- Executes during object creation, after setting all properties.
function FRelTolLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FRelTolLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setFTol.
function setFTol_Callback(hObject, eventdata, handles)
% hObject    handle to setFTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if checkOptimizer
    setFAbsTolField(handles.FAbsTolField);
    setFRelTolField(handles.FRelTolField);
end


% --- Executes on button press in resetFtolDefaults.
function resetFtolDefaults_Callback(hObject, eventdata, handles)
% hObject    handle to resetFtolDefaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if checkOptimizer
    setFRelTolDefault(handles.FRelTolField);
    setFAbsTolDefault(handles.FAbsTolField);
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
close(handles.SetAnalysisTolerances);
