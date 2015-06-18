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

function F=fitness(X)
% Bukin's 4th function.
% 
% Solution: F_min(-10,0)=0
% 
% Bukin's functions are truly pathological.
% Mishra (2006) offers the following description:
% 
% "Bukin's functions are almost fractal (with fine seesaw edges) in 
% the surroundings of their minimal points. Due to this property, they
% are extremely difficult to optimize by any method of global (or local)
% optimization and find correct values of decision variables"
% 
% Ferret does a nice job of mapping the deep valley where the solution
% resides with normal, default settings.  A very large value of the niching
% acceleration parameter helps with problems like this one:
% 
% par.niching.acceleration=10;  (roughly)
% 
% because this helps Ferret to search long narrow valleys without
% spending too much time dropping points on the valley walls.  This
% is a good strategy to employ whenever you see Ferret mapping long,
% deep valleys and having trouble obtaining a consistent solution.  Even
% so, Ferret has a lot of trouble with this problem and does not solve it
% consistently.
%
F=100*X(2,:).^2 + 0.01*abs(X(1,:) + 10);
