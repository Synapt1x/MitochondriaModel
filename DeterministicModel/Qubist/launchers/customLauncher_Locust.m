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

function customLauncher_Locust
% Modify this script if you need to make a custom launcher for Locust that
% runs from the command line.

% Set the Qubist component.
global QubistHome_ currentComponent_ randomSeed_
currentComponent_='Locust'; % Set the component.
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
% Force Qubist abort status to 0 so that Locust can run.
forceAbortQubist(0);
%
% Add the project path.
addpath(currentProjectPath_);
%
% Initialize random number generator.
initializeRNG;
%
% Parallelization info.
setGUIDataRoot('parallel', false);
launchDir=fileparts(which(mfilename));
setGUIDataRoot('launchDir', launchDir);
%
% -----------------------------------------
% Load the init file.  You should use getExtPar to do this, because
% getExtPar sets options that are required for parallel runs.  If you
% don't want to do parallel runs, you *can* simple do:
% extPar=init;
%
runInfo.projectPath=currentProjectPath_;
runInfo.initFile='init';
runInfo.initMode='LOAD';
extPar=getExtPar(runInfo);
% -----------------------------------------
% Set the graphics mode.  Uncomment one of the following 2 lines.
setQubistMode('RunNoGraphics'); % Uncomment to run with no graphics (normal for batch processing).
% setQubistMode('Run'); % Uncomment to run with full graphics.
% -----------------------------------------
% *** Additions to extPar here... ***
extPar.projectPath=currentProjectPath_; % ESSENTIAL!
% -----------------------------------------
%
% Start Locust.  Note that validation of the fitness function is done
% inside LocustDriver.
LocustDriver(extPar);
