function [t,y] = solver(parameters,params)
%{
Created by: Chris Cadonic
========================================
This function solves the full situation for my model by step-wise
solving the ODEs for each section using the appropriate equations.
%}

%Set the options for running ode45
options = odeset('NonNegative',[1,2,3,4]);

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
tic
[t1,y1] = ode45(@baselineSystem, parameters.baselineTimes, ...
    [parameters.Cytcred,parameters.O2,parameters.Hn, ...
    parameters.Hp],options,params);
[t2,y2] = ode45(@oligoSystem, parameters.oligoTimes, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
[t3,y3] = ode45(@fccpSystem, parameters.fccpTimes, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);
[t4,y4] = ode45(@inhibitSystem, parameters.inhibitTimes, ...
    [y3(end,1),y3(end,2),y3(end,3),y3(end,4)],options,params);
toc

t = [t1;t2;t3;t4];
y = [y1;y2;y3;y4];