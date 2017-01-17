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
parameters.ctrlParams.Vmax = 0.7225; %bounds: [0.01 10]
parameters.ctrlParams.K1 = 365.0185; %bounds: [0.1 1E4]
parameters.ctrlParams.Km = 0.1627; %bounds: [0.1 1E4]
parameters.ctrlParams.p1 = 43166.2487041382; %bounds: [1 1E4]
parameters.ctrlParams.p2 = 9342.59161533985; %bounds: [1 1E4]
parameters.ctrlParams.p3 = 11387.5724922773; %bounds: [1E-6 1]
parameters.ctrlParams.f0Vmax = 9812.42645440625; %bounds: [0.01 10]
parameters.ctrlParams.f0Km = 12.2505629561911; %bounds: [0.1 1E4]
parameters.ctrlParams.Dh = 5116.07002586063; %bounds: [1E-6 1]
parameters.ctrlParams.cytcred = 0.0499624001853914; %bounds: [1E-6 1]
parameters.ctrlParams.cytcox = 6.37656163806675; %bounds: [1E-6 1]
parameters.ctrlParams.oxygen = parameters.realo2Data(1); %bounds: [1E-6 1]
parameters.ctrlParams.omega = 0.015849; %bounds: [1E-2 50] pH = 7.8
parameters.ctrlParams.rho = 0.0398107; %bounds: [1E-2 50] pH = 7.4

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
parameters.expParams.cytcred = parameters.ctrlParams.cytcred; %bounds: [1E-6 1]
parameters.expParams.cytcox = parameters.ctrlParams.cytcox; %bounds: [1E-6 1]
parameters.expParams.oxygen = parameters.ctrlParams.oxygen; %bounds: [1E-6 1]
parameters.expParams.omega = parameters.ctrlParams.omega; %bounds: [1E-6 1]
parameters.expParams.rho = parameters.ctrlParams.rho; %bounds: [1E-6 1]


%% Define Initial Conditions
%initial conditions in nmol/mL; conversion: 1 nmol/mL = 1E-6 mol/L
parameters.Cytcox = parameters.ctrlParams.cytcox;
parameters.Cytcred = parameters.ctrlParams.cytcred;
parameters.Cytctot = parameters.Cytcox+parameters.Cytcred;
[parameters.ctrlParams.Cytctot,parameters.expParams.Cytctot] = deal(parameters.Cytctot);
parameters.O2 = parameters.ctrlParams.oxygen;
parameters.Hn = parameters.ctrlParams.omega;

%assuming a pH of 7.4 we get 3.981E-8 mol/L or:
parameters.Hp = parameters.ctrlParams.rho;

%% Define boundary times for integration
%define the time boundaries between conditions; First instance of segment
%change
[parameters.oligo_t, parameters.ctrlParams.oligo_t, ...
    parameters.expParams.oligo_t] = deal(98);
[parameters.fccp_25_t, parameters.ctrlParams.fccp_25_t, ...
    parameters.expParams.fccp_25_t] = deal(220);
[parameters.fccp_50_t, parameters.ctrlParams.fccp_50_t, ...
    parameters.expParams.fccp_50_t] = deal(314);
[parameters.fccp_75_t, parameters.ctrlParams.fccp_75_t, ...
    parameters.expParams.fccp_75_t] = deal(426);
[parameters.fccp_100_t, parameters.ctrlParams.fccp_100_t, ...
    parameters.expParams.fccp_100_t] = deal(520);
[parameters.inhibit_t, parameters.ctrlParams.inhibit_t, ...
    parameters.expParams.inhibit_t] = deal(608);

parameters.ctrlParams.fccp_25 = min(find(parameters.timePoints>=parameters.fccp_25_t));
parameters.ctrlParams.fccp_50 = min(find(parameters.timePoints>=parameters.fccp_50_t));
parameters.ctrlParams.fccp_75 = min(find(parameters.timePoints>=parameters.fccp_75_t));
parameters.ctrlParams.fccp_100 = min(find(parameters.timePoints>=parameters.fccp_100_t));
parameters.expParams.fccp_25 = parameters.ctrlParams.fccp_25;
parameters.expParams.fccp_50 = parameters.ctrlParams.fccp_50;
parameters.expParams.fccp_75 = parameters.ctrlParams.fccp_75;
parameters.expParams.fccp_100 = parameters.ctrlParams.fccp_100;

parameters.oligoTime = min(find(parameters.timePoints>=parameters.oligo_t));
parameters.inhibitTime = min(find(parameters.timePoints>=608));
parameters.ctrlParams.oligoTime = parameters.oligoTime;
parameters.ctrlParams.inhibitTime = parameters.inhibitTime;

%define the arrays holding the time points for each section
parameters.baselineTimes = parameters.timePoints( ...
    1:parameters.oligoTime-1);
parameters.oligoTimes = parameters.timePoints( ...
    parameters.oligoTime:parameters.inhibitTime-1);
parameters.inhibitTimes = parameters.timePoints( ...
    parameters.inhibitTime:end);

%number of points in each section
parameters.numpoints = [numel(parameters.baselineTimes),numel(...
    parameters.oligoTimes), numel(parameters.inhibitTimes)];

%% Define the labels and titles for GUI Graphs
%titles and labels for the output graphs
[parameters.title{1:5}] = deal(['Cyt c Reduced Concentration Over'...
    ' Time'],'Oxygen Concentration Over Time', ...
    'OCR Over Time', ...
    'Matrix Proton Concentration Over Time',...
    'IMS Proton Concentration Over Time');
[parameters.ylab{1:5}] = deal('Cyt c_{red} (nmol/mL)', ...
    'O_2 (nmol/mL)','OCR (pmol/(mL*sec))','H_N (nmol/mL)', ...
    'H_P (nmol/mL)');
parameters.xlab = 'Time (sec)';
