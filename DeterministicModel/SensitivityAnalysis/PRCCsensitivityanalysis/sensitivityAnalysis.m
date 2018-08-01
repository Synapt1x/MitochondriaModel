function sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function houses code for using symbolic variables to represent
functions in my deterministic model. This function will be essential
to conducting sensitivity analysis for my mitochondrial model by finding
the Jacobian of the set of equations in my model. This will be done
using the symbolic functions for each equation in my model as
carried out below.
This will be carrying out sensitivty analysis for the baseline system.
%}

%% Create LHS sampling and Sensitivity Coefficients

%%%%%%%%%%%%%%%%%%%%%%%% define parameters for run %%%%%%%%%%%%%%%%%%%%%%%%

num_sims = 40;
display_interval = num_sims / 4;
max_t = 1E3;
% lower bounds for params
lb = [1E5, 1, ... %f0
    1E6, 1E5, 1E5, ... %fIV
    1E5, 5E5, 5E-4, ... %fV
    1E3, 1E3, 0.05, 1E-3, 1E-3, 1E-3, 1E-3, 0.05];
    % last row: r0, ox0, leak, amp1-4, attenuate
% upper bounds for params
ub = [1E6, 50, ... %f0
    1E7, 1E6, 1E6, ... %fIV
    1E6, 5E6, 5E-3, ... %fV
    5E3, 5E3, 1.0, 5E-3, 5E-3, 5E-3, 5E-3, 1.0];
    % last row: r0, ox0, leak, amp1-4, attenuate
% set parameters for time evolution


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear cmd history for clarity
clc

% store the current directory and move up to acquire model information
curdir = fileparts(which(mfilename));
cd(['..',filesep,'..']);

% acquire initial setup data for the model
[all_params, data, ~] = setup;
params = all_params.ctrlParams;

cd(curdir);

%Initialize the symbolic variables in the model; vars, params and t
parameters = {'f0_Vmax', 'f0_Km', 'fIV_Vmax', 'fIV_K', 'fIV_Km', ...
    'fV_Vmax', 'fV_K', 'fV_Km', 'r0', 'ox0', 'p_leak', 'amp_1', ...
    'amp_2', 'amp_3', 'amp_4', 'r_attenuate'};
initial_params = [params.cytcred, params.oxygen, params.omega, params.rho];
num_params = numel(parameters);

%Initialize output parameters
sensitivityOutput.outputLabels = {};
sensitivityOutput.finalVals = zeros(num_sims, 1);
sensitivityOutput.prcc = [];
sensitivityOutput.sensitivity = struct();

%% Run single test

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(num_sims, numel(parameters));
lhs = bsxfun(@plus, lb, bsxfun(@times, lhsRaw, (ub-lb))); % rescale

%% Generate output matrix from simulations

disp('Simulating outputs from LHS sampling...');

% calculate all output vals using simulations
sensitivityOutput.finalVals = calc_output(params, lhs, data, ...
    initial_params, display_interval);

% firstly, remove all NaN result rows
[remove_rows, ~] = find(isnan(sensitivityOutput.finalVals));
sensitivityOutput.finalVals(remove_rows) = [];
lhs(remove_rows, :) = [];
n = numel(lhs(:, 1));

% calculate rank order matrices
[~, rank_lhs] = sort(lhs, 'ascend');
[~, rank_out] = sort(sensitivityOutput.finalVals, 'descend');

sensitivityOutput.prcc = calc_prcc(rank_out, rank_lhs);

% save prcc and sensitivity value to output
for p=1:num_params
    param_name = parameters{p};
    val = sensitivityOutput.prcc(p);
    sensitivityOutput.sensitivity.(param_name) = val;
    disp([param_name, ' sensitivity: ', num2str(val)]);
end

save sensitivityOutput.mat sensitivityOutput

%% run multiple tests at key time points


end

%% function for calculating output vals given LHS sampling for params
function final_vals = calc_output(params, param_lhs, data, ...
    initial_params, varagin)

    % extract number of simulations used in this lhs sampling
    num_sims = numel(param_lhs(:, 1));
    if numel(varagin) == 0
        display_interval = num_sims / 4;
    else
        display_interval = varagin(1);
    end
    
    % initialize final values vector for output
    final_vals = zeros(num_sims, 1);
    
    warning off;
    progress = 25;
    
    % set some options for ode23t
    options = odeset('NonNegative',[1,2,3,4]);  % settings for ode

    %Setup a fallback set of times in cases of unsolvable parameter sets
    t_fallback = [data.baseline_times; data.oligo_fccp_times; ...
        data.inhibit_times];
    num_times = numel(t_fallback);

    for simnum=1:num_sims
        % little display for progress through simulations
        if mod(simnum, display_interval) == 0
            disp(['Progress...', num2str(progress), '%...']);
            progress = progress + 25;
        end

        paramvals = num2cell(param_lhs(simnum, :));
        % convert to cell array to distribute to params
        [params.f0_Vmax,params.f0_Km, ...
            params.fIV_Vmax,params.fIV_K, params.fIV_Km, ...
            params.fV_Vmax, params.fV_K, params.fV_Km, ...
            params.cytcred, params.cytcox, params.p_alpha, params.amp_1, ...
            params.amp_2, params.amp_3, params.amp_4, params.cyt_c_drop] ...
            = paramvals{:};
        params.cytctot = params.cytcred + params.cytcox;

        % simulate the system using ode23t
        [t1,y1] = ode23t(@oligoFccpSystem, [data.baseline_times; ...
                    data.oligo_fccp_times], initial_params,options,params);
        [t2,y2] = ode23t(@inhibitSystem, data.inhibit_times, ...
            [params.cyt_c_drop * y1(end,1), y1(end,2), y1(end,3), ...
            y1(end,4)], options,params);

        t = [t1; t2];
        y = [y1; y2];

        % store the final value(s)s of each simulation
        if (sum(y(:, 2)) == 0) || (numel(y(:, 2)) ~= num_times)
            final_vals(simnum) = NaN(1);
        else
            evaluations = y(:,2); %evaluated data for o2
            realo2Data = data.CtrlO2; %exp o2 data

            final_vals(simnum) = sum((realo2Data-evaluations).^2)...
                /numel(realo2Data);
        end
    end
    
    warning on;
end

%% function for calculating sensitivity vals given output and parameter mtx
function prcc = calc_prcc(rank_out, rank_lhs)
    
    % extract number of parameters in LHS sampling
    num_params = numel(rank_lhs(1, :));
    
    % initialize prcc output var
    prcc = [];

    % calculate and populate prcc
    for p=1:num_params
        % exclude p-th parameter
        temp_rank_A = rank_lhs(:, p);
        temp_A = rank_lhs;
        temp_A(:, p) = [];
     
        % calculate linear regressions and residuals
        regression = {'r'};  % extract residuals from regression
        regress_A = regstats(rank_out, temp_A, 'linear', regression);
        out_residual = regress_A.r;
        regress_B = regstats(temp_rank_A, temp_A, 'linear', regression);
        residual_B = regress_B.r;
        correl_val = corr(out_residual, residual_B);

        prcc = [prcc correl_val];
    end

end


