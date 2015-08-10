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

function par=SAMOSA_setup(par)
% Sets reasonable defaults for parameters where possible.
% Values are over-ridden by SAMOSA_setup.
NTerms=getNTerms;
% ====================================
% User
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
par.user.output=''; % [string]: Name of optional user-defined output function called each move.
% ====================================
% Data Directory
% ====================================
% General
par.general.min=zeros(1,2*NTerms);
par.general.max=[ones(1,NTerms),2*pi*ones(1,NTerms)];
par.general.FAbsTol=10; % [real > 0]: Absolute tolerance on fitness values.
% ====================================
% Simplex
par.simplex.focusOnPolishing=false; % [logical]: true --> more thorough exploration.  false --> efficient polishing.
par.simplex.contractFactor=0.79; % [0 - 1] % Factor to contract by on contraction steps.
par.simplex.expandFactor=2; % [real > 1]: % Factor to expand by on expansion steps.
par.simplex.PKick=0.1; % [real > 1]: % Probability of a mutation-like kick.  Improves exploration.
% ====================================
% Stopping
par.stopping.maxNMoves=1000; % [integer > 0]: Maximum number of simplex moves.
par.stopping.maxFEval=NaN; % [Integer > 0]: Maximum number of function evaluations (approximate).
par.stopping.XTol=NaN; % [real > 0, or real vector (length=# of parameters)]: Tolerance on parameters.
par.stopping.FTol=NaN; % [real > 0, or real vector (length=# of objectives)]: Tolerance on objectives.
% ============================================
% Analysis
par.analysis.postProcess=''; % [string]: Name of code to process OptimalSolutions when analysis is done.
% ====================================
% Graphics & messages
par.interface.verbose=0; % [logical]: Verbose output?
par.interface.plotStep=1; % [integer > 0]: Number of steps between plot updates.
par.interface.graphics=1; % [integer: 1 or -1]: Graphics on or off?
par.interface.myColorMap='bone'; % [string: colormap name] User choice for colormap.
par.interface.myPlot=''; % [string]: Name of custom plot function.
par.interface.titleFontSize=12; % [integer >= 1]: Self-explanatory.
par.interface.labelFontSize=10; % [integer >= 1]: Self-explanatory.
par.interface.axisFontSize=8; % [integer >= 1]: Self-explanatory.
par.interface.xAxis.type='X'; % [string: 'X' or 'F']: Default X-axis type
par.interface.xAxis.value=1; % [1, NPar] or [1,NObj]: Default X-axis variable
par.interface.yAxis.type='X'; % [string: 'X' or 'F']: Default Y-axis type
par.interface.yAxis.value=2; % [1, NPar] or [1,NObj]: Default Y-axis variable
par.interface.zAxis.type='F'; % [string: 'X' or 'F']: Default Z-axis type
par.interface.zAxis.value=1; % [1, NPar] or [1,NObj]: Default Z-axis variable
par.interface.NPix=25; % [integer >= 1]: Size of the grid for contour and mesh plots.
par.interface.NContours=10; % [integer >= 1]: Number of contour levels for contour plots.
