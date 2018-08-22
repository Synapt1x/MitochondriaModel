function handles = set_params_func(handles, values, type, varargin)
%insert the parameter values passed to the function in the GUI

%check for whether a structure was passed as 'values'
if isstruct(values)
    temp_values = [];
    for param=1:numel(handles.parameters.paramNames)
        temp_values(param) = values.(handles.parameters.paramNames{param});
    end
    values = temp_values;
end

%check for whether it is control or experimental parameters
if strcmp(type,'control')
    boxes = handles.allcontEdits;
    params = handles.ctrlParams;
else
    boxes = handles.allEdits;
    params = handles.expParams;
end

%loop over and change all the displayed values for the parameters
for i = 1:numel(boxes)
    boxes{i}.String = values(i);
end

%change all the values in the correct params struc if vargin nonempty
if ~isempty(varargin)
    [params.f0_Vmax, params.f0_Km, params.fIV_Vmax, params.fIV_Km, ...
        params.fIV_K, params.fV_Vmax, params.fV_Km, params.fV_K, ...
        params.p_alpha, params.cytcred, params.cytcox, ...
        params.amp_1, params.amp_2, params.amp_3, params.amp_4, ...
        params.cyt_c_drop] = deal(values(1), ...
        values(2), values(3), values(4), values(5), values(6), ...
        values(7), values(8), values(9), values(10), values(11), ...
        values(12), values(13), values(14), values(15), values(16));
    params.cytctot = params.cytcox + params.cytcred;
end

if strcmp(type,'control')
    handles.ctrlParams = params;
else
    handles.expParams = params;
end