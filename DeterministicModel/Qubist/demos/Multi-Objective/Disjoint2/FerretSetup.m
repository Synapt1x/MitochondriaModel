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
par.general.min=0;
par.general.max=5;
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.7;
% ====================================
% Niching
par.niching.X=0.25;
% par.niching.F=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001;
par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PAntiXOver=0.1; 
% ====================================
% Immigration
par.immigration.PImmigrate=0.;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Zooming
par.zoom.NGen=5;
par.zoom.safety=0.5; % [real, usually <= 1]
par.zoom.allowZoomOut=1; % [0 or 1]
% ====================================
% Interface
par.interface.xAxis.type='F';
par.interface.xAxis.value=1;
par.interface.yAxis.type='F';
par.interface.yAxis.value=2;
par.interface.yAxis.type='X';
par.interface.yAxis.value=1;