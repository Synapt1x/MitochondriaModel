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

function startQubistWorkers(par, varargin)
global QubistHome_ currentComponent_ randomSeed_

% Number of optional arguments.
NV=length(varargin);

if NV == 0
    NWorkers=1;
else
    NWorkers=varargin{1};
end

% Is this launched directly from the component selector, so that there are
% only worker nodes and no node-0 Qubist session?
AWN=getGUIData('allWorkerNodes');
if isempty(AWN)
    AWN=false;
end
if ~AWN
    % These nodes are controlled from the Qubist console.
    setGUIData('nodeRunningInConsole', true);
end
status.allWorkerNodes=AWN;

% Is Java required?
if NV < 2
    useJava=true;
else
    useJava=varargin{2};
end

% Generate some status fields.
% Basic status fields.
status.dataDir=par.general.dataDir;
status.scratchDir=par.parallel.scratchDir;
status.writeLogFiles=num2str(par.parallel.writeLogFiles);
            
% User start directory.
matlab.launchDir=getGUIDataRoot('launchDir');

if NV < 3
    % Determine starting node ID number.
    max_nid=get_max_nid(status);
    if isempty(max_nid)
        start_nid=1;
    else
        start_nid=max_nid+1;
    end
else
    start_nid=varargin{3};
end

if NV >= 4
    handles=varargin{4};
else
    handles=[];
end

% Prepare startup command.
if ispref('Qubist', 'matlabLaunchCommand')
    % Actual command previously stored from the nodeManager.
    matlab.startup=getpref('Qubist', 'matlabLaunchCommand');
elseif ispc
    % Guess the command.  Normally just 'matlab'.
    matlab.startup='matlab';
else
    % Try to figure it out.
    matlab.startup=strrep(which('addpath'), 'toolbox/matlab/general/addpath.m', 'bin/matlab');
end

% Build Matlab options string.
if ispc
    if par.parallel.singleCompThread
        matlab.options='/nodesktop /nosplash /minimize /singleCompThread';
    else
        matlab.options='/nodesktop /nosplash /minimize';
    end
else
    if par.parallel.singleCompThread
        matlab.options='-nodisplay -nodesktop -nosplash -singleCompThread';
    else
        matlab.options='-nodisplay -nodesktop -nosplash';
    end
end
if ~useJava
    if ispc
        matlab.options=[matlab.options, ' /nojvm'];
    else
        matlab.options=[matlab.options, ' -nojvm'];
    end
end
if ispc
    matlab.options=[matlab.options, ' /r '];
else
    matlab.options=[matlab.options, ' -r '];
end

% Command to run after starting.
if any(strcmpi(currentComponent_, {'Locust', 'LocustNodeManager'}))
    % We require a Locust worker node.
    QubistWorkerNode=@LocustWorkerNode;
    matlab.nodeCmd='LocustWorkerNode(status)';
    status.component='Locust';
else
    % We require a Ferret worker node.
    QubistWorkerNode=@FerretWorkerNode;
    matlab.nodeCmd='FerretWorkerNode(status)';
    status.component='Ferret';
end
%
% Write path info and other information to the FerretNodeInfo file.
currentPath=path;
%
% Does this Matlab session belong to the node manager?
nodeRunningInConsole=getGUIData('nodeRunningInConsole');
if isempty(nodeRunningInConsole)
    nodeRunningInConsole=false;
end

if nodeRunningInConsole
    % There is already a node running in the console window.  Start new
    % nodes in new Matlab sessions running in the background.
    %
    % Loop over worker node IDs.
    for nid=start_nid:start_nid+NWorkers-1
        %
        % Only one worker allowed for a trial version.
        % #TRIAL if nid > 1
        % #TRIAL    disp('**********************************************************************');
        % #TRIAL    disp(['WARNING: ATTEMPTING TO START NODE #', num2str(nid)]);
        % #TRIAL    disp('ONLY ONE WORKER NODE IS ALLOWED FOR THIS TRIAL VERSION.');
        % #TRIAL    disp('Contact info@nqube.ca for an unlocked trial.');
        % #TRIAL    disp('**********************************************************************');
        % #TRIAL    break
        % #TRIAL end
        
        % try
        %     fileattrib(nodeFile, '+w');
        % end
        
        % Touch the status file.  This is important to reserve the node
        % number while the node is starting.
        status.file=fullfile(status.scratchDir, ['status.', num2str(nid)]);
        touchStatus(status);
        
        % Determine the random mode.
        if ischar(randomSeed_) && strcmpi(randomSeed_, 'same')
            seed=5489;
        elseif isnumeric(randomSeed_)
            seed=round(randomSeed_);
        else
            seed=NaN;
        end
        
        % Build the command.
        matlab.startupCmd=['QubistNodeLauncher_', num2str(nid)];
        QNL=fullfile(status.scratchDir, [matlab.startupCmd, '.m']);
        txt={...
            '% *** Qubist Node Launcher. ***',...
            '% THIS IS AN AUTO-GENERATED FILE - DO NOT MODIFY.',...
            '%',...
            'global QubistHome_ currentComponent_ randomSeed_',...
            '%',...
            ['QubistHome_=''', QubistHome_, ''';'],...
            ['randomSeed_=', num2str(seed), ';'],...
            ['status.nid=', num2str(nid), ';'],...
            ['status.component=''', status.component, ''';'],...
            ['status.dataDir=''', par.general.dataDir, ''';'],...
            ['status.scratchDir=''', status.scratchDir, ''';'],...
            ['status.QubistNodeLauncher=''', QNL, ''';'],...;
            ['status.writeLogFiles=', num2str(par.parallel.writeLogFiles), ';'],...
            ['path(''', currentPath, ''');'],...
            'setGUIData(''allWorkerNodes'', false);',...
            ['currentComponent_=''', status.component, ''';'],...
            [matlab.nodeCmd, ';'],...
            };
        %
        if exist(QNL, 'file')
            deleteFileWarningOff(QNL);
        end
        fid=fopen(QNL, 'w');
        if fid == -1
            error(['Could not open Qubist node info file ', QNL, ' for writing.']);
        end
        for i=1:length(txt)
            fprintf(fid, '%s\n', txt{i});
        end
        fclose(fid);
        
        % Continue buildng cmd...
        cmd=['"cd (''', matlab.launchDir, '''); addpath(''', status.scratchDir, '''); ', matlab.startupCmd, ';"'];
        %
        if ispc
            cmd=['start ', matlab.startup, ' ', matlab.options, ' ', cmd]; %#ok
            %
            % Warning: do not try to run in the background on Windows
            % machines:
            % cmd=['start /b ', matlab.startup, ' ', matlab.options, ' ', cmd]; %#ok
            % If you do this, the nodes will eventualy crash if then
            % generate any command line output using the disp command.
        else
            cmd=[matlab.startup, ' ', matlab.options, ' ', cmd, ' &']; %#ok
        end
        %
        % status.file=fullfile(status.scratchDir, ['status.', num2str(nid)]);
        % if exist(status.file, 'file')
        %     deleteFileWarningOff(status.file);
        % end
        [s,w]=unix(cmd);
        if s == 0
            disp(['Worker node ', num2str(nid), ' is starting.']);
            % while ~exist(status.file, 'file')
            %     disp(['Waiting for node ', num2str(nid), '...']);
            %     pause(0.25);
            % end
            % disp(['Node ', num2str(nid), ' is ready.']);
            % updateNodeManager;
            %
            % Update the list of nodes run by the current console.
            nodesRunByThisConsole=getGUIData('nodesRunByThisConsole');
            nodesRunByThisConsole=unique([nodesRunByThisConsole, nid]); %#ok
            setGUIData('nodesRunByThisConsole', nodesRunByThisConsole);
        else
            disp(['Worker node ', num2str(nid), ' failed.  Error code: ', num2str(s), ', result:', w, '.']);
        end
    end
    disp('Done starting requested nodes.');
    disp('Nodes will appear in the node manager when they are ready to compute.');
    updateNodeManager;
    
else
    % The console does not yet have a node running in it.  Start the node
    % in the console --> do not launch new Matlab session in the background.
    status.nid=start_nid;
    status.file=fullfile(status.scratchDir, '.', num2str(status.nid));
    status.killedFile=[status.file, '.killed'];
    status.writeLogFiles=par.parallel.writeLogFiles;
    if ~isempty(handles)
        enableNodeManagerComponents(handles);
    end
    %
    % There is now a node running in the console.
    setGUIData('nodeRunningInConsole', true);
    %
    % Start a Ferret or Locust worker node.
    QubistWorkerNode(status);
end
