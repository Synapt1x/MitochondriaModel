function testEquations()
%{
Created by: Chris Cadonic
========================================
This function houses a unit test for testing equations to make sure that the 
model equations output match manually computed output for certain sets of 
input conditions.
%}

%% Initialization

[parameters, data, models] = setup(); %run the setup function which creates the
%structure storing all variables necessary
%for the model (found in 'setup.m')

test_cases = [];

%% Test case 1
% Test validitiy for inputs t and y for the full system equations
test_one = struct();

% define input values
test_one.t = [50,... % baseline time
    150, ...% oligo time
    250, ...% fccp_25 time
    350, ...% fccp_50_time
    450, ...% fccp_75_time
    550, ...% fccp_full_time
    650];   % inhitibit time
true_y_vals = [];  % calculated manually using correct formulas and the
% fit parameters in p-star
test_one.y = repmat(true_y_vals, numel(test_one.t));
test_one.params = parameters.ctrlParams;

% define correct output values for the given equations
test_one.dy = [];

% add test case to list of tests
test_cases = [test_cases, test_one];

%% Test case 2
% Test validitiy for inputs t and y for the full system equations with
% non-ideal but valid parameter values
test_two = struct();

% define input values
test_two.t = [50,... % baseline time
    150, ...% oligo time
    250, ...% fccp_25 time
    350, ...% fccp_50_time
    450, ...% fccp_75_time
    550, ...% fccp_full_time
    650];   % inhitibit time
true_y_vals = [];  % calculated manually using correct formulas and the
% fit parameters in p-star
test_two.y = repmat(true_y_vals, numel(test_one.t));
test_two.params = parameters.ctrlParams;
test_two.params.f0_Vmax = 20; %bounds: [0.01 10]
test_two.params.f0_Km = 1; %bounds: [0.1 1E4]
test_two.params.fIV_Vmax = 0.1; %bounds: [0.01 10]
test_two.params.fIV_Km = 1E-5; %bounds: [0.1 1E4]
test_two.params.fIV_K = 1E-4; %bounds: [0.1 1E4]
test_two.params.fV_Vmax = 100; %bounds: [1 1E4]
test_two.params.fV_Km = 1E-4; %bounds: [1E-6 1]
test_two.params.fV_K = 1E-4; %bounds: [1 1E4]
test_two.params.cytcred = 3000 ...
    * parameters.converter; %bounds: [1E-6 1]
test_two.params.cytcox = 4000 ...
    * parameters.converter; %bounds: [1E-6 1]
test_two.params.p_alpha = 0.001; %bounds: [1E-9 1]
test_two.params.p_fccp = 1.0; %bounds: [1 1E5]  NO LONGER USED

test_two.params.amp_1 = 1E-5; % max effect of FCCP in first injection
test_two.params.amp_2 = 4; % max effect of FCCP in second injection
test_two.params.amp_3 = 100; % max effect of FCCP in third injection
test_two.params.amp_4 = 0.01; % max effect of FCCP in final injection

% multiplier to reduce proportion of cyt c red in inhibit step
test_two.params.cyt_c_drop = 1E-6; 

% define correct output values for the given equations
test_one.dy = [];

% add test case to list of tests
test_cases = [test_cases, test_two];


%% Run tests
