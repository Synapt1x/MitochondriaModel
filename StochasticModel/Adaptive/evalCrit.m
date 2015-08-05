function nc = evalCrit(X0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates the minimum amount of a substance required for a reaction to
% be classified as critical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

averageStart = sum(X0) / length(X0);
nc = 0.1.* averageStart;  % crticial amount is 10% of starting amount

% future testing will keep critical percentage at 1. Lower percentages
% extended the time required for the simulation 