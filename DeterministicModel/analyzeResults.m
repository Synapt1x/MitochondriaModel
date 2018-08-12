function analyzeResults(OptimalSolutions, varargin)
%{
Created by: Chris Cadonic
========================================
As per code generation suggestions in the Qubist manual, this function
can be called by Ferret after analysis to 'automatically post-process'
results. 
In this function, OptimalSolutions is loaded and then it will be saved to
the 'Solutions' folder in the format "Date-OptimalSolutions.mat".
This structure will then be analyzed in the code below to look for the
global best, which will be stored in the variable result. 
%}

%% Initialize vars

close all  % close all currently open windows
warning('off','MATLAB:prnRenderer:opengl');

% number of general solutions
size_sols = size(OptimalSolutions.X, 2);
size_sols = 20;

main_dir=fileparts(which(mfilename));

% determing if figures should be shown or not
if numel(varargin) > 0
    visibility = varargin{1};
else
    % default is not to show figures as popups but just to save them
    visibility = 'off';
end

% initialize storage variables
bestFit = OptimalSolutions.F(:,1).*inf;
bestSet = struct();
errs = struct();
means = struct();
stds = struct();
all_params = [];
F = Inf(1, size_sols);

top_ten = round(size_sols * 0.10);

[parameters, data, models] = setup;

all_top_o2 = zeros(numel(data.Time), top_ten);
best_fit = zeros(numel(data.Time), 1);

% output image filenames
save_mean_normed_filename = ['mean_normed_boxplots-', date];
save_range_normed_filename = ['range_normed_boxplots-', date];
save_max_normed_filename = ['max_normed_boxplots-', date];
save_top_sols_filename = ['top_solutions-', date];

%% Loop over OptimalSolutions to find Best

% To loop over entire optimal set:
for n=1:size_sols % Number of columns = number of solutions.
    
    %first use bsxfun to check 'greater than' for all elements of bestFit
    %vs. OptimalSolutions.F
    params = OptimalSolutions.X_struct(n);
    F(n) = get_F(params, parameters, data, models);
    
    all_params = [all_params; params];
    
    if F(n) < bestFit + 1E-9
        bestFit = F(n);
        bestSet = OptimalSolutions.X_struct(n);
    end
end

[sorted_F, idx] = sort(F);
top_F_idx = idx(1:top_ten);
top_params = all_params(top_F_idx);

fields = fieldnames(top_params);

top_field_vals = struct;
mean_normed_field_vals = struct;
range_normed_field_vals = struct;
max_normed_field_vals = struct;
mean_normed_vals = [];
range_normed_vals = [];
max_normed_vals = [];
order = cell([numel(fields) - 1, 1]);
names = {'V_{max_{cIV}}', 'K_{cIV}', 'K_{m_{cIV}}', 'V_{max_{cV}}', ... 
    'K_{cV}', 'K_{m_{cV}}', 'V_{max_{f0}}', 'K_{m_{f0}}', ...
    'cyt c_{red}', 'cyt c_{ox}', 'P_{leak}', 'P_{FCCP}', '\alpha_{fccp_{0.25}}', ...
    '\alpha_{fccp_{0.5}}', '\alpha_{fccp_{0.75}}', '\alpha_{fccp_{1.0}}',...
    'r_{attenuate}'};

for i = 1:numel(fields) - 1
    fieldname = fields{i};
    field_vals = [top_params.(fieldname)];
    top_field_vals.(fieldname) = field_vals;
    mean_normed_field_vals.(fieldname) = (field_vals  - mean(field_vals)) / ...
        (max(field_vals) - min(field_vals));
    range_normed_field_vals.(fieldname) = (field_vals  - min(field_vals)) / ...
        (max(field_vals) - min(field_vals));
    max_normed_field_vals.(fieldname) = field_vals / max(field_vals);
    
    max_normed_vals = [max_normed_vals, max_normed_field_vals.(fieldname)'];
    mean_normed_vals = [mean_normed_vals, mean_normed_field_vals.(fieldname)'];
    range_normed_vals = [range_normed_vals, ...
        range_normed_field_vals.(fieldname)'];
    order{i} = fieldname;
    
    stds.(fieldname) = std(field_vals);
    errs.(fieldname) = stds.(fieldname) / sqrt(length(field_vals));
    means.(fieldname) = mean(field_vals);
end

%% Plot all boxplots on same figure
f1 = figure('visible', visibility);
boxplot(mean_normed_vals);
%ylim([0 1])
title('Boxplots for top 10% of solutions after Mean Normalization');
set(gca, 'TickLabelInterpreter', 'tex');
set(gca, 'XTickLabel', names, 'XTickLabelRotation', 90, 'fontsize', 14);
xlabel('Model Parameter');
ylabel('Feature-normalized value');

f2 = figure('visible', visibility);
boxplot(range_normed_vals);
%ylim([0 1])
title('Boxplots for top 10% of solutions after Range Normalization');
set(gca, 'TickLabelInterpreter', 'tex');
set(gca, 'XTickLabel', names, 'XTickLabelRotation', 90, 'fontsize', 14);
xlabel('Model Parameter');
ylabel('Feature-normalized value');

f3 = figure('visible', visibility);
boxplot(range_normed_vals);
%ylim([0 1])
title('Boxplots for top 10% of solutions after Max Normalization');
set(gca, 'TickLabelInterpreter', 'tex');
set(gca, 'XTickLabel', names, 'XTickLabelRotation', 90, 'fontsize', 14);
xlabel('Model Parameter');
ylabel('Feature-normalized value');


%% Plot all of the curves from top 10% of solutions
for i=1:top_ten
    params = top_params(i);
    
    fields=fieldnames(params);
    fields(end)=[];

    % Update all the values in the ctrlParams parameter set in 'parameters'
    for j=1:1:numel(fields)    
        parameters.ctrlParams.(fields{j}) = params.(fields{j});
    end
    
    [~, y] = solver(parameters, parameters.ctrlParams, data, 'cc_full_model', ...
    models);

    try
        o2 = y(:,2);
        if i == 1
            best_fit = o2;
        end
        if all(o2 == zeros(numel(data.Time), 1));
            o2 = best_fit;
        end
        all_top_o2(:, i) = o2;
    catch
        continue
    end
end

max_vals = max(all_top_o2, [], 2);
min_vals = min(all_top_o2, [], 2);

ftop = figure('visible', visibility);
hold on
f = plot(data.Time, best_fit, 'b', 'LineWidth', 2);
plot(data.Time, max_vals, 'g--');
plot(data.Time, min_vals, 'r--');
title('Oxygen Concentration Over Time');
xlabel('Time (sec)');
ylabel('O_2 (nmol/mL)');
hold off
    
%% Save files to Solutions folder

cd(main_dir);

folder = fileparts(which(mfilename)); %get the current folder
cd([folder '/Solutions']); %change to Solutions folder
todayDate = date; %get the run date

%save the Best solution to the Solutions folder
resultsname = [todayDate '-BestResults'];
save(resultsname,'bestSet','bestFit', 'errs', 'stds', 'means', 'all_top_o2', ...
'top_field_vals', 'mean_normed_field_vals', 'range_normed_field_vals', ...
'max_normed_field_vals', 'order', 'names');

%display a message indicating the files will be saved
disp(['Saving output files to ' folder '/Solutions.']);

% export figures and figure images
saveas(f1, save_mean_normed_filename, 'fig');
saveas(f2, save_range_normed_filename, 'fig');
saveas(f3, save_max_normed_filename, 'fig');
saveas(ftop, save_top_sols_filename, 'fig');
export_fig(save_mean_normed_filename, f1);
export_fig(save_range_normed_filename, f2);
export_fig(save_max_normed_filename, f3);
export_fig(save_top_sols_filename, ftop)

cd(folder); %change back to original folder

% turn warnings back on
warning('on','MATLAB:prnRenderer:opengl');