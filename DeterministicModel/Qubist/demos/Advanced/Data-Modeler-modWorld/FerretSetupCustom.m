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
% ----------------------------------------------------------------
% This setup file is only meant to demonstrate the customLauncher.m
% program in the main directory.
disp('')
disp(' *** DATA-MODELER: SETUP FILE CALLED FROM CUSTOMLAUNCHER.M ***')
disp('')
% ----------------------------------------------------------------
%
K=par.user.extPar.K;
%
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
par.history.saveOnlyOptimals=1;
% ====================================
% General
par.general.min=zeros(1,2*K.NTerms);
par.general.max=[ones(1,K.NTerms),2*pi*ones(1,K.NTerms)];
par.general.cyclic=K.NTerms+1:2*K.NTerms;
par.general.NPop=1;
par.general.popSize=50;
par.general.NGen=10;
% ====================================
% Parallel Computing
par.parallel.NWorkers=1; % Number of worker nodes to launch initially.
par.parallel.timeout=10000; % Maximum time in seconds before an unresponsive node disconnects.
par.parallel.useJava=true; % Is Java required for worker nodes?
par.parallel.writeLogFiles=true; % Are log files required?
% ====================================
% Selection
par.selection.PTournament=1;
% ====================================
% Niching
par.niching.ParetoNiching=1;
par.niching.X=0.25;
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
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1; 
% ====================================
% Analysis
par.analysis.analyzeWhenDone=1;
% ====================================
% Immigration
par.immigration.PImmigrate=0.25;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
% ====================================
% Zooming
par.zoom.NGen=5;
par.zoom.safety=0.1;
% ====================================
% Interface
par.interface.myPlot='myPlot';
