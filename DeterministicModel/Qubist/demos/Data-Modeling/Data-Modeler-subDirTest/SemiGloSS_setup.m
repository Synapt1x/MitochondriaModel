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

function par=SemiGloSS_setup(par)
% Sets reasonable defaults for parameters where possible.
% Values are over-ridden by LocustSetup.
% ============================================
NTerms=getNTerms;
% ============================================
% User
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
par.user.output=''; % [string]: Name of optional user-defined output function called each time step.
% ====================================
% Data Directory
% ====================================
% Mode
par.mode.map=1; % [logical]: Mapping mode?
% ====================================
% User
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
% ====================================
% General
par.general.NTracks=Inf; % [integer >= 1]: The number of tracks (if in random initialization mode)
par.general.min=zeros(1,2*NTerms);
par.general.max=[ones(1,NTerms),2*pi*ones(1,NTerms)];
par.general.cyclic=NTerms+1:2*NTerms;
par.general.discreteStep=[]; % Discrete stepsizes of some parameters?  0's or [] --> continuous.
par.general.cyclic=[]; % [integer vector > 1]: Which parameters are cyclic?
par.general.XLabels={}; % [Cell array of strings]: Give names to some or all parameters: {'A','B',...}
par.general.FLabels={}; % [Cell array of strings]: Give names to some or all fitness values: {'FA','FB',...}
% ====================================
% Memory
par.memory.N=10; % [integer >= 1]: Length of memory registers to record previously successful moves.
par.memory.AR0=10; % [real >= 1]: Initial axis ratio of probability distributions used to generate new parameter sets.
par.memory.ARMax=10000; % [real >= 1]: Maximum axis ratio allowed.
par.memory.sigma0=0.1; % [real > 0]: Initial scale of perturbations.
par.memory.epsilon=0.1; % [real > 0]: Initial relative variation of perturbation size (usually < 1).
par.memory.VMix0=0.5;
% ====================================
% Bias
par.bias.limits=[-0.5, 0.5]; % [real vector]:
par.bias.ramp=20;
par.bias.modFrac=[0.025, 0.1]; % [real vector]:
par.bias.slack=0.33;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivate=0.01; % [0 - 1]: Probability of gene deactivation
par.CPD.PReactivate=0.001; % [0 - 1]: Probability of gene reactivation
% ====================================
% Exit Criteria
par.stop.maxIt=10000; % [integer]: Maximum number of iterations
par.stop.stepFrac=0.25;
par.stop.tolX=0; % [real > 0]: Tolerance on parameters.
par.stop.tolF=0; % [real > 0]: Tolerance on the fitness.
% ====================================
% Analysis
par.analysis.maxItNoProgress=25; % [integer]: Maximum iterations allowed with no progress.
% ====================================
% Graphics
par.interface.graphics=1; % [logical]: Graphics on or off?
par.interface.titleFontSize=10; % [integer]: Self-explanatory.
par.interface.labelFontSize=8; % [integer]: Self-explanatory.
par.interface.axisFontSize=8; % [integer]: Self-explanatory.
