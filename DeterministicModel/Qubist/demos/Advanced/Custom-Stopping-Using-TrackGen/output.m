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

function output(world)
% This demo shows the implementation of a complex (although somewhat
% arbitrary) custom stopping criterion, using the Ferret's generation
% tracking features.

% Minimum # of generations before convergence.
minGen=5;

% Call getGen to get the 'gen' structure.
gen=getGen;

% init.m initialized the gen buffer to have length=2.  gen fills from the
% front, so the first element is the most recent.  The buffer is full and
% ready for evaluation when the last element is non-empty.
if ~isempty(gen{end})
    %
    % Check whether of not the std(X) is still decreasing.
    dXStd=std(gen{2}.X)-std(gen{1}.X);
    disp(['Change in std(X) = ', num2str(dXStd)]);
    %
    % Allow for possible exit after a minimum of 5 generations.
    if world.par.bookKeeping.gen >= minGen
        if dXStd < 0
            abortQubist;
            disp('*** Solution has stopped improving.  Aborting run. ***');
        end
    end
end
