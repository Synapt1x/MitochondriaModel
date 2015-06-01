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

function testSimilarity
% Generates a binary and then transforms the parameters using a 
% similarity relationship.  Shows that the new parameters result in exactly
% the same velocity curves.  This function is used only to demonstrate the
% similarity relationship discussed in the Qubist User's Guide.  It is not actually
% called by Ferret.
%
% Create extPar & generate a set of velocity curves.
extPar=init; % Generate extPar.  This calculates the velocity curves, but they
% may contain noise.  We do not need noise here, so we set the noise to zero
% and re-calculate the velocity curve.
%
extPar.data.relErr=0; % No noise required here.
[extPar.data.t, extPar.data.V]=binary(extPar); % Calculate the velocity curves.

 % Plot it manually and colour the curves blue.
figure(1);
plot(extPar.data.t, extPar.data.V, 'b');
xlabel('t (s)');
ylabel('v (cm/s)');
hold on

% Scale the parameters.  The goal is to use the symmetry of the equations
% to find a new solution with different parameters that reproduces the
% original velocity curve exactly.  This is an example of mathematical
% degeneracy.
%
S=3; % The scaling parameter.  Set this to any value except for S=1
extPar.binaryPar.m1=S^3*extPar.binaryPar.m1;
extPar.binaryPar.m2=S^3*extPar.binaryPar.m2;
extPar.binaryPar.a=S*extPar.binaryPar.a;
extPar.binaryPar.sini=extPar.binaryPar.sini/S;

% Create the new curves using the scaled parameters.
[extPar.data.t, extPar.data.V]=binary(extPar);

% Plot it manually with red dots.  They should follow the red curve exactly
% if the similarity scaling used above is correct.
plot(extPar.data.t, extPar.data.V, 'r.'); % Plot it!
xlabel('t (s)');
ylabel('v (cm/s)');
hold off
