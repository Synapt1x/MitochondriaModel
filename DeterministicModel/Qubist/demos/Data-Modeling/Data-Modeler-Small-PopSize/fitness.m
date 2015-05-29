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

function F=fitness(X,extPar)
% Qubist demo fitness function.

NIndiv=size(X,2);
K=extPar.K;

N=length(extPar.x);
F=NaN+zeros(1,NIndiv);
for i=1:NIndiv
    C0=X(1:K.NTerms,i);
    phi0=X(K.NTerms+1:end,i);
    [x,f]=calcFunction(C0,phi0,extPar);
    F(i)=sum( (f-extPar.f).^2./extPar.sigma.^2 )/(N-2*K.NTerms);
end
