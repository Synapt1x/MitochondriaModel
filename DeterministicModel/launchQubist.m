%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2014. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function launchQubist
% * Launches Qubist and allows the user to add new projects.  LaunchQubist
% * should be copied to a convenient (usually central) location in each user's
% * home directory.  Do not run the launcher from the Qubist home directory
% * (QubistHome_ below).  Also, do not run the launcher from any project
% * directory (or sub-directory), because files belonging to this project may
% * over-shadow files belonging to other added projects (or even demos),
% * causing them to fail.
%
% * Set the java class path here if it is required.  Note that javaclasspath
% * must be called before assigning any global variables.  See javaclasspath
% * documentation for further information.
%
% javaclasspath( <arguments> );
%
% * Global variables required internally by Qubist.  You can add others if necessary.
global QubistHome_ currentComponent_ QubistSkin_ useMex_ randomSeed_
global GraphicsScale_ FontScale_
%
% * This is the default home for Qubist.  QubistHome_ should be over-written
% * by the name of the actual Qubist home directory.
QubistHome_='/home/synapt1x/Qubist';

% -----------------------------------------
% ---- QUBIST LAUNCH OPTIONS BEGIN HERE ---
% ---- MODIFY CODE BELOW THESE LINES ------
% -----------------------------------------
% *** MODIFY THIS LINE TO POINT TO THE QUBIST HOME DIRECTORY.
% * This is normally a global path.  For example...
% QubistHome_='/home/fiege/Documents/Qubist_Builder_Unity/Qubist';
%
% * Relative paths also work.  For example:
% QubistHome_='.';
% -----------------------------------------
% *** Use Qubist's compiled functions?  Uncomment one of these lines:
useMex_=true; % Use compiled functions when possible.
% useMex_=false; % Avoid compiled functions.
% -----------------------------------------
% *** Display settings for graphical user interface:
%
% * Skins:
% * -----
% * Uncomment one of these lines to set the desired skin, which affects the
% * appearance of QUBIST GUIs.  We recommend the "Unity", which should scale
% * reasonably well between displays.  You might also choose the "Minimalist"
% * skin if you are using a very old MATLAB 7.x version or if you want to
% * minimize graphics resources.
QubistSkin_='Unity'; % Best choice for most computers and MATLAB versions.
% QubistSkin_='Minimalist';  % Basic interface.  Best choice for old MATLAB 7.x versions.
%
% * Graphics and text scaling:
% * -------------------------
% * You can modify the following scaling factors to increase or decrease the
% * sizes of all MATLAB graphics, and the font sizes in the main Qubist interfaces.
% * Default values are GraphicsScale_=1 and FontScale_=1 for normal scaling.
GraphicsScale_=1;
FontScale_=1;
%
% -----------------------------------------
% *** Parallel computing:
% * Remove the Qubist 'matlabLaunchCommand' preference, if it exists.
if ispref('Qubist', 'matlabLaunchCommand'), rmpref('Qubist', 'matlabLaunchCommand'); end
%
% * Now, optionally, set a MATLAB start command for nodes.  Normally, you should
% * NOT have to do this, since the correct command should be determined automatically.
% * Set this preference only if you run into a problem.  For example:
% matlabLaunchCommand='matlab';
% setpref('Qubist', 'matlabLaunchCommand', matlabLaunchCommand);
% -----------------------------------------
% *** Initialize random number generator.
% * The value of global variable randomSeed_ determines the behaviour of
% * the random number generator.  Accepted values are as follows:
randomSeed_=NaN; % Use a DIFFERENT random seed each time.
% randomSeed_='same'; % Use SAME random seed each time = 5489.
% * randomSeed_=<INTEGER>; % Use random seed = <INTEGER>,
% * where <INTEGER> is replaced by an actual integer.  For example:
% randomSeed_=1234;
% -----------------------------------------
% ----- QUBIST LAUNCH OPTIONS END HERE ----
% ----- MODIFY CODE ABOVE THESE LINES -----
% -----------------------------------------

try
      % Determine Qubist code directory.
      sourceDir=fullfile(QubistHome_, 'Qubist_Source');
      pcodeDir=fullfile(QubistHome_, 'Qubist_Code');
      if exist(sourceDir, 'dir')
            % Source code is available.
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
      
      % THIS LINE SETS THE CURRENT ALGORITHM.
      currentComponent_='No_Component_Selected';
      
      % Check that that Qubist path is OK.
      checkQubistPath;
      % Are we using QubistFreeTools?
      if isempty(which('startFerretProject'))
            setGUIDataRoot('QubistFreeTools', true);
      else
            setGUIDataRoot('QubistFreeTools', false);
      end
      
      % Parallelization info.
      setGUIDataRoot('parallel', false);
      launchDir=fileparts(which(mfilename));
      setGUIDataRoot('launchDir', launchDir);
      
      try %#ok
            % Load the project info.
            setGUIData('UserProjects', Qubist_UserProjects);
      end
      
      % Initialize the random number generator.
      initializeRNG;
      
      % Prepare to launch.
      setQubistMode('Launch');
      
      % --- Start Qubist ---
      startQubist;
      
catch %#ok
      errordlg({'Qubist did not launch.', '',...
            ['Last error: ', lasterr]}, 'Qubist Launch Error'); %#ok
      rethrow(lasterror); %#ok
end

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

% =========================================================================

function projects=Qubist_UserProjects

% To add your own LOCAL (per user) projects to the Projects menu:
%
% Edit this file and add the path info for your projects in the following
% format:
%
% projects{n}.path='/full/path/to/project/directory'; %[default: ./]
% projects{n}.name='Project Name'; %[default: deepest directory in projects{n}.path]
% projects{n}.init='initializationCode'; %[default: none]
% projects{n}.setup='FerretSetupFile'; [default: 'FerretSetup']
%
% Here, n is an integer giving the number of the entry in the projects
% menu.  Start at n=1 for the 1st entry, n=2 for the 2nd, etc.
% Path should be the full directory path to the project, which contains
% the setup file and the fitness m-file.  Name is the arbitrary name of
% the project.  Init is an optional initilization m-file that produces
% an external parameter structure that is passed to Ferret.  Setup is
% the name of the Ferret setup file.
%
projects={};
%
% =========================================================================
% MODIFY THESE LINES TO ADD LOCAL PROJECTS VISIBLE ONLY TO THE CURRENT USER:
%
projects{1}.path=fileparts(which(mfilename));
projects{1}.name='Mito Model';
projects{1}.init='init';
projects{1}.setup='FerretSetup';
