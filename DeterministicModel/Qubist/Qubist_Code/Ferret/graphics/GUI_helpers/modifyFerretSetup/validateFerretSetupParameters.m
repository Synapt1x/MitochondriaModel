%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function validateFerretSetupParameters(handles)
% Helper function for modifyFerretSetup.

par=get(handles.modifyFerretSetup, 'UserData');
index=get(handles.FerretSetup, 'Value');
name=get(handles.FerretSetup, 'String');
name=name{index};
index=find(strcmpi(par.list, name));
if isempty(index)
    return
end

try %#ok
    evalString=get(handles.editValue, 'String');
    V=eval(evalString);
    if isnumeric(V) && isempty(V)
        V=[];
    end
catch
    % Assume it's a string if it can't be evaluated.
    V=evalString;
end
if ischar(V)
    V(V == '''')=[];
    V=strtrim(V);
end
field=par.list{index};
try
    eval(['par.struct.', field, '=V;']);
    [par.struct, warningState]=validate(par.struct, true);
    if warningState
        [dummy,par.list,par.values]=struct2List(par.struct);
    else
        par.values{index}=V;
    end
catch
    errordlg('The new value is not valid.  Reverting to old value.',...
        'Invalid Value');
    set(handles.editValue, 'String', par.values{index});
end
set(handles.modifyFerretSetup, 'UserData', par);
setModifiedEditValue(handles)
modifyParFields(handles);
