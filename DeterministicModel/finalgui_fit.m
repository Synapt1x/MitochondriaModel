function varargout = finalgui_fit(varargin)
%{
Created by: Chris Cadonic
=======================================
This function handles the user interface for fitting the model. The
user can start Qubist, and contrast how varying the parameters
of the model affects the output of the model with experimental
data. The user may also load new data to fit, and so on.

The instantiation code and object creation code are generated by
GUIDE in matlab. The remaining code was written specifically to
allow functionality in the program and is specific to the model.
GUIDE was primarily used for the interface, and to lay out elements
All Callback functions were programmed manually for use in this
model.
%}

% Last Modified by GUIDE v2.5 09-Feb-2015 12:53:55

%% Initialization Code
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_gui_OpeningFcn, ...
    'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


%% GUI Creation code
% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for main_gui
handles.output = hObject;

%take in the setup parameters from the 'finalgui.m' function
if ~isempty(varargin)
    handles.parameters = varargin{1};
    
    which_fit = {'Fitting: Control Data', 'Fitting: Experimental Data'};
    
    set(handles.fitting_data_text, 'String', ...
        which_fit{handles.parameters.data_fitting});
    
    handles.ctrlParams = varargin{1}.ctrlParams;
    handles.expParams = varargin{1}.expParams;
    
    % get all the data into the handles structure
    handles.data = varargin{2};
    
    %cell array for whether fitting ctrl or Alz data
    handles.data.data_types = {'CtrlO2', 'AlzO2', 'CtrlOCR', 'AlzOCR'};
    
    % store all the model equation system handles in a structure
    handles.models = varargin{3};
end

%add callback and model funcs dir to path
addpath([handles.parameters.curdir, filesep, 'CallbackFuncs']);
addpath(genpath([handles.parameters.curdir, filesep, 'ModelEquations']));
addpath(genpath([handles.parameters.curdir, filesep, 'UnitTests']));

%set the default model to be the custom CC full model
handles.selected_model = select_model(hObject, eventdata, handles);
handles.model_equations = handles.models.(handles.selected_model.Tag);

%store the default data for the model
for param=1:numel(handles.parameters.paramNames)
    handles.initialParams.(handles.parameters.paramNames{param}) = ...
        handles.ctrlParams.(handles.parameters.paramNames{param});
end
for initial_cond=1:numel(handles.parameters.conditionNames)
    handles.initialData(initial_cond) = ...
        handles.ctrlParams.(handles.parameters.conditionNames{initial_cond});
end

%store all graph handles in the handles structure as an array
[handles.graphs{1:2}] = deal(handles.O2_plot,handles.OCR_plot);

%label the axes for all graphs
graph_label(handles, 'fitting');

%store all exp editing text boxes in the handles structure as an array
[handles.allEdits{1:9}] = deal(handles.f0_Vmax_edit, ...
    handles.f0_Km_edit, handles.fIV_Vmax_edit, handles.fIV_Km_edit, ...
    handles.fIV_K_edit, handles.fV_Vmax_edit, handles.fV_Km_edit, ...
    handles.fV_K_edit, handles.p_leak_edit);

%store all initial concentrations text boxes in the handles structure as an
%array
[handles.allInitials{1:5}] = deal(handles.initial_cytctot_edit, ...
    handles.initial_cytcox_edit, handles.initial_cytcred_edit, ...
    handles.initial_o2_edit, handles.initial_hn_edit);


%insert the initial parameter values into the control and experimental textboxes
set_params_func(handles,handles.initialParams,'experimental');

%insert the initial concentration values into the textboxes
handles = set_initials_func(handles, [handles.parameters.cytctot, ...
    handles.parameters.cytcox, handles.parameters.cytcred, ...
    handles.parameters.O2, handles.parameters.Hn, ...
    handles.parameters.Hp]);

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Callback Functions

function finalgui_fit_WindowKeyPressFcn(hObject, eventdata, handles)
% Keypressfcn for the entire GUI
switch eventdata.Key
    case {'p','return'}
        plot_Callback(hObject,eventdata,handles);
    case 'r'
        randomizeButton_Callback(hObject,eventdata,handles);
    case 'd'
        params_default_Callback(hObject,eventdata,handles);
    case 'e'
        initial_default_Callback(hObject,eventdata,handles);
    case 'o'
        optimize_Callback(hObject, eventdata, handles);
    case 'l'
        loadparams_Callback(hObject, eventdata, handles);
end

function model_selector_selection_changed(hObject, eventdata, handles)
    [hObject, eventdata, handles] = model_selector_changed_func(hObject, ...
        eventdata, handles);
    
    guidata(hObject,handles);

function optimize_Callback(hObject, eventdata, handles) %optimize button

%run Qubist for optimization
launchQubist

function initial_cytctot_edit_Callback(hObject,eventdata,handles)
edit_box(hObject,handles,'initial','Cytctot');

%get current total Cyt C
currTot = hObject.String;
newCytcred = 0;

while ~(newCytcred)
    takeVal = inputdlg(['What will be the initial value of Cyt C ', ...
        'reduced? The remaining value from the total amount of ', ...
        'Cytochrome C will be set as Cyt C oxidized. The New value ', ...
        'of Cytochrome C Total: ',num2str(currTot),'.'], ...
        'Set Cytochrome Cyt C reduced');
    newCytcred = check_input(str2double(takeVal{1}),currTot);
end
newCytcox = str2double(currTot) - newCytcred;

%update the values in boxes and parameters structure
handles.initial_cytcox_edit.String = num2str(newCytcox);
handles.parameters.cytcox = newCytcox;
handles.initial_cytcred_edit.String = num2str(newCytcred);
handles.parameters.cytcred = newCytcred;
handles.parameters.cytctot = str2double(currTot);

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Edit boxes for Initial conditions and Parameters

function initial_cytcox_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','cytcox');
guidata(hObject,handles);

function initial_cytcred_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','cytcred');
guidata(hObject,handles);

function initial_o2_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','O2');
guidata(hObject,handles);

function initial_hn_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','Hn');
guidata(hObject,handles);

function initial_ph_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = change_pH(hObject, handles);
guidata(hObject, handles);

function V_max_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fIV_Vmax');
guidata(hObject,handles);

function K_1_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fIV_K');
guidata(hObject,handles);

function K_m_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fIV_Km');
guidata(hObject,handles);

function p1_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fV_Vmax');
guidata(hObject,handles);

function p2_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fV_K');
guidata(hObject,handles);

function p3_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','fV_Km');
guidata(hObject,handles);

function f0Vmax_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','f0_Vmax');
guidata(hObject,handles);

function f0Km_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','f0_Km');
guidata(hObject,handles);

function p_fccp_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','p_fccp');
guidata(hObject,handles);

function alpha_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','alpha');
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Additional buttons
%function for randomizing initial conditions
function randomizeButton_Callback(hObject,eventdata,handles)
%generate random vector
randomVect = randn(1,5)*25+100; % 4 initial conditions
randomVect(3) = randn*0.0033+0.01; % set cyt c red very very low initially
randomVect(1) = randomVect(2) + randomVect(3); % set cyt c tot to ox + red
randomVect(6) = (10^-(randn*1+7))*1E6; % randomize a pH

%send these values to set Initials to change boxes and parameters
handles = set_initials_func(handles, randomVect, 'randomize');
guidata(hObject,handles);

%function for resetting initial concentrations
function initial_default_Callback(hObject,eventdata,handles)
handles = set_initials_func(handles, handles.initialData(1:6), 'setDefault');
guidata(hObject,handles);

%function for resetting initial parameters
function params_default_Callback(hObject, eventdata, handles)
handles = set_params_func(handles, handles.initialParams(7:end), ...
    'control','setDefault');
handles = set_params_func(handles, handles.initialParams(7:end),  ...
    'experimental','setDefault');
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Menu Callback functions
%save the current version of fig
function save_fig_Callback(hObject, eventdata, handles)
%save the image and color map for the overall window
image = getframe(gcf);

try
    %save the image to a file specified by the user
    [filename,filepath]=uiputfile(fullfile(handles.parameters.curdir,'StateImages', ...
        [date,'-sessionImage.png']),'Save screenshot file');
    imwrite(image.cdata,[filepath,filename]);
    
    disp(['Image was successfully saved to: ', filepath,filename]);
catch % if an error is caught, don't throw error and instead abort save image
    disp('Snapshot save operation aborted.');
end

%save just the figures
function save_graphs_Callback(hObject, eventdata, handles)
% save the image and color map for the overall window
image = getframe(gcf);

%top_left = ginput(1);
%bot_right = ginput(1);

% crop just the graphs and store that as the image
image = imcrop(image.cdata,[565,79,817,685]);

try
    %save the image to a file specified by the user
    [filename,filepath]=uiputfile(fullfile(handles.parameters.curdir,'StateImages', ...
        [date,'-FitsessionImage.png']),'Save image of graphs to file');
    imwrite(image,[filepath,filename]);
    
    disp(['Image was successfully saved to: ', filepath,filename]);
catch % if an error is caught, don't throw error and instead abort save image
    disp('Saving image of graphs aborted.');
end

%save the workspace
function save_session_Callback(hObject,eventdata,handles)
%turn off 'use uisave' warning since uisave is in fact being used
warning('off','MATLAB:Figure:FigureSavedToMATFile');

try
    % save the current data found in the model
    currentdata = getappdata(gcf);
    [filename,filepath]=uiputfile(fullfile(handles.parameters.curdir,'Savestates', ...
        [date,'-FitSaveSession.mat']), 'Save session file');
    uisave('currentdata',[filepath,filename]);
    
    disp(['Session was successfully saved session file to: ', filepath,filename]);
catch % if an error is caught, don't throw error and instead abort save session
    disp('Session save operation aborted.');
end

%load a saved workspace
function load_session_Callback(hObject,eventdata,handles)
try
    [filename,filepath]=uigetfile(fullfile(handles.parameters.curdir,'Savestates','*.mat'), ...
        'Load session file');
    close(gcf);
    load([filepath,filename]);
    
    % check if it was a valid session file
    if (exist('currentdata'))
        disp('Session successfully loaded.');
    else % if not, reload finalgui to reset the GUI
        disp('.mat chosen was not a correct session savestate. Resetting GUI now.');
        finalgui_fit(handles.parameters);
    end
catch % if an error is caught, reload finalgui to reset the GUI
    disp('Session load operation aborted. Resetting GUI now.');
    finalgui_fit(handles.parameters);
end

function exit_prog_Callback(hObject, eventdata, handles)
disp('Goodbye! Thank you for using my mitochondrial model!');
close;

function version_Callback(hObject, eventdata, handles)
try
    [~,ver]=system('git describe --abbrev=0');
    msgbox(['The current version of this code is ',ver(1:end-1),'.'],'Code Version');
catch
    mshbox('To check the code version, "git" is required.','Git not found');
end

function info_Callback(hObject,eventdata, handles)
cd ..; % go up one directory level
open('README.md'); %open the readme file
cd DeterministicModel; % Re-enter DeterministicModel directory

function save_graph_Callback(hObject, eventdata, handles)
%output the figure to be saved
newgraph = open_graph('save');

%acquire the desired name for the figure
[figname,figpath]=uiputfile('.png','Please save the figure file.');

%save figure into fig file pointed out by the user
if ischar(figname) %check if user selected an output name
    set(newgraph,'color','w');
    export_fig(newgraph,[figpath,figname]);
else %if not, then abort saving and provide message
    msgbox('No output file name provided.','Operation aborted.');
end
%close the figure to free memory
close(newgraph);

function open_graph_Callback(hObject, eventdata, handles)
open_graph; %simply open the figure in a new window

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Graphs Callback
function plot_Callback(hObject, eventdata, handles) %plot button in gui

[hObject, handles] = plot_fit_func(hObject, handles); %call the plot fit function

%update all the graph axes
graph_label(handles, 'fitting');

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Previous Solutions Button
function loadparams_Callback(hObject,eventdata,handles)

%open dialog for user to navigate to file
[filename,filepath] = uigetfile(fullfile(handles.parameters.curdir, ...
    'Solutions','*-BestResults.mat'),['Select the "BestResults.mat"', ...
    'containing the parameter set to load']);

if ischar(filename) %if a file is selected, load that file
    load([filepath,filename]); %load the file
    
    values = [];
    
    for j=1:1:length(fieldnames(bestSet))-1
        values(j) = bestSet.(handles.parameters.paramNames{j});
    end
    
    %change all the values of parameters to loaded parameter set
    handles = set_params_func(handles,values','exp','changeVals');
    
    %update initial values
    handles = set_initials_func(handles, [handles.expParams.cytctot, ...
    handles.expParams.cytcox, handles.expParams.cytcred, ...
    handles.parameters.O2, handles.parameters.Hn, ...
    handles.parameters.Hp]);
    %additional argin signals set_params_func to update handles.parameters
    guidata(hObject,handles);
else
    disp('No file selected. Load parameters operation aborted.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Close optimization window callback
function DeleteFcn_Callback(hObject, eventdata, handles)
delete('temp-data_fitting.mat');