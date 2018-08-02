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

    %%%%%%%%%%%%%%%%%%%%% define parameters for run %%%%%%%%%%%%%%%%%%%%%%

    % universal and single-run parameters
    plot_on = true;  % whether to plot immediately after or not
    plot_prcc = {'f0_Vmax', 'fIV_Vmax', 'fIV_Km', 'fV_Vmax', ...
        'fV_Km', 'fV_K'};
    
    num_sims = 1E3;
    display_interval = num_sims / 4;
    max_t = 1E3;
    calc_type = 'RMSE';
    %calc_type = 'finalO2val';
    %calc_type = 'avgO2';
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
    num_time_samples = 36;
    num_multi_sims = 5E2;
    independent_multi = true;
    
    if (independent_multi)
        multi_on = 'multi';
    else
        multi_on = 'single';
    end
    
    % set the output filename for the .mat
    filename = sprintf(['Output', filesep, date, ...
    '-sensitivityOutput-', calc_type, '-', multi_on, '.mat']);
    
    % store the output settings
    sensitivityOutput.settings = struct('num_sims', num_sims, ...
        'calc_type', calc_type, 'num_time_samples', num_time_samples, ...
        'num_multi_sims', num_multi_sims, ...
        'indendent_multi', independent_multi);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % clear cmd history for clarity
    clc

    % store the current directory and move up to acquire model information
    curdir = fileparts(which(mfilename));
    cd(['..',filesep,'..']);

    % acquire initial setup data for the model
    [all_params, data, ~] = setup;
    params = all_params.ctrlParams;
    
    % store all times
    all_t = [data.baseline_times; data.oligo_fccp_times; ...
        data.inhibit_times];
    num_times = numel(all_t);

    cd(curdir);

    %Initialize the symbolic variables in the model; vars, params and t
    parameters = {'f0_Vmax', 'f0_Km', 'fIV_Vmax', 'fIV_K', 'fIV_Km', ...
        'fV_Vmax', 'fV_K', 'fV_Km', 'r0', 'ox0', 'p_leak', 'amp_1', ...
        'amp_2', 'amp_3', 'amp_4', 'r_attenuate'};
    initial_params = [params.cytcred, params.oxygen, params.omega, ...
        params.rho];
    num_params = numel(parameters);

    %Initialize output parameters
    sensitivityOutput.outputLabels = parameters;
    sensitivityOutput.finalVals = zeros(num_sims, 1);
    sensitivityOutput.prcc = [];
    sensitivityOutput.sensitivity = struct();
    sensitivityOutput.raw_data = struct();

    %% Run single test ================================================ %%
    
    disp('Generating overall LHS ...');

    % create the sampling pool using latin hypercube sampling
    lhsRaw = lhsdesign(num_sims, numel(parameters));
    lhs = bsxfun(@plus, lb, bsxfun(@times, lhsRaw, (ub-lb))); % rescale
    sensitivityOutput.raw_data.single_lhs = lhs;

    %% Generate output matrix from simulations

    disp('Simulating outputs from LHS ...');

    % calculate all output vals using simulations
    [sensitivityOutput.finalVals, all_y] = calc_output(params, lhs, ...
        data, initial_params, num_times, calc_type, display_interval);

    % firstly, remove all NaN result rows
    [remove_rows, ~] = find(isnan(sensitivityOutput.finalVals));
    sensitivityOutput.finalVals(remove_rows) = [];
    lhs(remove_rows, :) = [];
    n = numel(lhs(:, 1));

    % calculate rank order matrices
    rank_lhs = rank_order(lhs);
    rank_out = rank_order(sensitivityOutput.finalVals);
    
    sensitivityOutput.prcc = calc_prcc(rank_out, rank_lhs);

    % save prcc and sensitivity value to output
    for p=1:num_params
        param_name = parameters{p};
        val = sensitivityOutput.prcc(p);
        sensitivityOutput.sensitivity.(param_name) = val;
    end

    %% Multiple tests at key time points ========================== %%
    
    % assemble the time points
    num_time_samples = min([num_time_samples, num_times]);
    sample_times_idx = round(linspace(1, num_times, num_time_samples));
    sample_times = all_t(sample_times_idx);
    % extra the comparison data at these time points
    compare_data = data.CtrlO2(sample_times_idx);
    
    % save time points to output
    sensitivityOutput.time_points = sample_times;
    
    %Initialize output parameters
    sensitivityOutput.time_prcc = zeros(num_time_samples, num_params);
    
    disp('=====Examining time evolution of samples=====');
    
    for t_i=1:num_time_samples
                
        if independent_multi
            disp(['Simulating next time point...', num2str(t_i), ...
                '/', num2str(num_time_samples)]);
            
            % create the sampling pool using latin hypercube sampling
            lhsRaw = lhsdesign(num_multi_sims, numel(parameters));
            % rescale
            lhs = bsxfun(@plus, lb, bsxfun(@times, lhsRaw, (ub-lb)));

            % calculate all output vals using simulations
            [finalVals, all_y] = calc_output(params, lhs, data, ...
                initial_params, num_times, calc_type, display_interval);
            
            % firstly, remove all NaN result rows
            [remove_rows, ~] = find(isnan(finalVals));
            lhs(remove_rows, :) = [];
            finalVals(remove_rows) = [];
            n = numel(lhs(:, 1));

            if strcmp(calc_type, 'RMSE')
                sim_y = finalVals;
            elseif strcmp(calc_type, 'finalO2val')
                sim_y = all_y(t_i, :)';
            end
        else
            y_vals = all_y(t_i, :)';

            if strcmp(calc_type, 'RMSE')
                compare_y = compare_data(t_i);
                sim_y = (y_vals - compare_y) .^ 2;
            elseif strcmp(calc_type, 'finalO2val')
                sim_y = y_vals;
            end
        end
        
        % calculate rank order matrices
        [~, rank_lhs] = sort(lhs, 'ascend');
        [~, rank_out] = sort(sim_y, 'descend');

        new_prcc = calc_prcc(rank_out, rank_lhs);
        sensitivityOutput.time_prcc(t_i, :) = new_prcc;
    end
    if ~independent_multi
        disp('Finished assembling PRCC evolution...');
    end
    
    % calculate statistics
    sensitivityOutput.variance = var(sensitivityOutput.time_prcc);
    sensitivityOutput.means = mean(sensitivityOutput.time_prcc);
    
    % print results
    disp('==================== RESULTS =======================');
    table(parameters', sensitivityOutput.prcc', ...
        sensitivityOutput.means', sensitivityOutput.variance', ...
        'VariableNames', {'parameters', 'sensitivity', 'mean', 'variance'})

    save(filename, 'sensitivityOutput');
    
    % plot if plot_on is set to do so
    if plot_on
        plot_prcc_multi(sensitivityOutput, plot_prcc);
    end    

end

%% function for rank-ordering a matrix
function rank_mtx = rank_order(x)

    rank_mtx = zeros(size(x));

    [rows, cols] = size(x);
    for j=1:cols
        [~, i] = sort(x(:, j));
        rank_mtx(i, j) = (1 : rows)';
    end

end

%% function for calculating output vals given LHS sampling for params
function [final_vals, all_y] = calc_output(params, param_lhs, data, ...
    initial_params, num_times, calc_type, varagin)

    tic  % time the function

    % extract number of simulations used in this lhs sampling
    num_sims = numel(param_lhs(:, 1));
    if (numel(varagin) == 0)
        display_interval = num_sims / 4;
    else
        display_interval = varagin(1);
    end
    
    % initialize final values vector for output
    final_vals = zeros(num_sims, 1);
    all_y = [];
    
    warning off;
    progress = 25;
    
    % set some options for ode23t
    options = odeset('NonNegative',[1,2,3,4]);  % settings for ode

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
            all_y = [all_y, y(:, 2)];
            if (strcmp(calc_type, 'RMSE'))
                % output RMSE for entire timeframe of data
                evaluations = y(:,2); %evaluated data for o2
                realo2Data = data.CtrlO2; %exp o2 data

                final_vals(simnum) = sum((realo2Data-evaluations).^2)...
                    /numel(realo2Data);
            elseif (strcmp(calc_type, 'finalO2val'))
                % output final O2 value
                final_vals(simnum) = y(end, 2);
                
            end
        end
    end
    
    warning on;
    toc
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

%% function for plotting sensitivity vals over time with various params
function plot_prcc_multi(sensitivityOutput, varargin)
    
    %%%% Varargin specifies which prcc vals to plot singly as strings

    % extract values
    time_points = sensitivityOutput.time_points;
    prcc_vals = sensitivityOutput.time_prcc;
    
    % create filename for plotting all prcc
    all_filename = sprintf(['Images', filesep, date, ...
        '-AllPRCCvals-', sensitivityOutput.settings.calc_type]);
    
    % plot
    f1 = figure(1);
    plot(time_points, prcc_vals);
    title('PRCC values for all parameters over time');
    xlabel('Time (sec)');
    ylabel('Correlation');
    ylim([-1.0, 1.0]);
    leg1 = legend(sensitivityOutput.outputLabels);
    set(leg1,'Location','BestOutside'); 
    
    savefig(f1, all_filename);
    saveas(f1, all_filename, 'png');
    
    % plot specific plots if specified
    if (numel(varargin) > 0)
        plot_params = varargin(1);
        
        select_filename = sprintf(['Images', filesep, date, '-', ...
            [plot_params{1}{:}], ...
        '-PRCCvals-', sensitivityOutput.settings.calc_type]);
        
        param_idx = [find(ismember(sensitivityOutput.outputLabels, ...
            plot_params{1}))];
        
        f2 = figure(2);
        plot(time_points, prcc_vals(:, param_idx));
        title('PRCC values for selected parameters over time');
        xlabel('Time (sec');
        ylabel('Correlation');
        ylim([-1.0, 1.0]);
        leg2 = legend(plot_params{1});
        set(leg2, 'Location', 'BestOutside');
        
        
        savefig(f2, select_filename);
        saveas(f2, select_filename, 'png');
        
    end

end

