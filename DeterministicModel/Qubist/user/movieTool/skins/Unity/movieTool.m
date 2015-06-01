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

function varargout = movieTool(varargin)
% MOVIETOOL M-file for movieTool.fig
%      MOVIETOOL, by itself, creates a new MOVIETOOL or raises the existing
%      singleton*.
%
%      H = MOVIETOOL returns the handle to a new MOVIETOOL or the handle to
%      the existing singleton*.
%
%      MOVIETOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIETOOL.M with the given input arguments.
%
%      MOVIETOOL('Property','Value',...) creates a new MOVIETOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before movieTool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to movieTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help movieTool

% Last Modified by GUIDE v2.5 15-May-2009 20:22:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @movieTool_OpeningFcn, ...
                   'gui_OutputFcn',  @movieTool_OutputFcn, ...
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


% --- Executes just before movieTool is made visible.
function movieTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to movieTool (see VARARGIN)

% Set default colours for all components.
matchColours(hObject);

% Choose default command line output for movieTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    showBackground(hObject);
end

% UIWAIT makes movieTool wait for user response (see UIRESUME)
% uiwait(handles.movieTool);

% --- Outputs from this function are returned to the command line.
function varargout = movieTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function fpsSlider_Callback(hObject, eventdata, handles)
% hObject    handle to fpsSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue=round(get(hObject, 'Value'));
set(handles.fpsText, 'String', ['FPS = ', num2str(sliderValue)]);

% --- Executes during object creation, after setting all properties.
function fpsSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fpsSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function qualitySlider_Callback(hObject, eventdata, handles)
% hObject    handle to qualitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue=round(get(hObject, 'Value'));
set(handles.qualityText, 'String', ['Quality = ', num2str(sliderValue)]);

% --- Executes during object creation, after setting all properties.
function qualitySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qualitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in compressorChoice.
function compressorChoice_Callback(hObject, eventdata, handles)
% hObject    handle to compressorChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns compressorChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from compressorChoice


% --- Executes during object creation, after setting all properties.
function compressorChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compressorChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

compressors=get(hObject, 'String');
if ischar(compressors)
    % It seems that this comes out as a char string under Linux, but a cell
    % array under other platforms.
    compressors={compressors};
end
if ispc
    defaultCompressor='Indeo3';
    allowedCompressors={'All'};
else
    defaultCompressor='None';
    allowedCompressors={'None'};
end
DC=0;
for c=length(compressors):-1:1
    if strcmpi(allowedCompressors{1}, 'All')
        continue
    else
        enable=0;
        for a=1:length(allowedCompressors)
            if strcmpi(compressors{c}, allowedCompressors{a})
                enable=1;
                break
            end
        end
        if ~enable
            compressors(c)=[];
        end
    end
end
set(hObject, 'String', compressors);
for c=length(compressors):-1:1
    if ~DC && strcmpi(compressors{c}, defaultCompressor)
        DC=c;
        set(hObject, 'Value', DC);
    end
end

% --- Executes on button press in selectFrame.
function selectFrame_Callback(hObject, eventdata, handles)
% hObject    handle to selectFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Start in the most recent dataDir if possible, or a directory above it.
dataDir=getStartDataDir;
%
% Select the file.
disp('*** Select the 1st frame of your movie. ***');
[data.firstFrame, data.framesDir]=uigetfile('*.*', 'Select the 1st frame of your movie.', dataDir);
if data.framesDir(end) == filesep
    data.framesDir(end)=[];
end
data.fullFileName=fullfile(data.framesDir, data.firstFrame);
%
% What type of file is this?
index=strfind(data.firstFrame, '.');
if isempty(index)
    uiwait(warndlg('The selected file does not have an extension.  Exiting.',...
        'Invalid file type'));
    return
end
extension=data.firstFrame(index(end):end);
if strcmpi(extension, '.mat')
    % It's a History file.  Set the last project & dataDir paths.
    setpref('Qubist', 'lastDataDir', fileparts(data.framesDir));
else
    % Assume that it's an image format.
    AIF=auxImageFrame;
    g=guidata(AIF);
    try
        I=feval('imread', data.fullFileName); % Creates variable movieFrame.
        cla(g.axes1);
        imagesc(I, 'Parent', g.axes1);
        axis(g.axes1, 'image');
        AIFName=['movieTool: image = ', data.firstFrame];
        set(AIF, 'NumberTitle', 'off', 'Name', AIFName);
        set(g.axes1, 'box', 'on', 'XTick', [], 'YTick', []);
    catch
        errordlg(['An error occured while drawing the image.  ',...
            'Make sure that this is really an image file.'],...
            'Image Error')
        return
    end
end
set(hObject, 'UserData', data);
disp(['First frame: ', data.firstFrame]);

% --- Executes on button press in generateMovie.
function generateMovie_Callback(hObject, eventdata, handles)
% hObject    handle to generateMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)'
data=get(handles.selectFrame, 'UserData');
if isempty(data)
    errordlg('You must select a movie frame 1st!',...
        'Error Generating Movie');
    return
end
fps=get(handles.fpsSlider, 'Value');
quality=get(handles.qualitySlider, 'Value');
index=get(handles.compressorChoice, 'Value');
switch index
    case 1,
        compressor=''; % Default
    case 2,
        compressor='Indeo3';
    case 3,
        compressor='Indeo5';
    case 4,
        compressor='Cinepak';
    case 5,
        compressor='MSVC';
    case 6,
        compressor='None';
end
generateMovie(data.framesDir, data.firstFrame, fps, quality, compressor);


function compressorText_Callback(hObject, eventdata, handles)
% hObject    handle to compressorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compressorText as text
%        str2double(get(hObject,'String')) returns contents of compressorText as a double


% --- Executes during object creation, after setting all properties.
function compressorText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compressorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fpsText_Callback(hObject, eventdata, handles)
% hObject    handle to fpsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fpsText as text
%        str2double(get(hObject,'String')) returns contents of fpsText as a double


% --- Executes during object creation, after setting all properties.
function fpsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fpsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function qualityText_Callback(hObject, eventdata, handles)
% hObject    handle to qualityText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qualityText as text
%        str2double(get(hObject,'String')) returns contents of qualityText as a double


% --- Executes during object creation, after setting all properties.
function qualityText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qualityText (see GCBO)
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
close(handles.movieTool);
