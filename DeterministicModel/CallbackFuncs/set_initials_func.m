function handles = set_initials_func(handles, values, varargin)
%insert the parameter values passed to the function in the GUI

%loop over and change all the displayed values for the parameters
for i = 1:numel(handles.allInitials)
    set(handles.allInitials{i},'String',values(i));
end

%calc pH from concentration and set the proper text box to it
setpH=-log10(values(6)*1E-6);
set(handles.initial_ph_edit,'String',setpH);

%change all the values in the handles.parameters struc if vargin nonempty
if ~isempty(varargin)
    [handles.parameters.cytctot, handles.parameters.cytcox, ...
        handles.parameters.cytcred, handles.parameters.O2, ...
        handles.parameters.Hn, handles.parameters.Hp] = deal( ...
        values(1), values(2), values(3), values(4), values(5), values(6));
end