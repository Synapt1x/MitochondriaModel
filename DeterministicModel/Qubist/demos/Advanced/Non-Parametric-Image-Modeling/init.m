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

N=15;
img=sum(imread('myRoad5.png'),3);
sz=size(img);

binSize=floor(min(sz/N));

extPar.Nr=floor(sz(1)/binSize);
extPar.Nc=floor(sz(2)/binSize);

extPar.img=[];
for r=extPar.Nr:-1:1
    for c=extPar.Nc:-1:1
        extPar.img(r,c)=...
            mean(mean(img((r-1)*binSize+1:r*binSize, (c-1)*binSize+1:c*binSize)));
    end
end

extPar.img=extPar.img/max(extPar.img(:));
