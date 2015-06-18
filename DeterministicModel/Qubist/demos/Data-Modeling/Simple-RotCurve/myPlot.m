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

[F,index]=min(F);
X1=X(:,index);
extPar.K=X2Par(X1,extPar.K);
extPar.rho=calcFunction(extPar);

plot(extPar.r,extPar.data.rho,'r+', extPar.r,extPar.rho);
xlabel('r');
ylabel('\rho(r)');
