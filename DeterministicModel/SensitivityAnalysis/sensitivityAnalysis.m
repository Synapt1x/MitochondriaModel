function sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function houses code for using symbolic variables to represent
functions in my deterministic model. This function will be essential
to conducting sensitivity analysis for my masters project by finding
the Jacobian of the set of equations in my model. This will be done
using the symbolic functions for each equation in my model as
carried out below.
This will be carrying out sensitivty analysis for the baseline system.
%}

%% Create LHS sampling and Sensitivity Coefficients

% clear cmd history for clarity
clc

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho f0Vmax f0Km Vmax K1 Km p1 p2 p3 p4 t cytcdiff;
r = 0.1;
o = 171.0549;
omega = 100;
rho = 0.0398;

%Initialize output parameters
sensitivityOutput.equations = [];
[sensitivityOutput.outputLabels, sensitivityOutput.outputVals] ...
      = deal({});

%define cytcdiff
cytcdiff = 100.1 - r;

% define parameters for run
numsims = 100;
lb = [0.01, 0.1, 0.01, 0.1, 1, 0.1, 1, 1E-6, 0.1]; % lower bounds for params
ub = [10, 1, 1E4, 10, 1E4, 1E4, 1E4, 1, 1E5]; % upper bound for params

%Define each of the baseline equations from the mito model
dr = 2*((f0Vmax*(cytcdiff))/(f0Km+(cytcdiff))) ...
      *(omega./rho) - 2*((Vmax*o)/(Km*(1 ...
      +(K1/r))+o))*(omega/rho); %dr
do = -0.5*((Vmax*o)/(Km*(1+(K1/r))+o)) ...
      *(omega/rho); %do
domega = -6*((f0Vmax*(cytcdiff))/(f0Km+(cytcdiff))) ...
      *(omega./rho) - 2*((Vmax*o)/(Km*(1 ...
      +(K1/r))+o))*(omega/rho) + ((p1 ...
      *(rho/omega))/((rho/omega)+p2 + (p3/omega)))*rho; %domega
drho = 6*((f0Vmax*(cytcdiff))/(f0Km+(cytcdiff))) ...
      *(omega./rho) + 2*((Vmax*o)/(Km*(1 ...
      +(K1/r))+o))*(omega/rho) - ((p1 ...
      *(rho/omega))/((rho/omega)+p2 + (p3/omega)))*rho; % drho

%define arrays containing all funcs and all params
funcs = [dr,do,domega];
params = [f0Vmax,f0Km,Vmax,K1,Km,p1,p2,p3,t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);
equations = num2cell(jacobianMatrix);

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(numsims,numel(params));
lhs = bsxfun(@plus,lb,bsxfun(@times,lhsRaw,(ub-lb))); %rescale to fit within bounds
lhsCell = num2cell(lhs); %convert to cell matrix

disp('Generating equations using latin hypercube sampling...');

% create label matrix
sensitivityOutput.outputLabels = {'dr/df0Vmax', 'dr/df0Km', 'dr/dVmax', 'dr/dKm', ...
      'dr/dK1', 'dr/dp1','dr/dp2','dr/dp3','dr/dt';'do/df0Vmax', 'do/df0Km', 'do/dVmax', ...
      'do/dKm', 'do/dK1', 'do/dp1','do/dp2','do/dp3','do/dt';'domega/df0Vmax',  ...
      'domega/df0Km', 'domega/dVmax', 'domega/dKm', 'domega/dK1', ...
      'domega/dp1', 'domega/dp2','domega/dp3','domega/dt'};

% convert from symbolic notation and store in structure
sensitivityOutput.equations = vpa(equations);

%% Apply LHS sampling and carry out statistics on results

% move up one folder to the main model
curdir = fileparts(which(mfilename));
cd('..');

% acquire params for the properties of the model
params = setup;
params.timePoints = linspace(0.1,1E4,1E3);
sensitivityOutput.finalVals = [];

disp('Simulating the model and keeping final values of long-time runs...');

for sim=1:numsims
      % convert to cell array to distribute to params
      tempLhs = num2cell(lhs(sim,:));
      [params.ctrlParams.f0Vmax,params.ctrlParams.f0Km, ...
            params.ctrlParams.Vmax,params.ctrlParams.K1, ...
            params.ctrlParams.Km,params.ctrlParams.p1, ...
            params.ctrlParams.p2,params.ctrlParams.p3, ...
            params.ctrlParams.t] = tempLhs{:};
      
      % simulate the system using ode23t
      [~,y] = ode23t(@baselineSystem, params.timePoints, ...
            [params.Cytcred,params.O2,params.Hn, params.Hp], ...
            [],params.ctrlParams);
      
      % store the final value(s)s of each simulation
      sensitivityOutput.finalVals(sim,1:4) = mean(y(end-round(numel(y)*0.1):end,:));
      
      % also use the lhs values to find the values for each
      % sensitivity coefficient
      [f0Vmax, f0Km, Vmax, K1, Km, p1, p2, p3, t] = deal(lhsCell{sim,:}); %set values

      for eqNum=1:numel(equations) % evaluate each equation with this value set
            sensitivityOutput.finalVals(sim,eqNum+4) = subs(equations{eqNum});
      end      
end

%change back to sensitivity analysis folder
cd(curdir)

% call the compute stats function to analyze the results
computeStats(sensitivityOutput.finalVals);
