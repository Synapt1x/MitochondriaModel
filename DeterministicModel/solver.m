function [t,y] = solver(parameters,params)
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

%Set the options for running ode15s
options = odeset('NonNegative',[1,2,3,4]);

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
[t1,y1] = ode15s(@baselineSystem, parameters.data.baseline_times, ...
    [params.cytcred,params.oxygen,params.omega,params.rho],options,params);
[t2,y2] = ode15s(@oligoSystem, parameters.data.oligo_fccp_times, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
if (y2(end,3)==0)||(y2(end,3)<1.9972e-07)
    y2(end,3)=1.9972e-07;
end
[t3,y3] = ode15s(@inhibitSystem, parameters.data.inhibit_times, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);

t = [t1;t2;t3];
y = [y1;y2;y3];