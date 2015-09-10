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
% control condition parameter values
parameters.ctrlParams.Vmax =88.5452; %bounds: [0.01 10]
parameters.ctrlParams.K1 =  402.997; %bounds: [0.1 1E4]
parameters.ctrlParams.Km = 245.918; %bounds: [0.1 1E4]
parameters.ctrlParams.p1 = 33.5047; %bounds: [1 1E4]
parameters.ctrlParams.p2 = 314.8; %bounds: [1 1E4]
parameters.ctrlParams.p3 =6.14627E-3; %bounds: [1E-6 1]
parameters.ctrlParams.f0Vmax = 283.556; %bounds: [0.01 10]
parameters.ctrlParams.f0Km = 39696.5; %bounds: [0.1 1E4]
parameters.ctrlParams.Dh = 50; %bounds: [1E-6 1]

% experimental condition parameter values
% Initially set to be equivalent to the control parameter set
parameters.expParams.Vmax =parameters.ctrlParams.Vmax; %bounds: [0.01 10]
parameters.expParams.K1 =  parameters.ctrlParams.K1; %bounds: [0.1 1E4]
parameters.expParams.Km = parameters.ctrlParams.Km; %bounds: [0.1 1E4]
parameters.expParams.p1 = parameters.ctrlParams.p1; %bounds: [1 1E4]
parameters.expParams.p2 = parameters.ctrlParams.p2; %bounds: [1 1E4]
parameters.expParams.p3 =parameters.ctrlParams.p3; %bounds: [1E-6 1]
parameters.expParams.f0Vmax = parameters.ctrlParams.f0Vmax; %bounds: [0.01 10]
parameters.expParams.f0Km = parameters.ctrlParams.f0Km; %bounds: [0.1 1E4]
parameters.expParams.Dh = parameters.ctrlParams.Dh; %bounds: [1E-6 1]

%% Define Initial Conditions
%initial conditions in nmol/mL; conversion: 1 nmol/mL = 1E-6 mol/L
parameters.Cytcox = 100;
parameters.Cytcred = 0.1;
parameters.Cytctot = parameters.Cytcox+parameters.Cytcred;
[parameters.ctrlParams.Cytctot,parameters.expParams.Cytctot] = deal(parameters.Cytctot);
parameters.O2 = parameters.realo2Data(1);
parameters.Hn = 100;

%assuming a pH of 7.4 we get 3.981E-8 mol/L or:
parameters.Hp = 0.03981;

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