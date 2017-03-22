function varargout = finalgui(varargin)
%{
Created by: Chris Cadonic
=======================================
This function handles the user interface for the model, which
provides a GUI that allows the model to be fully accessible. The
user can alter parameters and manipulate the model, run additional
simulations, and thus view how alterations affect the model
without having to restart the model.

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

%take in the setup parameters from the 'main.m' function
if ~isempty(varargin)
    handles.parameters = varargin{1};
    handles.parameters.data_fitting = 1; %default fit for control data
    
    handles.ctrlParams = varargin{1}.ctrlParams;
    handles.expParams = varargin{1}.expParams;
    
    % get all the data into the handles structure
    handles.data = varargin{2};
end

%add callback funcs dir to path
addpath([handles.parameters.curdir, filesep, 'CallbackFuncs']);

%store the default data for the model
for param=1:numel(handles.parameters.paramNames)
    handles.initialParams.(handles.parameters.paramNames{param}) = ...
        handles.ctrlParams.(handles.parameters.paramNames{param});
end
for initial_cond=1:numel(handles.parameters.conditionNames)
    handles.initialData.(handles.parameters.conditionNames{initial_cond}) = ...
        handles.ctrlParams.(handles.parameters.conditionNames{initial_cond});
end

%store all graph handles in the handles structure as an array
[handles.graphs{1:5}] = deal(handles.Cytc_plot, ...
    handles.O2_plot,handles.OCR_plot,handles.H_N_plot,...
    handles.H_P_plot);

%store all control editing text boxes in the handles structure as an array
[handles.allcontEdits{1:9}] = deal(handles.V_max_cedit, handles.K_1_cedit, ...
    handles.K_m_cedit,handles.p1_cedit,handles.p2_cedit, handles.p3_cedit, ...
    handles.f0Vmax_cedit, handles.f0Km_cedit, handles.Dh_cedit);

%store all exp editing text boxes in the handles structure as an array
[handles.allEdits{1:9}] = deal(handles.V_max_edit, handles.K_1_edit, ...
    handles.K_m_edit,handles.p1_edit,handles.p2_edit, handles.p3_edit, ...
    handles.f0Vmax_edit, handles.f0Km_edit, handles.Dh_edit);

%store all initial concentrations text boxes in the handles structure as an
%array
[handles.allInitials{1:5}] = deal(handles.initial_cytctot_edit, ...
    handles.initial_cytcox_edit, handles.initial_cytcred_edit, ...
    handles.initial_o2_edit, handles.initial_hn_edit);

%label the axes for all graphs
graph_label(handles);

%insert the initial parameter values into the control and experimental textboxes
set_params_func(handles,handles.initialParams,'control');
set_params_func(handles,handles.initialParams,'experimental');

%insert the initial concentration values into the textboxes
handles = set_initials_func(handles, [handles.parameters.cytctot, ...
    handles.parameters.cytcox, handles.parameters.cytcred, ...
    handles.parameters.O2, handles.parameters.Hn, ...
    handles.parameters.Hp]);

%insert the initial conditions into the textboxes
set(findall(handles.controlGroup,'-property','Enable'),'Enable','off');

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Callback Functions

function finalgui_WindowKeyPressFcn(hObject, eventdata, handles)
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

function optimize_Callback(hObject, eventdata, handles) %optimize button

%determine which data set will be fit in this call
which_fit = questdlg('Which data set will you be fitting?', ...
    'Select data type for fitting', 'Control', 'Alzheimers', 'Cancel', 'Cancel');
switch which_fit
    case 'Control'
        handles.parameters.data_fitting = 1;
        data_fit = {handles.parameters.data_fitting};
        save('temp-data_fitting.mat', 'data_fit')

        %open the optimization window
        finalgui_fit(handles.parameters, handles.data);
        
    case 'Alzheimers'
        handles.parameters.data_fitting = 2;
        data_fit = {handles.parameters.data_fitting};
        save('temp-data_fitting.mat', 'data_fit')
        
        %open the optimization window
        finalgui_fit(handles.parameters, handles.data);
        
    case 'Cancel'
        handles.parameters.data_fitting = 1;
        data_fit = {handles.parameters.data_fitting};
        save('temp-data_fitting.mat', 'data_fit')
        
        waitfor(msgbox('Optimization cancelled.', 'Cancelled.'));
end


function initial_cytctot_edit_Callback(hObject,eventdata,handles)
edit_box(hObject,handles,'initial','Cytctot');

%get current total Cyt C
currTot = str2double(get(hObject,'String'));
newCytcred = 0;

while ~(newCytcred)
    takeVal = inputdlg(['What will be the initial value of Cyt C ', ...
        'reduced? The remaining value from the total amount of ', ...
        'Cytochrome C will be set as Cyt C oxidized. The New value ', ...
        'of Cytochrome C Total: ',num2str(currTot),'.'], ...
        'Set Cytochrome Cyt C reduced');
    newCytcred = check_input(str2double(takeVal{1}),currTot);
end
newCytcox = currTot - newCytcred;

%update the values in boxes and parameters structure
set(handles.initial_cytcox_edit,'String',num2str(newCytcox));
handles.parameters.Cytcox = newCytcox;
set(handles.initial_cytcred_edit,'String',num2str(newCytcred));
handles.parameters.Cytcred = newCytcred;
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Edit boxes for Initial conditions and Parameters

function initial_cytcox_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','Cytcox');
guidata(hObject,handles);

function initial_cytcred_edit_Callback(hObject,eventdata,handles)
[hObject, handles] = edit_box(hObject,handles,'initial','Cytcred');
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

function V_max_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','Vmax');
guidata(hObject,handles);

function K_1_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','K1');
guidata(hObject,handles);

function K_m_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','Km');
guidata(hObject,handles);

function p1_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','p1');
guidata(hObject,handles);

function p2_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','p2');
guidata(hObject,handles);

function p3_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','p3');
guidata(hObject,handles);

function f0Vmax_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','f0Vmax');
guidata(hObject,handles);

function f0Km_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','f0Km');
guidata(hObject,handles);

function Dh_cedit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'control','Dh');
guidata(hObject,handles);

function V_max_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','Vmax');
guidata(hObject,handles);

function K_1_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','K1');
guidata(hObject,handles);

function K_m_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','Km');
guidata(hObject,handles);

function p1_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','p1');
guidata(hObject,handles);

function p2_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','p2');
guidata(hObject,handles);

function p3_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','p3');
guidata(hObject,handles);

function f0Vmax_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','f0Vmax');
guidata(hObject,handles);

function f0Km_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','f0Km');
guidata(hObject,handles);

function Dh_edit_Callback(hObject, eventdata, handles)
[hObject, handles] = edit_box(hObject,handles,'experimental','Dh');
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Additional buttons
%function for allowing editing in the control parameters
function enableCont_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(findall(handles.controlGroup,'-property','Enable'),'Enable','on');
else
    set(findall(handles.controlGroup,'-property','Enable'),'Enable','off');
end;

%function for allowing editing in the control parameters
function enableExp_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(findall(handles.experimentalGroup,'-property','Enable'),'Enable','on');
else
    set(findall(handles.experimentalGroup,'-property','Enable'),'Enable','off');
end;

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
handles = set_initials_func(handles, handles.initialData(:), 'setDefault');
guidata(hObject,handles);

%function for resetting initial parameters
function params_default_Callback(hObject, eventdata, handles)
handles = set_params_func(handles, handles.initialParams(:), ...
    'control','setDefault');
handles = set_params_func(handles, handles.initialParams(:),  ...
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

% crop just the graphs and store that as the image
image = imcrop(image.cdata,[565,79,817,685]);

try
    %save the image to a file specified by the user
    [filename,filepath]=uiputfile(fullfile(handles.parameters.curdir,'StateImages', ...
        [date,'-sessionImage.png']),'Save image of graphs to file');
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
        [date,'-SaveSession.mat']), 'Save session file');
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
        finalgui(handles.parameters);
    end
catch % if an error is caught, reload finalgui to reset the GUI
    disp('Session load operation aborted. Resetting GUI now.');
    finalgui(handles.parameters);
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
function plot_Callback(hObject, eventdata, handles) % plot button in gui

[hObject, handles] = plot_func(hObject, handles); %call the plot function

% %update all the graph axes
graph_label(handles);

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
    
    %change all the values of parameters to loaded parameter set
    handles = set_params_func(handles,myResults','experimental','changeVals');
    %additional argin signals set_params_func to update handles.parameters
    guidata(hObject,handles);
else
    disp('No file selected. Load parameters operation aborted.');
end