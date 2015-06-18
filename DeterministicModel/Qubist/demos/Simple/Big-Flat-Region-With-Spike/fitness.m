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

function F=fitness(X,extPar)

xSpike=-0.75+zeros(extPar.D,1);
rSpike=0.05;
dSpike=1.0;

r=sqrt(sum( bsxfun(@minus, X, xSpike).^2, 1));

% F=-dSpike*max(0, (1-r/rSpike));
F=-dSpike*exp(-r.^2/rSpike^2);
% F=-dSpike*exp(-abs(r/rSpike));
