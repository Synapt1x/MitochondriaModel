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

function startSemiGloSS_project(projectPath, varargin)
global currentComponent_ randomSeed_
% Simple interface to startQubistProject.

% Specify component.
currentComponent_='SemiGloSS';

% -----------------------------------------
% ---- QUBIST LAUNCH OPTIONS BEGIN HERE ---
% ---- MODIFY CODE BELOW THESE LINES ------
% -----------------------------------------
% *** Initialize random number generator.
% The value of global variable randomSeed_ determines the behaviour of
% the random number generator.  Accepted values are as follows:
randomSeed_=NaN; % Use a DIFFERENT random seed each time.
% randomSeed_='same'; % Use SAME random seed each time = 5489.
% randomSeed_=<INTEGER>; % Use random seed = <INTEGER>, where <INTEGER>
%   is replaced by an actual integer.  For example, randomSeed_=1234;
% -----------------------------------------
% ----- QUBIST LAUNCH OPTIONS END HERE ----
% ----- MODIFY CODE ABOVE THESE LINES -----
% -----------------------------------------

% Add full path.
setQubistPath;

% This is not a parallel run.
setGUIData('parallel', false);

% Initialize runInfo.
runInfo.initMode='LOAD';
setGUIData('runInfo', runInfo');

% Reset graphics.
rmGUIData('graphics');

% Start Qubist.
startQubistProject(projectPath, varargin{:});
