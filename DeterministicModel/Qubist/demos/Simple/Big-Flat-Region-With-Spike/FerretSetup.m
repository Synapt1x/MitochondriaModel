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
% General
D=par.user.extPar.D;
par.general.min=-ones(1,D);
par.general.max=ones(1,D);
par.general.NPop=4;
par.general.popSize=100;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.FAbsTol=1;
par.selection.exploitFrac=0.1;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.scale=0.25;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.ALS=0;
par.XOver.dispersion=0.25;
% ====================================
% Niching
par.niching.X=0.3;
% ====================================
% Zooming
par.zoom.NGen=10;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';

par.XOverBB.PXOver=1;
par.link.PLink=0.5;
