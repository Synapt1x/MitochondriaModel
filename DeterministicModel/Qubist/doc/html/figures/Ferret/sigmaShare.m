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

function sigmaShare

N=1e3;
x=[linspace(eps,1,N), linspace(1+eps,2,N)];
phi0=calcPhi(x,0);
phi5=calcPhi(x,0.5);
phi1=calcPhi(x,1);
phi2=calcPhi(x,2);
figure(1);
plot(x,phi2,'b', x,phi1,'g', x,phi5,'r', x,phi0,'c', 'LineWidth', 2);
axis([0,1.5,0,1.1]);
set(gca, 'FontSize', 16);
xlabel('d_{i,j}', 'FontSize', 20);
ylabel('(1-d_{i,j})^p', 'FontSize', 20);
legend('p=2', 'p=1', 'p=0.5', 'p=0')

function phi=calcPhi(x,p)
phi=zeros(1,length(x));
index=x<=1;
phi(index)=(1-x(index)).^p;