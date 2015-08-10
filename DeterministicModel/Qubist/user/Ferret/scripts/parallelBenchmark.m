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

function parallelBenchmark
global QubistHome_ isRunning_ currentProjectPath_ currentComponent_ useMex_ benchmark

% A useful program for benchmarking performance of a project for parallel
% runs on a multi-core computer.  The number of cores used is incremented
% for each run, and the run time is recorded.  Data directories will be
% called FerretData-1, FerretData-2, etc.  MAKE SURE THESE DO NOT EXIST OR
% ARE EMPY PRIOR TO RUNNING!  Otherwise, the benchmak will be interrupted
% by an interactive prompt.

% Set the current component to Ferret.
currentComponent_='Ferret';
%
% Reset the path:
path(pathdef);
%
% -----------------------------------------
% MODIFY THIS LINE TO POINT TO THE Qubist HOME DIRECTORY.
% This is usually a global path, but a relative path also works (even for parallel runs) 
% because a side-effect of setQubistPath is to convert QubistHome_ to a global path.
QubistHome_='../../..';
addpath(QubistHome_);
setQubistPath;
%
% Give the project path and setup file name.
currentProjectPath_=[QubistHome_, '/demos/Advanced/Spectroscopic-Binaries'];
setupFile='FerretSetup';
NCores=1:8;
NGen=100;
nodeDistributionFactor=10;
% -----------------------------------------

% Use compiled functions or not?
useMex_=true;

% Add Qubist home.
addpath(QubistHome_);
%
% Force Qubist abort status to 0 so that Ferret can run.
forceAbortQubist(0);
isRunning_=0;

% Add the project path.
addpath(genpath(currentProjectPath_));

% Parallelization info.
setGUIDataRoot('parallel', true);
launchDir=fileparts(which(mfilename));
setGUIDataRoot('launchDir', launchDir);

% ---------------------------------------------------------------------
% Initialize the random number generator.  It may occasionally be useful
% to re-generate runs *exactly* by using exactly the same pseudo-random
% sequence.  If this is desired, just comment out the first line below
% that initializes the random number generator using the clock, and
% uncomment the second line, which resets the random number generator to
% its default state.  Random number initialization is not done anywhere
% else in Qubist.
%
% Get the Matlab version.
MatlabVersion=getMatlabVersion;
if MatlabVersion.major < 7
    error('Qubist required MATLAB version 7.');
end
%
% * Uncomment for DIFFERENT random sequence each time.
if MatlabVersion.minor >= 12
    s = RandStream.create('mt19937ar','seed',sum(100*clock));
    RandStream.setGlobalStream(s);  %#ok
elseif MatlabVersion.minor >= 7
    s = RandStream.create('mt19937ar','seed',sum(100*clock));
    RandStream.setDefaultStream(s);  %#ok
elseif MatlabVersion.minor >= 4
    rand('twister', sum(100*clock)); %#ok
else
    randn('state', sum(100*clock)); %#ok
end
%
% * Uncomment for SAME random sequence each time.
% if MatlabVersion.minor >= 12
%     s = RandStream.create('mt19937ar','seed',5489);
%     RandStream.setGlobalStream(s);  %#ok
% elseif MatlabVersion.minor >= 7
%     s = RandStream.create('mt19937ar','seed',5489);
%     RandStream.setDefaultStream(s);
% elseif MatlabVersion.minor >= 4
%     rand('twister', 5489);
% else
%     rand('state', 0);
% end
% randn('state', 0);
%
% Other options are possible.  Refer to the Matlab's documentation on
% random number generators by typing 'help rand'.
% ----------------------------------------------------------------

benchmark=[];
for i=length(NCores):-1:1
    %
    % -----------------------------------------
    % Load the init file.  You should use getExtPar to do this, because
    % getExtPar sets options that are required for parallel runs.  If you
    % don't want to do parallel runs, you *can* simple do:
    % extPar=init;
    %
    setQubistMode('Initialize');
    runInfo.projectPath=currentProjectPath_;
    runInfo.initFile='init';
    extPar=getExtPar(runInfo);
    par=loadFerretSetup(extPar, setupFile);
    %
    % Modify setup file.
    NWorkers=NCores(i)-1;
    par.general.NGen=NGen;
    par.parallel.NWorkers=NWorkers;
    par.parallel.nodeDistributionFactor=nodeDistributionFactor;
    appendName=['-', num2str(NCores(i))];
    par.general.dataDir=[par.general.dataDir, appendName];
    %
    % -----------------------------------------
    % Set the graphics mode.  Uncomment one of the following 2 lines.
    setQubistMode('RunNoGraphics'); % Uncomment to run with no graphics (normal for batch processing).
    % setQubistMode('Run'); % Uncomment to run with full graphics.
    % -----------------------------------------
    % *** Additions to extPar here... ***
    extPar.projectPath=currentProjectPath_; % ESSENTIAL!
    % -----------------------------------------
    %
    % Store benchmark info in a global variable;
    benchmark.NCores(i)=NCores(i);
    benchmark.start(i)=now;
    Ferret(extPar, par);
    benchmark.stop(i)=now;
end
%
% Save benchmark info.
benchmark.time=(benchmark.stop-benchmark.start)*24*3600; % in seconds.
if exist('benchmark.mat', 'file')
    delete('benchmark.mat');
end
save('benchmark', 'benchmark');
%
% Make a graph.
figure(1);
plot(benchmark.NCores, benchmark.time);
xlabel('NCores');
ylabel('time (s)');
if exist('benchmark.png', 'file')
    delete('benchmark.png');
end
print('-dpng', 'benchmark.png');

% =========================================================================
function MatlabVersion=getMatlabVersion
% Get the Matlab version.
MV=version;
index=find(MV == '.');
if length(index) < 2
    MatlabVersion=[];
else
    MatlabVersion.major=str2num(MV(1:index(1)-1)); %#ok
    MatlabVersion.minor=str2num(MV(index(1)+1:index(2)-1)); %#ok
    MatlabVersion.version=100*MatlabVersion.major+MatlabVersion.minor;
end

% =========================================================================
