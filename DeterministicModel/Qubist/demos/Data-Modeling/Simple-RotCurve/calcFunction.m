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

function rho=calcFunction(extPar)

K=extPar.K;
rhoIn=0.5*(1+tanh(extPar.r-K.rIn));
rhoOut=0.5*(1-tanh(extPar.r-K.rOut));
rMid=(K.rIn+K.rOut)/2;
slopeFcn=1+K.drho_dr*(extPar.r-rMid);
rho=K.rho0*rhoIn.*rhoOut.*slopeFcn;
rho(rho < 0)=0;
