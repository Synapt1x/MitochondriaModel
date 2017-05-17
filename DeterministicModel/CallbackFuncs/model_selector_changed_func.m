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
    prev_model.Value = 1;
    next_model.Value = 0;
    return
end

for graph_num = 1:length(handles.graphs)
    axes(handles.graphs{graph_num})
    cla reset
end

drawnow() % refresh the gui

%% change the model selected

handles.selected_model = next_model;

handles.model_equations = 