function varargout = main_gui(varargin)
%{
Created by: Chris Cadonic
=====================================================
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
%set all kinetics buttons to default value (decoupled)

% Choose default command line output for main_gui
handles.output = hObject;

%take in the setup parameters from the 'main.m' function
handles.parameters = varargin{1};

%store all graph handles in the handles structure as an array
[handles.graphs{1:6}] = deal(handles.Cytc_plot, ...
    handles.O2_plot,handles.OCR_plot,handles.H_N_plot,...
    handles.H_P_plot,handles.protons);

%label the axes for all graphs
graphLabel(handles);

%insert the initial paramter values into the textboxes
set(handles.V_max_edit,'String',handles.parameters.Vmax);
set(handles.K_1_edit,'String',handles.parameters.K1);
set(handles.K_m_edit,'String',handles.parameters.Km);
set(handles.p1_edit,'String',handles.parameters.p1);
set(handles.p2_edit,'String',handles.parameters.p2);
set(handles.p3_edit,'String',handles.parameters.p3);
set(handles.f0_edit,'String',handles.parameters.f0);
set(handles.Dh_edit,'String',handles.parameters.Dh);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%% Main Callback Functions

function optimize_Callback(hObject, eventdata, handles) %optimize button

%run Qubist for optimization
launchQubist

function V_max_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newVmax = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.Vmax = newVmax;
guidata(hObject,handles);

function K_1_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newK1 = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.K1 = newK1;
guidata(hObject,handles);

function K_m_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newKm = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.Km = newKm;
guidata(hObject,handles);

function p1_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newp1 = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.p1 = newp1;
guidata(hObject,handles);

function p2_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newp2 = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.p2 = newp2;
guidata(hObject,handles);

function p3_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newp3 = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.p3 = newp3;
guidata(hObject,handles);

function f0_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newf0 = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.f0 = newf0;
guidata(hObject,handles);

function Dh_edit_Callback(hObject, eventdata, handles)
%extract the new value input by the user
newDh = str2double(get(hObject, 'String'));

%update the model with this new value
handles.parameters.Dh = newDh;
guidata(hObject,handles);

function figcytc_Callback(hObject, eventdata, handles)
openFig(handles.Cytc_plot,handles,1);

function fighn_Callback(hObject, eventdata, handles)
openFig(handles.H_N_plot,handles,4);

function fighp_Callback(hObject, eventdata, handles)
openFig(handles.H_P_plot,handles,5);

function figo2_Callback(hObject, eventdata, handles)
openFig(handles.O2_plot,handles,2);

function figocr_Callback(hObject, eventdata, handles)
openFig(handles.OCR_plot,handles,3);

function figprot_Callback(hObject, eventdata, handles)
openFig(handles.protons,handles,6);

%% Plot Callback function
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

%% Graph Labeling Function
function graphLabel(handles)
%{
since updating the axes elements resets the axis properties such as title,
this function is called each time a figure is plotted so as to reset the
titles and labels to the proper text.
%}
for i=1:numel(handles.parameters.title)
    axes(handles.graphs{i})
    xlabel(handles.parameters.xlab,'FontName','Calibri');
    ylabel(handles.parameters.ylab{i},'FontName','Calibri');
    title(textwrap({handles.parameters.title{i}},30), ...
        'FontWeight','bold');
end

%% Open Large Figure Function
function openFig(hObject,handles,ObjNum)
%open a new figure using the graph from the relevant axes
h2copy = allchild(hObject); %extract all children from hObject
if isempty(h2copy) %check to see if the graph exists yet
    msgbox(['This function has not been plotted yet. ' ...
        'Please use the plot button below to graph the function before opening it.'],'No Plot');
else
    figure('units','normalized','outerposition',[0 0 1 1]); %create the figure
    hParent = axes; %create handle for axes child
    copyobj(h2copy,hParent) %copy the original graph to the new fig

    %now add the correct labels to the new figure
    xlabel(handles.parameters.xlab,'FontName','Calibri');
    ylabel(handles.parameters.ylab{ObjNum},'FontName','Calibri');
    title(handles.parameters.title{ObjNum},'FontWeight','bold');
end
