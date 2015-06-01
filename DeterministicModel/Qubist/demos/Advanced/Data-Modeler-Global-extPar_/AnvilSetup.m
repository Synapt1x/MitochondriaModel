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

function par=AnvilSetup(par)
% Sets reasonable defaults for parameters where possible.
% Values are over-ridden by AnvilSetup.
NTerms=getNTerms;
% ====================================
% User
par.user.fitnessFcn='fitness'; % Name of the fitness function.
par.user.output=''; % [string]: Name of optional user-defined output function called each timestep.
% ====================================
% Data Directory
% ====================================
% General
par.general.min=zeros(1,2*NTerms);
par.general.max=[ones(1,NTerms),2*pi*ones(1,NTerms)];
par.general.cyclic=NTerms+1:2*NTerms;
% ====================================
% Annealing constants
par.anneal.T0=250; % Starting temp.
par.anneal.TMin=0; % Min temp.
par.anneal.TCool=1000; % [0 - 1]: Cooling timescale.
par.anneal.Tf=0.00; % Temp for exit.
par.anneal.PReheat=0.01; % [0 - 1]: Probability of re-heating.
par.anneal.sigma=0.1; % Initial perturbation size.
% ====================================
% Tracks
par.tracks.N=100; % The number of Anvil tracks.
par.tracks.window=25; % [real ~ 1]: Anvil keeps ceil(par.tracks.window*par.tracks.N) steps in memory.
% Used to control adaptive cooling and dynamic perturbation size.
% ====================================
% Crossover: A GA-like crossover operator.
par.XOver.PXOver=1; % Probability of crossover between Anvil tracks.
par.XOver.strength=0.5; % The strength of the crossover operator.
par.XOver.dispersion=0.1; % Randomization during crossover.
% ====================================
% Selection
par.selection.PSelect=1; % [0 - 1]: Selection pressure for a GA-like selection operator.
par.selection.FAbsTol=0; % [real >= 0]: Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.selection.FRelTol=0; % [real >= 0]: Relative fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
% ====================================
% Stopping criteria
%
par.stopping.maxTimeSteps=Inf; % [integer > 0]: Maximum number of time steps
par.stopping.maxItNoImprovement=25; % [integer]: % Maximum number of steps with no improvement.
%
% Tolerance on X and F - mainly for single-objective problems.
par.stopping.XTol=NaN; % [real > 0, or real vector (length=# of parameters)]: Tolerance on parameters.
par.stopping.FTol=NaN; % [real > 0, or real vector (length=# of objectives)]: Tolerance on objectives.
par.stopping.boolean=@or; % [boolean operator]: Should be '@and' or '@or'.
%
% Max number of solutions allowed in final optimal set.
par.stopping.maxNOptimals=1000; % [integer]: Max number of optimals.
% ====================================
% Niching
par.niching.X=0.25;  % [0:1]: X-Niching: Typically ~0.25 is about right.
par.niching.F=0;  % [0:1]: F-Niching: Typically ~0.25 is about right.
par.niching.exponent=2; % [real: usually > 0 & <~ 2]: Used in the niche function.
% ============================================
% Analysis
par.analysis.postProcess=''; % [string]: Name of code to process OptimalSolutions when analysis is done.
% ============================================
% Graphics & messages
par.interface.graphics=1; % [integer: 1 or -1]: Graphics on or off?
par.interface.plotStep=1; % How often to update graphics?
par.interface.myPlot=''; % Name of custom plot function.
par.interface.titleFontSize=10; % Self-explanatory.
par.interface.labelFontSize=8; % Self-explanatory.
par.interface.axisFontSize=8; % Self-explanatory.
par.interface.xAxis.type='X'; % Default X-axis type (X or F)
par.interface.xAxis.value=1; % Default X-axis variable (1 - NPar or NObj)
par.interface.yAxis.type='X'; % Default Y-axis type (X or F)
par.interface.yAxis.value=2; % Default Y-axis variable (1 - NPar or NObj)
par.interface.zAxis.type='F'; % Default Y-axis type (X or F)
par.interface.zAxis.value=1; % Default Y-axis variable (1 - NPar or NObj)
