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

function plotBinary(t,V,extPar)

t=t/extPar.K.yr;
kms=1e5;
V=V/kms;
VData=extPar.data.V/kms;

plot(t, VData(1,:), 'r', t, VData(2,:), 'r',...
    t, V(1,:), 'b', t, V(2,:), 'b');
xlabel('t (yr)');
ylabel('v (km/s)');
