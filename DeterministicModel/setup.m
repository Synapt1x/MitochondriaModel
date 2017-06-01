function [parameters, data, models] = setup(varargin)
%{
Created by: Chris Cadonic
========================================
The setup function handles the values for each variable in the
system in a structure known as 'parameters'. parameters contains
all of the model's parameters and also the data, graph labels.
%}

%% Data Import
%import the real data
if ~isempty(varargin)
    % indicate to data_formatter that [C] will be converted to pressure
    [data, parameters.converter] = data_formatter('pressure');
else
    % if not converting [C] to pressure
    [data, parameters.converter] = data_formatter;
end

parameters.data_fitting = 1; % default fit is for fitting control data

%get the current working directory
parameters.curdir = fileparts(which(mfilename));
addpath(parameters.curdir, filesep, 'ModelSystems');

%% Define the Parameters of the Model
% control condition parameter values
parameters.ctrlParams.fIV_Vmax = 0.7225; %bounds: [0.01 10]
parameters.ctrlParams.fIV_K = 365.0185; %bounds: [0.1 1E4]
parameters.ctrlParams.fIV_Km = 0.1627; %bounds: [0.1 1E4]
parameters.ctrlParams.fV_Vmax = 43166.2487041382; %bounds: [1 1E4]
parameters.ctrlParams.fV_K = 9342.59161533985; %bounds: [1 1E4]
parameters.ctrlParams.fV_Km = 11387.5724922773; %bounds: [1E-6 1]
parameters.ctrlParams.f0_Vmax = 9812.42645440625; %bounds: [0.01 10]
parameters.ctrlParams.f0_Km = 12.2505629561911; %bounds: [0.1 1E4]
parameters.ctrlParams.Dh = 5116.07002586063; %bounds: [1E-6 1]
parameters.ctrlParams.alpha = 0.5; %bounds: [1E-9 1]
parameters.ctrlParams.cytcred = 0.0499624001853914 ...
    * parameters.converter; %bounds: [1E-6 1]
parameters.ctrlParams.cytcox = 6.37656163806675 ...
    * parameters.converter; %bounds: [1E-6 1]

parameters.paramNames = fields(parameters.ctrlParams);

parameters.ctrlParams.oxygen = data.CtrlO2(1); %bounds: [1E-6 1]
parameters.ctrlParams.omega = 0.015849 ...
    * parameters.converter; %bounds: [1E-2 50] pH = 7.8
parameters.ctrlParams.rho = 0.0398107 ...
    * parameters.converter; %assuming a pH of 7.4 we get 3.981E-8 mol/L
parameters.ctrlParams.psi = -log(parameters.ctrlParams.omega / ...
                                parameters.ctrlParams.rho); %MP approximation

% experimental condition parameter values
% Initially set to be equivalent to the control parameter set
parameters.expParams.fIV_Vmax =parameters.ctrlParams.fIV_Vmax; %bounds: [0.01 10]
parameters.expParams.fIV_K =  parameters.ctrlParams.fIV_K; %bounds: [0.1 1E4]
parameters.expParams.fIV_Km = parameters.ctrlParams.fIV_Km; %bounds: [0.1 1E4]
parameters.expParams.fV_Vmax = parameters.ctrlParams.fV_Vmax; %bounds: [1 1E4]
parameters.expParams.fV_K = parameters.ctrlParams.fV_K; %bounds: [1 1E4]
parameters.expParams.fV_Km =parameters.ctrlParams.fV_Km; %bounds: [1E-6 1]
parameters.expParams.f0_Vmax = parameters.ctrlParams.f0_Vmax; %bounds: [0.01 10]
parameters.expParams.f0_Km = parameters.ctrlParams.f0_Km; %bounds: [0.1 1E4]
parameters.expParams.Dh = parameters.ctrlParams.Dh; %bounds: [1E-6 1]
parameters.expParams.cytcred = parameters.ctrlParams.cytcred; %bounds: [1E-6 1]
parameters.expParams.cytcox = parameters.ctrlParams.cytcox; %bounds: [1E-6 1]
parameters.expParams.alpha = parameters.ctrlParams.alpha; %bounds: [1E-3 1E6]

parameters.expParams.oxygen = parameters.ctrlParams.oxygen; %bounds: [1E-6 1]
parameters.expParams.omega = parameters.ctrlParams.omega; %bounds: [1E-6 1]
parameters.expParams.rho = parameters.ctrlParams.rho; % pH=7.4
parameters.expParams.psi = parameters.ctrlParams.psi; %MP approximation

%define the initial condition fields
parameters.conditionNames = {'cytctot', 'cytcox', 'cytcred', 'oxygen', ...
    'omega', 'rho'};


%% Define Initial Conditions
%initial conditions in nmol/mL; conversion: 1 nmol/mL = 1E-6 mol/L
parameters.cytcox = parameters.ctrlParams.cytcox;
parameters.cytcred = parameters.ctrlParams.cytcred;
parameters.cytctot = parameters.cytcox+parameters.cytcred;
[parameters.ctrlParams.cytctot,parameters.expParams.cytctot] = deal(parameters.cytctot);
parameters.O2 = parameters.ctrlParams.oxygen;
parameters.Hn = parameters.ctrlParams.omega;
parameters.Hp = parameters.ctrlParams.rho;
parameters.psi = parameters.ctrlParams.psi;

%% Add time points to ctrl and exp param sets
[parameters.ctrlParams.fccp_25_t, parameters.expParams.fccp_25_t] = ...
    deal(data.fccp_25_t);
[parameters.ctrlParams.fccp_50_t, parameters.expParams.fccp_50_t] = ...
    deal(data.fccp_50_t);
[parameters.ctrlParams.fccp_75_t, parameters.expParams.fccp_75_t] = ...
    deal(data.fccp_75_t);
[parameters.ctrlParams.fccp_100_t, parameters.expParams.fccp_100_t] = ...
    deal(data.fccp_100_t);

%% Add all of the different subsystems of the model
parameters.system = {};
for subsys = 1:8
    parameters.system{subsys} = {str2func(['baselineSystem',int2str(subsys)]), ...
        str2func(['oligoSystem',int2str(subsys)]), ...
        str2func(['inhibitSystem',int2str(subsys)])};
end


%% Define the labels and titles for GUI Graphs
%titles and labels for the output graphs
[parameters.title{1:7}] = deal('Oxygen Concentration Over Time', ...
    'OCR Over Time', ['Cyt c Reduced Concentration Over'...
    ' Time'], 'Matrix Proton Concentration Over Time',...
    'IMS Proton Concentration Over Time', ['Cyt c Reduced Concentration Over'...
    ' Time'], 'Membrane Potential \Delta\Psi Over Time');
[parameters.ylab{1:7}] = deal('O_2 (nmol/mL)','OCR (pmol/(mL*sec))', ...
    'Cyt c_{red} (nmol/mL)', 'H_N (nmol/mL)', 'H_P (nmol/mL)', ...
    'Cyt c_{red} (nmol/mL)', '\Delta\Psi (V)');
parameters.xlab = 'Time (sec)';


%% Define the function handles for the current model system
models.cc_full_model = {@baselineSystem, @oligoSystem, ...
    @inhibitSystem};
models.cc_baseline_model = {@baselineSystem};
models.cc_mp_model = {@baselineSystem_MP, @oligoSystem_MP, ...
    @inhibitSystem_MP};
