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

function F=fitnessFerret(X,extPar)
global extPar_
% Qubist demo fitness function.

% Comment one of these out to toggle between internal optimizers.
internalOptimizer=@SAMOSA;
% internalOptimizer=@Anvil;

F=0;
for i=1:size(X,1)
    if isAbortEval(extPar.status)
        % It is good form to supply all outputs, even if there is an
        % early exit in a parallel run.
        F=[];
        break
    end
    %
    % Call SAMOSA or Anvil.
    if strcmpi(func2str(internalOptimizer), 'SAMOSA')
        % Call SAMOSA.
        OptimalSolutionsInternal=internalOptimizer(extPar.QubistPar.user.SAMOSA_par);
    else
        % Call Anvil.
        OptimalSolutionsInternal=internalOptimizer(extPar.QubistPar.user.AnvilPar);
    end
    %
    % Grab just one optimal:
    F_internal=OptimalSolutionsInternal.F(1);
    %
    % Generate Ferret's fitness function, using the value returned by
    % SAMOSA.
    F=F+(extPar_.shared.K+extPar_.internal.K(i))*sum(X.^2,1)+F_internal;
end
