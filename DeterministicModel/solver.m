function [t,y] = solver(parameters, params, data, varargin)
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

%% Left out until strategy for dealing with different systems is determined
% %determine if solving a particular sub-system of the model
% if numel(varargin) > 0
%     model_num = varargin{1};
%     
%     baselineSys = @parameters.system{model_num, 1};
%     oligoSys = @parameters.system{model_num, 2};
%     inhibitSys = @parameters.system{model_num, 3};
% else
%     baselineSys = @baselineSystem;
%     oligoSys = @oligoSystem;
%     inhibitSys = @inhibitSystem;
% end    

%Set the options for running ode15s
options = odeset('NonNegative',[1,2,3,4]);

%Solve by using ode for each section and passing along the final
%values as initial values for the next section

t_fallback = [data.baseline_times; data.oligo_fccp_times; data.inhibit_times];
num_times = numel(t_fallback);

try
    warning off
    [t1,y1] = ode45(@baselineSystem, data.baseline_times, ...
        [params.cytcred,params.oxygen,params.omega,params.rho],options,params);
    [t2,y2] = ode45(@oligoSystem, data.oligo_fccp_times, ...
        [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
    if (y2(end,3)==0)||(y2(end,3)<1.9972e-07)
        y2(end,3)=1.9972e-07;
    end
    [t3,y3] = ode45(@inhibitSystem, data.inhibit_times, ...
        [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);
    
    t = [t1;t2;t3];
    y = [y1;y2;y3];
    
    if numel(y(:,2)) ~= num_times
        error('Error in ode solver.');
    end
    warning on
catch
    t = t_fallback;
    y = zeros(num_times, 4);
    y(:,3:4) = ones(num_times, 2);
end