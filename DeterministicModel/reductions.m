function reductions()
%{
========================================
Created by: Chris Cadonic
For: M.Sc program in Biomedical Engineering
Project: Modeling Mitochondrial Bioenergetics
========================================
This is the code used for running and outputting graphs for predictions
using the mitochondrial model developed in my masters project, specifically
the volumetric slice plots illustrating the effect of changing main model
parameters on baseline model output.

These predictions are made in an effort to illustrate how the model
suggests changes in Alzheimer's data may appear.
%}

% initialize model
[parameters, data, models] = setup();
orig_parameters = parameters;
orig_cytcred_prop = parameters.ctrlParams.cytcred ...
    / (parameters.ctrlParams.cytcox + parameters.ctrlParams.cytcred);

% slice parameters
plots = {'f0', 'fIV'};
all_o2 = [];

ratios = [1.0, 0.9, 0.75, 0.5, 0.25, 0.1];

linestyles = {'-', '--', ':', ':', '-', '--'};

%% x, y, z = Vmax, Km, Cyt c for f0
%% x, y, z = Vmax, Km, K for fIV
var = struct();
var.f0 = 'cytctot';
var.fIV = 'fIV_Vmax';

% plot parameters
fig_names = {{'Effect of Reducing Initial Cytochrome c total on OCR'}, ...
    'Effect of Reducing V_{max_{fIV}} on OCR'};
filenames = {['SlicePredictions/f0-tenPercentReductions-', date] ...
    ['SlicePredictions/fIV-tenPercentReductions-', date]};
var_files = {['SlicePredictions/f0-tenPercentReductions-vars-', date, '.mat'], ...
    ['SlicePredictions/fIV--tenPercentReductions-vars-', date, '.mat']};

for plot_num=1:2
    
    cur_plot = plots{plot_num};
    
    disp(['-- Starting plot of ', cur_plot, ' --']);
    
    var_plot = var.(cur_plot);
    
    vals = parameters.ctrlParams.(var_plot) * ratios;
    
    cur_fig = figure(plot_num);
    
    hold on;
    set(gca, 'ColorOrder', [0 0 0; 0.1 1.0 0.1; 1.0 0.1 0.1; 0.1 0.1 1.0; ...
        0.8 0.8 0.1; 0.1 0.8 0.8]);

    for i=1:length(vals)
        parameters = orig_parameters;
        
        cur_val = vals(i);
        parameters.ctrlParams.(var_plot) = cur_val;

        if strcmp(var_plot,'cytctot')
            parameters.cytctot = cur_val;
            parameters.ctrlParams.cytcred = cur_val * orig_cytcred_prop;
            parameters.ctrlParams.cytcox = cur_val ...
                - parameters.ctrlParams.cytcred;
            parameters.cytcred = parameters.ctrlParams.cytcred;
            parameters.cytcox = parameters.ctrlParams.cytcox;
        end
        
        [t, out] = solver(parameters, parameters.ctrlParams, data, ...
            'cc_full_model', models);
        
        o2 = out(:,2);
        plot(t(2:end), o2(2:end), 'linestyle', linestyles{i}, ...
            'LineWidth', 2);
        
        all_o2 = [all_o2, o2];
        
    end
    
    vertScale = get(gca,'yLim'); % get the y resolution

    % draw oligo line
    line([data.oligo_t, data.oligo_t], ...
        vertScale, 'Color','b','LineWidth',0.01);
    text(data.oligo_t,vertScale(2),'Oligomycin', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');

    % draw fccp lines   
    line([data.fccp_25_t, data.fccp_25_t], ...
        vertScale,'Color','b');
    text(data.fccp_25_t,vertScale(2),'FCCP_{125}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([data.fccp_50_t, data.fccp_50_t], ...
        vertScale,'Color','b');
    text(data.fccp_50_t,vertScale(2),'FCCP_{250}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([data.fccp_75_t, data.fccp_75_t], ...
        vertScale,'Color','b');
    text(data.fccp_75_t,vertScale(2),'FCCP_{375}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([data.fccp_100_t, data.fccp_100_t], ...
        vertScale,'Color','b');
    text(data.fccp_100_t,vertScale(2),'FCCP_{500}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');

    % draw inhibit line
    line([data.inhibit_t, data.inhibit_t], ...
        vertScale, 'Color','b');
    text(data.inhibit_t,vertScale(2),'Rot/AA', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');

    % while iterating over graphs, also set xLim
    set(gca,'xLim',[t(1), t(end)]);

    title(fig_names{plot_num});
    xlabel('Time (sec)');
    ylabel('OCR (pmol/(mL*sec))');
    export_fig(filenames{plot_num})
    save(var_files{plot_num}, 'cur_fig', 'all_o2')
    disp('--Finished plot--');
end


