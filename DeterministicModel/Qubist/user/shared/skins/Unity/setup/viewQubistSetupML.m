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

function varargout = viewQubistSetupML(varargin)
%VIEWQUBISTSETUPML M-file for viewQubistSetupML.fig
%      VIEWQUBISTSETUPML, by itself, creates a new VIEWQUBISTSETUPML or raises the existing
%      singleton*.
%
%      H = VIEWQUBISTSETUPML returns the handle to a new VIEWQUBISTSETUPML or the handle to
%      the existing singleton*.
%
%      VIEWQUBISTSETUPML('Property','Value',...) creates a new VIEWQUBISTSETUPML using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to viewQubistSetupML_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VIEWQUBISTSETUPML('CALLBACK') and VIEWQUBISTSETUPML('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VIEWQUBISTSETUPML.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewQubistSetupML

% Last Modified by GUIDE v2.5 30-Oct-2009 17:29:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewQubistSetupML_OpeningFcn, ...
                   'gui_OutputFcn',  @viewQubistSetupML_OutputFcn, ...
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


% --- Executes just before viewQubistSetupML is made visible.
function viewQubistSetupML_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for viewQubistSetupML
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

showBackground(hObject);
viewParFields(handles, true); % true ==> read from GUIData system.

% UIWAIT makes viewQubistSetupML wait for user response (see UIRESUME)
% uiwait(handles.viewQubistSetupML);


% --- Outputs from this function are returned to the command line.
function varargout = viewQubistSetupML_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in QubistSetup.
function QubistSetup_Callback(hObject, eventdata, handles)
% hObject    handle to QubistSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns QubistSetup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from QubistSetup


% --- Executes during object creation, after setting all properties.
function QubistSetup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QubistSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.viewQubistSetupML);
