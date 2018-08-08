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
    plot_prcc = {'fIV_Vmax', 'fIV_K', 'fIV_Km', 'fV_Vmax', ...
        'fV_K', 'fV_Km', 'r0', 'ox0', 'p_leak', 'dummy'};
    fig_visibility = 'off';  % set to on to view figures during run   
    
    num_sims = 2E4;
    display_interval = num_sims / 4;
    max_t = 1E3;
    %calc_type = 'RMSE';
    calc_type = 'finalO2val';
    %calc_type = 'avgO2';
    % lower bounds for params
    lb = [2, 0.3, ... %f0
        0.1, 0.0001, 0.0002, ... %fIV
        5, 0.00001, 0.0001, ... %fV
        0.1, 200, 0.0004, 1E-5, 1E-2, 1E-2, 1E-2, 0.00001, 0];
        % last row: r0, ox0, leak, amp1-4, attenuate
    % upper bounds for params
    ub = [200, 40, ... %f0
        10, 0.01, 0.02, ... %fIV
        600, 0.001, 0.01, ... %fV
        10, 20000, 0.04, 1E-3, 0.9, 0.9, 0.9, 0.001, 1000];
        % last row: r0, ox0, leak, amp1-4, attenuate
        
    % set parameters for time evolution
    num_time_samples = 120;
    num_multi_sims = 2E3;
    independent_multi = true;
    smooth_on = true;
    smooth_type = 'rlowess';
    
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
        'amp_2', 'amp_3', 'amp_4', 'r_attenuate', 'dummy'};
    initial_params = [params.cytcred, params.oxygen, params.omega, ...
        params.rho];
    num_params = numel(parameters);

    %Initialize output parameters
    sensitivityOutput.outputLabels = {'f0_{Vmax}', 'f0_{Km}', 'fIV_{Vmax}', ...
        'fIV_K', 'fIV_{Km}', 'fV_{Vmax}', 'fV_K', 'fV_{Km}', 'r(0)', ...
        'ox(0)', 'p_{leak}', '\alpha_1', '\alpha_2', '\alpha_3', '\alpha_4', ...
        'r_{attenuate}', 'dummy'};
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
        end

        y_vals = all_y(t_i, :)';

        if strcmp(calc_type, 'RMSE')
            compare_y = compare_data(t_i);
            sim_y = (y_vals - compare_y) .^ 2;
        elseif strcmp(calc_type, 'finalO2val')
            sim_y = y_vals;
        end
        
        rank_lhs = rank_order(lhs);
        rank_out = rank_order(sim_y);

        new_prcc = calc_prcc(rank_out, rank_lhs);
        sensitivityOutput.time_prcc(t_i, :) = new_prcc;
    end
    if ~independent_multi
        disp('Finished assembling PRCC evolution...');
    end
    
    % calculate statistics
    sensitivityOutput.variance = var(sensitivityOutput.time_prcc);
    sensitivityOutput.means = mean(sensitivityOutput.time_prcc);
    [sensitivityOutput.p_vals, sensitivityOutput.sig_val, ...
        sensitivityOutput.significance] = inference(sensitivityOutput, n);
    
    % print results
    disp('==================== RESULTS =======================');
    table(parameters', sensitivityOutput.prcc', ...
        sensitivityOutput.means', sensitivityOutput.variance', ...
        sensitivityOutput.p_vals, 'VariableNames', ...
        {'parameters', 'sensitivity', 'mean', 'variance', 'p'})
    
    sensitivityOutput.smoothed_prcc = smooth_data(sensitivityOutput, ...
        smooth_type);

    save(filename, 'sensitivityOutput');
    
    % plot if plot_on is set to do so
    if plot_on
        plot_sensitivity(sensitivityOutput, parameters, fig_visibility);
        plot_prcc_multi(sensitivityOutput, smooth_on, smooth_type, ...
            fig_visibility, plot_prcc);
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
    initial_params, num_times, calc_type, varargin)

    tic  % time the function

    % extract number of simulations used in this lhs sampling
    num_sims = numel(param_lhs(:, 1));
    if (numel(varargin) == 0)
        display_interval = num_sims / 4;
    else
        display_interval = varargin{1};
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

%% function for plotting global sensitivity vals
function plot_sensitivity(sensitivityOutput, param_names, fig_visibility)

    % extract from sensitivity output
    sensitivities = sensitivityOutput.sensitivity;
    vals = [];
    
    % significance value
    sig_val = sensitivityOutput.sig_val;
    
    % create filename for plotting sensitivities
    sensitivities_filename = sprintf(['Images', filesep, date, ...
        '-Sensitivities-', sensitivityOutput.settings.calc_type]);
    
    for i=1:numel(param_names)
        name = param_names{i};
        param_val = sensitivities.(name);
        
        vals = [vals param_val];
    end
    
    num_params = numel(param_names);
    
    % plot bar graph of sensitivities
    barfig = figure('Name', 'Figure 1: Parameter Sensitivities', ...
        'visible', fig_visibility);
    bar(vals);
    % label the graph appropriately
    title('Sensitivity of each Model Parameter');
    ylabel('Correlation');
    ylim([-1, 1]);
    xlim([0, num_params + 1]);
    set(gca, 'FontSize', 10, 'XTickLabelRotation', 90, ...
        'xticklabel', sensitivityOutput.outputLabels, 'xtick', 1:num_params);
    % create highlight patch for significance level
    line([0, (num_params + 1)], [sig_val, sig_val], 'Color', 'red', ...
        'LineStyle', '--', 'LineWidth', 1.5);
    line([0, (num_params + 1)], [-sig_val, -sig_val], 'Color', 'red', ...
        'LineStyle', '--', 'LineWidth', 1.5);
    x = [0 (num_params + 1) (num_params + 1) 0];
    y = [-sig_val -sig_val sig_val sig_val];
    sig_patch = patch(x, y, 'red');
    alpha(sig_patch, 0.3);
    % reverse gca children to send bar graph to front
    set(gca,'children',flipud(get(gca,'children')))
    
    % finally add significance asterisks
    sig_params = find(strcmp(sensitivityOutput.significance, '*') > 0);
    for i=1:numel(sig_params)
        x = sig_params(i);
        y = vals(x);
        x = x - 0.15;
        if y < 0
            y = y - 0.05;
        else
            y = y + 0.05;
        end
        text(x, y, '*');
    end
    
    % save sensitivity figure
    savefig(barfig, sensitivities_filename);
    saveas(barfig, sensitivities_filename, 'png');
    
end

%% function for plotting sensitivity vals over time with various params
function plot_prcc_multi(sensitivityOutput, smooth_on, smooth_type, ...
    fig_visibility, varargin)
    
    %%%% Varargin specifies which prcc vals to plot singly as strings

    % extract values
    time_points = sensitivityOutput.time_points;
    if smooth_on
        prcc_vals = smooth_data(sensitivityOutput, smooth_type);
    else
        prcc_vals = sensitivityOutput.time_prcc;
    end
    
    % create filename for plotting all prcc
    all_filename = sprintf(['Images', filesep, date, ...
        '-AllPRCCvals-', sensitivityOutput.settings.calc_type]);
    
    % plot
    f2 = figure('Name', 'Figure 2: PRCC Over Time for All Parameters', ...
        'visible', fig_visibility);
    plot(time_points, prcc_vals);
    title('PRCC values for all parameters over time');
    xlabel('Time (sec)');
    ylabel('Correlation');
    ylim([-1.0, 1.0]);
    leg2 = legend(sensitivityOutput.outputLabels);
    set(leg2,'Location','BestOutside'); 
    
    % save all PRCC fig
    savefig(f2, all_filename);
    saveas(f2, all_filename, 'png');
    
    % plot specific plots if specified
    if (numel(varargin) > 0)
        plot_params = varargin(1);
        
        
        select_filename = sprintf(['Images', filesep, date, '-', ...
            [plot_params{1}{:}], ...
        '-PRCCvals-', sensitivityOutput.settings.calc_type]);
        
        param_idx = [find(ismember(sensitivityOutput.outputLabels, ...
            plot_params{1}))];
        
        f3 = figure('Name', ...
            'Figure 3: PRCC Over Time for Selected Parameters', ...
            'visible', fig_visibility);
        plot(time_points, prcc_vals(:, param_idx));
        title('PRCC values for selected parameters over time');
        xlabel('Time (sec)');
        ylabel('Correlation');
        ylim([-1.0, 1.0]);
        leg3 = legend(plot_params{1});
        set(leg3, 'Location', 'BestOutside');
        
        % save selected PRCC fig
        savefig(f3, select_filename);
        saveas(f3, select_filename, 'png');
        
    end

end

%% function for smoothing time_prcc if wanted
function smoothed = smooth_data(sensitivityOutput, varargin)

    % extract data
    data = sensitivityOutput.time_prcc;
    [rows, cols] = size(data);
    smoothed = zeros([rows, cols]);
    
    % extract smoothing method in case one is passed in
    if numel(varargin) > 0
        smooth_type = varargin{1};
    else
        smooth_type = 'moving';
    end
    
    % smooth each column independently
    for j=1:cols
        smoothed(:, j) = smooth(data(:, j), smooth_type);
    end

end

%% function for conducting inference on the calculated PRCCs
function [p_vals, sig_val, sig] = inference(sensitivityOutput, n)
    
    % initialize and extract
    sig = cell(numel(sensitivityOutput.prcc), 1);
    sig_val = 0.05;  % default alpha
    prcc = abs(sensitivityOutput.prcc);
    
    df = n - 2 -1;  % degrees of freedom
    
    % calculate T scores and p-values
    t_scores = prcc .* sqrt(df ./ (1 - prcc .^ 2));
    p_vals = tcdf(t_scores, df, 'upper')';
    
    % get bonferroni correction val
    b_alpha = 1 - (1 - sig_val)^(1 / numel(prcc));
    
    % determine which are significant
    sig(p_vals < b_alpha) = {'*'};
    sig(p_vals >= b_alpha) = {'-'};
    
    % finally determine correlation that corresponds to corrected alpha
    t_cutoff = abs(tinv(b_alpha, df));
    sig_val = sqrt(t_cutoff ^2 / (df + t_cutoff^2));
    
end
