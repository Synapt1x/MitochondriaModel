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

function varargout = HistoryExplorerGUI(varargin)
% HISTORYEXPLORERGUI M-file for HistoryExplorerGUI.fig
%      HISTORYEXPLORERGUI, by itself, creates a new HISTORYEXPLORERGUI or raises the existing
%      singleton*.
%
%      H = HISTORYEXPLORERGUI returns the handle to a new HISTORYEXPLORERGUI or the handle to
%      the existing singleton*.
%
%      HISTORYEXPLORERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTORYEXPLORERGUI.M with the given input arguments.
%
%      HISTORYEXPLORERGUI('Property','Value',...) creates a new HISTORYEXPLORERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HistoryExplorerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HistoryExplorerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HistoryExplorerGUI

% Last Modified by GUIDE v2.5 09-Dec-2009 02:31:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HistoryExplorerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @HistoryExplorerGUI_OutputFcn, ...
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


% --- Executes just before HistoryExplorerGUI is made visible.
function HistoryExplorerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HistoryExplorerGUI (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for HistoryExplorerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set textbox values from the sliders.
genIndex=getGUIData('currentGeneration');
set(handles.generationTextbox, 'String', num2str(genIndex));

try
    showBackground(hObject);
end

% UIWAIT makes HistoryExplorerGUI wait for user response (see UIRESUME)
% uiwait(handles.HistoryExplorerGUI);


% --- Outputs from this function are returned to the command line.
function varargout = HistoryExplorerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function generationSlider_Callback(hObject, eventdata, handles)
% hObject    handle to generationSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGenerationFromSlider(handles);


% --- Executes during object creation, after setting all properties.
function generationSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generationSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
setGenerationFromSlider(handles, hObject);


function generationTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to generationTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of generationTextbox as text
%        str2double(get(hObject,'String')) returns contents of generationTextbox as a double
setGenerationFromTextBox(handles, hObject);


% --- Executes during object creation, after setting all properties.
function generationTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generationTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewButton.
function viewButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Re-construct the Ferret window!
viewFerretGeneration;


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
close(handles.HistoryExplorerGUI);
