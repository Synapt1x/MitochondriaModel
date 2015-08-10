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

function varargout = set2DPlotParameters(varargin)
% SET2DPLOTPARAMETERS M-file for set2DPlotParameters.fig
%      SET2DPLOTPARAMETERS, by itself, creates a new SET2DPLOTPARAMETERS or raises the existing
%      singleton*.
%
%      H = SET2DPLOTPARAMETERS returns the handle to a new SET2DPLOTPARAMETERS or the handle to
%      the existing singleton*.
%
%      SET2DPLOTPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET2DPLOTPARAMETERS.M with the given input arguments.
%
%      SET2DPLOTPARAMETERS('Property','Value',...) creates a new SET2DPLOTPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before set2DPlotParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to set2DPlotParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help set2DPlotParameters

% Last Modified by GUIDE v2.5 11-Jun-2008 07:36:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @set2DPlotParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @set2DPlotParameters_OutputFcn, ...
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


% --- Executes just before set2DPlotParameters is made visible.
function set2DPlotParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to set2DPlotParameters (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for set2DPlotParameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% *** NOTE THAT SOME DEFAULTS ARE SET IN binAnalysisData.
% THESE MUST AGREE WITH VALUES HERE AND THOSE THAT
% ARE PRE-SET USING GUIDE***
% NPix=50;
% bias=-1;
% sliceLevel=1;
% sliceDir='valleys';
%
UD.limits.NPix.min=get(handles.NPixSlider, 'Min');
UD.limits.NPix.max=get(handles.NPixSlider, 'Max');
UD.limits.NContours.min=get(handles.contourSlider, 'Min');
UD.limits.NContours.max=get(handles.contourSlider, 'Max');
UD.limits.bias.min=get(handles.biasSlider, 'Min');
UD.limits.bias.max=get(handles.biasSlider, 'Max');
%
% Read analysisPlotOptions and set these values as the current defaults.
APO=getGUIData('analysisPlotOptions');
if ~isempty(APO) && isfield(APO,'shading')
    UD.defaults=APO;
    set(handles.logButton, 'Value', APO.shading.log);
    set(hObject,'ColorMap',eval(APO.cmap));
else
    UD.defaults.NPix=get(handles.NPixSlider, 'Value');
    UD.defaults.NPix=round(UD.defaults.NPix);
    UD.defaults.NContours=get(handles.contourSlider, 'Value');
    UD.defaults.NContours=round(UD.defaults.NContours);
    try
        UD.defaults.specifiedContourValues.levels=eval(get(handles.contourValueBox, 'String'));
    catch
        UD.defaults.specifiedContourValues.levels=[];
    end
    if get(handles.minPlus, 'Value');
        UD.defaults.specifiedContourValues.zeroPoint=-1;
    elseif get(handles.maxMinus, 'Value');
        UD.defaults.specifiedContourValues.zeroPoint=1;
    else
        UD.defaults.specifiedContourValues.zeroPoint=0;
    end
    UD.defaults.specifiedContourValues.labels=get(handles.contourLabels, 'Value');
    UD.defaults.bias=get(handles.biasSlider, 'Value');
    UD.defaults.bias=round(100*UD.defaults.bias)/100;
    UD.defaults.sliceLevel=get(handles.sliceSlider, 'Value');
    if get(handles.valleyButton, 'Value')
        UD.defaults.sliceDir='valleys';
    elseif get(handles.meanButton, 'Value')
        UD.defaults.sliceDir='mean';
    elseif get(handles.peakButton, 'Value')
        UD.defaults.sliceDir='peaks';
    end
    if ~isempty(APO) && isfield(APO,'cmap')
        UD.defaults.cmap=APO.cmap;
    else
        [cmap,UD.defaults.cmap]=getCMap2DPP(handles.selectCMap);
    end
end
%
set(hObject, 'UserData', UD);

APO=getGUIData('analysisPlotOptions');
if ~isempty(APO)
    if isfield(APO,'cmap')
        try
            cmap=eval(APO.cmap);
        catch
            cmap=getCMap2DPP(handles.selectCMap);
        end
    else
        cmap=getCMap2DPP(handles.selectCMap);
    end
    if isfield(APO, 'shading')
    len=size(cmap,1);
    set(handles.grayMinSlider, 'Value', (APO.shading.min-1)/(len-1));
    set(handles.grayMaxSlider, 'Value', (APO.shading.max-1)/(len-1));
    end
end
applyDefaults2DPP(handles);
%
try
    showBackground(hObject);
end

% This line ensures that no new axes are added to the user interface.
set(hObject, 'NextPlot', 'new');

% UIWAIT makes set2DPlotParameters wait for user response (see UIRESUME)
% uiwait(handles.set2DPlotParameters);


% --- Outputs from this function are returned to the command line.
function varargout = set2DPlotParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function NPixSlider_Callback(hObject, eventdata, handles)
% hObject    handle to NPixSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

NPix=get(handles.NPixSlider, 'Value');
NPix=round(NPix);
set(handles.NPixText, 'String', NPix);


% --- Executes during object creation, after setting all properties.
function NPixSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NPixSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function biasSlider_Callback(hObject, eventdata, handles)
% hObject    handle to biasSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

bias=get(hObject, 'Value');
bias=round(100*bias)/100;
set(handles.biasText, 'String', bias);


% --- Executes during object creation, after setting all properties.
function biasSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to biasSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function NPixText_Callback(hObject, eventdata, handles)
% hObject    handle to NPixText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NPixText as text
%        str2double(get(hObject,'String')) returns contents of NPixText as a double

NPix=str2num(get(hObject, 'String'));
OK=true;
if isempty(NPix)
    OK=false;
else
    NPix=round(NPix);
    limits=getLimits2DPP(handles);
    if NPix >= limits.NPix.min && NPix <= limits.NPix.max
        set(hObject, 'String', NPix);
        set(handles.NPixSlider, 'Value', NPix);
    else
        OK=false;
    end
end
%
if ~OK
    NPix=get(handles.NPixSlider, 'Value');
    NPix=round(NPix);
    set(hObject, 'String', NPix);
end

% --- Executes during object creation, after setting all properties.
function NPixText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NPixText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function contourSlider_Callback(hObject, eventdata, handles)
% hObject    handle to contourSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

NContours=get(hObject, 'Value');
NContours=round(NContours);
set(handles.contourText, 'String', NContours);


% --- Executes during object creation, after setting all properties.
function contourSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contourSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function contourText_Callback(hObject, eventdata, handles)
% hObject    handle to contourText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contourText as text
%        str2double(get(hObject,'String')) returns contents of contourText as a double

NContours=str2num(get(hObject, 'String'));
OK=true;
if isempty(NContours)
    OK=false;
else
    NContours=round(NContours);
    limits=getLimits2DPP(handles);
    if NContours >= limits.NContours.min && NContours <= limits.NContours.max
        set(hObject, 'String', NContours);
        set(handles.contourSlider, 'Value', NContours);
    else
        OK=false;
    end
end
%
if ~OK
    NContours=get(handles.contourSlider, 'Value');
    NContours=round(NContours);
    set(hObject, 'String', NContours);
end


% --- Executes during object creation, after setting all properties.
function contourText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contourText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliceLevel=get(hObject, 'Value');
set(handles.sliceText, 'String', num2str(sliceLevel,3));


% --- Executes during object creation, after setting all properties.
function sliceSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliceText_Callback(hObject, eventdata, handles)
% hObject    handle to sliceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliceText as text
%        str2double(get(hObject,'String')) returns contents of sliceText as a double

sliceLevel=str2num(get(hObject, 'String'));
if isempty(sliceLevel) || sliceLevel < 0 || sliceLevel > 1
    sliceLevel=get(handles.sliceSlider, 'Value');
    set(hObject, 'String', num2str(sliceLevel,3));
else
    set(hObject, 'String', num2str(sliceLevel,3));
    set(handles.sliceSlider, 'Value', sliceLevel);
end


% --- Executes during object creation, after setting all properties.
function sliceText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in sliceButtonGroup.
function sliceButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in sliceButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Nothing to do here...


% --- Executes on button press in biasMean.
function biasMean_Callback(hObject, eventdata, handles)
% hObject    handle to biasMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bias=0;
set(handles.biasSlider, 'Value', bias);
set(handles.biasText, 'String', bias);


% --- Executes on button press in biasMin.
function biasMin_Callback(hObject, eventdata, handles)
% hObject    handle to biasMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bias=-1;
set(handles.biasSlider, 'Value', bias);
set(handles.biasText, 'String', bias);


% --- Executes on button press in biasMax.
function biasMax_Callback(hObject, eventdata, handles)
% hObject    handle to biasMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bias=1;
set(handles.biasSlider, 'Value', bias);
set(handles.biasText, 'String', bias);


function biasText_Callback(hObject, eventdata, handles)
% hObject    handle to biasText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of biasText as text
%        str2double(get(hObject,'String')) returns contents of biasText as a double
bias=str2num(get(hObject, 'String'));
OK=true;
if isempty(bias)
    OK=false;
else
    bias=round(100*bias)/100;
    limits=getLimits2DPP(handles);
    if bias >= limits.bias.min && bias <= limits.bias.max
        set(hObject, 'String', bias);
        set(handles.biasSlider, 'Value', bias);
    else
        OK=false;
    end
end
%
if ~OK
    bias=get(handles.biasSlider, 'Value');
    bias=round(100*bias)/100;
    set(hObject, 'String', bias);
end


% --- Executes during object creation, after setting all properties.
function biasText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to biasText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in logButton.
function logButton_Callback(hObject, eventdata, handles)
% hObject    handle to logButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logButton


% --- Executes on slider movement.
function grayMinSlider_Callback(hObject, eventdata, handles)
% hObject    handle to grayMinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

cmap=getCMap2DPP(handles.selectCMap);
color=getColor2DPP(cmap,get(hObject, 'Value'));
set(hObject, 'BackgroundColor', color);


% --- Executes during object creation, after setting all properties.
function grayMinSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grayMinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function grayMaxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to grayMaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

cmap=getCMap2DPP(handles.selectCMap);
color=getColor2DPP(cmap,get(hObject, 'Value'));
set(hObject, 'BackgroundColor', color);


% --- Executes during object creation, after setting all properties.
function grayMaxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grayMaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.set2DPlotParameters);


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
applyDefaults2DPP(handles);


% --- Executes on button press in setDefaults.
function setDefaults_Callback(hObject, eventdata, handles)
% hObject    handle to setDefaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UD=get(handles.set2DPlotParameters, 'UserData');
UD.defaults=readSettings2DPP(handles);
set(handles.set2DPlotParameters, 'UserData', UD);
setGUIData('analysisPlotOptions', UD.defaults)


% --- Executes on button press in applyButton.
function applyButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analysisPlotOptions=readSettings2DPP(handles);

try %#ok
    setGUIData('analysisPlotOptions', analysisPlotOptions);
    plotFinalResults;
end


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function instructions_Callback(hObject, eventdata, handles)
% hObject    handle to instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'This interface allows the user to set plotting parameters for ',...
    'contour and image plots.',...
    '',...
    '--- Horizontal Sliders: ---',...
    '* Top: The Controls the number of pixels that are used to interpolate ',...
    'the solution set.',...
    'Middle: Sets the number of contours.  No effect of image plots. ',...
    ['* Bottom: Contour and image plots use shading to display a flat, ',...
    '2-dimensional (x-y) image of a 3-dimensional function, whose z-axis ',...
    'is set by the Z-Axis menu of the Analysis window.  The bottom slider ',...
    'controls where to slice through the function: min --> left, ',...
    'max --> right, mean --> middle position.'],...
    '* This property can also be controlled by the min/mean/max buttons ',...
    'and the text boxes.',...
    '',...
    '--- Vertical Sliders: ---',...
    ['* Change the min and max values of the grayscale (or other colormap).  ',...
    'A logarithmic stretch of the colormap can be specified by the ',...
    '''Log'' button.'],...
    },...
    'Instructions')


% --- Executes on selection change in selectCMap.
function selectCMap_Callback(hObject, eventdata, handles)
% hObject    handle to selectCMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectCMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectCMap
h=getGUIData('LocustAnalysisWindow');
if isempty(h)
    return
end
cmap=getCMap2DPP(hObject);
try %#ok
   set(h,'Colormap',cmap);
end
color=getColor2DPP(cmap,get(handles.grayMinSlider, 'Value'));
set(handles.grayMinSlider, 'BackgroundColor', color);
color=getColor2DPP(cmap,get(handles.grayMaxSlider, 'Value'));
set(handles.grayMaxSlider, 'BackgroundColor', color);
drawnow;
plotFinalResults;


% --- Executes during object creation, after setting all properties.
function selectCMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectCMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function contourValueBox_Callback(hObject, eventdata, handles)
% hObject    handle to contourValueBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contourValueBox as text
%        str2double(get(hObject,'String')) returns contents of contourValueBox as a double
try
    contourValues=strtrim(get(hObject, 'String'));
    try
        contourValues=eval(contourValues);
    catch
        contourValues( contourValues == ',' |...
            contourValues == '[' | contourValues == ']' |...
            contourValues == '{' | contourValues == '}' |...
            contourValues == '(' | contourValues == ')' )=' ';
        contourValues=eval(['[', contourValues, ']']);
    end
    sz=size(contourValues);
    errorTitle='Contouring Error';
    if ~isnumeric(contourValues)
        errorText='Contour values must be numeric.';
        errordlg(errorText, errorTitle);
        error(errorText);
    elseif length(sz) > 2
        errorText='Contour values must evaluate to a vector.  Expresson evaluated to an array with  > 2 dimensions.';
        errordlg(errorText, errorTitle);
        error(errorText);
    elseif min(sz) > 1
        errorText='Contour values must evaluate to a vector.  Expression evaluates to a non-vector matrix.';
        errordlg(errorText, errorTitle);
        error(errorText);
    else
        if sz(1) > 1
            contourValues=contourValues';
        end
        contourValues(isinf(contourValues))=[];
        contourValues(isnan(contourValues))=[];
        set(hObject, 'String', formatVector(contourValues));
        set(hObject, 'BackgroundColor', 'w');
    end
catch
    contourValues=[];
    set(hObject, 'BackgroundColor', 'r');
end
if isempty(contourValues)
    set(handles.contourSlider, 'Enable', 'on');
    set(handles.contourText, 'Enable', 'on');
else
    set(handles.contourSlider, 'Enable', 'inactive');
    set(handles.contourText, 'Enable', 'off');
end


% --- Executes during object creation, after setting all properties.
function contourValueBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contourValueBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in minPlus.
function minPlus_Callback(hObject, eventdata, handles)
% hObject    handle to minPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of minPlus
set(handles.maxMinus, 'Value', 0);


% --- Executes on button press in maxMinus.
function maxMinus_Callback(hObject, eventdata, handles)
% hObject    handle to maxMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maxMinus
set(handles.minPlus, 'Value', 0);


% --- Executes on button press in contourLabels.
function contourLabels_Callback(hObject, eventdata, handles)
% hObject    handle to contourLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contourLabels


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
close(handles.set2DPlotParameters);
