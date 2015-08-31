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
end

%store the default data for the model
handles.initialData = [handles.parameters.Cytctot, ...
        handles.parameters.Cytcox, handles.parameters.Cytcred, ...
        handles.parameters.O2, handles.parameters.Hn, ...
        handles.parameters.Hp, handles.parameters.Vmax, ...
        handles.parameters.K1, handles.parameters.Km, ...
        handles.parameters.p1, handles.parameters.p2, ...
        handles.parameters.p3, handles.parameters.f0Vmax, ...
        handles.parameters.f0Km, handles.parameters.Dh];

%store all graph handles in the handles structure as an array
[handles.graphs{1:6}] = deal(handles.Cytc_plot, ...
        handles.O2_plot,handles.OCR_plot,handles.H_N_plot,...
        handles.H_P_plot,handles.protons);

%store all control editing text boxes in the handles structure as an array
[handles.allcontEdits{1:9}] = deal(handles.V_max_cedit, handles.K_1_cedit, ...
        handles.K_m_cedit,handles.p1_cedit,handles.p2_cedit, handles.p3_cedit, ...
        handles.f0Vmax_cedit, handles.f0Km_edit, handles.Dh_cedit);

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
graphLabel(handles);

%insert the initial parameter values into the textboxes
setParams(hObject,handles,[handles.parameters.Vmax, ...
        handles.parameters.K1, handles.parameters.Km, ...
        handles.parameters.p1, handles.parameters.p2, ...
        handles.parameters.p3, handles.parameters.f0Vmax, ...
        handles.parameters.f0Km, handles.parameters.Dh]);

%insert the initial concentration values into the textboxes
setInitials(hObject, handles, [handles.parameters.Cytctot, ...
        handles.parameters.Cytcox, handles.parameters.Cytcred, ...
        handles.parameters.O2, handles.parameters.Hn, ...
        handles.parameters.Hp]);

%insert the initial conditions into the textboxes
set(findall(handles.controlGroup,'-property','Enable'),'Enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%% Main Callback Functions

function optimize_Callback(hObject, eventdata, handles) %optimize button

%run Qubist for optimization
launchQubist

function initial_cytctot_edit_Callback(hObject,eventdata,handles)
editBox(hObject,handles,'Cytctot');

%get current total Cyt C
currTot = str2double(get(hObject,'String'));
newCytcred = 0;

while ~(newCytcred)
        takeVal = inputdlg(['What will be the initial value of Cyt C ', ...
                'reduced? The remaining value from the total amount of ', ...
                'Cytochrome C will be set as Cyt C oxidized. The New value ', ...
                'of Cytochrome C Total: ',num2str(currTot),'.'], ...
                'Set Cytochrome Cyt C reduced');
        newCytcred = ensureRightInput(str2double(takeVal{1}),currTot);
end
newCytcox = currTot - newCytcred;

%update the values in boxes and parameters structure
set(handles.initial_cytcox_edit,'String',num2str(newCytcox));
handles.parameters.Cytcox = newCytcox;
set(handles.initial_cytcred_edit,'String',num2str(newCytcred));
handles.parameters.Cytcred = newCytcred;
guidata(hObject,handles);

function initial_cytcox_edit_Callback(hObject,eventdata,handles)
editBox(hObject,handles,'Cytcox');

function initial_cytcred_edit_Callback(hObject,eventdata,handles)
editBox(hObject,handles,'Cytcred');

function initial_o2_edit_Callback(hObject,eventdata,handles)
editBox(hObject,handles,'O2');

function initial_hn_edit_Callback(hObject,eventdata,handles)
editBox(hObject,handles,'Hn');

function initial_ph_edit_Callback(hObject,eventdata,handles)
getHpconc = 0;
oldHp = 0;
newHp = 0;
getVal = str2double(get(hObject,'String'));

if isnan(getVal) %if not, throw error box and reset value
        msgbox('Please input a valid number.','Not a number');
        
        %get the concentration value for resetting the edit box
        getHpconc = getfield(handles.parameters,'Hp');
        
        oldHp = -log10(getHpconc *1E-6);
        
        set(hObject,'String',oldHp);
else %if so, then update the model with new value
        %Hp from the given pH
        if checkpH(getVal)
                newHp = 10^-getVal * 1E6;
                handles.parameters = setfield(handles.parameters,'Hp',newHp);
        else
                %get the concentration value for resetting the edit box
                getHpconc = getfield(handles.parameters,'Hp');

                oldHp = -log10(getHpconc *1E-6);
                set(hObject,'String',oldHp);
        end
end

guidata(hObject,handles);

function V_max_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Vmax');

function K_1_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'K1');

function K_m_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Km');

function p1_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p1');

function p2_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p2');

function p3_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p3');

function f0Vmax_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'f0Vmax');

function f0Km_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'f0Km');

function Dh_cedit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Dh');

function V_max_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Vmax');

function K_1_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'K1');

function K_m_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Km');

function p1_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p1');

function p2_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p2');

function p3_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'p3');

function f0Vmax_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'f0Vmax');

function f0Km_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'f0Km');

function Dh_edit_Callback(hObject, eventdata, handles)
editBox(hObject,handles,'Dh');

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
setInitials(hObject,handles, randomVect, 'randomize');

%function for resetting initial concentrations
function initial_default_Callback(hObject,eventdata,handles)
setInitials(hObject, handles, [handles.initialData(1:6)], 'setDefault');

%function for resetting initial parameters
function params_default_Callback(hObject, eventdata, handles)
setParams(hObject, handles, [handles.initialData(7:end)], 'setDefault');

%% Load Previous Solutions Button
function loadparams_Callback(hObject,eventdata,handles)
folder = fileparts(which(mfilename)); %get the current folder

%open dialog for user to navigate to file
waitfor(msgbox('Please select the ''BestResults.mat'' file to load.','Load Parameter Set'));
[filename,filepath] = uigetfile({'*-BestResults.mat';'*.*'},'Select the .mat containing the parameter set to load');

if ischar(filename) %if a file is selected, load that file
        cd(filepath); %change to file's directory
        load(filename); %load the file
        cd(folder); %change to previous directory
        
        %change all the values of parameters to loaded parameter set
        setParams(hObject,handles,myResults','changeVals');
        %additional argin signals setParams to update handles.parameters
else
        msgbox('No file selected.','Aborted.');
end

%% Menu Callback functions
function save_fig_Callback(hObject, eventdata, handles) %save the current version of fig
%save the image and color map for the overall window
image = getframe(gcf);

try
        %save the image to a file specified by the user
        [filename,filepath]=uiputfile({[date,'-sessionImage.png']},'Save screenshot file');
        imwrite(image.cdata,[filepath,filename]);
        
        disp(['Image was successfully saved to: ', filepath,filename]);
catch % if an error is caught, don't throw error and instead abort save image
        disp('Snapshot save operation aborted.');
end

function save_session_Callback(hObject,eventdata,handles) %save the workspace
%turn off 'use uisave' warning since uisave is in fact being used
warning('off','MATLAB:Figure:FigureSavedToMATFile');

try
        % save the current data found in the model
        currentdata = getappdata(gcf);
        uisave('currentdata',[date,'-SaveSession.mat']);
        
        disp('Session was successfully saved.');
catch % if an error is caught, don't throw error and instead abort save session
        disp('Session save operation aborted.');
end

function load_session_Callback(hObject,eventdata,handles) %load a saved workspace
try
        [filename,filepath]=uigetfile({'*.mat'},'Load session file');
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
[~,ver]=system('git describe --abbrev=0');
msgbox(['The current version of this code is ',ver(1:end-1), ...
        ' and the most recent Git commit is "',cmt(1:end-1),'".'],'Code Version');

function info_Callback(hObject,eventdata, handles)
system('cd ..'); %go back a folder to get to the main readme file
open('README.md'); %open the readme file
system('cd DeterministicModel'); %go back into Deterministic Model

function save_graph_Callback(hObject, eventdata, handles)
%output the figure to be saved
newgraph = openGraph('save');

%acquire the desired name for the figure
[figname,figpath]=uiputfile('.png','Please save the figure file.');

%save figure into fig file pointed out by the user
if ischar(figname) %check if user selected an output name
        saveas(newgraph,[figpath,figname],'png');
else %if not, then abort saving and provide message
        msgbox('No output file name provided.','Operation aborted.');
end
%close the figure to free memory
close(newgraph);


function open_graph_Callback(hObject, eventdata, handles)
openGraph; %simply open the figure in a new window

%% Plot Graphs Callback
function plot_Callback(hObject, eventdata, handles) %plot button in gui

%plug in the equations into the ode solver
[t y] = solver(handles.parameters);

%store the values calculated for each variable
[cytcred o2 Hn Hp] = deal(y(:,1),y(:,2),y(:,3),y(:,4));

%calculate the OCR values from the oxygen
calcOCR = ((handles.parameters.Vmax.*o2)./(handles.parameters.Km.*...
        (1+(handles.parameters.K1./cytcred))+o2)).*Hn./Hp;

%plot the Cyt c concentration over time
axes(handles.Cytc_plot);
plot(t(2:end),cytcred(2:end),'b','lineWidth',2.5);

%plot the O2 concentration over time with real O2 data on top
axes(handles.O2_plot);
hold on
cla % clear axes
plot(t(2:end),o2(2:end),'b','lineWidth',2.5);
plot(t(2:end),handles.parameters.realo2Data(2:end),'g','lineWidth',2.5);
hold off

%plot the OCR over time with real OCR data on top
axes(handles.OCR_plot);
hold on
cla % clear axes
plot(t(2:end),calcOCR(2:end),'b','lineWidth',2.5);
plot(t(2:end),handles.parameters.realOCR(2:end),'g','lineWidth',2.5);
hold off

%plot the Hn concentration over time
axes(handles.H_N_plot);
plot(t(2:end),Hn(2:end),'b','lineWidth',2.5);

%plot the Hp concentration over time
axes(handles.H_P_plot);
plot(t(2:end),Hp(2:end),'b','lineWidth',2.5);

protRatio = (Hn./Hp); %calc total amount of protons

%plot the Hp rate of appearance over time
axes(handles.protons);
plot(t(2:end),protRatio(2:end),'b','lineWidth',2.5);

%update all the graph axes
graphLabel(handles);

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Graph Labeling Function
function graphLabel(handles)
%{
since updating the axes elements resets the axis properties such as title,
this function is called each time a figure is plotted so as to reset the
titles and labels to the proper text.
%}
for i=1:numel(handles.parameters.title)
        axes(handles.graphs{i})
        set(handles.graphs{i},'FontSize',8);
        xlabel(handles.parameters.xlab,'FontName','Helvetica','FontSize',8);
        ylabel(handles.parameters.ylab{i},'FontName','Helvetica','FontSize',8);
        title(textwrap({handles.parameters.title{i}},30), ...
                'FontWeight','bold','FontName','Helvetica','FontSize',9);
end

%% Open Clicked Figure in New Figure
function varargout = openGraph(varargin)
%determine which object was clicked
whichgraph = gco;
obj=get(gca);

%open a new figure using the graph from the relevant axes
h2copy = allchild(whichgraph); %extract all children from hObject
if isempty(h2copy) %check to see if the graph exists yet
        msgbox(['This function has not been plotted yet. ' ...
                'Please use the plot button below to graph the function before opening it.'],'No Plot');
else
        if ~isempty(varargin)
                newgraph = figure('Visible','Off','units','normalized','outerposition',[0 0 1 1]); %create the figure
        else
                newgraph = figure('units','normalized','outerposition',[0 0 1 1]); %create the figure
        end
        hParent = axes; %create handle for axes child
        copyobj(h2copy,hParent) %copy the original graph to the new fig
        
        %now add the correct labels to the new figure
        xlabel(obj.XLabel.String,'FontName','Calibri');
        ylabel(obj.YLabel.String,'FontName','Calibri');
        title(obj.Title.String,'FontSize',16,'FontWeight','bold','FontName','Calibri');
        
        %optionally output the figure for the 'save' feature
        varargout{1}=newgraph;
        
end

%% Change all parameter values
function setParams(hObject,handles,values,varargin)
%insert the parameter values passed to the function in the GUI

%loop over and change all the displayed values for the parameters
for i = 1:numel(handles.allEdits)
        set(handles.allEdits{i},'String',values(i));
end

%change all the values in the handles.parameters struc if vargin nonempty
if ~isempty(varargin)
        [handles.parameters.Vmax, handles.parameters.K1, ...
                handles.parameters.Km, handles.parameters.p1, ...
                handles.parameters.p2, handles.parameters.p3, ...
                handles.parameters.f0Vmax, handles.parameters.f0Km, ...
                handles.parameters.Dh] = deal(values(1), values(2), values(3), ...
                values(4), values(5),values(6),values(7),values(8), values(9));
end

%update the data in the gui
guidata(hObject,handles);

%% Change all Initial values
function setInitials(hObject,handles,values,varargin)
%insert the parameter values passed to the function in the GUI

%loop over and change all the displayed values for the parameters
for i = 1:numel(handles.allInitials)
        set(handles.allInitials{i},'String',values(i));
end

%calc pH from concentration and set the proper text box to it
setpH=-log10(values(6)*1E-6);
set(handles.initial_ph_edit,'String',setpH);

%change all the values in the handles.parameters struc if vargin nonempty
if ~isempty(varargin)
        [handles.parameters.Cytctot, handles.parameters.Cytcox, ...
                handles.parameters.Cytcred, handles.parameters.O2, ...
                handles.parameters.Hn, handles.parameters.Hp] = deal( ...
                values(1), values(2), values(3), values(4), values(5), values(6));
end

%update the data in the gui
guidata(hObject,handles);

%% Edit text box
function editBox(hObject,handles,paramChange)
%extract the new value input by the user
newVal = str2double(get(hObject, 'String'));

%check for whether or not a correct input was given
if isnan(newVal) %if not, throw error box and reset value
        msgbox('Please input a valid number.','Not a number');
        set(hObject,'String',getfield(handles.parameters,paramChange));
else %if so, then update the model with new value
        handles.parameters = setfield(handles.parameters,paramChange,newVal);
end
%also check to see if cytochrome c total needs to be updated
if strcmp(paramChange,'Cytcred')|strcmp(paramChange,'Cytcox')
        %update the total amount of cytochrome c total
        updateInitialCytctot(hObject,handles);
end

guidata(hObject,handles);


%% Update Initial Cytchrome C Total
function updateInitialCytctot(hObject,handles)
%get current total cyt c
newCytcox = str2double(get(handles.initial_cytcox_edit,'String'));
newCytcred = str2double(get(handles.initial_cytcred_edit,'String'));
newTot = newCytcox + newCytcred;

%increase cyt c tot by the amount of introduced cyt c red
set(handles.initial_cytctot_edit,'String',newCytcox+newCytcred);
handles.parameters.Cytctot = newTot;

%update the handles structure
guidata(hObject,handles);

%% Check for input value
function cytcred = ensureRightInput(input,currTot)
if ~isnumeric(input)
        msgbox('Not a valid number. Please enter a number.','Not a number');
else
        if input > currTot
                waitfor(msgbox(['Please enter a number less than the ', ...
                        'total amount of Cytochrome C. That is, less than ', ...
                        num2str(currTot),'.'], 'Cytochrome C reduced level too high'));
                cytcred = 0;
        else
                cytcred = input;
        end
end

%% Check for valid pH value
function validity = checkpH(value)
validity = true;
if (value < 0) || (value > 14)
        waitfor(msgbox('Not a valid pH.','Invalid pH'));
        validity = false;
elseif (value >= 11.88)
        waitfor(msgbox('Too basic for this system. Must be pH < 11.88.','pH too high'));
        validity = false;
end