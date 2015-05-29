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

function setModifiedEditValue(handles)
% Reads the FerretSetup listbox, retrieves the corresponding value, and
% writes it to the editValues textbox.
%
par=get(handles.modifyFerretSetup, 'UserData');
index=get(handles.FerretSetup, 'Value');
name=get(handles.FerretSetup, 'String');
name=name{index};
index=find(strcmpi(par.list, name));
if isempty(index)
    set(handles.editValue, 'String', 'NO MOD POSSIBLE');
    return
else
    index=index(1);
end

if index <= length(par.list)
    V=par.values{index};
    VLen=length(V);
    if isnumeric(V)
        if VLen > 1
            V=formatVector(V, 6);
        elseif VLen == 1
            V=num2str(V);
        elseif VLen == 0
            V='[]';
        end
    elseif islogical(V)
        if V
            V='true';
        else
            V='false';
        end
    elseif ischar(V)
        V(V == '''')=[];
        V=strtrim(V);
    end
    %
    if iscell(V)
        set(handles.editValue, 'String', 'CELL ARRAY')
    elseif size(V,1) > 1
        set(handles.editValue, 'String', 'Multi-Line Text');
    else
        set(handles.editValue, 'String', V);
    end
end
