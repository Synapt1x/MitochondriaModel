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

function varargout = licenseWindow(varargin)
% LICENSEWINDOW M-file for licenseWindow.fig
%      LICENSEWINDOW, by itself, creates a new LICENSEWINDOW or raises the existing
%      singleton*.
%
%      H = LICENSEWINDOW returns the handle to a new LICENSEWINDOW or the handle to
%      the existing singleton*.
%
%      LICENSEWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LICENSEWINDOW.M with the given input arguments.
%
%      LICENSEWINDOW('Property','Value',...) creates a new LICENSEWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before licenseWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to licenseWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help licenseWindow

% Last Modified by GUIDE v2.5 24-Feb-2008 06:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @licenseWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @licenseWindow_OutputFcn, ...
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


% --- Executes just before licenseWindow is made visible.
function licenseWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to licenseWindow (see VARARGIN)

% Set default colours for all components.
% matchColours(hObject);

try
    set(handles.certifyCheckbox, 'Value', 0, 'Enable', 'on');
    set(handles.acceptButton, 'Enable', 'off');
    %
    licenseText=readLicense;
    set(handles.licensePane, 'String', licenseText);
    %
    UserData.acceptAgreement=false;
    UserData.passKey='';
    set(handles.licenseWindow, 'UserData', UserData);
    %
    showBackground(hObject, 'LicenseWindow.png');
end

% Choose default command line output for licenseWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes licenseWindow wait for user response (see UIRESUME)
uiwait(handles.licenseWindow);


% --- Outputs from this function are returned to the command line.
function varargout = licenseWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(handles)
    varargout={[]};
else
    varargout{1} = handles.output;
end

% Close the window.
% close(handles.licenseWindow);

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in acceptButton.
function acceptButton_Callback(hObject, eventdata, handles)
% hObject    handle to acceptButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.licenseWindow, 'UserData');
UserData.acceptAgreement=true;
set(handles.licenseWindow, 'UserData', UserData);
uiresume;

% --- Executes on button press in declineButton.
function declineButton_Callback(hObject, eventdata, handles)
% hObject    handle to declineButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(hObject, 'UserData');
UserData.acceptAgreement=false;
set(handles.licenseWindow, 'UserData', UserData);
uiresume;

% --- Executes on button press in certifyCheckbox.
function certifyCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to certifyCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject, 'Value') && ~isempty(get(handles.passKeyTextBox, 'String'))
    set(hObject, 'Enable', 'off');
    set(handles.passKeyTextBox, 'Enable', 'off');
    set(handles.acceptButton, 'Enable', 'on');
end

function passKeyTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to passKeyTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passKeyTextBox as text
%        str2double(get(hObject,'String')) returns contents of passKeyTextBox as a double
keyAccepted=~isempty(get(hObject, 'String'));
if keyAccepted
    UserData=get(handles.licenseWindow, 'UserData');
    UserData.passKey=get(hObject, 'String');
    set(handles.licenseWindow, 'UserData', UserData);
    if get(handles.certifyCheckbox, 'Value')
        set(hObject, 'Enable', 'off');
        set(handles.certifyCheckbox, 'Enable', 'off');
        set(handles.acceptButton, 'Enable', 'on');
    end
end

% --- Executes during object creation, after setting all properties.
function passKeyTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passKeyTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function passKeyStaticText_Callback(hObject, eventdata, handles)
% hObject    handle to passKeyStaticText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passKeyStaticText as text
%        str2double(get(hObject,'String')) returns contents of passKeyStaticText as a double


% --- Executes during object creation, after setting all properties.
function passKeyStaticText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passKeyStaticText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function licenseWindow_Callback(hObject, eventdata, handles)
% hObject    handle to licenseWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of licenseWindow as text
%        str2double(get(hObject,'String')) returns contents of licenseWindow as a double


% --- Executes during object creation, after setting all properties.
function licenseWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to licenseWindow (see GCBO)
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
