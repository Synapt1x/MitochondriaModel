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

% ====================================
% User
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
par.user.output=''; % [string]: Name of optional user-defined output function called each move.
% ====================================
% Data Directory
% ====================================
% General
NTerms=numel(par.user.extPar.img);
par.general.min=zeros(1,NTerms);
par.general.max=ones(1,NTerms);
% ====================================
% Simplex
par.simplex.focusOnPolishing=true; % [logical]: true --> more thorough exploration.  false --> efficient polishing.
par.simplex.contractFactor=0.79; % [0 - 1] % Factor to contract by on contraction steps.
par.simplex.expandFactor=2; % [real > 1]: % Factor to expand by on expansion steps.
par.simplex.PKick=0.1; % [real > 1]: % Probability of a mutation-like kick.  Improves exploration.
% ====================================
% Stopping
par.stopping.maxNMoves=Inf; % [integer > 0]: Maximum number of simplex moves.
par.stopping.maxFEval=NaN; % [Integer > 0]: Maximum number of function evaluations (approximate).
par.stopping.XTol=NaN; % [real > 0, or real vector (length=# of parameters)]: Tolerance on parameters.
par.stopping.FTol=NaN; % [real > 0, or real vector (length=# of objectives)]: Tolerance on objectives.
