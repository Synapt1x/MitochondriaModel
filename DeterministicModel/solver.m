function [t,y] = solver(parameters)
%{
This is a temporary attempt to solve the full situation for my model
as a boundary value problem.
%}

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
[t1,y1] = ode23t(@baselineSystem, parameters.baselineTimes, ...
    parameters.initialConditions,[],parameters);
[t2,y2] = ode23t(@oligoSystem, parameters.oligoTimes, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],[],parameters);
[t3,y3] = ode23t(@fccpSystem, parameters.FCCPTimes, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],[],parameters);
[t4,y4] = ode23t(@inhibitSystem, parameters.inhibitTimes, ...
    [y3(end,1),y3(end,2),y3(end,3),y3(end,4)],[],parameters);