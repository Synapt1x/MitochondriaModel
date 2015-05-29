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

function varargout = plotSelectExternal(varargin)
% PLOTSELECTEXTERNAL M-file for plotSelectExternal.fig
%      PLOTSELECTEXTERNAL, by itself, creates a new PLOTSELECTEXTERNAL or raises the existing
%      singleton*.
%
%      H = PLOTSELECTEXTERNAL returns the handle to a new PLOTSELECTEXTERNAL or the handle to
%      the existing singleton*.
%
%      PLOTSELECTEXTERNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSELECTEXTERNAL.M with the given input arguments.
%
%      PLOTSELECTEXTERNAL('Property','Value',...) creates a new PLOTSELECTEXTERNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotSelectExternal_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotSelectExternal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotSelectExternal

% Last Modified by GUIDE v2.5 12-Jul-2008 01:26:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plotSelectExternal_OpeningFcn, ...
    'gui_OutputFcn',  @plotSelectExternal_OutputFcn, ...
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


% --- Executes just before plotSelectExternal is made visible.
function plotSelectExternal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotSelectExternal (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for plotSelectExternal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    showBackground(hObject);
end

% UIWAIT makes plotSelectExternal wait for user response (see UIRESUME)
% uiwait(handles.plotSelectExternal);


% --- Outputs from this function are returned to the command line.
function varargout = plotSelectExternal_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in plotSelectListBox.
function plotSelectListBox_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSelectListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSelectListBox


% --- Executes during object creation, after setting all properties.
function plotSelectListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSelectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSelect.
function plotSelect_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotType=get(handles.plotSelectListBox, 'Value');
setGUIData('XFPlotType', plotType);
makeFerretPlots(3);
