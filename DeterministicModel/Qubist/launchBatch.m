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

function launchBatch
% Launches Qubist and allows the user to add new projects.  LaunchQubist
% should be copied to a convenient (usually central) location in each user's
% home directory.  Do not run the launcher from the Qubist home directory
% (QubistHome_ below).  Also, do not run the launcher from any project
% directory (or sub-directory), because files belonging to this project may
% over-shadow files belonging to other added projects (or even demos),
% causing them to fail.
%
% Set the java class path here if it is required.  Note that javaclasspath
% must be called before assigning any global variables.  See javaclasspath
% documentation for further information.
%
% javaclasspath( <arguments> );
%
% Global variables required internally by Qubist.  You can add others if necessary.
global QubistHome_ currentComponent_ useMex_ batchManagerWindow_ randomSeed_
%
% This is the default home for Qubist.  QubistHome_ should be over-written
% by the name of the actual Qubist home directory.
QubistHome_=getDefaultQubistHome;
%
% -----------------------------------------
% ---- QUBIST LAUNCH OPTIONS BEGIN HERE ---
% ---- MODIFY CODE BELOW THESE LINES ------
% -----------------------------------------
% *** MODIFY THIS LINE TO POINT TO THE QUBIST HOME DIRECTORY.
% This is normally a global path.  For example...
% QubistHome_='C:\Users\JFiege\Documents\Qubist';
%
% Relative paths also work.  For example:
% QubistHome_='.';
% -----------------------------------------
% Set the default optimizer ('Ferret' or 'Locust').
% (This is just a default.  The optimizer can be set using a line like
% "code=Ferret" or "code=Locust" in the queue.txt batch file.)
currentComponent_='Ferret';
% -----------------------------------------
% Do you want to use the graphical batch manager window?
batchManagerWindow_=true; % true or false.
% -----------------------------------------
% *** Use Qubist's compiled functions?  Uncomment one of these lines:
useMex_=true; % Use compiled functions when possible.
% useMex_=false; % Avoid compiled functions.
% -----------------------------------------
% *** Parallel computing:
% Remove the Qubist 'matlabLaunchCommand' preference, if it exists.
if ispref('Qubist', 'matlabLaunchCommand'), rmpref('Qubist', 'matlabLaunchCommand'); end
%
% Now, optionally, set a MATLAB start command for nodes.  Generally, you should
% *NOT* have to do this, since the correct command should be determined automatically.
% Set this preference only if you run into a problem.  For example:
% matlabLaunchCommand='matlab';
% setpref('Qubist', 'matlabLaunchCommand', matlabLaunchCommand);
% -----------------------------------------
% *** Initialize random number generator.
% The value of global variable randomSeed_ determines the behaviour of
% the random number generator.  Accepted values are as follows:
randomSeed_=NaN; % Use a DIFFERENT random seed each time.
% randomSeed_='same'; % Use SAME random seed each time = 5489.
% randomSeed_=<INTEGER>; % Use random seed = <INTEGER>, where <INTEGER>
%   is replaced by an actual integer.  For example, randomSeed_=1234;
% -----------------------------------------
% ----- QUBIST LAUNCH OPTIONS END HERE ----
% ----- MODIFY CODE ABOVE THESE LINES -----
% -----------------------------------------

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

% Add basic paths.
path(pathdef);
addpath(QubistHome_);
addpath(genpath(fullfile(QubistHome_, 'launchers')));
addpath(genpath(fullfile(codeDir, 'tools', 'installation')));

% Check that the p-files work, if checkPFiles.p exists.  This will generate an
% error if the p-file version is incorrect.
if exist('checkPFiles', 'file')
    try
        checkPFiles;
    catch %#ok
        error('Qubist p-files are not readable.  Contact nQube for assistance.');
    end
else
    error(['QUBIST PATH IS INCORRECT.  Check that the QubistHome_ ',...
        'variable in your launcher points to the Qubist home directory.']);
end

% Add shared paths.
addpath(genpath(fullfile(codeDir, 'shared', 'utility')));

% Clear the entire GUIData system.
rmGUIDataRoot('all');

% Check that that Qubist path is OK.
checkQubistPath;

% Parallelization info.
setGUIDataRoot('parallel', false);
launchDir=fileparts(which(mfilename));
setGUIDataRoot('launchDir', launchDir);

% Initialize the random number generator.
initializeRNG;

% Add remaining paths.
setQubistPath;

% Start the batch manager.
batchManager;

% =========================================================================

function QubistHome_=getDefaultQubistHome
% Sets the default Qubist home directory and does basic checking.  The
% default is only used if launchQubist is called from the Qubist
% installation directory and the user has not specified the QubistHome_ path.
QubistHome_=fileparts(which(mfilename));
[QubistPath, Qubist]=fileparts(QubistHome_);
if ~strfind(Qubist, 'Qubist')
    QubistHome_='';
end
