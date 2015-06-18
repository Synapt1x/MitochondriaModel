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

function varargout = licenseInfo(varargin)
% LICENSEINFO M-file for licenseInfo.fig
%      LICENSEINFO, by itself, creates a new LICENSEINFO or raises the existing
%      singleton*.
%
%      H = LICENSEINFO returns the handle to a new LICENSEINFO or the handle to
%      the existing singleton*.
%
%      LICENSEINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LICENSEINFO.M with the given input arguments.
%
%      LICENSEINFO('Property','Value',...) creates a new LICENSEINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before licenseInfo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to licenseInfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help licenseInfo

% Last Modified by GUIDE v2.5 14-Jul-2008 03:05:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @licenseInfo_OpeningFcn, ...
                   'gui_OutputFcn',  @licenseInfo_OutputFcn, ...
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


% --- Executes just before licenseInfo is made visible.
function licenseInfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to licenseInfo (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

try
    licenseText=readLicense;
    set(handles.licensePane, 'String', licenseText);
    %
    UserData.acceptAgreement=false;
    set(handles.licenseInfo, 'UserData', UserData);
    %
    showBackground(hObject, 'LicenseWindow.png');
end

% Choose default command line output for licenseInfo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes licenseInfo wait for user response (see UIRESUME)
% uiwait(handles.licenseInfo);

% --- Outputs from this function are returned to the command line.
function varargout = licenseInfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Close the window.
% close(handles.licenseInfo);

function licenseBox_Callback(hObject, eventdata, handles)
% hObject    handle to licenseBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of licenseBox as text
%        str2double(get(hObject,'String')) returns contents of licenseBox as a double


% --- Executes during object creation, after setting all properties.
function licenseBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to licenseBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function licenseInfo_Callback(hObject, eventdata, handles)
% hObject    handle to licenseInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of licenseInfo as text
%        str2double(get(hObject,'String')) returns contents of licenseInfo as a double


% --- Executes during object creation, after setting all properties.
function licenseInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to licenseInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function licensePane_Callback(hObject, eventdata, handles)
% hObject    handle to licensePane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of licensePane as text
%        str2double(get(hObject,'String')) returns contents of licensePane as a double


% --- Executes during object creation, after setting all properties.
function licensePane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to licensePane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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
close(handles.licenseInfo);
