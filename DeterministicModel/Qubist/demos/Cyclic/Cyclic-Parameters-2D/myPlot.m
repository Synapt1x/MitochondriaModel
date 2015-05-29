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

QubistPar=extPar.QubistPar;
xMin=min(QubistPar.general.min,[],1);
xMax=max(QubistPar.general.max,[],1);
NGenes=length(xMin);
cpar=QubistPar.general.cyclic;
cpar(cpar < 1)=[];
cpar(cpar > NGenes)=[];
xMin(cpar)=QubistPar.zoom.initialLimits.min(cpar);
xMax(cpar)=QubistPar.zoom.initialLimits.max(cpar);

NPlt=100;
x0=linspace(xMin(1),xMax(1),NPlt); 
y0=linspace(xMin(2),xMax(2),NPlt);
[x0,y0]=meshgrid(x0,y0);

F0=baseFunction(x0,y0);

contour(x0,y0,F0,40); hold on;
plot(X(1,:),X(2,:),'k.'); % hold off;
