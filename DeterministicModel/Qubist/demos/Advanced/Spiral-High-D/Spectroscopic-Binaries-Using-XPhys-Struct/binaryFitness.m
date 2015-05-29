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

function F=binaryFitness(X,extPar)
% Fitness function for the spectroscopic binary modeling code from the
% Qubist User's Guide.
%
% Determine number of parameters and the number of solutions requesed by
% Ferret.
if isempty(X)
    N=0;
else
    N=X(1).info.N;
    NPar=X(1).info.NPar;
end
for i=N:-1:1
    if isAbortEval(extPar.status)
        F=[];
        break
    end
    %
    if mod(i,10)==0
        % Pause occasionally to keep user interfaces responsive.
        pause(0.001);
    end
    %
    % Compute the velocity curves:
    % t --> time (unused).
    % V --> velocity.
    extPar.binaryPar=getBinaryPar(X(i),extPar);
    [t,V]=binary(extPar);
    %
    % Degrees of freedom:
    DOF=numel(extPar.data.V)-NPar;
    %
    % Fitness: just the usual reduced chi^2 formula.
    F(i)=sum(sum((V-extPar.data.V).^2/extPar.data.dV^2))/DOF; %#ok
    %
end
