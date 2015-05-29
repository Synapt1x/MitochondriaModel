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

function K=const
% A list of useful physical constants in cgs units.
%
K.deg=pi/180; % Conversion factor: degrees --> radians
K.Msol=1.989e33; % Mass of the Sun
K.AU=1.496e13; % Astronomical unit in cm: mean Sun-Earth distance
K.G=6.67e-8; % Gravitational constant
K.yr=365.25*24*3600; % Conversion factor: years --> seconds
