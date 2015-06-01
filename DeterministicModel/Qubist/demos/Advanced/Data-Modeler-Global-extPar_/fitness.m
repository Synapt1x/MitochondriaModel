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
global extPar_
% Qubist demo fitness function.

NIndiv=size(X,2);
K=extPar_.K;

N=length(extPar_.x);
F=NaN+zeros(1,NIndiv);
for i=NIndiv:-1:1
    if isAbortEval(extPar.status)
        % It is good form to supply all outputs, even if there is an
        % early exit in a parallel run.
        F=[]; auxOutput={}; saveData={};
        break
    end
    C0=X(1:K.NTerms,i);
    phi0=X(K.NTerms+1:end,i);
    [x,f]=calcFunction(C0,phi0);
    F(i)=sum( (f-extPar_.f).^2./extPar_.sigma.^2 )/(N-2*K.NTerms);
    auxOutput{i}=F(i); %#ok
    saveData{i}=F(i); %#ok
end
