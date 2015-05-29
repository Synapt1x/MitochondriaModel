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
NDim=20; rmax=10;
par.general.min=-rmax*ones(1,NDim);
par.general.max=rmax*ones(1,NDim);
par.general.NPop=2;
par.general.popSize=250;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.PPreferSuperiorMates=0.5;
par.selection.FRankTol=0.33;
% ====================================
% Niching
par.niching.X=0.25;
% par.niching.acceleration=1;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.025;
par.mutation.selectiveMutation=-0.5;
% par.mutation.BBRestricted=0;
par.mutation.PSuperMutate=0.025;
% ====================================
% Crossover
par.XOver.PXOver=1;
par.XOver.PAntiXOver=0.5;
par.XOver.dispersionTechnique='cylindrical'; % Hollow cylinder.
par.XOver.dispersion=0.25;
par.XOver.matingRestriction.X=-0.5;
% par.XOver.PPreferSuperiorMates=false;
% par.XOver.ALS=1;
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
par.elitism.frac=0.05;
% ====================================
% Linkage Learning
par.link.PLink=0.5;
% par.link.strategy=1;
% par.link.mixDim=0;
% ====================================
% Interface
par.interface.graphics=1;
par.interface.myPlot='myPlot';

par.niching.XPar=[1,2];
par.zoom.NGen=25;
% par.strategy.isAdaptive=false;
par.strategy.adapt.XOver.ALS=false; 
