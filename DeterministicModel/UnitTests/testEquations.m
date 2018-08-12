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

epsilon = 1E-6; % epsilon error for float threshold

test_cases = [];

% notify that tests are being run
disp('Testing equation sets to ensure match to manual calculations...');

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
y_vals = [2000, 150, 0.5, 2.5];  % calculated manually using correct formulas and the
% fit parameters in p-star
test_one.y = repmat(y_vals', 1, numel(test_one.t));
test_one.params = parameters.ctrlParams;

% define correct output values for the given equations
test_one.dy = [9.644618695, -0.068049974, 80.519437673, -70.874818978; ...
    9.644618695, -0.068049974, -30.274247973, 39.918866668; ...
    9.644618695, -0.068049974, -30.274247767, 39.918866462; ...
    9.644618695, -0.068049974, -30.191796749, 39.836415445; ...
    9.644618695, -0.068049974, -28.270776860, 37.915395555; ...
    9.644618695, -0.068049974, -30.274043958, 39.918662653; ...
    -0.272199898, -0.068049974, 1.562334159, -1.834534057]';

% add test case to list of tests
test_cases = [test_cases, test_one];

%% Test case 2
% Test validitiy for inputs t and y for the full system equations with
% non-ideal but valid parameter values
test_two = struct();

% define input values
test_two.t = test_one.t;
test_two.y = test_one.y;
test_two.params = parameters.ctrlParams;

% create artificial parameter values to ensure these are being used
% correctly as well
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
test_two.params.cytctot = test_two.params.cytcred + test_two.params.cytcox;
test_two.params.p_alpha = 0.001; %bounds: [1E-9 1]
test_two.params.p_fccp = 1.0; %bounds: [1 1E5]  NO LONGER USED

test_two.params.amp_1 = 1E-5; % max effect of FCCP in first injection
test_two.params.amp_2 = 4; % max effect of FCCP in second injection
test_two.params.amp_3 = 100; % max effect of FCCP in third injection
test_two.params.amp_4 = 0.01; % max effect of FCCP in final injection

% multiplier to reduce proportion of cyt c red in inhibit step
test_two.params.cyt_c_drop = 1E-6; 

% define correct output values for the given equations
test_two.dy = [7.958400323, -0.009999999, 75.924165969, -67.965765646; ...
    7.958400323, -0.009999999, -24.069834391, 32.028234714; ...
    7.958400323, -0.009999999, -24.069834338, 32.028234660; ...
    7.958400323, -0.009999999, -24.048368085, 32.006768408; ...
    7.958400323, -0.009999999, -23.533178077, 31.491578399; ...
    7.958400323, -0.009999999, -24.069780726, 32.028181048; ...
    -0.039999997, -0.009999999, 0.483542855, -0.523542852]';

% add test case to list of tests
test_cases = [test_cases, test_two];


%% Run tests

% loop over each test case
for test_num=1:numel(test_cases)
    fprintf('Running test %d / %d ...', test_num, numel(test_cases));
    test_case = test_cases(test_num);
    num_steps = numel(test_case.t);
    
    % loop over each time in the test
    for t_i=1:num_steps
        
        % extract test values from case
        time = test_case.t(t_i);
        y_vals = test_case.y(:, t_i);
        dy = test_case.dy(:, t_i);
        
        % compute values from equations
        if time < data.inhibit_t
            calc_dy = oligoFccpSystem(time, y_vals, test_case.params);
        else
            calc_dy = inhibitSystem(time, y_vals, test_case.params);
        end
        
        % check for value consistency
        diff_vals = abs(dy - calc_dy);
        check_vals = arrayfun(@(x) x < epsilon, diff_vals);
        assert(all(check_vals), sprintf('Equations are not consistent ', ...
            ' manually calculated values. Please re-check equations. ', ...
            '**Specific fail for test %d computed at t=%d.', test_num, time));        
    end
    
    fprintf('passed!\n');
    
end
