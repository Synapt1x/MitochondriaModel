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

function par=FerretSetup(par)
%
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
% ====================================
% General
par.general.min=[0,-1,-1];
par.general.max=[6,3,2];
par.general.XLabels={'tag', 'X','Y'};
par.general.FLabels={'F'};
par.general.tag=1;
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=1000;
% ====================================
% Strategy Parameters
par.strategy.isAdaptive=true; % [logical]: Global switch for strategy adaptation.
par.strategy.NGen=25; % [integer > 1]: Number of generations over which trackers are smoothed and forget their history.
%
% Which strategy parameters are allowed to adapt? (true or false)
par.strategy.adapt.mutation.scale=true; % [logical]
par.strategy.adapt.XOver.dispersion=true; % [logical]
par.strategy.adapt.XOver.strength=true; % [logical]
par.strategy.adapt.XOver.ALS=false; % [logical]
par.strategy.adapt.XOver.matingRestriction=true; % [logical]
par.strategy.adapt.niching.acceleration=false; % [logical]
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.FAbsTol=0.025;
par.selection.clusterScale=0.5;
par.selection.competitionRestriction=0;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.scale=0.25;
par.mutation.selectiveMutation=0;
par.mutation.PSuperMutate=0.01;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.strength=0.5;
par.XOver.dispersion=0.25;
par.XOver.matingRestriction.X=0;
% ====================================
% Niching
par.niching.X=0.33;
% ====================================
% Zooming
par.zoom.NGen=5;
par.zoom.safety=0.25;
par.zoom.allowZoomOut=1;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% ====================================
% Graphics & messages
par.interface.graphics=1; % [integer: 1, 0, or -1]: Full graphics (1), low graphics (0), or no graphics (-1)?
par.interface.axisFontSize=8; % [integer >= 1]: Self-explanatory.
par.interface.xAxis.type='X'; % ['X' or 'F']: Default X-axis type
par.interface.xAxis.value=2; % [1, NPar] or [1,NObj]: Default X-axis variable
par.interface.yAxis.type='X'; % ['X' or 'F']: Default Y-axis type
par.interface.yAxis.value=3; % [1, NPar] or [1,NObj]: Default Y-axis variable
par.interface.zAxis.type='F'; % ['X' or 'F']: Default Z-axis type
par.interface.zAxis.value=1; % [1, NPar] or [1,NObj]: Default Z-axis variable
