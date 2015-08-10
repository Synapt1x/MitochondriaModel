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

function [F,auxOutput]=fitness(X,par)
% Will minimize F.
% LOW F is a highly fit individual.

NIndiv=size(X,2);
K=par.K;

N=length(par.x);
F=NaN+zeros(1,NIndiv);
auxOutput=cell(1,NIndiv);
for i=1:NIndiv
    C0=X(1:K.NTerms,i);
    phi0=X(K.NTerms+1:end,i);
    [x,f]=calcFunction(C0,phi0,par);
    F(i)=sum( (f-par.f).^2./par.sigma.^2 )/(N-2*K.NTerms);
    auxOutput{i}=F(i); % OPTIONAL OUTPUT FIELD -- SEE GUIDE. 
end

F(isnan(F))=Inf;
