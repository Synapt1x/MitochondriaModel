function hObject = select_model(hObject, eventdata, handles)
% This is a helper function used to determine which model will be selected
% in the button group model_selector

% create a cell array for all the different model buttons
models = {handles.cc_full_model, handles.cc_baseline_model};

% determine which model is selected
for model_num = 1:length(models)
    check_model = models{model_num};
    if check_model.Value == 1
        hObject = check_model;
        break
    end
end