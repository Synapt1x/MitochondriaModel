function [t,y] = solver(parameters)
%{
This is a temporary attempt to solve the full situation for my model
as a boundary value problem.
%}

%Solve by using ode for each section and passing along the final
%values as initial values for the next section

[t1,y1] = ode45(@baselineSystem, parameters.baselineTimes, ...
    parameters.initialConditions,[],parameters);
[t2,y2] = ode45(@oligoSystem, parameters.oligoTimes, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],[],parameters);
[t3,y3] = ode45(@fccpSystem, parameters.fccpTimes, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],[],parameters);
[t4,y4] = ode45(@inhibitSystem, parameters.inhibitTimes, ...
    [y3(end,1),y3(end,2),y3(end,3),y3(end,4)],[],parameters);

t = [t1;t2;t3;t4];
y = [y1;y2;y3;y4];