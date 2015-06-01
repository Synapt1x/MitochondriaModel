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

function varargout = aboutFerret(varargin)
% ABOUTFERRET M-file for aboutFerret.fig
%      ABOUTFERRET, by itself, creates a new ABOUTFERRET or raises the existing
%      singleton*.
%
%      H = ABOUTFERRET returns the handle to a new ABOUTFERRET or the handle to
%      the existing singleton*.
%
%      ABOUTFERRET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUTFERRET.M with the given input arguments.
%
%      ABOUTFERRET('Property','Value',...) creates a new ABOUTFERRET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aboutFerret_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aboutFerret_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aboutFerret

% Last Modified by GUIDE v2.5 24-Jan-2008 00:55:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aboutFerret_OpeningFcn, ...
                   'gui_OutputFcn',  @aboutFerret_OutputFcn, ...
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


% --- Executes just before aboutFerret is made visible.
function aboutFerret_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aboutFerret (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

% Choose default command line output for aboutFerret
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

version=Qubist_Version;
textQubist=['Qubist ', version.Qubist];
textFerret=['Ferret ', version.Ferret];
textAnvil=['Anvil ', version.Anvil];
textLocust=['Locust ', version.Locust];
textSAMOSA=['SAMOSA ', version.SAMOSA];
textSemiGloSS=['SemiGloSS ', version.SemiGloSS];

txt={['Qubist is an advanced global optimization toolbox by nQube ',...
    'Technical Computing Corporation.'],...
    '',...
    ['Ferret is a versatile linkage-learning multi-objective genetic ',...
    'algorithm, which contains numerous enhancements that are ',...
    'not found in conventional genetic algorithms.  These include:'],...
    '',...
    '1. Multi-Objective Optimization',...
    '2. Advanced Critical Parameter Detection (CPD) capabilities',...
    '3. Linkage-Learning for automatic design decomposiiton',...
    '4. Seamless integration with the polishers SAMOSA, Anvil, and',...
    '    SemiGloSS.  Used within Ferret as polishers for high-precision',...
    '    multi-objective Optimization.',...
    '',...
    [textQubist, ' optimizer versions:'],...
    [textFerret, ', ', textLocust, ', ', textAnvil, ', ', textSAMOSA, ', ', textSemiGloSS],...
    '',...
    'Copyright 2002-2011.  nQube Technical Computing Corp.  All rights reserved.'};

set(handles.text1, 'String', txt);

try
    showBackground(hObject, 'ferret.png', -1);
end

% UIWAIT makes aboutFerret wait for user response (see UIRESUME)
% uiwait(handles.aboutFerret);


% --- Outputs from this function are returned to the command line.
function varargout = aboutFerret_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.aboutFerret);
