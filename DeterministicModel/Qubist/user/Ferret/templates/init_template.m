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

function extPar=init

% -----------------------
% function signature:
% extpar=init()
%
% extPar --> Matlab structure
% -----------------------
%
% The purpose of this function is to allow the user to send a structure
% containing 'external parameters' to the fitness function.  These fields
% of extPar are static parameters; they do not vary from one call to the
% next.
%
% The init facility should be used for slow or computationally expensive
% steps in your project that only need to be done once, during initialization.
% Such steps are independent of the optimization parameters (the 'X'
% argument of the fitness function), and therefore do not vary from one call
% of the fitness function to the next.
%
% A good example of how to use init involves loading data from the disk that
% is used during a model fitting routine.  Loading data is very
% time-consuming, and there is no reason to do it every time the fitness
% function is called.  It is much better to load the data once in init, and
% allow Ferret to pass the data in memory to the fitness function.  Iint is also
% useful for loading constants that need to be passed to the fitness function.
%
% init is also used to define non-default names for the data directory
% (where History files are stored) and the scratch directory (used for
% parallel computing).  *It is useful to use a fast, non-network drive or
% ramdisk for the scratchDir.
%
% For example:
%
% -----------------------
% function extPar=init
%
% % Load some constants...
% extPar.K.c=2.99792458e8; % speed of light.
% extPar.K.G=6.673e-11; % gravitational constant.
%
% % Load a big matrix.
% extPar.data=load('myData');
%
% % Specify non-default dataDir and scratchDir.
% extPar.dataDir='C:\Users\JFiege\Documents\myDataDir';
% extPar.acratchDir='C:\Users\JFiege\Documents\myScratchDir';
%
% -----------------------
%
% Now, when the user's fitness function is called, it has access to extPar:
%
% -----------------------
% function F=fitness(X, extPar)
%
% c=extPar.K.c;
% G=extPar.K.G;
%
% myData=extPar.myData;
% -----------------------

