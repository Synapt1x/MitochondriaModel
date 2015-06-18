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

extPar.filename='photometry_n5055.tab';
% extPar.filename='photometry_n2403.tab';

data=[];
fid=fopen(extPar.filename);
while true
    tline=fgetl(fid);
    if ~ischar(tline), break, end
    tline=str2num(tline);
    if ~isempty(tline)
        data=[data; tline];
    end
end
fclose(fid);

extPar.r=data(:,1);
extPar.logI=log(data(:,5));
