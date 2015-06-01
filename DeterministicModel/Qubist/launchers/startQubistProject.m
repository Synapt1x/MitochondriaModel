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

function startQubistProject(projectPath, varargin)
global currentProjectPath_ currentComponent_
% This function initializes the project and launches QubistDriver.
% The global valiable currentProjectPath_ is set in the sub-function
% loadQubistProject below.
%
% ***Called when a demo or project is selected.***

% Make sure aborts are cleared.
% Note that this function wipes out runInfo.

forceAbortQubist(0);

if isempty(currentComponent_)
    error('Error in startQubistProject.  No optimizer selected.');
end

NV=length(varargin);
if NV >= 1
    initFile=varargin{1};
else
    initFile='';
end
optimizer=currentComponent_;
if NV >= 2
    setupFile=varargin{2};
else
    switch lower(currentComponent_)
        case 'samosa'
            setupFile='SAMOSA_setup';
        case 'semigloss'
            setupFile='SemiGloSS_setup';
        case 'ferretnodemanager'
            optimizer='Ferret';
            setupFile='FerretSetup';
        case 'locustnodemanager'
            optimizer='Locust';
            setupFile='LocustSetup';
        otherwise
            setupFile=[currentComponent_, 'Setup'];
    end
end
if NV >= 3
    projectName=varargin{3};
else
    projectName='';
end

% Load the project.
try
    projectPath=loadQubistProject(projectPath);
catch
    dispErr;
    return
end

% Create runInfo.
currentProjectPath_=projectPath;
runInfo=getGUIData('runInfo');
% selectProject/selectDemo clear runInfo.  startFerretProject,
% startLocustProject, etc. set runInfo.initMode='LOAD';
if isempty(runInfo) || ~isfield(runInfo, 'initMode')
    runInfo.initMode='ASK';
end
runInfo.launchDir=getGUIDataRoot('launchDir');
runInfo.optimizer=optimizer;
runInfo.projectPath=projectPath;
runInfo.projectName=projectName;
runInfo.setupFile=setupFile;
runInfo.initFile=initFile;
runInfo.generation=0;

% Add fields that are required for the Info/Edit pane.
% (Ferret only).
runInfo.files.Notes=which('Notes.txt');
if ~isempty(setupFile) && exist(setupFile, 'file')
    runInfo.files.setup=which(setupFile);
else
    runInfo.files.setup='';
end
if ~isempty(initFile) && exist(initFile, 'file')
    runInfo.files.init=which(initFile);
else
    runInfo.files.init='';
end
% Can't get the fitness file here because Qubist hasn't loaded par yet!

% Add runInfo to the GUIData system.
setGUIData('runInfo', runInfo);

% Remove commands from the PaintedPoint interface.
rmGUIData('PaintedPointsLastCommand')

% Note that readNotes and getExtPar require runInfo.
try %#ok
    readNotes;
end

% ------------------------------------------------
% Launch Qubist! (INITIALIZE MODE ONLY)
%
% Set the Qubist mode.
setQubistMode('Initialize');
%
% Run init file to generate extPar.
extPar=getExtPar;
%
% Set the last project path.
setpref('Qubist', 'lastProjectDir', projectPath);
%
% START THE QUBIST DRIVER.
QubistDriver(extPar, runInfo.setupFile);

% This is done twice since QubistDriver calls Ferret, which loads par.  The
% setup file is now available.
try %#ok
    readNotes;
end

% =====================================================================

function dispErr

disp('There was an error loading your project')
disp('********** ERROR RECEIVED **********');
disp(lasterr);
disp('************************************');
