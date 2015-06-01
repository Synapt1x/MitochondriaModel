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

function [F,auxOutput,saveData,XMod]=fitness(X, extPar)
%
% -----------------------
% function signature:
% [F,{auxOutput},{saveData},{XPhysMod}]=fitness(X, {extPar})
% *** Braces {} indicate optional fields. ***
%
% X --> [NGenes x N matrix]
% extPar --> Matlab structure
% F --> [NObj x N matrix]
% auxOutput --> {N-element Matlab cell array} or {empty cell array}
% saveData --> {N-element Matlab cell array} or {empty cell array}
% XPhysMod --> [NGenes x N matrix]
% -----------------------
%
% INPUT ARGUMENTS:
%
% X is an NGenes x N matrix sent from Ferret, where NGenes is the number of
% genes (parameters) in the problem, and N is the number of solutions requested.
% Thus, each column of X represents the parameters of a solution that needs
% to be evaluated.  The number of rows NGenes is fixed for each run and always
% equals the number of parameters.  The number of columns N is not fixed and
% will change from one call to the dext, depending on how many solutions
% that Ferret requires.
%
% extPar is the external parameter structure that is produced by the user's
% init file.  All fields defined by init are accessible to Ferret through extPar.
% ExtPar is empty if the user has not specified an init file.
%
%
% OUTPUT ARGUMENTS:
%
% F is the NObj x N fitness matrix.  The number of rows NObj must equal the
% number of objectives in the problem, and the number of columns N must be
% equal to the number of columns in X.  The order of the rows does not
% matter.  Note that Ferret is a *minimizer*.  Good solutions correspond to
% low values of F, which is opposite to the usual convention in the genetic
% algorithm literature.  F is mandatory.
%
% AuxOutput is a cell array with N elements, which contains auxilliary
% output data.  AuxOutput is a good place to put the results of any useful
% intermediate calculations or side-calculations that you might with to
% examine at the end of the run.  It is important to recognize that anything
% that you include in the auxOutput cell array will be saved along with your
% History files.  Therefore, it is a good idea to limit the amount of data
% that you include in auxOutput.  If you record large amounts of data in
% auxOutput, your History files will be very large, and loading them for
% analysis will require a lot of memory and take a long time.  Use the
% saveData cell array for large data structures.  AuxOutput is optional.
%
% SaveData behaves exactly like auxOutput except that the saved data is
% separate from the History files.  This is prefered for larger data
% structures.
%
% XPhysMod is a rarely used option that allows the user to modify the
% values of the X matrix from inside of the fitness function and re-insert
% them into the population.  This is sometimes useful for managing
% constraints.  For example, if there is a constraint that the values of
% the parameters must add up to 1, but this can't be built in to the
% fitness function for one reason or another, it can be accomplished in the
% following way:
%
% -----------------------
% [F,auxOutput,saveData,XMod]=fitness(X, extPar)
%
% Normalize the sum of X to 1 in each column.
% XMod=X./repmat(sum(X,1),size(X,1),1);
%
% F=calcFitness(XMod); % Calculate fitness values.
% auxOutput={}; saveData={}; % Dummy values.
% -----------------------
