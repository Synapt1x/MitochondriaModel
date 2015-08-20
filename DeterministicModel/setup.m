function parameters = setup
%{
Created by: Chris Cadonic
========================================
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
parameters.Vmax =2.12363323252006; %bounds: [0.1 1E4]
parameters.K1 =  100.1019; %bounds: [0.1 1E4]
parameters.Km = 101.2983; %bounds: [0.1 1E4]
parameters.p1 = 10.8150; %bounds: [1 1E4]
parameters.p2 = 99.3193; %bounds: [1 1E4]
parameters.p3 =7.5784e-04; %bounds: [1E-6 1]
parameters.f0 = 95.3875; %bounds: [1 1E4]
parameters.Dh = 0.1885; %bounds: [1E-6 1]

%% Define Initial Conditions
%initial conditions in nmol/mL
parameters.Cytcox = 100;
parameters.Cytcred = 100;
parameters.Cytctot = parameters.Cytcox+parameters.Cytcred;
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

%% Define the labels and titles for GUI Graphs
%titles and labels for the output graphs
[parameters.title{1:6}] = deal(['Reduced cytochrome c concentration over'...
    ' time'],'Oxygen concentration over time', ...
    'Oxygen consumption rate over time', ...
    'Matrix proton concentration over time',...
    'Intermembrane space proton concentration over time',...
    'Proton ratio comparing Matrix and Intermembrane space');
[parameters.ylab{1:6}] = deal('Cyt c_{red} (nmol/mL)', ...
    'O_2 (nmol/mL)','OCR (nmol/mL*sec)','H_N (nmol/mL)',['delta '...
    'H_N (nmol/mL*sec)'],'H_{ratio} (nmol/mL)');
parameters.xlab = 'Time (sec)';