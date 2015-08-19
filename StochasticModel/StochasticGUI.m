function varargout = StochasticGUI(varargin)
% STOCHASTICGUI MATLAB code for StochasticGUI.fig
%      STOCHASTICGUI, by itself, creates a new STOCHASTICGUI or raises the existing
%      singleton*.
%
%      H = STOCHASTICGUI returns the handle to a new STOCHASTICGUI or the handle to
%      the existing singleton*.
%
%      STOCHASTICGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STOCHASTICGUI.M with the given input arguments.
%
%      STOCHASTICGUI('Property','Value',...) creates a new STOCHASTICGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StochasticGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StochasticGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StochasticGUI

% Last Modified by GUIDE v2.5 19-Aug-2015 13:33:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StochasticGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StochasticGUI_OutputFcn, ...
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


% --- Executes just before StochasticGUI is made visible.
function StochasticGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StochasticGUI (see VARARGIN)

handles.specAmt=varargin{1};
handles.times=varargin{2};

% Choose default command line output for StochasticGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StochasticGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StochasticGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.OxygenPlot);
plot(handles.times,handles.specAmt(2,:));
xlabel('Time(s)')
ylabel('Oxygen Amount')

axes(handles.CytCPlot);
plot(handles.times, handles.specAmt(1,:));
xlabel('Time(s)')
ylabel('Cytochrome c Reduced Amount')

axes(handles.NADPlot)
plot(handles.times, handles.specAmt(6,:));
xlabel('Time(s)')
ylabel('NAD+ Amount')

axes(handles.HPPlot)
plot(handles.times, handles.specAmt(4,:)); 
xlabel('Time(s)')
ylabel('HP Amount')
