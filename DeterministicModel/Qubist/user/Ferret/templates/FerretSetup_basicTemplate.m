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
% Sets reasonable defaults for parameters where possible.
% Values are over-ridden by FerretSetup.m
% 
% ====================================
% User-defined parameters & output
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
%
% ====================================
% History
par.history.NGenPerHistoryFile=25; % [integer >= 1]: How many generations per History file?
%
% ====================================
% General
par.general.NPop=1; % [integer >= 1]: Number of populations.
par.general.popSize=500; % [integer >= 1]: Size of each population.
par.general.NGen=1000; % [integer >= 1]: Maximum number of generations to run for.
par.general.min=[0, 0]; % [real vector]: Minimum values of all parameters.
par.general.max=[1, 1]; % [real vector]: Maximum values of all parameters.
par.general.XLabels={}; % [Cell array of strings]: Give names to some or all parameters: {'A','B',...}
par.general.FLabels={}; % [Cell array of strings]: Give names to some or all fitness values: {'FA','FB',...}
%
% ====================================
% Competition
par.selection.PTournament=1; % [0 - 1]: Natural selection: probability that each individual will compete.
par.selection.pressure=1; % [0 - 1]: Natural selection pressure on overall fitness.
par.selection.PPreferSuperiorMates=1; % [0 - 1]: Sexual selection: probability that individuals prefer superior mates during XOver.
%
% ====================================
% Mutation
par.mutation.PMutate=0.05; % [0 - 1]: Probability of mutation.
par.mutation.scale=0.25; % [0 - 1]: Min & max scale of mutation.
%
% ====================================
% Crossover
par.XOver.PXOver=1;  % [0 - 1]: Probability of X-Type crossovers.
par.XOver.strength=0.5; % [0 - 1]: Scale of crossover.
par.XOver.PAntiXOver=0; % [0 - 1]: Probability of anti-crossovers.
%
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % [0 - 1]: Probability of Building Block crossovers.
par.XOverBB.multiBB=false; % [logical]: Single or multiple BB XOver?
%
% ====================================
% Niching
par.niching.mergeMetric='combine'; % [string: 'combine' (default) or 'Pareto']: Method to combine niching in P, X, and F spaces.
par.niching.P=0;  % [0 - 1]: Pattern niching: Typically ~0.5 is about right.
par.niching.X=0;  % [0 - 1]: X-Niching: Typically ~0.25 is about right.
par.niching.F=0;  % [0 - 1]: F-Niching: Typically ~0.25 is about right.
%
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0; % [0 - 1]: Probability of gene deactivation.
par.CPD.PReactivateGenes=0; % [0 - 1]: Probability of gene reactivation.
%
% ====================================
% Immigration
par.immigration.PImmigrate=0.05; % [0 - 1, usually << 1]: Probability of immigration between populations.
%
% ====================================
% Elitism
par.elitism.frac=0.05; % [0 - 1]: Fraction of population that are designated elite.
