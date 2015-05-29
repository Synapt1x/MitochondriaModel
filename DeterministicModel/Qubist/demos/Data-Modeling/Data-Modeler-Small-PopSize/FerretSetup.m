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
% Helper function.  FerretSetup needs to know the number of terms.
NTerms=getNTerms;
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
% ====================================
% General
par.general.min=zeros(1,2*NTerms);
par.general.max=[ones(1,NTerms),2*pi*ones(1,NTerms)];
par.general.cyclic=NTerms+1:2*NTerms;
par.general.NPop=1;
par.general.popSize=25;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.3;
par.selection.FAbsTol=1;
% ====================================
% Niching
par.niching.X=0; %.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.0;
par.CPD.PReactivateGenes=0.0;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PXOverBB=0.05;
par.XOver.PAntiXOver=0.1; 
% ====================================
% Immigration
par.immigration.PImmigrate=0.25;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
par.link.mixDim=0.1; % Greater than 0 if mixing is desired.  Usually range: [0,1], but could be higher.
% ====================================
% Zooming
par.zoom.NGen=25;
par.zoom.safety=0.5;
% ====================================
% Interface
par.interface.myPlot='myPlot';
par.interface.commands={'sin','cos','blah'}; % Just for demo purposes.


% par.polish.optimizer='fminsearch';
% par.polish.optimizer='SAMOSA';
% par.polish.optimizer='Anvil';
par.polish.optimizer='SemiGloSS';
