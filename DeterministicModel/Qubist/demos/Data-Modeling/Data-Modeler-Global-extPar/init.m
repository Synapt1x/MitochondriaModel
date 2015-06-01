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
global extPar_
% This demonstrates the technique of sending extPar_ (the output from the
% init function) as a global variable.  This may be useful in unusual
% situations like calling SAMOSA or Anvil from *inside* a Ferret fitness
% function, since it allows them to use a shared copy of extPar_, thus
% decreasing memory usage.  If extPar_ is present as a global variable
% after init is caled, the output from init will *not* be included in
% par.user.extPar, but *will* be available as global variable extPar_.
% Note that when using the global extPar_ technique, extPar (without the
% underscore) is still required for fields added by Ferret - most importantly
% extPar.status for the parallel computing system.

K.NTerms=getNTerms;
K.N=250;
K.sigma=0.1;

extPar_=fakeData(K);
