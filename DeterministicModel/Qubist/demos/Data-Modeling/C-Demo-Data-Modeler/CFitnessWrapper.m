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

function F=CFitnessWrapper(X,par)
% Will minimize F.
% LOW F is a highly fit individual.

% A wrapper function is required because nargout is called on mxFitness,
% and C functions don't know how to answer this!
%
% Fot example:
% nargout('mxFitness')
% ??? Error using ==> nargout
% mxFitness does not know how to answer nargin/nargout.

if ~(exist('mxFitness') == 3) %#ok
    uiwait(warndlg(['The mxFitness mex function does not exist.  Ferret ',...
        'will attempt to compile the C code to generate the mex function.'],...
        'Mex File Does Not Exist'));
    try %#ok
        mxFile=which('mxFitness.c');
        if isempty(mxFile)
            error('mxFitness.c does not exist!');
        end
        mexDir=fileparts(mxFile);
        mex(mxFile, '-outdir', mexDir)
        disp('*** Compilation to mex was successful.  Continuing... ***');
    catch %#ok
        errordlg({'The C function could not be compiled to mex.  Last error:',...
            lasterr}, 'Mex Generation Failed'); %#ok
        rethrow(lasterror); %#ok
    end
end

% Call the C function.
F=mxFitness(X,par);
