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

function [F, auxOutput, saveData, X]=fitness(X,extPar)
% Qubist demo fitness function.

NIndiv=size(X,2);
K=extPar.K;
auxOutput={};
saveData={};

N=length(extPar.x);
F=NaN(1,NIndiv); fDiffMax=Inf;
for n=NIndiv:-1:1
    if isAbortEval(extPar.status)
        % It is good form to supply all outputs, even if there is an
        % early exit in a parallel run.
        F=[];
        break
    end
    [model, X(:,n)]=makeModel(X(:,n),extPar);
    fDiff=abs(model.f-extPar.solution.f);
    fDiffMax=min(fDiffMax, max(fDiff));
    if K.noise == 0
        F(n)=sum( fDiff.^2 )/(N-2*K.NTerms);
    else
        F(n)=sum( fDiff.^2./K.noise.^2 )/(N-2*K.NTerms);
    end
end
