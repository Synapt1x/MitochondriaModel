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

function extPar=init

extPar.NBeam=25;
extPar.tau=25;

x=linspace(-1,1,extPar.NBeam);
y=x;
[extPar.X,extPar.Y]=ndgrid(x,y);
extPar.mu=0.1+zeros(extPar.NBeam);
R=sqrt(extPar.X.^2+extPar.Y.^2);
extPar.mu(R<2/3)=1;
