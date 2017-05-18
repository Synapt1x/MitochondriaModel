function [hObject, eventdata, handles] = model_selector_changed_func(...
    hObject, eventdata, handles)
%Function handling the selection of the current model in the GUI

%% initialization

% get the current and next models
prev_model = handles.selected_model;
next_model = select_model(hObject, eventdata, handles);

%% reset the GUI

% inform user that the model will be changed
make_switch = questdlg(['Would you lke to change the model to ', ...
    next_model.String, '?'], 'Change Model.', 'Yes', 'Cancel', 'Yes');
if strcmp(make_switch, 'Cancel')
    
    next_model.Value = 0;
    prev_model.Value = 1;
    
    return
end

% clear all graphs and refresh the gui
arrayfun(@cla,findall(0,'type','axes'))
drawnow()

%% change the model selected

% update handles to reflect the model change
handles.selected_model = next_model;
handles.model_equations = handles.models.(handles.selected_model.Tag);

% reset initial concentrations and parameter values
% parameters
if isfield(handles, 'main_window')
    handles = set_params_func(handles, handles.initialParams(:), ...
        'control','setDefault');
end
handles = set_params_func(handles, handles.initialParams(:),  ...
    'experimental','setDefault');
% initial concentrations
handles = set_initials_func(handles, handles.initialData(:), 'setDefault');

guidata(hObject,handles);