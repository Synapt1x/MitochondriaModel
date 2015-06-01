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

function par=FerretSetup(par,varargin)
%
% User
par.user.fitnessFcn='fitness';
% par.user.output='output';
% ====================================
% History
% ====================================
% General
NDim=2; rmax=10;
par.general.min=-rmax*ones(1,NDim);
par.general.max=rmax*ones(1,NDim);
par.general.NPop=1;
par.general.popSize=200;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.75;
% ====================================
% Niching
par.niching.X=0.25;
par.niching.acceleration=1;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.1;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1;
par.XOver.PAntiXOver=0.15;
par.XOver.dispersionTechnique='cylindrical'; % Hollow cylinder.
par.XOver.dispersion=0.25;
par.XOver.matingRestriction.X=-0.5;
par.XOver.ALS=0;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.00;
par.CPD.PReactivateGenes=0.005;
par.CPD.NaN2Random=1;
% ====================================
% Elitism
par.elitism.frac=0.1;
% ====================================
% Linkage Learning
par.link.PLink=0.25;
% par.link.strategy=1;
% par.link.mixDim=0;
% ====================================
% Interface
par.interface.graphics=1;
par.interface.myPlot='myPlot';

par.zoom.NGen=25;
% par.strategy.isAdaptive=false;
par.strategy.adapt.XOver.ALS=false; 
