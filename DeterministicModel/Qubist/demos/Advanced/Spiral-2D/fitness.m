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

function [F,auxOutput,saveData]=fitness(X,extPar)
% Qubist demo fitness function.

lambda=5;
r0=0.25;

x=X(1,:);
y=X(2,:);

r=sqrt(x.^2+y.^2);
theta=atan2(y,x);

F=sign(cos(2*pi/lambda*r0)-cos(theta+2*pi/lambda*r));
F(isnan(F))=Inf;

auxOutput={};
saveData={};
