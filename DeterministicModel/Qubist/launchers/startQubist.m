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

function startQubist(varargin)
global QubistHome_ currentComponent_ OptimalSolutions PolishedSolutions silent_
global GraphicsScale_
% Algorithm selector for Qubist.

% Default GraphicsScale_.
if isempty(GraphicsScale_)
    GraphicsScale_=1;
end

% Initialize silent_ global variable.
silent_=false;

% Locate the Qubist global path.
% WARNING: path(pathdef) is called by setQubistPath in this function.

QubistHome_=fileparts(which('setQubistPath'));
if isempty(QubistHome_)
    error('Qubist path not found.');
end
addpath(QubistHome_);

% Add BASIC paths.
setQubistPath('basic');

% Re-start the GUIData system
graphics=getGUIDataRoot('graphics');
rmGUIData('allBranches');

% Get names of all optimizers.
allOptimizers=getOptimizerNames;

% Display a startup message.
try %#ok
    QV=Qubist_Version;
    disp(['Starting Qubist ', QV.Qubist, '.'])
end

% Apply graphics scaling.
% Make sure that the default ScreenPixelsPerInch are hidden away in
% preferences, so that we can always return to the default.
if ispref('Qubist', 'defaultScreenPixelsPerInch')
    ppi0=getpref('Qubist', 'defaultScreenPixelsPerInch');
else
    ppi0=get(0, 'ScreenPixelsPerInch');
    setpref('Qubist', 'defaultScreenPixelsPerInch', ppi0);
end
ppi=round(ppi0*GraphicsScale_);
set(0, 'ScreenPixelsPerInch', ppi);

% Select the optimizer
uiwait(selectQubistComponent);

% Indicate the graphics mode:
% 1 --> Full graphics GUI console
% 0 --> Minimal graphics GUI console
% -1 --> Text only mode.
if ~isempty(graphics)
    setGUIData('graphics', graphics)
end

% Ensure that launchDir is defined.
if isempty(getGUIDataRoot('launchDir'))
    setGUIDataRoot('launchDir', fileparts(which(mfilename)));
end

% Erase OptimalSolutions & PolishedSolutions.
OptimalSolutions=[];
PolishedSolutions=[];

% Check the paths to the user projects.
checkUserProjectPaths;

if find(strcmpi(allOptimizers, currentComponent_))
    % The component is an optimizer.

    % Create the function handle for the desired algorithm.
    switch lower(currentComponent_)
        case lower('Ferret'),
            currentComponent_='Ferret';
            startOpt=@startFerret;
        case lower('Anvil'),
            currentComponent_='Anvil';
            startOpt=@startAnvil;
        case lower('Locust'),
            currentComponent_='Locust';
            startOpt=@startLocust;
        case lower('SAMOSA'),
            currentComponent_='SAMOSA';
            startOpt=@startSAMOSA;
        case lower('SemiGloSS'),
            currentComponent_='SemiGloSS';
            startOpt=@startSemiGloSS;
        otherwise
            disp('Qubist aborted by user.  Bye...');
            return
    end

    try
        % Start the optimizer.
        startOpt(varargin{:});
    catch
        E=lasterror;
        try
            errTxt1=['Error = ', E.message];
            errTxt2=['Occurred on line ', num2str(E.stack(1).line), ' of file ', E.stack(1).file, '.'];
        catch
            errTxt1='Error = Unknown.';
            errTxt2='< No stack trace available. >';
        end
            
        errordlgCheckGraphics({'Qubist failed to start.  The last error message was as follows:',...
            '',...
            errTxt1,...
            errTxt2,...
            '',...
            ['* IF this is an installation issues, re-install Qubist by selecting ',...
            '''Re-Install Qubist'' from the Qubist component selection menu ',...
            '(the ''launchQubist'' menu).']},...
            'Qubist Launch Error');
    end
    
elseif strcmpi(currentComponent_, 'Resume Ferret/Locust')
    try
        currentComponent_='Ferret'; % Default.
        resumeQubistTool;
    catch %#ok
        errordlgCheckGraphics({'Ferret/Locust run failed to resume.', ' ',...
            'Last Error: ', lasterr},  'Ferret/Locust Resume Error'); %#ok
    end

elseif strcmpi(currentComponent_, 'Ferret History Explorer')
    try
        currentComponent_='FerretHistoryExplorer';
        setQubistPath;
        FerretHistoryExplorer;
    catch %#ok
        errordlgCheckGraphics({'Ferret History Explorer failed to start.', ' ',...
            'Last Error: ', lasterr},...
            'Ferret History Explorer Error'); %#ok
    end
    
elseif strcmpi(currentComponent_, 'Qubist Node Manager')
    try
        currentComponent_='QubistNodeManager';
        disp(['Setting Qubist path: QubistHome_ = ', QubistHome_]);
        setQubistPath;
        h=nodeManager(true);
        if nargin == 0
            setQubistMode('Launch');
        end
        addProjectMenus(h);
        setGUIData('QubistNodeManager', h);
        setGUIData('allWorkerNodes', true);
        setGUIData('nodeRunningInConsole', false);
    catch %#ok
        errordlgCheckGraphics({'Qubist Node Manager failed to start.', ' ',...
            'Last Error: ', lasterr},...
            'Qubist Node Manager Error'); %#ok
    end

elseif strcmpi(currentComponent_, 'Analyze History')
    try
        currentComponent_='analyzeHistoryTool';
        setQubistPath;
        analyzeHistoryTool;
    catch %#ok
        errordlgCheckGraphics({'Analyze History Tool failed.', ' ',...
            'Last Error: ', lasterr}, 'AnalyzeHistory Error'); %#ok
    end
    %
    % Post-process OptimalSolutions without modifying OptimalSolutions.
    % This should not be protected by try/catch.
    postProcessOptimalSolutions(OptimalSolutions);

elseif strcmpi(currentComponent_, 'OptimalSolutions Viewer')
    try
        currentComponent_='OptimalSolutionsViewer';
        setQubistPath;
        viewOptimalSolutions;
    catch %#ok
        errordlgCheckGraphics({'The OptimalSolutions viewer experienced an error loading the file.', ' ',...
            'Last Error: ', lasterr},...
            'OptimalSolutions Viewer Error'); %#ok
    end
    
elseif strcmpi(currentComponent_, 'Movie Tool')
    try
        currentComponent_='movieTool';
        setQubistPath;
        movieTool;
    catch %#ok
        errordlgCheckGraphics({'MovieTool failed to start.', ' ',...
            'Last Error: ', lasterr},...
            'MovieTool Error'); %#ok
    end
    
elseif strcmpi(currentComponent_, 'Merge OptimalSolutions')
    try
        currentComponent_='mergeOptimalSolutions';
        setQubistPath;
        mergeOptimalSolutions;
    catch %#ok
        errordlgCheckGraphics({'Merge OptimalSolutions tool failed to start.', ' ',...
            'Last Error: ', lasterr},...
            'Merge OptimalSolutions Error'); %#ok
    end
    %
    % Post-process OptimalSolutions without modifying OptimalSolutions.
    % This should not be protected by try/catch.  Note that MergedSolutions
    % is SAVED as `MergedSolutions', but can be accessed via the global
    % variable OptimalSolutions after loading.
    postProcessOptimalSolutions(OptimalSolutions);
else
    % Close everything.
    disp('No component was selected.');
    otherWindows={'FerretConsoleWindow', 'AnvilConsoleWindow', 'LocustConsoleWindow',...
        'SAMOSA_consoleWindow', 'SemiGloSSConsoleWindow', };
    closeComponents(otherWindows);
end

% ===============================================================

function checkUserProjectPaths
% Checks the paths of user projects and deletes any that are not found.

projects=getGUIData('UserProjects');
if iscell(projects)
    for p=length(projects):-1:1
        if isfield(projects{p}, 'path') && ischar(projects{p}.path)
            projects{p}.path=regexprep(projects{p}.path, '[/\\]', filesep);
            if ~isdir(projects{p}.path)
                if isfield(projects{p}, 'name') && ischar(projects{p}.name)
                    disp(['* Path not found for project ''', projects{p}.name, '''.']);
                else
                    disp(['* Path not found for project ', num2str(p), '.']);
                end
                projects(p)=[];
            end
        else
            warning(['No path given for project ', num2str(p), '. Removing from launchQubist.']);
            projects(p)=[];
        end
    end
end
setGUIData('UserProjects', projects);
