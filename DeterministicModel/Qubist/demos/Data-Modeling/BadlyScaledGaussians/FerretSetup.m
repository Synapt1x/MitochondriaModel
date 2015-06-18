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
% FerretSetup needs to know the number of terms.
NTerms=par.user.extPar.K.NTerms;
% ====================================
% User
par.user.fitnessFcn='fitness';
% par.user.output='output';
par.user.output='';
% ====================================
% Data
par.history.NGenPerHistoryFile=5;
% ====================================
% General
maxHeight=1; maxWidth=2*par.user.extPar.K.lineWidth;
minPar=1e-6;
ONE=ones(1,NTerms); ZERO=zeros(1,NTerms);
if par.user.extPar.fixCentre
    par.general.min=minPar+[ZERO, ZERO];
    par.general.max=[ONE, maxWidth+ZERO];
else
    par.general.min=minPar+[ZERO, ZERO, ZERO];
    par.general.max=[ONE, maxWidth+ZERO, ONE];
end
par.general.popSize=250;
par.general.NGen=100000;
par.general.NPop=2;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.FAbsTol=0;
par.selection.FRelTol=0;
par.selection.FRankTol=0;
par.selection.exploitFrac=0.1;
% par.selection.clusterScale=0.5;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.01;
par.mutation.selectiveMutation=-0.5;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.matingRestriction.F=-0;
par.XOver.PAntiXOver=0.1;
par.XOver.ALS=0;
par.XOver.dispersion=0.25;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% par.XOverBB.multiBB=0; % Single or multiple BB XOver?
par.XOverBB.NPass=1;
% ====================================
% Immigration
par.immigration.PImmigrate=0.02;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=1; % 0.25;
% par.link.FRelTol=0;
% par.link.PMultiLink=0;
% ====================================
% Zooming
par.zoom.NGen=25;
par.zoom.safety=0.5;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.startF=Inf;
par.localOpt.maxNMoves=100;
par.localOpt.startWhenConverged=false;
par.localOpt.POptimizeOnImprovement=0.025;
par.localOpt.POptimizeOnNoImprovement=0.025;
% ====================================
% Interface
par.interface.myPlot='myPlot';

par.polish.optimizer='fminsearch';
% par.polish.optimizer='SAMOSA';
% par.polish.optimizer='Anvil';
% par.polish.optimizer='SemiGloSS';
% par.polish.optimizer='default'; % [string]: Use defaults.
