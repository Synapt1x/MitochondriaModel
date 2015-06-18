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

[FMin, index]=min(F); %#ok
X1=X(:,index);

% p=1:size(X,1);
% plot(p, extPar.solution.X0', 'b',...
%     p, extPar.solution.X0', 'bo',...
%     p, X1', 'r+');

model=makeModel(X1,extPar);

offset=1e-3;
semilogy(extPar.x, offset+extPar.solution.f, 'b',...
    extPar.x, offset+model.f, 'r');

fMin=min(offset+model.f); fMax=max(offset+model.f);
D=abs( [model.height; model.width]-...
    [extPar.solution.height; extPar.solution.width] );
dMax=max(D);
disp(['Max(D)=', num2str(dMax)]);
D=D/dMax*(fMax-fMin)+fMin;

hold on;
index=(0:length(D)-1)/(length(D)-1);
semilogy(index,D,'g',index,D,'go');
hold off;
