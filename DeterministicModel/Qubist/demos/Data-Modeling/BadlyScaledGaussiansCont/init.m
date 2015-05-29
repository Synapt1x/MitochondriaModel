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

extPar.fixCentre=true;

K.N=250;
K.lineWidth=0.01;
K.noise=0;
K.NTerms=6;

extPar.K=K;
extPar.x=linspace(0,1,K.N);
% Continuum.
contPar=rand(3,1);

while true
    for n=K.NTerms:-1:1
        height(n,1)=(0.2+0.8*rand)/4^(n-1);
        width(n,1)=rand*K.lineWidth;
        centre(n,1)=rand;
    end
    if extPar.fixCentre
        extPar.solution.centre=centre;
        X0=[height; width; contPar];
    else
        X0=[height; width; centre; contPar];
    end
    extPar.solution=makeModel(X0, extPar);
    extPar.solution.X0=X0;
    extPar.solution.f0=extPar.solution.f;
    extPar.solution.f=extPar.solution.f0+K.noise*randn(1,K.N);
    
    figure(1);
    offset=1e-3;
    semilogy(extPar.x, offset+extPar.solution.f0, 'b',...
        extPar.x, offset+extPar.solution.f, 'r');
    
    q=input('Use this model? (1 --> accept, otherwise reject) >> ', 's');
    if strcmpi(q, '1')
        break
    end
end

% ===========================================================================
% Specify directory names.
% extPar.dataDir='/Users/fiege/Documents/junk/FerretData';
% extPar.scratchDir='/Users/fiege/Documents/junk/scratch';
