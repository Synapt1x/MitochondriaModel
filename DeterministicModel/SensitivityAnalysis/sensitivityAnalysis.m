function sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function carries out a relative sensitivty analysis for the entire system
using the method outlined in Beard (2005).

In this file, MT = minus ten percent, and PT = plus ten percent
%}

%% Create LHS sampling and Sensitivity Coefficients

% clear cmd history for clarity
clc

cd('..');
addpath([pwd,'/AdditionalFuncs']);

parameters = setup; %run the setup function which creates the
%structure storing all variables necessary
%for evaluating the model (found in 'setup.m')

% store the values of the parameters in a vector
[paramSet,paramMT,paramPT] = deal(parameters.ctrlParams);
paramVals = [paramSet.f0Vmax, paramSet.Vmax, paramSet.f0Km, paramSet.K1, ...
      paramSet.Vmax, paramSet.Km, paramSet.p1, paramSet.p2, paramSet.p3, ...
      paramSet.Dh];

% calculate +- 10 %
MTVals= paramVals*0.9;
PTVals = paramVals*1.1;

% store the minus 10 % parameter values
[paramMT.f0Vmax, paramMT.Vmax, paramMT.f0Km, paramMT.K1, ...
      paramMT.Vmax, paramMT.Km, paramMT.p1, paramMT.p2, paramMT.p3, ...
      paramMT.Dh] = deal(MTVals(1),MTVals(2), MTVals(3), MTVals(4), MTVals(5), ...
      MTVals(6), MTVals(7), MTVals(8), MTVals(9), MTVals(10));

% store the plus 10 % parameters values
[paramPT.f0Vmax, paramPT.Vmax, paramPT.f0Km, paramPT.K1, ...
      paramPT.Vmax, paramPT.Km, paramPT.p1, paramPT.p2, paramPT.p3, ...
      paramPT.Dh] = deal(PTVals(1),PTVals(2), PTVals(3), PTVals(4), PTVals(5), ...
      PTVals(6), PTVals(7), PTVals(8), PTVals(9), PTVals(10));

% call solver to calculate the output of the model for each alteration
[~, MTsolutionVals] = solver(parameters, paramMT);
[~, solutionVals] = solver(parameters, paramSet);
[~, PTsolutionVals] = solver(parameters,paramPT);

% acquire real data from the parameters structure
realData = parameters.realo2Data;

% Evaluate E*, and E* of plus and minus 10
E_minusTen = sum((realData - MTsolutionVals(:,2)).^2)/numel(realData);
E_optimal = sum((realData - solutionVals(:,2)).^2)/numel(realData);
E_plusTen = sum((realData - PTsolutionVals(:,2)).^2)/numel(realData);




