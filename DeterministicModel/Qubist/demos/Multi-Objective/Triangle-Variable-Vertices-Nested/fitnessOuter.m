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

function [F,auxOutput]=fitnessOuter(X,extPar)
% Qubist demo fitness function.

theta=X(1,:);
for n=length(theta):-1:1
    theta1=theta(n);
    
    weight=rand(3,1);
    weight=weight/sum(weight);
    extPar.QubistPar.user.SAMOSA_par.user.extPar.weight=weight;
    extPar.QubistPar.user.SAMOSA_par.user.extPar.theta=theta1;
    OptimalSolutionsInternal=SAMOSA(extPar.QubistPar.user.SAMOSA_par);
    
    XS=OptimalSolutionsInternal.X;
    index=ceil(rand*size(XS,2));
    XS=XS(:,index);
    
    x=XS(1);
    y=XS(2);
    
    v1=[0; 0];
    v2=[1; 0];
    v3=[cos(theta1); sin(theta1)];
    
    F1=((x-v1(1)).^2+(y-v1(2)).^2);
    F2=((x-v2(1)).^2+(y-v2(2)).^2);
    F3=((x-v3(1,:)).^2+(y-v3(2,:)).^2);
    
    F(:,n)=[F1;F2;F3];
    
    auxOutput{n}.X=[theta1; x; y];
    auxOutput{n}.F=F(:,n);
    disp(n);
end
