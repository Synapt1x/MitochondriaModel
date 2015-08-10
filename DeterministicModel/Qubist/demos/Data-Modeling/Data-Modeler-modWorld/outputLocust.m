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

function [dummy, swarm]=outputLocust(swarm)
dummy=[];

% Add parameters every NRefine generations:
NRefine=25;

if mod(swarm.timeStep, NRefine) == 0
    [NPar, N]=size(swarm.coords.X); %#ok
    swarm.par.general.min=[swarm.par.general.min, 0, 0];
    swarm.par.general.max=[swarm.par.general.max, 1, 2*pi];
    swarm.par.general.cyclic=[swarm.par.general.cyclic, NPar+2];
    %
    %
    % Add 2 new parameters by adding 2 rows to swarm.coords.X:
    XMod=[rand(1,N); 2*pi*rand(1,N)];
    swarm.coords.X=[swarm.coords.X; XMod];
    %
    % Fitness will be re-evaluated automatically.  No need to do it
    % here.
    %
    % Tell Locust that you want to restart.
    setGUIData('restart', true);
end
