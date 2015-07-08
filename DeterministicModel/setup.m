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
parameters.Vmax =5.07198140424508; %bounds: [0.1 1E4]
parameters.K1 = 995.198918111726; %bounds: [0.1 1E4]
parameters.Km = 1999.99718259769; %bounds: [0.1 1E4]
parameters.p1 = 99.9995776218140; %bounds: [1 1E4]
parameters.p2 = 50.0003; %bounds: [1 1E4]
parameters.p3 = 0.000100001381209052; %bounds: [1E-6 1]
parameters.f0 = 50.0000000000048; %bounds: [1 1E4]
parameters.Dh = 9.99998980711126; %bounds: [1E-6 1]


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
%define the time boundaries between conditions; First instance of segment
%change
parameters.oligoTime = min(find(parameters.timePoints>=121.8));
parameters.fccpTime = min(find(parameters.timePoints>=271.8));
parameters.inhibitTime = min(find(parameters.timePoints>=432));

%define the arrays holding the time points for each section
parameters.baselineTimes = parameters.timePoints( ...
    1:parameters.oligoTime-1);
parameters.oligoTimes = parameters.timePoints( ...
    parameters.oligoTime:parameters.fccpTime-1);
parameters.fccpTimes = parameters.timePoints( ...
    parameters.fccpTime:parameters.inhibitTime-1);
parameters.inhibitTimes = parameters.timePoints( ...
    parameters.inhibitTime:end);

%number of points in each section
parameters.numpoints = [numel(parameters.baselineTimes),numel(...
    parameters.oligoTimes),numel(parameters.fccpTimes), ...
    numel(parameters.inhibitTimes)];

%format the realOCR to repeat OCR avg at each time point in time vector
%make sure to add to the rude function to path to format this properly
parameters.realOCRgraph = rude(parameters.numpoints,parameters.realOCR)';

%% Define the labels and titles for GUI Graphs
%titles and labels for the output graphs
[parameters.title{1:6}] = deal(['Reduced cytochrome c concentration over'...
    ' time'],'Oxygen concentration over time', ...
    'Oxygen consumption rate over time', ...
    'Matrix proton concentration over time',...
    'Intermembrane space proton concentration over time',...
    'Total proton concentration over time');
[parameters.ylab{1:6}] = deal('Cyt c_{red} (nmol)', ...
    'O_2 (nmol)','OCR (nmol/sec)','H_N (nmol)',['delta '...
    'H_N (nmol/sec)'],'H_{total} (nmol)');
parameters.xlab = 'Time (sec)';