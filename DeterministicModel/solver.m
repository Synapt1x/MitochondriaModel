function [t,y] = solver(parameters,params)
%{
Created by: Chris Cadonic
========================================
This function solves the full situation for my model by step-wise
solving the ODEs for each section using the appropriate equations.
%}

%update all parameter values
parameters.Cytcred = params.cytcred;
parameters.Cytcox = params.cytcox;
parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;
parameters.Hn = params.omega;
parameters.Hp = params.rho;
parameters.O2 = params.oxygen;
params.Cytctot = params.cytcred + params.cytcox;

%Set the options for running ode15s
options = odeset('NonNegative',[1,2,3,4]);

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
[t1,y1] = ode15s(@baselineSystem, parameters.baselineTimes, ...
    [params.cytcred,params.oxygen,params.omega,params.rho],options,params);
[t2,y2] = ode15s(@oligoSystem, parameters.oligoTimes, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
[t3,y3] = ode15s(@fccpSystem, parameters.fccpTimes, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);
[t4,y4] = ode15s(@inhibitSystem, parameters.inhibitTimes, ...
    [y3(end,1),y3(end,2),y3(end,3),y3(end,4)],options,params);

t = [t1;t2;t3;t4];
y = [y1;y2;y3;y4];