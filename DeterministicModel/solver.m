function [t,y] = solver(t,y,parameters)
%{
This is a temporary attempt to solve the full situation for my model
as a boundary value problem.
%}

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
[t1,y1] = ode45(@baselineSystem, parameters.timePointsbase, ...
    parameters.intialConditions,[],parameters);
[t1,y1] = ode45(@oligoSystem, parameters.timePointsoligo, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],[],parameters);
[t1,y1] = ode45(@fccpSystem, parameters.timePointsfccp, ...
    ,[],parameters);
[t1,y1] = ode45(@inhibitSystem, parameters.timePointsinhibit, ...
    ,[],parameters);