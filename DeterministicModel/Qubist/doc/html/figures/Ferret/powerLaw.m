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
phip5=calcPhi(x,0.5);
phi1=calcPhi(x,1);
phi2=calcPhi(x,2);
phi5=calcPhi(x,4);
figure(1);
plot(x,phi5,'b',x,phi2,'g', x,phi1,'r', x,phip5,'c', 'LineWidth', 2);
axis([0,1,0,1.1]);
set(gca, 'FontSize', 16);
xlabel('d_{i,j}', 'FontSize', 20);
ylabel('(1+d_{i,j}/\sigma_{share})^{-p}', 'FontSize', 20);
legend('p=4', 'p=2', 'p=1', 'p=0.5')
box on

function phi=calcPhi(x,p)
sigmaShare=0.25;
phi=zeros(1,length(x));
phi=(1+x/sigmaShare).^(-p);
