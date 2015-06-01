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

function myPlot(X, F, extPar)
persistent FMin FMax xTrueMin

QubistPar=extPar.QubistPar;
xMin=min(QubistPar.general.min(:,1));
xMax=max(QubistPar.general.max(:,1));

Nplt=250;
dx=(xMax-xMin)/(Nplt-1);
x0=xMin:dx:xMax;
yb=baseFunction(x0);
y0=fitness(x0, extPar);

if isempty(FMin) || isempty(FMax) || isempty(xTrueMin)
    FMin=min(F);
    FMax=max(F);
    xTrueMin=x0(yb==min(yb));
    xTrueMin=xTrueMin(1);
else
    FMin=min(FMin,min(F));
    FMax=max(FMax,max(F));
end

pl=plot(x0,y0); hold on;
set(pl, 'Color', [0.5,0.5,1]);
pl=plot([xTrueMin,xTrueMin],[FMin,FMax],'g');
set(pl,'LineWidth',3);
plot(X,F,'r.');
pl=plot(x0,yb,'k');
set(pl,'LineWidth',2); hold off;
    
axis([xMin,xMax,FMin,FMax])

xlabel('X');
ylabel('F')
