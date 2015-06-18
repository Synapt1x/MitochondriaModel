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

function [model,X]=makeModel(X,extPar)

NTerms=extPar.K.NTerms;
%
% Unpack X -> model parameters.
model.height=X(1:NTerms);
model.width=X(NTerms+1:2*NTerms);
if extPar.fixCentre
    model.centre=extPar.solution.centre;
else
    model.centre=X(2*NTerms+1:3*NTerms);
end
%
% Sort by line centre.
[model.centre, index]=sort(model.centre);
model.height=model.height(index);
model.width=model.width(index);
if extPar.fixCentre
    model.cont=X(2*NTerms+1:end);
    X=[model.height; model.width; model.cont];
else
    model.cont=X(3*NTerms+1:end);
    X=[model.height; model.width; model.centre; model.cont];
end
%
% Remove lines with zeros width.
index=model.width == 0;
model.width(index)=1;
model.height(index)=0;
%
% Generate the model
model.f=model.cont(1)*exp(-(extPar.x-model.cont(3)).^2/2./model.cont(2)^2);
for n=extPar.K.NTerms:-1:1
    model.f=model.f+model.height(n).*...
        exp(-(extPar.x-model.centre(n)).^2/2./model.width(n).^2);
end
