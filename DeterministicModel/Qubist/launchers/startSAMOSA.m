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

function startSAMOSA(varargin)
global QubistHome_ abort_ isRunning_ currentProjectPath_ currentComponent_
global OptimalSolutions PolishedSolutions

% Launch program for SAMOSA.
% WARNING: path(pathdef) is called by setQubistPath in this function.

currentComponent_='SAMOSA';

% Locate the Qubist global path.
QubistHome_=fileparts(which('setQubistPath'));
if isempty(QubistHome_)
    error('Qubist path not found.');
end
addpath(QubistHome_);

% Add BASIC paths.
setQubistPath('basic');

% Add full path.
setQubistPath;

% Get extPar.
if nargin >= 1
    extPar=varargin{1};
else
    extPar=[];
end

% Shut down other windows.
otherWindows={'FerretConsoleWindow', 'AnvilConsoleWindow',...
    'LocustConsoleWindow', 'SemiGloSSConsoleWindow'};
closeComponents(otherWindows);

abort_=0;
isRunning_=0;

% Set run mode.
setGUIData('runInfo', []);
currentProjectPath_='';
setQubistMode('Launch');

% Reset graphics.
rmGUIData('graphics');

% Ensure that launchDir is defined.
if isempty(getGUIDataRoot('launchDir'))
    setGUIDataRoot('launchDir', fileparts(which(mfilename)));
end

% Erase OptimalSolutions & PolishedSolutions.
OptimalSolutions=[];
PolishedSolutions=[];

% Display a startup message.
try %#ok
    QV=Qubist_Version;
    disp(['Starting SAMOSA ', QV.SAMOSA, '.'])
end

% Filter argument list.
args={extPar};
for i=length(args):-1:1
    if isempty(args{i})
        args(i)=[];
    else
        break
    end
end

% Start SAMOSA.
SAMOSA_driver(args{:});
