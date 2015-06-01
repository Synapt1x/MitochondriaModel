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

function F=fitness(X,extPar)
% Qubist demo fitness function.

% alpha=exp(-extPar.ferret.gen/extPar.tau);
% alpha=1;

NIndiv=size(X,2);
for n=NIndiv:-1:1
    [img, beams]=makeImage(X(:,n),extPar);
    % beams=abs(diff(beams,1));
    % beamStd=mean(std(beams,1));
    % F(n)=alpha*10*beamStd+(1-alpha)*std(img(:))/mean(img(:))+alpha;
    
    MI=mean(img(:));
    % img=diff(diff(img,1),2);
    % p=1;
    % SD=sum( abs( (img(:)-mean(img(:)) ).^p ) ).^(1/p);
    
    SD=std(img(:));
    if MI > 0
        F(n)=SD/MI;
    else
        F(n)=0;
    end
end
