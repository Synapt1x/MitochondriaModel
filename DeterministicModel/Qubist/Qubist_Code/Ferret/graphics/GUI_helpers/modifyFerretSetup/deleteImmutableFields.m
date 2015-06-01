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

function par=deleteImmutableFields(par)
% Deletes some fields from the modifyFerretSetup interface

immutableFields={'user.fitnessFcn', 'general.dataDir', 'general.NPop',...
    'general.NGenes', 'general.popSize', 'general.min', 'general.max',...
    'general.setupFile', 'general.projectPath', 'general.NObj',...
    'setup', 'bookKeeping', 'user.output', 'ferret.gen', 'ferret.min', 'ferret.max'};
index=[];
for i=1:length(immutableFields)
    index=[index; find(~cellfun('isempty',strfind(par.list, immutableFields{i})))]; %#ok
end
par.list(index)=[];
par.values(index)=[];
