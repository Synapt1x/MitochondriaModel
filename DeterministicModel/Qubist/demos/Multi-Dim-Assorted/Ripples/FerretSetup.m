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
par.general.min=8*pi*[-1,-1];
par.general.max=8*pi*[1,1];
par.general.softMin=[1,2];
par.general.softMax=[1,2];
par.general.XLabels={'X','Y'};
par.general.FLabels={'F'};
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.scale=0.25;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Zooming
par.zoom.NGen=Inf;
par.zoom.safety=0.25;
par.zoom.allowZoomOut=1;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
