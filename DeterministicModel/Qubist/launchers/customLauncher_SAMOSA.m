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

function [OptimalSolutions, simplex]=customLauncher_SAMOSA
% Modify this script if you need to make a custom launcher for SAMOSA that
% runs from the command line.

% Set the Qubist component.
global QubistHome_ currentComponent_ randomSeed_
currentComponent_='SAMOSA';
%
% Reset the path:
path(pathdef);
%
% -----------------------------------------
% ---- QUBIST LAUNCH OPTIONS BEGIN HERE ---
% ---- MODIFY CODE BELOW THESE LINES ------
% -----------------------------------------
% *** MODIFY THIS LINE TO POINT TO THE QUBIST HOME DIRECTORY.
% This is usually a global path, but a relative path also works (even for parallel runs) 
% because a side-effect of setQubistPath is to convert QubistHome_ to a global path.
% QubistHome_='/Users/fiege/Documents/Qubist_Builder_PL/Qubist';
QubistHome_='/home/fiege/Documents/Qubist_Builder_PL/Qubist';
% -----------------------------------------
% *** Give the project path and setup file name.
currentProjectPath_=[QubistHome_, '/demos/Data-Modeling/Data-Modeler'];
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
%
% Add Qubist paths:
addpath(QubistHome_);
setQubistPath;
%
% Add the project directory.
addpath(currentProjectPath_);
%
% Initialize random number generator.
initializeRNG;
%
% Force Qubist abort status to 0 so that SAMOSA can run.
forceAbortQubist(0);
%
% Load the default SAMOSA setup file and modify it using the project's setup file.
par=defaultSAMOSA_setup;
par=SAMOSA_setup(par);
%
% Turn off graphics.
par.interface.graphics=-1;
%
% Load the init file, and add it to par.
par.user.extPar=init;
%
% ----------------------------------------------------------------------
% Validate the fitness function.  Comment out these lines if to are running
% your project many times and are *sure* that your fitness function works.
validateFitnessFunction('SAMOSA', par);
%
% Abort if validation fails.
if getQubistAbortStatus; % Checks the abort status.
    disp('Stopping due to problems with the fitness function...');
    return
end
% ----------------------------------------------------------------------
%
% This is not a parallel run.
setGUIData('parallel', false);
%
% Start SAMOSA
[OptimalSolutions, simplex]=SAMOSA(par);
