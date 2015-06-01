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

function extraPlotsForUserGuide
% Generate some extra plots for the Qubist User's Guide.  These figures show
% that the three functions q1, q2, and q3 discussed in the user's guide are
% well-determined by model when applied to artificial data.
%
% I assume that OptimalSolutions has been loaded into the workspace and
% made global by giving the command "global OptimalSolutions" on the MATLAB
% command line.
global OptimalSolutions
%
% Convert OptimalSolutions.X into the paameters of our binary star system.
binaryPar=X2Par(OptimalSolutions.X,OptimalSolutions.par);
M=binaryPar.m1+binaryPar.m2;
%
% Define the "q" quantities from the user's guide.
q1=binaryPar.m2./binaryPar.m1;
q2=binaryPar.a.^3./M;
q3=sqrt(M./binaryPar.a).*binaryPar.sini;
%
% Define the font sizes.
fontsize1=18;
fontsize2=14;
%
% Plot them!
figure(1); clf
plotStuff(q1,q2,OptimalSolutions.F);
xlabel('q_1', 'FontSize', fontsize1);
ylabel('q_2', 'FontSize', fontsize1);
set(gca, 'FontSize', fontsize2);
%
figure(2); clf
plotStuff(q2,q3,OptimalSolutions.F);
xlabel('q_2', 'FontSize', fontsize1);
ylabel('q_3', 'FontSize', fontsize1);
set(gca, 'FontSize', fontsize2);
%
figure(3); clf
plotStuff(q3,q1,OptimalSolutions.F);
xlabel('q_3', 'FontSize', fontsize1);
ylabel('q_1', 'FontSize', fontsize1);
set(gca, 'FontSize', fontsize2);

function plotStuff(q1,q2,F)
% Do the actual plotting.  Divide q1 and q2 into NFitnessBins bins
% determined by fitess values F.  Each bin will be shaded differently.
%
NFitnessBins=100;
markerSize=5;
%
FMin=min(F);
FMax=max(F);
FBinEdges=linspace(FMin, FMax, NFitnessBins+1);
%
hold on;
for i=NFitnessBins:-1:1
    index=F > FBinEdges(i) & F < FBinEdges(i+1);
    scale=(i-1)/(NFitnessBins-1);
    color=[scale, scale, scale^0.333];
    plot(q1(index), q2(index), '.', 'Color', color, 'MarkerSize', markerSize);
end
hold off;
set(gcf, 'Units', 'pixels');
set(gca, 'Units', 'pixels');
pos=get(gca, 'Position');
width=800; height=650; border=80;
pos(3)=width+2*border; pos(4)=height+2*border;
set(gcf, 'Position', pos);
pos=get(gca, 'Position');
pos(1)=1.25*border; pos(2)=1.25*border; pos(3)=width; pos(4)=height;
set(gca, 'Position', pos);
box on;
