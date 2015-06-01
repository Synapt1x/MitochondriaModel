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

function projects=QubistGlobalProjects
%
% To add ***GLOBALLY ACCESSIBLE*** projects to the Projects menu:
%
% Edit this file and add the path info for your projects in the 
% following format: 
% 
% projects{n}.path='/full/path/to/project/directory'; %[default: ./]
% projects{n}.name='Project Name'; %[default: deepest directory in projects{n}.path]
% projects{n}.init='initializationCode'; %[default: none]
% projects{n}.setup='FerretSetupFile'; [default: 'FerretSetup']
% 
% Here, n is an integer giving the number of the entry in the projects
% menu.  Start at n=1 for the 1st entry, n=2 for the 2nd, etc.
% Path should be the full directory path to the project, which contains
% the setup file and the fitness m-file.  Name is the arbitrary name of
% the project.  Init is an optional initilization m-file that produces
% an external parameter structure that is passed to Ferret.  Setup is
% the name of the Ferret setup file.
%
projects={};
%
% =========================================================================
% MODIFY THESE LINES TO ADD *GLOBAL* PROJECTS VISIBLE TO *ALL* USERS:
%
% projects{1}.path='/Users/fiege/Documents/myGlobalProject';
% projects{1}.name='Sample Global Qubist Project';
% projects{1}.init='init';
% projects{1}.setup='FerretSetup';
%
% =====================================================================
