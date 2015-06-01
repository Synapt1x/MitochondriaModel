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
% Plot the F values on top of the theoretical curve.
% Pareto surface is a line joining the points x1=(0.5,0.5) and
% x2=(-0.5,-0.5).  On this line, y=x, which makes the trade-off surface
% easy to evaluate analytically (See Notes.txt):
%
x=linspace(-0.5, 0.5, 250);
x1=-0.5; x2=0.5;
F1=2*(x-x1).^2; F2=2*(x-x2).^2;
plot(F1, F2, 'b', F(1,:), F(2,:), 'r.');
xlabel('F_1');
ylabel('F_2');
