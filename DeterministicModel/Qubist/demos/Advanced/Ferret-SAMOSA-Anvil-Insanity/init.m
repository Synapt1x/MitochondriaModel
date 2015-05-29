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

function init
global extPar_

NPar=getNPar;
%
extPar_.shared.K=rand;
%
extPar_.Ferret.NPar=NPar.Ferret;
extPar_.Ferret.K=rand(1,extPar_.Ferret.NPar);
%
extPar_.internal.NPar=NPar.SAMOSA;
extPar_.internal.K=rand(1,extPar_.internal.NPar);
