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
    
    step_x = (x_max * step_factor) / 1.5;
    step_y = (y_max * step_factor) / 1.5;
    step_z = (z_max * step_factor) / 1.5;

    % initialize slices to be graphed
    [x,y,z] = meshgrid(0:step_x:x_max, 0:step_y:y_max, 0:step_z:z_max);
    
    x_vals = x(1, :, 1);
    y_vals = y(1, :, 1);
    z_vals = z(1, :, 1);
    
    xslice = x_max / 2;
    yslice = y_max / 2;
    zslice = z_max / 2;
    
    slice(x, y, z, v, xslice, yslice, zslice);
    
    colormap hsv;
    
end
