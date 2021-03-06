function [hObject, handles] = edit_box(hObject, handles, type, paramChange)

%extract the new value input by the user
newVal = str2double(get(hObject, 'String'));

if strcmp(type,'control')
    %check for whether or not a correct input was given
    if isnan(newVal) %if not, throw error box and reset value
        msgbox('Please input a valid number.','Not a number');
        hObject.String = handles.ctrlParams.(paramChange);
    else %if so, then update the model with new value
        handles.ctrlParams.(paramChange) = newVal;
    end
elseif strcmp(type,'experimental')
    %check for whether or not a correct input was given
    if isnan(newVal) %if not, throw error box and reset value
        msgbox('Please input a valid number.','Not a number');
        hObject.String = handles.expParams.(paramChange);
    else %if so, then update the model with new value
        handles.expParams.(paramChange) = newVal;
    end
else
    %check for whether or not a correct input was given
    if isnan(newVal) %if not, throw error box and reset value
        msgbox('Please input a valid number.','Not a number');
        hObject.String = handles.parameters.(paramChange);
    else %if so, then update the model with new value
        handles.ctrlParams.(paramChange) = newVal;
        handles.expParams.(paramChange) = newVal;
        handles.parameters.(paramChange) = newVal;
    end
end

%also check to see if cytochrome c total needs to be updated
if strcmp(paramChange,'cytcred') || strcmp(paramChange,'cytcox')
    %update the total amount of cytochrome c total
    %get current total cyt c
    newCytcox = str2double(get(handles.initial_cytcox_edit,'String'));
    newCytcred = str2double(get(handles.initial_cytcred_edit,'String'));
    newTot = newCytcox + newCytcred;
    
    %increase cyt c tot by the amount of introduced cyt c red
    handles.initial_cytctot_edit.String = newCytcox + newCytcred;
    handles.ctrlParams.cytctot = newTot;
    handles.expParams.cytctot = newTot;
    handles.parameters.cytctot = newTot;
end

%update data
guidata(hObject,handles);