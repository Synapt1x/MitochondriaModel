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

function resetQubistPreferences
% Resets preferences for Qubist and all of the component optimizers.

pref={'Qubist', 'Ferret', 'SemiGloSS', 'Anvil', 'Locust'};
message={'Attempting to reset preferences for Qubist package and all optimizers.', ''};

for p=1:length(pref)
    try
        rmpref(pref{p});
        message=[message, {['Preferences were reset for ', pref{p}, '.']}]; %#ok
    catch
        message=[message, {['No preferences to reset for ', pref{p}, '.']}]; %#ok
    end
end
message=[message, {'', 'Finished resetting preferences.'}];

msgboxCheckGraphics(message, 'Reset Qubist Preferences');
