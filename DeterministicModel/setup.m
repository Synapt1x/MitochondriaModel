function parameters = setup
%{
Created by: Chris Cadonic
=====================================================
The setup function handles the values for each variable in the
system in a structure known as 'parameters'. parameters contains
all of the model's parameters and also the data, graph labels.
%}

%% Data Import
%import the real data
[parameters.timePoints,parameters.realo2Data, ...
    parameters.realOCR] = data_formatter;

%% Define the Parameters of the Model
%parameter values
parameters.Vmax =2825.4; %bounds: [0.1 1E4]
parameters.K1 = 1495; %bounds: [0.1 1E4]
parameters.Km = 2096.1; %bounds: [0.1 1E4]
parameters.p1 = 40.5013; %bounds: [1 1E4]
parameters.p2 = 1477.4; %bounds: [1 1E4]
parameters.p3 = 1.415e-5; %bounds: [1E-6 1]
parameters.f0 = 1.1797; %bounds: [1 1E4]
parameters.Dh = 2.4025e-7; %bounds: [1E-6 1]


%% Define Initial Conditions
%initial conditions
parameters.Cytcox = 100;
parameters.Cytcred = 100;
parameters.O2 = parameters.realo2Data(1);
parameters.Hn = 1000;
parameters.Hp = 100;

%parameters for defining the IV of the region of interest
parameters.initialConditions = [parameters.Cytcred,parameters.O2, ...
    parameters.Hn,parameters.Hp]; %Initial Vs

%% Define boundary times for integration
%define the time boundaries between conditions
oligoTime = min(find(parameters.timePoints>=121.8));
fccpTime = min(find(parameters.timePoints>=271.8));
inhibitTime = min(find(parameters.timePoints>=432));

%define the arrays holding the time points for each section
parameters.baselineTimes = parameters.timePoints(1:oligoTime-1);
parameters.oligoTimes = parameters.timePoints(oligoTime:fccpTime-1);
parameters.FCCPTimes = parameters.timePoints(fccpTime:inhibitTime-1);
parameters.inhibitTimes = parameters.timePoints(inhibitTime:end);

%number of points in each section
numpoints = [numel(parameters.baselineTimes),numel(...
    parameters.oligoTimes),numel(parameters.FCCPTimes), ...
    numel(parameters.inhibitTimes)];

%format the realOCR to repeat OCR avg at each time point in time vector
%make sure to add to the rude function to path to format this properly
parameters.realOCRgraph = rude(numpoints,parameters.realOCR)';

%% Define the labels and titles for GUI Graphs
%titles and labels for the output graphs
[parameters.title{1:6}] = deal(['Reduced cytochrome c concentration over'...
    ' time'],'Oxygen concentration over time', ...
    'Oxygen consumption rate over time', ...
    'Matrix proton concentration over time',...
    'Intermembrane space proton concentration over time',...
    'Total proton concentration over time');
[parameters.ylab{1:6}] = deal('Cyt c_{red} (mmol)', ...
    'O_2 (mmol)','OCR (mmol/sec)','H_N (mmol)',['delta '...
    'H_N (mmol/sec)'],'H_{total} (mmol)');
parameters.xlab = 'Time (sec)';