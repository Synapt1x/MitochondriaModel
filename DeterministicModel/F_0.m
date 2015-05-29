function v = F_0(parameters)
%This function is only relevant for the decoupled situation
%
% In this case the system only concerns the activity of complex IV. With
% this situation, the activiy of complexes I-III are instead treated as a
% set cumulative function supplying proton movement and cytochrome c
% reduced for complex IV. F_0 models this acivity. The default F_0 form is 
% a constant, so F_0 = 1 always;

    v = parameters.f0;
    
end