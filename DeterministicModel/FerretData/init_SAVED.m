%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2014. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function extPar=init

[extPar.parameters, extPar.data, extPar.models]=setup('pressure');

% setup which data will be fit by passing in temporary file; if there is
% no temporary file, ask user which data will be fit
try
    load('temp-data_fitting.mat');
    extPar.parameters.data_fitting = data_fit{1};
catch
    %determine which data set will be fit in this call
    which_fit = questdlg('Which data set will you be fitting?', ...
        'Select data type for fitting', 'Control', 'Alzheimers', 'Cancel', ...
        'Cancel');
    switch which_fit
        case 'Control'
            extPar.parameters.data_fitting = 1;            
        case 'Alzheimers'
            extPar.parameters.data_fitting = 2;
        case 'Cancel'
            extPar.parameters.data_fitting = 1;
            waitfor(msgbox('Default fit for control will be used.', 'Default'));
    end
end

% setup which model will be fit by asking user
which_model = questdlg('Which model will you be fitting?', ...
    'Select model for fitting', 'CC Full Model', 'CC Baseline Model', ...
    'Cancel', 'Cancel');
switch which_model
    case 'CC Full Model'
        extPar.selected_model = 'cc_full_model';
    case 'CC Baseline Model'
        extPar.selected_model = 'cc_baseline_model';
    case 'Cancel'
        extPar.select_model = 'cc_full_model';
        waitfor(msgbox('Default fit for cc full model will be used', ...
            'Default'));
end