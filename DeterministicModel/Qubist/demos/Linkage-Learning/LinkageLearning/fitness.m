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
% Each BB contributes -1 to the fitness.  For 10 BBs, the solution is -10.

BBSize=3;
threshold=0.8;

[NGenes,popSize]=size(X);
if mod(NGenes,BBSize) ~= 0
	error('NGenes must be a multiple of BBSize!');
end

NBB=NGenes/BBSize;
% This is guaranteed to be an integer.

F=zeros(1,popSize);
S0=threshold*BBSize;

for i=1:popSize
    X1=X(:,i);
    for b=1:NBB
        index=1+(b-1)*BBSize:b*BBSize;
        BB=X1(index);
        S=sum(BB); % max(S)=BBSize;
        if S < S0
            F1=S/S0;
        else
            F1=-(S-S0)/(BBSize-S0);
        end
        BBScale=1;
        F(i)=F(i)+BBScale*F1;
    end
end
