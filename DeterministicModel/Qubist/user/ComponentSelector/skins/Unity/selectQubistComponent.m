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

function varargout = selectQubistComponent(varargin)

%SELECTQUBISTCOMPONENT M-file for selectQubistComponent.fig
%      SELECTQUBISTCOMPONENT, by itself, creates a new SELECTQUBISTCOMPONENT or raises the existing
%      singleton*.
%
%      H = SELECTQUBISTCOMPONENT returns the handle to a new SELECTQUBISTCOMPONENT or the handle to
%      the existing singleton*.
%
%      SELECTQUBISTCOMPONENT('Property','Value',...) creates a new SELECTQUBISTCOMPONENT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to selectQubistComponent_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SELECTQUBISTCOMPONENT('CALLBACK') and SELECTQUBISTCOMPONENT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SELECTQUBISTCOMPONENT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectQubistComponent

% Last Modified by GUIDE v2.5 03-Jun-2008 19:06:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectQubistComponent_OpeningFcn, ...
                   'gui_OutputFcn',  @selectQubistComponent_OutputFcn, ...
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


% --- Executes just before selectQubistComponent is made visible.
function selectQubistComponent_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

% Choose default command line output for selectQubistComponent
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    showBackground(hObject);
end

% Set default.
setSelectedComponent('ComponentSelector');
setCurrentComponent;

h=get(handles.QubistButtonGroup, 'selectedObject');
setSelectedComponent(get(h,'String'));

% Add menus.
addComponentSelectorMenus(hObject);

% Trigger the installation/authorization procedure.
authorizeQubist;

% UIWAIT makes selectQubistComponent wait for user response (see UIRESUME)
% uiwait(handles.selectQubistComponent);

% Disable some buttons if called from QubistFreeTools.
disableQubistFreeToolButtons(h);


% --- Outputs from this function are returned to the command line.
function varargout = selectQubistComponent_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in launchButton.
function launchButton_Callback(hObject, eventdata, handles)
% hObject    handle to launchButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setCurrentComponent;
close(handles.selectQubistComponent);
drawnow;

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.selectQubistComponent);
drawnow;

% --- Executes when selected object is changed in QubistButtonGroup.
function QubistButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)

% hObject    handle to the selected object in QubistButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setSelectedComponent(get(hObject, 'String'));


% ========== USER FUNCTIONS ==========
function setCurrentComponent
global currentComponent_ selectedComponent_
%
currentComponent_=selectedComponent_;

% ------------------------------------

function setSelectedComponent(co)
global selectedComponent_
%
selectedComponent_=co;
