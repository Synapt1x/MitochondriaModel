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

function setConsoleWindowSize(varargin)
% Set the default sizes for the console windows.

% Resize horizontal fraction.
resizeFactor=1;

% Defaults.
FerretConsoleWindowSize_.units='characters';
FerretConsoleWindowSize_.borderSize=8;
FerretConsoleWindowSize_.withGraphics.size=[130.0, 35.714285714285715];
FerretConsoleWindowSize_.withGraphics.resize=[130.0, 35.714285714285715];
FerretConsoleWindowSize_.noGraphics.size=[81.83333333333331, 6.5];
FerretConsoleWindowSize_.noGraphics.resize=[81.83333333333331, 1];

% Try to over-write using info from the GUI if possible.
if ~isempty(varargin)
    try
        % Assume the first field is graphics object and the second is the field name.
        pos=get(varargin{1}, 'Position');
        FerretConsoleWindowSize_.(varargin{2}).size=pos(3:4);
        %
        % Resize.
        resize=FerretConsoleWindowSize_.(varargin{2}).size;
        resize(1)=resize(1)*resizeFactor;
        FerretConsoleWindowSize_.(varargin{2}).resize=resize;
        
    end
end

% Send to GUIData.
setGUIData('FerretConsoleWindowSize',FerretConsoleWindowSize_)
