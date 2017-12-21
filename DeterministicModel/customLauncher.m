global QubistHome_ isRunning_ currentProjectPath_ currentComponent_ useMex_
% Modify this script if you need to make a custom launcher for Ferret.
% This is useful if you need to run Ferret multiple times in a customized
% batch mode.
% -----------------------------------------

% Set the current component to Ferret.
currentComponent_='Ferret';

% -----------------------------------------
% MODIFY THIS LINE TO POINT TO THE Qubist HOME DIRECTORY.
% This is usually a global path, but a relative path also works (even for
% parallel & runs) because a side-effect of setQubistPath is to convert
% QubistHome_ to a global path.
if ispc
    QubistHome_='C:\Users\synapt1x\Documents\Qubist';
elseif isunix
    QubistHome_='~/Qubist';
end
addpath(QubistHome_);
setQubistPath(QubistHome_);
%
% Give the project path and setup file name.
currentProjectPath_=fileparts(which(mfilename));
setupFile='FerretSetup_mito';
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
setGUIDataRoot('parallel', false);
launchDir=fileparts(which(mfilename));
setGUIDataRoot('launchDir', launchDir);

%
% -----------------------------------------
% Load the init file. You should use getExtPar to do this, because
% getExtPar sets options that are required for parallel runs. If you
% don’t want to do parallel runs, you *can* simple do:
% extPar=init;
%
%runInfo.projectPath=currentProjectPath_;
%runInfo.initFile='init';
%extPar=getExtPar(runInfo);
extPar=init;
% -----------------------------------------
% *** Additions to extPar here... ***
%
% These extPar fields are required.
% Uncomment to run with no graphics (normal for & batch processing).
extPar.mode='RunNoGraphics';
% extPar.mode=’Run’; % Uncomment to run with full graphics.
%
extPar.projectPath=currentProjectPath_; % ESSENTIAL!
% -----------------------------------------
% The user can also make his/her own modifications
% to the template here.
extPar.runNumber=1;
% -----------------------------------------
%
Ferret(extPar, setupFile);