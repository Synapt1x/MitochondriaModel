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

function [img, beams]=makeImage(X,extPar)

img=zeros(extPar.NBeam);
beams=[];

n=1; X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
D=extPar.Y-(-1);
img=img+repmat(X1,1,extPar.NBeam).*exp(-cumsum(extPar.mu.*D,2));
beams=[beams, X1]; %#ok

n=2; X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
D=1-extPar.Y;
img=img+repmat(X1,1,extPar.NBeam).*exp(-fliplr(cumsum(fliplr(extPar.mu.*D),2)));
beams=[beams, X1]; %#ok

n=3; X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
D=extPar.X-(-1);
img=img+repmat(X1',extPar.NBeam,1).*exp(-cumsum(extPar.mu.*D,1));
beams=[beams, X1]; %#ok
% %
n=4; X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
D=1-extPar.X;
img=img+repmat(X1',extPar.NBeam,1).*exp(-flipud(cumsum(flipud(extPar.mu.*D),1)));
beams=[beams, X1];

% for n=1:2
%     X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
%     img=img+repmat(X1,1,extPar.NBeam);
%     beams=[beams, X1]; %#ok
% end
% for n=3:4
%     X1=X(extPar.NBeam*(n-1)+1:extPar.NBeam*n, :);
%     img=img+repmat(X1',extPar.NBeam,1);
%     beams=[beams, X1]; %#ok
% end
