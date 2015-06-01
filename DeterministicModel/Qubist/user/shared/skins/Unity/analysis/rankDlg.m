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

function varargout = rankDlg(varargin)
% RANKDLG M-file for rankDlg.fig
%      RANKDLG, by itself, creates a new RANKDLG or raises the existing
%      singleton*.
%
%      H = RANKDLG returns the handle to a new RANKDLG or the handle to
%      the existing singleton*.
%
%      RANKDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RANKDLG.M with the given input arguments.
%
%      RANKDLG('Property','Value',...) creates a new RANKDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rankDlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rankDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rankDlg

% Last Modified by GUIDE v2.5 14-Jul-2008 02:25:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rankDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @rankDlg_OutputFcn, ...
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


% --- Executes just before rankDlg is made visible.
function rankDlg_OpeningFcn(hObject, eventdata, handles, varargin)
global abortAnalysis_
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rankDlg (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

% Choose default command line output for rankDlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

showBackground(hObject);
abortAnalysis_=0;

% UIWAIT makes rankDlg wait for user response (see UIRESUME)
% uiwait(handles.rankDlg);


% --- Outputs from this function are returned to the command line.
function varargout = rankDlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in continueButton.
function continueButton_Callback(hObject, eventdata, handles)
global abortAnalysis_
% hObject    handle to continueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortAnalysis_=0;
close(handles.rankDlg);
pause(0.01);
drawnow;


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
global abortAnalysis_
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortAnalysis_=1;
close(handles.rankDlg);
pause(0.01);
drawnow;


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
close(handles.rankDlg)
