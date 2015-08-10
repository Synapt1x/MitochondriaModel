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

function logI=calcFunction(K, extPar)

% % Disk parameters:
% K.logI0=X(1,i);
% K.Rd=X(2,i);
% %
% % Sersic bulge parameters:
% K.logIe=X(3,i);
% K.Re=X(4,i);
% K.n=X(5,i);
% K.bn = 1.9992*K.n - 0.3271;
    
% Disk:
logI_disk=K.logI0-extPar.r/K.Rd;
logI_bulge=K.logIe+(-K.bn*(extPar.r/K.Re).^(1/K.n)-1);
logI=log(exp(logI_disk)+exp(logI_bulge));
