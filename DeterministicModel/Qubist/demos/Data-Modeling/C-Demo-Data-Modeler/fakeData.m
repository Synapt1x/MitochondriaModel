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

function data=fakeData(K)

data.K=K;
data.solution.C=rand(1,K.NTerms);
data.solution.phi=2*pi*rand(1,K.NTerms);

data.x=linspace(0,2*pi,K.N);
data.f0=zeros(1,K.N);
for n=1:K.NTerms
    C=data.solution.C(n);
    phi=data.solution.phi(n);
    data.f0=data.f0+C*cos(n*data.x+phi);
end

data.sigma=K.sigma*ones(1,K.N);
data.f=data.f0+data.sigma.*randn(1,K.N);
