function slicePredictions()
%{
========================================
Created by: Chris Cadonic
For: M.Sc program in Biomedical Engineering
Project: Modeling Mitochondrial Bioenergetics
========================================
This is the code used for running and outputting graphs for predictions
using the mitochondrial model developed in my masters project.

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
step_factor = 0.05;

%% x, y, z = Vmax, Km, Cyt c for f0
%% x, y, z = Vmax, Km, K for fIV
vars = struct();
vars.f0 = {'f0_Vmax', 'f0_Km', 'cytctot'};
vars.fIV = {'fIV_Vmax', 'fIV_Km', 'fIV_K'};

for plot_num=1:2
    
    cur_plot = plots{plot_num};
    
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
    
    len = length(x(1, :, 1));
    
    x_vals = x(1, :, 1);
    y_vals = y(:, 1, 1)';
    z_vals = z(1, 1, :);
    z_vals = reshape(z_vals, [1, len]);
    
    all_vals = [x_vals; y_vals; z_vals]';

    for i=1:len
        parameters = orig_parameters;
        
        cur_vals = all_vals(i, :);
        
        for j=1:length(cur_vals)
            parameters.ctrlParams.(var_plot{j}) = cur_vals(j);
            
            if strcmp(var_plot{j},'cytctot')
                parameters.cytctot = cur_vals(j);
                parameters.ctrlParams.cytcred = cur_vals(j) * orig_cytcred_prop;
                parameters.ctrlParams.cytcox = cur_vals(j) ...
                    - parameters.ctrlParams.cytcred;
                parameters.cytcred = parameters.ctrlParams.cytcred;
                parameters.cytcox = parameters.ctrlParams.cytcox;
            end
        end
        
        [t, y] = solver(parameters, parameters.ctrlParams, data, ...
            'cc_baseline_model', models);
    end
    
    xslice = x_max / 2;
    yslice = y_max / 2;
    zslice = z_max / 2;
    
    
    slice(x, y, z, v, xslice, yslice, zslice);
    
    colormap hsv;
    
end
