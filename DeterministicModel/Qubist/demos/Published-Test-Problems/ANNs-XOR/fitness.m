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

function F=fitness(X)
% ANNs-XOR function from Mishra 2006.
% Online at http://mpra.ub.uni-muenchen.de/1742/ 
% MPRA Paper No. 1742, posted 07. November 2007 / 01:57
%
% Very difficult function: unknown true solution.
% Best solution found by Mishra:
% F_min(0.99999, 0.99993, -0.89414,  0.99994, 0.55932, 0.99994, 0.99994, -0.99963,  -0.08272))=0.95979 
% I don't agree with his solution.  The published values result in
% F_min=0.9661 by direct evaluation.
%
% Ferret finds:
% F = 0.96556 @ X = [-1 1 -1 -1 -1 -0.5846 1 -1 -0.1007]
% Result is reproducible.  Found this with 10 populations of 100
% individual.
%
% The discrepancy could just be due to round-off errors - numerical
% differences in F are very small.
%
% I'm defining all these x variables just to improve readability of this
% complicated function.
x1=X(1,:);
x2=X(2,:);
x3=X(3,:);
x4=X(4,:);
x5=X(5,:);
x6=X(6,:);
x7=X(7,:);
x8=X(8,:);
x9=X(9,:);

f1=(1+exp(-x7./(1+exp(-x1-x2-x5))-x8./(1+exp(-x3-x4-x6))-x9)).^-2;
f2=(1+exp(-x7./(1+exp(-x5))-x8./(1+exp(-x6))-x9)).^(-2);
f3=(1-(1+exp(-x7./(1+exp(-x1-x5))-x8./(1+exp(-x3-x6))-x9)).^-1).^2;
f4=(1-(1+exp(-x7./(1+exp(-x2-x5))-x8./(1+exp(-x4-x6))-x9)).^-1).^2;
F=f1+f2+f3+f4;
