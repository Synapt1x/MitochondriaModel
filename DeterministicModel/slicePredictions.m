function slicePredictions()
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
step_factor = 0.01;

%% x, y, z = Vmax, Km, Cyt c for f0
%% x, y, z = Vmax, Km, K for fIV
vars = struct();
vars.f0 = {'f0_Vmax', 'f0_Km', 'cytctot'};
vars.fIV = {'fIV_Vmax', 'fIV_Km', 'fIV_K'};

labels.f0 = {'V_{max_{f0}}', 'Km_{f0}', 'cyt c_{tot}'};
labels.fIV = {'V_{max_{fIV}}', 'Km_{fIV}', 'K_{fIV}'};

% plot parameters
fig_names = {{'Effect of Altering Input Function Parameters', 'on Average OCR'}, ...
    {'Effect of Altering Complex IV Function Parameters', 'on Average OCR'}};
filenames = {['SlicePredictions/f0-Predictions-', date] ...
    ['SlicePredictions/fIV-Predictions-', date]};
var_files = {['SlicePredictions/f0-vars-', date, '.mat'], ...
    ['SlicePredictions/fIV-vars-', date, '.mat']};

for plot_num=1:2
    
    cur_plot = plots{plot_num};
    
    disp(['-- Starting plot of ', cur_plot, ' --']);
    
    var_plot = vars.(cur_plot);
    
    x_max = parameters.ctrlParams.(var_plot{1}) * 1.5;
    y_max = parameters.ctrlParams.(var_plot{2}) * 1.5;
    z_max = parameters.ctrlParams.(var_plot{3}) * 1.5;
    
    x_min = parameters.ctrlParams.(var_plot{1}) * 0.01;
    y_min = parameters.ctrlParams.(var_plot{2}) * 0.01;
    z_min = parameters.ctrlParams.(var_plot{3}) * 0.01;
    
    step_x = (x_max * step_factor) / 1.5;
    step_y = (y_max * step_factor) / 1.5;
    step_z = (z_max * step_factor) / 1.5;

    % initialize slices to be graphed
    [x,y,z] = meshgrid(x_min : step_x : x_max, ...
        y_min : step_y : y_max, ...
        z_min : step_z : z_max);
    
    pts = [x(:), y(:), z(:)];
    all_o2 = zeros(length(pts), 1);
    
    arm_length = length(x);
    len = numel(x);    

    for i=1:len
        parameters = orig_parameters;
        
        cur_vals = pts(i, :);
        
        for j=1:length(var_plot)
            var = var_plot{j};
            
            parameters.ctrlParams.(var) = cur_vals(j);
            
            if strcmp(var_plot{j},'cytctot')
                parameters.cytctot = cur_vals(j);
                parameters.ctrlParams.cytcred = cur_vals(j) * orig_cytcred_prop;
                parameters.ctrlParams.cytcox = cur_vals(j) ...
                    - parameters.ctrlParams.cytcred;
                parameters.cytcred = parameters.ctrlParams.cytcred;
                parameters.cytcox = parameters.ctrlParams.cytcox;
            end
        end
        
        [~, out] = solver(parameters, parameters.ctrlParams, data, ...
            'cc_baseline_model', models);
        
        o2 = out(:,2);
        avg_o2 = mean(o2);
        
        all_o2(i) = avg_o2;
    end
    
    all_o2 = reshape(all_o2, [arm_length, arm_length, arm_length]);
    
    xslice = x_max / 2;
    yslice = y_max / 2;
    zslice = z_max / 2;
    
    figure(plot_num);
    fig = slice(x, y, z, all_o2, xslice, yslice, zslice);
    
    slice_labels = labels.(plots{plot_num});
    title(fig_names{plot_num});
    xlabel(slice_labels{1});
    ylabel(slice_labels{2});
    zlabel(slice_labels{3});
    
    for i=1:length(fig)
        fig(i).FaceColor = 'interp';
        fig(i).EdgeColor = 'none';
        fig(i).DiffuseStrength = 0.8;
    end
    axis tight;
    colormap jet;
    colorbar;
    
    export_fig(filenames{plot_num})
    save(var_files{plot_num}, 'fig', 'all_o2', 'xslice', 'yslice', ...
        'zslice')
    disp('--Finished plot--');
end


