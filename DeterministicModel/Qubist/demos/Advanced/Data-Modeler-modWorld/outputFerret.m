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

function [dummy, world]=outputFerret(world)
dummy=[];

if world.par.bookKeeping.gen == 10
    setGUIData('reevaluateAll', true);
end

% Add parameters every NRefine generations:
NRefine=25;

if mod(world.par.bookKeeping.gen, NRefine) == 0
    [NGenes, N]=size(world.pop{1}.indiv.genome.XPhys); %#ok
    world.par.general.min=[world.par.general.min, 0, 0];
    world.par.general.max=[world.par.general.max, 1, 2*pi];
    world.par.general.cyclic=[world.par.general.cyclic, NGenes+2];
    for p=1:length(world.pop)
        %
        % Add 2 new parameters by adding 2 rows to world.pop{p}.indiv.genome.XPhys:
        XMod=[rand(1,N); 2*pi*rand(1,N)];
        world.pop{p}.indiv.genome.XPhys=[world.pop{p}.indiv.genome.XPhys; XMod];
        %
        % genome.X and genome.XFullySpecified are repaired by Ferret: no need to do it here. 
        % world.pop{p}.indiv.genome.X=transformXPhys2X(world.pop{p}.indiv.genome.XPhys, world.par);
        % world.pop{p}.indiv.genome.XFullySpecified=[world.pop{p}.indiv.genome.XFullySpecified;...
        %     world.pop{p}.indiv.genome.X(NGenes+1:end,:)];
        %
        % Fitness will also be re-evaluated automatically.  No need to do
        % it here.
        %
        % Ferret will assume that as much CPD information as possible
        % should be retained: i.e the previous parameters still have the
        % same definition and make sense.  If you don't want this
        % behaviour, you can set world.pop{p}.indiv.genome.X manually.
        % Insert NaN values into this matrix wherever you want an
        % unspecified parameters.  Set
        % world.pop{p}.indiv.genome.X=world.pop{p}.indiv.genome.XFullySpecified;
        % to re-initialize the CPD system, so that all parameters are regarded as fully specified. 
        %
        % The linkage matrix needs to be fixed.  Ferret will do this
        % automatically, *if* you want the defalt behaviour: resize the
        % linkage matrix, but keep as much of the old linkage matrix as
        % possible.  It will be padded with new rows and columns with value
        % equal to world.par.link.initialLinkage is the number of
        % parameters increased, or rows and columns will be deleted from
        % the end if the number of parameters decreases.  Repair your own
        % linkage matrix if you want different behaviour.  i.e. Set the
        % whole matrix equal to par.link.initialLinkage if the old linkages
        % are no longer valid.
        %
        % NGenesMod=length(world.par.general.min);
        % world.link.P=resizeMatrix(world.link.P, world.par.link.initialLinkage, NGenesMod);
        % world.link.P1=resizeMatrix(world.link.P1, world.par.link.initialLinkage, NGenesMod);
        % world.link.P2=resizeMatrix(world.link.P2, world.par.link.initialLinkage, NGenesMod);
    end
    %
    % Tell Ferret that you want to restart.
    setGUIData('restart', true);
end

function PNew=resizeMatrix(P, P0, NNew)
% This function resizes the linkage matrix.  The old linkage matrix is
% kept, and new rows and columns are added at the end for the new
% parameters.  *** This is done by default automatically by Ferret. ***

PNew=P0+zeros(NNew);
NOld=size(P,1);
PNew(1:NOld,1:NOld)=P;

% For many problems, it might be better to wipe the linkage matrix clean
% instead of augmenting it.  Do this here with the following lines:
% world.link.P=P0+zeros(NNew);
% world.link.P1=P0+zeros(NNew);
% world.link.P2=P0+zeros(NNew);
