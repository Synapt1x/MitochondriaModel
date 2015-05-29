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
NPar=getNPar;
% ====================================
% User
par.user.fitnessFcn='fitnessFerret';
par.user.output='output';
% ====================================
% Data
par.history.NGenPerHistoryFile=5;
% ====================================
% General
par.general.min=zeros(1,NPar.Ferret);
par.general.max=ones(1,NPar.Ferret);
par.general.popSize=100;
par.general.NGen=100000;
par.general.NPop=1;
% ====================================
% Parallel Computing
par.parallel.NWorkers=0; % Number of worker nodes to launch initially.
par.parallel.timeout=10000; % Maximum time in seconds before an unresponsive node disconnects.
par.parallel.useJava=true; % Is Java required for worker nodes?
par.parallel.writeLogFiles=true; % Are log files required?
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.75;
par.selection.FAbsTol=1;
par.selection.exploitFrac=0.25;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001;
par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.01;
par.mutation.selectiveMutation=-0.5;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.matingRestriction.X=-0.5;
par.XOver.PAntiXOver=0.1;
par.XOver.ALS=0.1;
par.XOver.dispersion=0.25;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% ====================================
% Immigration
par.immigration.PImmigrate=0.01;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
% ====================================
% Zooming
par.zoom.NGen=10;
par.zoom.safety=0.5;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.startF=Inf; %1.25;
par.localOpt.startWhenConverged=false;
par.localOpt.POptimizeOnImprovement=0.05;
par.localOpt.POptimizeOnNoImprovement=0.05;
% ====================================
% Interface
par.interface.myPlot='myPlot';
% ====================================
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
%
% Add modified fields from SAMOSA_setup.
par.user.SAMOSA_par=SAMOSA_setup(par.user.SAMOSA_par);
%
% ====================================
% !!!!! ADD SETUP INFO FOR Anvil. !!!!!
% This info is required for the SAMOSA call that is embedded in Ferret's
% fitness function.
%
% Load an INCOMPLETE default setup file from
% Qubist/user/Ferret/defaults/defaultSAMOSA_setup.
par.user.AnvilPar=defaultAnvilSetup;
%
% Add remaining fields by translating Ferret --> Anvil.
par.user.AnvilPar=translateFerretToAnvil(par, par.user.AnvilPar);
%
% Add modified fields from SAMOSA_setup.
par.user.AnvilPar=AnvilSetup(par.user.AnvilPar);
