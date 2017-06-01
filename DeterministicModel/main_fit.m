function main_fit
%{
========================================
Created by: Chris Cadonic
For: M.Sc program in Biomedical Engineering
Project: Modeling Mitochondrial Bioenergetics
========================================
This is the primary file for running the mitochondrial model created
for my master's project as part of the biomedical engineering
program.

See the readme file 'manual.pdf' for more information as to how
this program functions and how each component script functions.
The readme file 'changelog.txt' indicates the changes implemented
into the model as well as the timestamps for each change.

This code is slightlty altered from its original form to simply model
the decoupled system, that is, to primarily model complex IV.

For altering the parameters of the model, changes can be made to
the differential equations in 'decoupled_derivative_system.m', the
setup conditions in 'setup.m', optimization run by using
'launchQubist.m', the gui handled by 'main_gui.m', and the
importing of data handled by 'data_formatter.m'.
%}

[parameters, data, models] = setup; %run the setup function which creates the
%structure storing all variables necessary
%for the model (found in 'setup.m')

save parameters %save the model parameters in parameters.mat

%create the GUI for interfacing and display
%finalgui(parameters);

%determine which data set will be fit in this call
which_fit = questdlg('Which data set will you be fitting?', ...
    'Select data type for fitting', 'Control', 'Alzheimers', 'Cancel', 'Cancel');
switch which_fit
    case 'Control'
        data_fitting = 1;
        data_fit = {data_fitting};
        save('temp-data_fitting.mat', 'data_fit')

        %open the optimization window
        finalgui_fit(parameters, data, models);
        
    case 'Alzheimers'
        data_fitting = 2;
        data_fit = {data_fitting};
        save('temp-data_fitting.mat', 'data_fit')
        
        %open the optimization window
        finalgui_fit(parameters, data, models);
        
    case 'Cancel'
        hdata_fitting = 1;
        data_fit = {data_fitting};
        save('temp-data_fitting.mat', 'data_fit')
        
        waitfor(msgbox('Optimization cancelled.', 'Cancelled.'));
end