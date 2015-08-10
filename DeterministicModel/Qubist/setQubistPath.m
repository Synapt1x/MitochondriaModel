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

function setQubistPath(varargin)
global QubistHome_ currentComponent_
% Set the Qubist path.  Default is current directory.
% *** Note that this DOES NOT set the project path.***
% That is done in startQubistProject.m
%
% *** setQubistPath resets the path and must therefore be called BEFORE getExtPar.

% Translate to a global path.
QubistHome_=fileparts(which(mfilename));

% Determine Qubist code directory.
sourceDir=fullfile(QubistHome_, 'Qubist_Source');
pcodeDir=fullfile(QubistHome_, 'Qubist_Code');
if exist(sourceDir, 'dir')
    % Source code is available (Only true for developers).
    codeDir=sourceDir;
elseif exist(pcodeDir, 'dir')
    % PCode is available (Usually the case).
    codeDir=pcodeDir;
else
    % Can't find Qubist program files.
    error('Qubist program files not found.')
end

% Start defining paths.
launcherPath=fullfile(QubistHome_, 'launchers');
selectorPath=fullfile(codeDir, 'shared', 'optimSelect');
mexPath=fullfile(codeDir, 'shared', 'mex');
GUIDataPath=fullfile(codeDir, 'shared', 'utility', 'GUIData');
componentsPath=fullfile(codeDir, 'shared', 'utility', 'components');
batchPath=fullfile(codeDir, 'batchManager');
if ~isempty(varargin) && strcmpi(varargin{1}, 'basic')
    % Set BASIC PATHS ONLY for startup programs (startQubist, startFerret, etc.).
    runModePath=fullfile(codeDir, 'shared', 'utility', 'runMode');
    versionPath=fullfile(codeDir, 'shared', 'versionData');
    securityPath=fullfile(codeDir, 'shared', 'security');
    graphicsUtilities=fullfile(codeDir, 'shared', 'graphics', 'utility');
    licensePath=fullfile(codeDir, 'shared', 'license');
    toolsPath=fullfile(codeDir, 'shared', 'tools'); % Required for Resume Tool.
    installerPath=fullfile(codeDir, 'tools', 'installation');
    addpath(launcherPath, runModePath, selectorPath, versionPath, genpath(securityPath),...
        GUIDataPath, componentsPath, licensePath, graphicsUtilities, installerPath,...
        mexPath, toolsPath);
    %
    % Load the skin directory.
    addSkinDirectory;
    return
else
    addpath(launcherPath, selectorPath, mexPath, componentsPath, GUIDataPath, batchPath);
end

% Make sure that mex is compiled.
checkMex;

% Get the names of all Qubist components.
componentNames=getComponentNames;

if isempty(currentComponent_) || strcmpi(currentComponent_, 'ComponentSelector')
    errordlgCheckGraphics('No optimizer has been selected.  Restart Qubist.', 'No Component Selected');
    error('No component selected.');
elseif isempty(find(strcmpi(componentNames, currentComponent_), 1))
    disp(['The current component ''', currentComponent_, ''' is not part of the Qubist distribution.']);
    disp('Qubist assumes this component is user-defined.  Continuing...');
end

% Resets the path to the initial state.  Avoids naming conflicts.
path(pathdef);

% Set the Qubist path.
if exist(QubistHome_, 'dir')
    path(QubistHome_, path);
    GUIDataPath=fullfile(codeDir, 'shared', 'utility', 'GUIData');
    addpath(codeDir, launcherPath, GUIDataPath);
    %
    if isempty(currentComponent_)
        error('Error in setQubistPath.  No optimizer has been chosen.');
    end
    %
    % Add the following package directories.  These need to be in the right
    % order to prevent overshadowing.  Latter directories in the list
    % overshadow previous ones.
    if strcmpi(currentComponent_, 'FerretNodeManager')
        packageDirectories=[componentNames, {'shared', 'tools', 'Ferret'}];
    elseif strcmpi(currentComponent_, 'LocustNodeManager')
        packageDirectories=[componentNames, {'shared', 'tools', 'Locust'}];
    else
        packageDirectories=[componentNames, {'shared', 'tools', currentComponent_}];
    end
    % Ferret is added to the path ONLY so that it can be shredded if there
    % is a security violation.
    for p=1:length(packageDirectories)
        path(genpath( fullfile(codeDir, packageDirectories{p}) ), path);
    end
    %
else
    errordlgCheckGraphics({'The path specified for the Qubist',...
        'home directory does not exist.'}, 'Path Not Found', 'modal');
    error('Qubist path not found.');
end

% Always add the Ferret user/defaults directory, since defaultFerretSetup
% is used as a template for the other optimizers for some parameters.
userDir=fullfile(QubistHome_, 'user', 'Ferret');
if exist(userDir, 'dir')
    addpath(fullfile(userDir, 'defaults'));
end
    
% Now add the actual userDir for the selected component.
if strcmpi(currentComponent_, 'FerretNodeManager')
    CC='Ferret';
elseif strcmpi(currentComponent_, 'LocustNodeManager')
    CC='Locust';
else
    CC=currentComponent_;
end
userDir=fullfile(QubistHome_, 'user', CC);
if exist(userDir, 'dir')
    defaultDir=fullfile(userDir, 'defaults');
    if exist(defaultDir, 'dir')
        addpath(defaultDir);
    end
end

% Add the user/projects directory to pick up global projects.
projectsDir=fullfile(QubistHome_, 'user', 'projects');
addpath(projectsDir);

% Load the skin directory.
addSkinDirectory;

% Display QubistHome_ message.
if strcmpi(strtrim(QubistHome_), '.')
    disp('QubistHome_ is set to [./] (current working directory).');
else
    disp(['QubistHome_ is set to [', QubistHome_, '].']);
end

% This pause statement seems necessary for Linux systems.
pause(0.001);

% ========================================================

function addSkinDirectory
global QubistHome_ currentComponent_ QubistSkin_
% Just adds the requested skin directory to the path.

% Skip these directories when adding skins.
skipDir={'projects'};

defaultSkin='Unity';
if isempty(QubistSkin_) || strcmpi(QubistSkin_, 'default')
    QubistSkin_=defaultSkin;
end
%
componentDirs0=dir(fullfile(QubistHome_, 'user'));
componentDirs={};
for i=1:length(componentDirs0)
    if ~strcmpi(componentDirs0(i).name, '.') && ~strcmpi(componentDirs0(i).name, '..')
        componentDirs=[componentDirs, {componentDirs0(i).name}]; %#ok
    end
end
componentDirs(strcmpi(componentDirs, {currentComponent_}))=[];
componentDirs=[componentDirs, {currentComponent_}];
%
% Add all of the skins to the path.  The last one to be added is the
% currentComponent_, which causes it to be at the top of the path.
addpath(fullfile(QubistHome_, 'user')); % Needed to add matchColours.m.
skinExists=false;
for i=1:length(componentDirs);
    skin=QubistSkin_;
    CD=fullfile(QubistHome_, 'user', componentDirs{i});
    if exist(CD, 'dir') && ~any(strcmpi(skipDir, componentDirs{i}))
        skinDir=fullfile(CD, 'skins', skin);
        if exist(skinDir, 'dir')
            skinExists=true;
        else
            skin=defaultSkin;
            skinDir=fullfile(QubistHome_, 'user', componentDirs{i}, 'skins', skin);
            %
            % Issue a warning if no component has been selected yet, or if
            % componentDirs{i} matches the current component.
            if strcmpi(currentComponent_, 'No_Component_Selected') ||...
                    strcmpi(componentDirs{i}, currentComponent_)
                disp(['The requested skin ''', QubistSkin_, ''' was not found for component ''', componentDirs{i}, '''.  Using default skin ''', skin, '''.']);
            end
        end
        addpath(genpath(skinDir));
    end
end
%
% Does the skin exist for any component?
if ~skinExists
    disp(['*** Warning: The requested skin ''', QubistSkin_, ''' was not found for *ANY* Qubist component.']);
    disp(['Using default skin ''', defaultSkin, ''' for all components. ***']);
    QubistSkin_=defaultSkin;
end
% Make sure that QubistSkin_ is available via GUIData.
setGUIData('QubistSkin_', QubistSkin_);
