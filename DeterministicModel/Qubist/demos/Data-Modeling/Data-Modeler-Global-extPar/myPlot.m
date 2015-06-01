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

function myPlot(X,F,extPar)
global extPar_

[FMin, index]=min(F); %#ok
C=X(1:extPar_.K.NTerms,index);
phi=X(extPar_.K.NTerms+1:end,index);

[x,f]=calcFunction(C,phi,extPar_);

errorbar(extPar_.x,extPar_.f,extPar_.sigma); hold on
plot(extPar_.x,extPar_.f0,'k',x,f,'r'); hold off
