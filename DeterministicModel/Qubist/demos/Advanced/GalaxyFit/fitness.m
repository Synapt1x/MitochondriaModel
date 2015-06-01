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

function F=fitness(X,extPar)

% Here are the equations (copied from http://adsabs.harvard.edu/abs/2009ApJ...705.1395C):
% Bulge component: Sersic law:
% \begin{equation} I(R)=I_e \exp \lbrace -b_n[ (R/R_e) ^{1/n} -1] \rbrace, \end{equation}
% or: I(R)=I_e*exp(-b_n((R/R_e)^(1/n)-1))
% in which I_e is the intensity at the effective radius R_e defined as the radius that contains half of the total light and n is a dimensionless index that measures the "curvature" of the luminosity profile. b_n is a function of n and is defined as b_n = 1.9992n - 0.3271 for 0.5 < n < 10 (Capaccioli 1989). The de Vaucouleurs law is a specific case of the S�sic law for n = 4.
%
% Disk component: Exponential disk
% The stellar disk intensity profile is fitted with the exponential disk formula (see, e.g., Freeman 1970)
% \begin{equation} I(R) = I_0\; \exp(- R/R_d), \end{equation}
% or: I(R)=I_0*exp(-R/R_d)
% where I0 is the intensity at R = 0 and Rd the scale-length of the disk.

NIndiv=size(X,2);
F=NaN+zeros(1,NIndiv);
for i=NIndiv:-1:1
    if isAbortEval(extPar.status)
        % It is good form to supply all outputs, even if there is an
        % early exit in a parallel run.
        F=[];
        break
    end
    %
    K=X2Par(X(:,i), extPar);
    logI_model=calcFunction(K,extPar);
    F(i)=sum( (logI_model-extPar.logI).^2 );
end
