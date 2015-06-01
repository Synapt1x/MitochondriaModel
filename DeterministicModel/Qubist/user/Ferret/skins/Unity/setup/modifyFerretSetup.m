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

function varargout = modifyFerretSetup(varargin)
%MODIFYFERRETSETUP M-file for modifyFerretSetup.fig
%      MODIFYFERRETSETUP, by itself, creates a new MODIFYFERRETSETUP or raises the existing
%      singleton*.
%
%      H = MODIFYFERRETSETUP returns the handle to a new MODIFYFERRETSETUP or the handle to
%      the existing singleton*.
%
%      MODIFYFERRETSETUP('Property','Value',...) creates a new MODIFYFERRETSETUP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to modifyFerretSetup_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MODIFYFERRETSETUP('CALLBACK') and MODIFYFERRETSETUP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MODIFYFERRETSETUP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modifyFerretSetup

% Last Modified by GUIDE v2.5 07-Sep-2008 00:11:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modifyFerretSetup_OpeningFcn, ...
                   'gui_OutputFcn',  @modifyFerretSetup_OutputFcn, ...
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


% --- Executes just before modifyFerretSetup is made visible.
function modifyFerretSetup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for modifyFerretSetup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

showBackground(hObject);
modifyParFields(handles, true); % true ==> read from GUIData system.

% UIWAIT makes modifyFerretSetup wait for user response (see UIRESUME)
% uiwait(handles.modifyFerretSetup);


% --- Outputs from this function are returned to the command line.
function varargout = modifyFerretSetup_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FerretSetup.
function FerretSetup_Callback(hObject, eventdata, handles)
% hObject    handle to FerretSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FerretSetup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FerretSetup
setModifiedEditValue(handles);


% --- Executes during object creation, after setting all properties.
function FerretSetup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FerretSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editValue_Callback(hObject, eventdata, handles)
% hObject    handle to editValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editValue as text
%        str2double(get(hObject,'String')) returns contents of editValue as a double


% --- Executes during object creation, after setting all properties.
function editValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in validateValue.
function validateValue_Callback(hObject, eventdata, handles)
% hObject    handle to validateValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validateFerretSetupParameters(handles);


% --- Executes on button press in saveChanges.
function saveChanges_Callback(hObject, eventdata, handles)
% hObject    handle to saveChanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buttonPressed=uigetpref('Ferret','modifyFerretSetup',...
    'WARNING: Final Polishing',...
    {'This feature is intended for advanced users only.  ',...
    'Your changes are about to be sent to Ferret with MINIMAL VALIDATION.',...
    '',...
    '*** AN INCORRECT CHANGE CAN CRASH YOUR RUN. ***',...
    '',...
    'Are you SURE that you wish to proceed?'},...
    {'y','n';'Yes','No'}, 'DefaultButton', 'No');

if strcmpi(buttonPressed,'n')
    disp('*** Modify FerretSetup changes cancelled.  Nothing was sent to Ferret. ***');
    return
end

validateFerretSetupParameters(handles);
par=get(handles.modifyFerretSetup, 'UserData');
setGUIData('par', par.struct);
disp('*** FerretSetup was modified. ***');


% --- Executes on button press in discardChanges.
function discardChanges_Callback(hObject, eventdata, handles)
% hObject    handle to discardChanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modifyParFields(handles);


% --- Executes on button press in polishMode.
function polishMode_Callback(hObject, eventdata, handles)
% hObject    handle to polishMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buttonPressed=uigetpref('Ferret','modifyFerretSetup',...
    'WARNING: Final Polishing',...
    {'If you continue, Ferret will enter a very agressive mode that is only intended for FINAL',...
    'polishing of the optimal set.  This is meant to improve your very best solutions,  but',...
    'may also cause a significant loss of diversity, which cannot be undone.',...
    '',...
    '*** DO NOT PROCEED UNLESS YOUR RUN IS NEARLY FINISHED. ***',...
    '',...
    'Are you SURE that you wish to proceed?'},...
    {'y','n';'Yes','No'}, 'DefaultButton', 'No');

if strcmpi(buttonPressed, 'N')
    disp('*** Final polish mode cancelled.  Nothing was sent to Ferret. ***')
    return
end

par=modifyParFields(handles);
par=par.struct;
%
par.strategy.isAdaptive=false;
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.BBPressure=1;
par.selection.FAbsTol=0;
par.selection.FRelTol=0;
par.selection.FRankTol=0;
par.XOver.dispersion=0;
par.link.PLink=0;
par.link.FAbsTol=0;
par.link.FRelTol=0;
par.link.PRandomizeNewBBs=0;
%
setGUIData('par', par);
disp('FerretSetup was modified.  Polishing has begun.');
modifyParFields(handles);


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
close(handles.modifyFerretSetup);
