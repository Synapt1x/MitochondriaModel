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

index=find(F == min(F));
index=index(ceil(rand*length(index)));
img=makeImage(X(:,index),extPar);
q=max(img(:))/max(X(:,index));

n=1; X2a=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, index)';
n=2; X2b=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, index)';
img=[q*X2a', img, q*X2b'];

n=3; X2c=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, index);
n=4; X2d=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, index);
img=[[NaN, q*X2c', NaN]; img; [NaN, q*X2d', NaN]];

image(63*img/max(img(:))); hold on;
% index=1:extPar.NBeam;
plot(index,X2a, index, X2b, index, X2c, index, X2d);
plot(extPar.NBeam*X2a, extPar.NBeam*X2b, '.', extPar.NBeam*X2c, extPar.NBeam*X2d, '.');
hold off;

colormap bone;
