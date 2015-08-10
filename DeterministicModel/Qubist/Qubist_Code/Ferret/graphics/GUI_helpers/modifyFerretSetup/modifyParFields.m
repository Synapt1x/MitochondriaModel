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

function par=modifyParFields(handles, varargin)
% Loads par structure from the GUIData system and copies it to UserData.
%
par=get(handles.modifyFerretSetup, 'UserData');
if isempty(par) || (~isempty(varargin) && islogical(varargin{1}) && varargin{1})
    par=[];
    par.struct=getGUIData('par');
    if ~isempty(par)
        [dummy,par.list,par.values]=struct2List(par.struct);
    end
end

lastFieldName='';
parList={};
for i=1:length(par.list)
    fieldName=regexpi(par.list{i}, '\.', 'split');
    if ~isempty(fieldName)
        fieldName=fieldName{1};
    end
    if ~strcmpi(fieldName, lastFieldName)
        if i > 1
            parList=[parList, {' '}]; %#ok
        end
        parList=[parList, {['========== ', fieldName, ' =========='], ' '}]; %#ok
    end
    parList=[parList, {par.list{i}}]; %#ok
    lastFieldName=fieldName;
end

if ~isempty(par)
    par=deleteImmutableFields(par);
    set(handles.FerretSetup, 'String', parList);
    set(handles.modifyFerretSetup, 'UserData', par);
    setModifiedEditValue(handles);
end
