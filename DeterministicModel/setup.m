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
parameters.realOCR = parameters.realOCR * 1000; %correct units to pmol/ml s

%% Define the Parameters of the Model
% control condition parameter values
parameters.ctrlParams.Vmax =108.341994455382; %bounds: [0.01 10]
parameters.ctrlParams.K1 =  12.5255224171547; %bounds: [0.1 1E4]
parameters.ctrlParams.Km = 4801.32913410929; %bounds: [0.1 1E4]
parameters.ctrlParams.p1 = 1010000.831504916252; %bounds: [1 1E4]
parameters.ctrlParams.p2 = 611.524018740580; %bounds: [1 1E4]
parameters.ctrlParams.p3 =7521.37411099897; %bounds: [1E-6 1]
parameters.ctrlParams.f0Vmax = 103.961719751620; %bounds: [0.01 10]
parameters.ctrlParams.f0Km = 14704.2403743490; %bounds: [0.1 1E4]
parameters.ctrlParams.Dh = 13.237075749221; %bounds: [1E-6 1]
parameters.ctrlParams.cytcred = 0.1; %bounds: [1E-6 1]
parameters.ctrlParams.cytcox = 100; %bounds: [1E-6 1]
%parameters.ctrlParams.oxygen = parameters.realo2Data(1); %bounds: [1E-6 1]
parameters.ctrlParams.omega = 100; %bounds: [1E-6 1]
%parameters.ctrlParams.rho = 0.0398107; %bounds: [1E-6 1]

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
%parameters.expParams.oxygen = parameters.ctrlParams.oxygen; %bounds: [1E-6 1]
parameters.expParams.omega = parameters.ctrlParams.omega; %bounds: [1E-6 1]
%parameters.expParams.rho = parameters.ctrlParams.rho; %bounds: [1E-6 1]


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

%% Load Additional Functions
% add the additionalFuncs folder to path if it isn't already there
curdir = fileparts(which(mfilename));
addpath([curdir,'/AdditionalFuncs/']);

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
