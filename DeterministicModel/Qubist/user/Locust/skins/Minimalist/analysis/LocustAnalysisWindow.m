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

function varargout = LocustAnalysisWindow(varargin)
%LOCUSTANALYSISWINDOW M-file for LocustAnalysisWindow.fig
%      LOCUSTANALYSISWINDOW, by itself, creates a new LOCUSTANALYSISWINDOW or raises the existing
%      singleton*.
%
%      H = LOCUSTANALYSISWINDOW returns the handle to a new LOCUSTANALYSISWINDOW or the handle to
%      the existing singleton*.
%
%      LOCUSTANALYSISWINDOW('Property','Value',...) creates a new LOCUSTANALYSISWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LocustAnalysisWindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LOCUSTANALYSISWINDOW('CALLBACK') and LOCUSTANALYSISWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LOCUSTANALYSISWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LocustAnalysisWindow

% Last Modified by GUIDE v2.5 29-May-2008 02:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LocustAnalysisWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @LocustAnalysisWindow_OutputFcn, ...
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


% --- Executes just before LocustAnalysisWindow is made visible.
function LocustAnalysisWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

h=guidata(hObject);
% set(h.figMenuFileSave, 'Visible', 'off');

try
    showBackground(hObject);
end

% Choose default command line output for LocustAnalysisWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Drop boxes don't work well on Macs.
comp=computer;
if ~isempty([strfind(comp, 'MAC'), strfind(comp, 'GLNX')])
    set(handles.plotSelect, 'Visible', 'off');
    set(handles.plotSelectExternal, 'Visible', 'on');
end

% Delete some buttons from the toolbar
deleteFigureToolbarButtons(hObject)

% UIWAIT makes LocustAnalysisWindow wait for user response (see UIRESUME)
% uiwait(handles.LocustAnalysisWindow);


% --- Outputs from this function are returned to the command line.
function varargout = LocustAnalysisWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in XFSpace.
function XFSpace_Callback(hObject, eventdata, handles)
% hObject    handle to XFSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setLocustFinalView(1);


% --- Executes on button press in UserPlot.
function UserPlot_Callback(hObject, eventdata, handles)
% hObject    handle to UserPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setLocustFinalView(2);


% --- Executes on button press in analyzeHistory.
function analyzeHistory_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analyzeHistoryHandler;


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startPolisher.
function startPolisher_Callback(hObject, eventdata, handles)
% hObject    handle to startPolisher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
polisherHandler('start');


% --- Executes on button press in abortPolisher.
function abortPolisher_Callback(hObject, eventdata, handles)
% hObject    handle to abortPolisher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
polisherHandler('stop');


% --- Executes on selection change in plotSelect.
function plotSelect_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSelect

plotType=get(hObject, 'Value');
choices=get(hObject, 'String');
if isempty(strfind(choices{plotType}, 'HIDE ME'))
    % Set the plot type.
    setGUIData('XFPlotTypeFinal', plotType);
    setLocustFinalView(1);
    if ~isempty(find([3,4,5,6] == plotType, 1))
        % Contour or image plot.
        set2DPlotParameters;
    end
else
    % The choice is '*** HIDE ME ***'.
    set(hObject, 'Visible', 'off', 'Value', getGUIData('XFPlotTypeFinal'));
end

% --- Executes during object creation, after setting all properties.
function plotSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

plotType=getGUIData('XFPlotTypeFinal');
if isempty(plotType)
    plotType = getGUIData('XFPlotType');
    % Default to the most recent type in the main window
end
if isempty(plotType)
    plotType = 1;
end
set(hObject, 'Value', plotType);
setGUIData('XFPlotTypeFinal', get(hObject,'Value'));


% --- Executes on button press in plotSelectExternal.
function plotSelectExternal_Callback(hObject, eventdata, handles)
% hObject    handle to plotSelectExternal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try %#ok
    plotSelectAnalysisExternal;
end


% --- Executes on button press in stopAnalyze.
function stopAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to stopAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
abortAnalysis;


% --- Executes on button press in paintPoint.
function paintPoint_Callback(hObject, eventdata, handles)
% hObject    handle to paintPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paintPoint(handles.LocustAnalysisWindow);


% --- Executes on button press in setPaintColour.
function setPaintColour_Callback(hObject, eventdata, handles)
% hObject    handle to setPaintColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setPaintColour(hObject);


% --- Executes on button press in fuzziness.
function fuzziness_Callback(hObject, eventdata, handles)
% hObject    handle to fuzziness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if checkOptimizer
    setAnalysisTolerances;
    FRelTol=getGUIData('FRelTol');
    FAbsTol=getGUIData('FAbsTol');
    set(handles.FRelTolText, 'Visible', 'on', 'String', ['FRelTol: ', num2str(FRelTol,3)]);
    set(handles.FAbsTolText, 'Visible', 'on', 'String', ['FAbsTol: ', num2str(FAbsTol,3)]);
end


% Check the optimizer
function ok=checkOptimizer
runInfo=getGUIData('runInfo');
if isempty(runInfo) || ~strcmpi(runInfo.optimizer, 'Locust')
    errordlg('Can''t set fuzziness fields because the run is not active.',...
        'Analysis Error')
    ok=false;
else
    ok=true;
end
%
par=getGUIData('par');
if isempty(par) || ~isfield(par.general, 'NObj') || isempty(par.general.NObj)
    errordlg('Can''t set fuzziness fields because the number of objectives is not known.',...
        'Analysis Error')
    ok=false;
end
