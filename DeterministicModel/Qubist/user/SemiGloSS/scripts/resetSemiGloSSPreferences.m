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

function resetSemiGloSSPreferences

try
    rmpref('SemiGloSS');
    msgboxCheckGraphics({'SemiGloSS has been successfully reset.';...
        'All saved preferences have been cleared'},...
        'Reset SemiGloSS');
catch
    msgboxCheckGraphics('There were no preferences to reset.',...
        'Reset SemiGloSS');
end
