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

function plotMassRatio
% Plot a histogram of the mass ratio M1/M2.

load OptimalSolutions.mat;
mass1=OptimalSolutions.X(4,:);
mass2=OptimalSolutions.X(5,:);

figure(1);
hist(mass1./mass2, 100);
set(gca, 'FontSize', 14);
xlabel('Mass Ratio: M1/M2', 'FontSize', 16);
ylabel('N', 'FontSize', 16)
title('Mass Ratios of Models in the Optimal Set', 'Fontsize', 18)
