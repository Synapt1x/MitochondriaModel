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

function par=LocustSetup(par)
% Sets reasonable defaults for parameters where possible.
% Values are over-ridden by LocustSetup.
% ============================================
% User
par.user.fitnessFcn='fitness'; % [string]: Name of the fitness function.
par.user.output=''; % [string]: Name of optional user-defined output function called each time step.
% ============================================
% History
par.history.NStepsPerHistoryFile=25; % [integer >= 1]: How many time steps per History file?
% ============================================
% General
NTerms=numel(par.user.extPar.img);
par.general.min=zeros(1,NTerms);
par.general.max=ones(1,NTerms);
% ============================================
% PSO constants
par.swarm.N=10; % [integer >= 1]: Number of particles in the swarm.
par.swarm.cg=0.5; % [real]: Global best constant.
par.swarm.cp=1; % 1; % [real]: Personal best constant.
par.swarm.dt=1; % [real]: Time step (usually 1)
par.swarm.TDamp=10; % [real]: Damping constant.
par.swarm.globalFrac=1; % [real]: Number of global neighbourhoods as fraction of swarm size.
par.swarm.globalRange=2; % [real]: Fuzziness of global neighbourhoods.
par.swarm.PCompeteGlobal=0.25; % [real]: Probability of globals competing.
par.swarm.PKick=0.1; % [real << 1]: Probability of perturbing swarm with a random `kick'.
par.swarm.kickSize=0.05; % [real <~ 0.1]: Size of the kick.
% ============================================
% Selection
par.selection.FAbsTol=0; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.selection.FRelTol=0; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
par.selection.exploitFrac=0.25; % [0:1]: Fraction of swarm devoted to exploiting best-ranked solutions, as opposed to exploring.
% ============================================
% Stopping criteria
par.stopping.maxTimeSteps=Inf; % [integer > 0]: Maximum number of time steps.
par.stopping.maxFEval=Inf; % [Integer > 0]: Maximum number of function evaluations (approximate).
%
% Tolerance on X and F - mainly for single-objective problems. 
par.stopping.XTol=NaN; % [real > 0, or real vector (length=# of parameters)]: Tolerance on parameters.
par.stopping.FTol=NaN; % [real > 0, or real vector (length=# of objectives)]: Tolerance on objectives.
par.stopping.boolean=@or; % [boolean operator]: '@or' or '@and' for exit criteria.
% ============================================
% Niching
par.niching.X=0.25;  % [0:1]: X-Niching: Typically ~0.25 is about right.
par.niching.F=0;  % [0:1]: F-Niching: Typically ~0.25 is about right.
par.niching.exponent=2; % [real: usually > 0 & <~ 2]: Used in the niche function.
% ============================================
% Analysis
par.analysis.analyzeWhenDone=false; % [logical]: Do analysis automatically when evolution stops.
par.analysis.conserveMemory=false; % [logical]: Minimize memory usage during analysis?  (Analysis will be slower)
par.analysis.maxItNoProgress=100; % [integer >= 1]: Max iterations with no progress before analysis stops.
par.analysis.postProcess=''; % [string]: Name of code to process OptimalSolutions when analysis is done.
% ============================================
% *** Polisher Setup ***
% par.polish.optimizer='fminsearch';
% par.polish.optimizer='SAMOSA';
% par.polish.optimizer='Anvil';
% par.polish.optimizer='SemiGloSS';
par.polish.optimizer='default'; % string]: Use defaults.
%
% fminsearch:
par.polish.fminsearch.NTracks=Inf; % [integer]: Maximum number of tracks.  `Inf' --> all in optimal set.
par.polish.fminsearch.options=[]; % options structure from optimset.
%
% SAMOSA uses its own setup file.  Here, we just add the number of tracks requested.
par.polish.SAMOSA=defaultSAMOSA_setup; % [m-file name]: Name of SAMOSA setup function.
par.polish.SAMOSA.NTracks=Inf; % [integer]: Maximum number of tracks.  `Inf' --> all in optimal set.
%
% Single/Multi-Objective: Anvil & SemiGloSS uses their own setup files.
par.polish.Anvil=defaultAnvilSetup;  % [m-file name]: Name of Anvil setup function.
par.polish.SemiGloSS=defaultSemiGloSS_setup; % [m-file name]: Name of SemiGloSS setup function.
