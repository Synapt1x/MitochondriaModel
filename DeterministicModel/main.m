function main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created by: Chris Cadonic
% For: M.Sc program in Biomedical Engineering
% Project: Modeling Mitochondrial Bioenergetics
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the primary file for running the mitochondrial model created for
% my master's project as part of the biomedical engineering program. 
%
% See the readme file 'manual.pdf' for more information as to how this 
% program functions and how each component script functions. The readme
% file 'changelog.txt' indicates the changes implemented into the model as
% well as the timestamps for each change.
%
% This code is slightlty altered from its original form to simply model the
% decoupled system1, that is, to primarily model complex IV.
%
% For altering the parameters of the model, changes can be made to the
% differential equations in 'derivatives.m', the setup conditions in
% 'setup.m', and the methods of solving equations in 'solver.m'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameters = setup; %run the setup function which creates a structure
%storing all variables necessary for the model

save parameters %save the parameters for the model to the workspace

%create the GUI for interfacing and display
main_gui(parameters);