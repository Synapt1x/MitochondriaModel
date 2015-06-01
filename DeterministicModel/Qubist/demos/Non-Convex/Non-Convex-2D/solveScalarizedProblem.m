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

function solveScalarizedProblem
global w k OptimalSolutions

NWeight=5000;
weightVector=linspace(0,1,NWeight);

% for i=NWeight:-1:1
%     w=weightVector(i);
%     X(i)=fminbnd(@scalarFitness, -2*pi, 2*pi);
% end

NOpt=size(OptimalSolutions.X,2);
for i=NWeight:-1:1
    w=weightVector(i);
    index=ceil(NOpt*rand);
    X0=OptimalSolutions.X(:,index);
    X(i)=fminsearch(@scalarFitness, X0);
end

figure(1); clf;
col=0.75+[0,0,0];
hold on
plot(OptimalSolutions.F(1,:), OptimalSolutions.F(2,:), '.',...
    'MarkerSize', 48, 'MarkerFaceColor', col, 'MarkerEdgeColor', col);
F=fitness(X);
col=[0,0,0];
plot(F(1,:), F(2,:), '.', 'MarkerSize', 24, 'MarkerFaceColor', col, 'MarkerEdgeColor', col);
index=min(F,[],1) < 0.01;
plot(F(1,index), F(2,index), 'p', 'MarkerSize', 36, 'MarkerFaceColor', col,...
    'MarkerEdgeColor', col);
set(gca, 'XLim', [0,1]*1.05, 'YLim', [0,1]*1.05, 'FontSize', 16);
xlabel('F_1', 'FontSize', 18);
ylabel('F_2', 'FontSize', 18);
box on;
title(['k=',num2str(k)], 'FontSize', 24);
pos=get(gcf, 'Position');
pos(3)=800; pos(4)=600;
set(gcf, 'Position', pos);
