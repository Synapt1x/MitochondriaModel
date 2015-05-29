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

function varargout = aboutQubist(varargin)
% ABOUTQUBIST M-file for aboutQubist.fig
%      ABOUTQUBIST, by itself, creates a new ABOUTQUBIST or raises the existing
%      singleton*.
%
%      H = ABOUTQUBIST returns the handle to a new ABOUTQUBIST or the handle to
%      the existing singleton*.
%
%      ABOUTQUBIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUTQUBIST.M with the given input arguments.
%
%      ABOUTQUBIST('Property','Value',...) creates a new ABOUTQUBIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aboutFerret_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aboutQubist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aboutQubist

% Last Modified by GUIDE v2.5 15-Apr-2008 02:35:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aboutQubist_OpeningFcn, ...
                   'gui_OutputFcn',  @aboutQubist_OutputFcn, ...
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


% --- Executes just before aboutQubist is made visible.
function aboutQubist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aboutQubist (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

% Choose default command line output for aboutQubist
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

txt1={['Qubist is an advanced global optimization toolbox by nQube',...
    'Technical Computing Corporation.'],...
    '',...
    ['Qubist contains 4 optimizers: Ferret, Locust, Anvil, & SemiGloSS.  ',...
    'Ferret is by far the most powerful optimizer in the toolbox ',...
    'and the most suitable for research applications.'],...
    '',...
    ['Ferret is a versatile linkage-learning multi-objective genetic ',...
    'algorithm, which contains numerous enhancements that are ',...
    'not found in conventional genetic algorithms.  Ferret is ',...
    'fundamentally an evolutionary optimization algorithm, but one in ',...
    'which the evolution is subtly guided by an embedded machine ',...
    'learning algorithm.'],...
    '',...
    ['Locust is an enhanced multi-objective particle swarm optimizer with several ',...
    'additional features borrowed from the Ferret Genetic Algorithm.'],...
    '',...
    ['Anvil is a multi-objective simulated annealing/genetic algorithm hybrid ',...
    'code, with many features borrowed from Ferret.  It can be used as a ',...
    'stand-alone optimizer, or as a polisher for Ferret.  Anvil is under intense  ',...
    'current development, and an enhanced version will likely be part of a future',...
    'Qubist release.'],...
    '',...
    ['SAMOSA is a "Straightforward Approach to a Multi-Objective Simplex ',...
    'Algorithm."  It can be used as a standalone alternative to Matlab''s ',...
    'fminsearch algorithm, or as Ferret''s a multi-objective solution polisher.'],...
    '',...
    ['SemiGloSS is Qubist''s experimental ''Semi-Global Solution Spray'' Optimizer, ',...
    'which can be used as a stand-alone multi-objective optimizer, or as a ',...
    'multi-objective solution polisher for Ferret or Locust.'],...
    };

txt2={[textQubist, ' optimizer versions:'],...
    [textFerret, ', ', textLocust, ', ', textAnvil, ', ', textSAMOSA, ', ', textSemiGloSS],...
    '',...
    'Copyright 2002-2011.  nQube Technical Computing Corp.  All rights reserved.'};

set(handles.text1, 'String', txt1);
set(handles.text2, 'String', txt2);

try
    showBackground(hObject, 'Qubist_Splash.png', -1);
end

% UIWAIT makes aboutQubist wait for user response (see UIRESUME)
% uiwait(handles.aboutQubist);


% --- Outputs from this function are returned to the command line.
function varargout = aboutQubist_OutputFcn(hObject, eventdata, handles) 
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

close(handles.aboutQubist);
