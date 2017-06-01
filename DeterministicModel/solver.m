function [t,y] = solver(parameters, params, data, model_type, ...
    models)
%{
Created by: Chris Cadonic
========================================
This function solves the full situation for my model by step-wise
solving the ODEs for each section using the appropriate equations.
%}

%update all parameter values
parameters.cytcred = params.cytcred;
parameters.cytcox = params.cytcox;
parameters.cytctot = parameters.cytcred + parameters.cytcox;
parameters.Hn = params.omega;
parameters.Hp = params.rho;
parameters.O2 = params.oxygen;
params.cytctot = params.cytcred + params.cytcox;

initial_params = [params.cytcred, params.oxygen, params.omega, params.rho];
initial_params_mp = [params.cytcred, params.oxygen, params.psi];

%Set the options for running ode15s
options = odeset('NonNegative',[1,2,3,4]);
options_mp = odeset('NonNegative', [1, 2, 3]);

%Setup a fallback set of times in cases of unsolvable parameter sets
t_fallback = [data.baseline_times; data.oligo_fccp_times; data.inhibit_times];
num_times = numel(t_fallback);

%Extract the appropriate model equation systems
model_equations = models.(model_type);

%Determine the appropriate solving methods for the given model
try
    warning off
    switch model_type
        case 'cc_full_model'
            %Solve by using ode for each section and passing along the final
            %values as initial values for the next section using the proton
            %balance equations
            [t1,y1] = ode15s(model_equations{1}, data.baseline_times, ...
                initial_params,options,params);
            [t2,y2] = ode15s(model_equations{2}, data.oligo_fccp_times, ...
                [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
            if (y2(end,3)==0)||(y2(end,3)<1.9972e-07)
                y2(end,3)=1.9972e-07;
            end
            [t3,y3] = ode15s(model_equations{3}, data.inhibit_times, ...
                [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);

            t = [t1;t2;t3];
            y = [y1;y2;y3];

            if (numel(y(:,2)) ~= num_times) || (~isreal(y))
                error('Error in ode solver.');
            end
        case 'cc_baseline_model'
            %Solve by using ode for the entire timeframe for just the baseline
            %system
            [t,y] = ode15s(model_equations{1}, t_fallback, initial_params,options,...
                params);

            if numel(y) ~= num_times
                error('Error in ode solver.');
            end
        case 'cc_mp_model'
            %Solve by using ode for each section and passing along the final
            %values as initial values for the next section using the MP
            %equations
            [t1,y1] = ode15s(model_equations{1}, data.baseline_times, ...
                initial_params_mp,options_mp,params);
            [t2,y2] = ode15s(model_equations{2}, data.oligo_fccp_times, ...
                [y1(end,1),y1(end,2),y1(end,3)],options_mp,params);
            [t3,y3] = ode15s(model_equations{3}, data.inhibit_times, ...
                [y2(end,1),y2(end,2),y2(end,3)],options_mp,params);

            t = [t1;t2;t3];
            y = [y1;y2;y3];

            if numel(y(:,2)) ~= num_times
                error('Error in ode solver.');
            end
    end
    warning on
catch
    t = t_fallback;
    y = zeros(num_times, 4);
    y(:,3:4) = ones(num_times, 2);
    end
end