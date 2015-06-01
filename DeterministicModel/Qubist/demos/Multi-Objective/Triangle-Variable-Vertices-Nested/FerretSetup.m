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
% ====================================
% User
par.user.fitnessFcn='fitnessOuter';
% ====================================
% Data
% ====================================
% General
par.general.min=0;
par.general.max=2*pi;
par.general.XLabels={'\theta'};
par.general.FLabels={'F_A'};
par.general.cyclic=1;
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.FAbsTol=0;
par.selection.pressure=1;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
par.CPD.NaN2Random=1;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PXOverBB=1;
par.XOver.PAntiXOver=0.1; 
% ====================================
% Elitism
par.elitism.frac=0.001; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0;

%
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% @  EXTRA SETUP INFO FOR SAMOSA AND Anvil
% @ All extra setup info MUST go into par.user if you want 
% @ this demo to also work with Locust.  par.user is copied
% @ into LocustSetup verbatim by the translation program
% @ translateFerretToLocust.  Other user-defined fields are
% @ not copied.                                        
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%
% !!!!! ADD SETUP INFO FOR SAMOSA. !!!!!
% This info is required for the SAMOSA call that is embedded in Ferret's
% fitness function.
%
% Load an INCOMPLETE default setup file from
% Qubist/user/Ferret/defaults/defaultSAMOSA_setup.
par.user.SAMOSA_par=defaultSAMOSA_setup;
%
% Add remaining fields by translating Ferret --> SAMOSA.
par.user.SAMOSA_par=translateFerretToSAMOSA(par, par.user.SAMOSA_par);
%
% The translation program will use Ferret's setup file (specifically the
% par.general.min and max fields) to determine par.general.X0, and this
% will be wrong for SAMOSA.  Destroy the X0 field and let SAMOSA sort it
% out for itself.
par.user.SAMOSA_par.general.X0=[];
par.user.SAMOSA_par.user.extPar=par.user.extPar;
%
% Add modified fields from SAMOSA_setup.
par.user.SAMOSA_par=SAMOSA_setup(par.user.SAMOSA_par);
