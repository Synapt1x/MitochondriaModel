%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function myPlot(X,F,extPar)
eps=1e-5;

F=fitness(X,extPar);
%
QubistPar=extPar.QubistPar;
xMin=min(QubistPar.general.min(:,1));
xMax=max(QubistPar.general.max(:,1));

Nplt=100;
dx=(xMax-xMin)/(Nplt-1);
x0=xMin:dx:xMax;
y0=fitness(x0, extPar);

plot(x0,y0,'b'); hold on;
plot(X,F,'ro'); hold off;

yMin=min(y0);
yMax=max(y0);
if xMax-xMin < eps
    xMin=xMin-eps;
    xMax=xMax+eps;
end
if yMax-yMin < eps
    yMin=yMin-eps;
    yMax=yMin+eps;
end
% axis([xMin,xMax,yMin,yMax])

xlabel('X');
ylabel('F')
