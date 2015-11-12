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

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho f0Vmax f0Km Vmax K1 Km p1 p2 p3 p4 t cytcdiff;
r = 0.1;
o = 171.0549;
omega = 100;
rho = 0.0398;

%Initialize output parameters
sensitivityOutput.equations = [];
[equations, sensitivityOutput.outputLabels, output, ...
      sensitivityOutput.outputVals] = deal({});

%define cytcdiff
cytcdiff = 100.1 - r;

% define parameters for run
numsims = 1E3;

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

%define arrays containing all funcs and all params
funcs = [dr,do,domega];
params = [f0Vmax,f0Km,Vmax,K1,Km,p1,p2,p3,t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);

% create the sampling pool using latin hypercube sampling
lhs = lhsdesign(numsims,numel(params));

disp('Generating equations using latin hypercube sampling...');

% loop over and apply lhs to each equation
for eq =1:numel(jacobianMatrix)
      % each parameter sensitivity is stored in jacobianMatrix
      equations{eq} = jacobianMatrix(eq); %store each equation
      
      lhsCell = num2cell(lhs); %convert to cell matrix
      for i=1:numsims
            [f0Vmax, f0Km, Vmax, K1, Km, p1, p2, p3, t] = deal(lhsCell{i,:});
            
            output{i,eq} = subs(jacobianMatrix(eq));
            output{i,eq} = double(output{i,eq});
      end
end

% create label matrix
sensitivityOutput.outputLabels = {'dr/df0Vmax','do/df0Vmax', ...
      'domega/df0Vmax','dr/df0Km','do/df0Km','domega/df0Km', 'dr/dVmax', ...
      'do/dVmax','domega/dVmax', 'dr/dK1','do/dK1','domega/dK1','dr/dKm', ...
      'do/dKm','domega/dKm', 'dr/dp1','do/dp1','domega/dp1', 'dr/dp2', ...
      'do/dp2','domega/dp2', 'dr/dp3','do/dp3','domega/dp3', 'dr/dt', ...
      'do/dt','domega/dt'};

% convert from symbolic notation and store in structure
sensitivityOutput.equations = vpa(equations);
sensitivityOutput.outputVals = cell2mat(output);

% compute sensitivity scores
sensitivityOutput.vals = subs(sensitivityOutput.outputVals);

%% Apply LHS sampling and carry out statistics on results

% move up one folder to the main model
curdir = fileparts(which(mfilename));
cd('..');

% acquire params for the properties of the model
params = setup;
params.timePoints = linspace(0.1,1E4,1E3);
finalVals = zeros(numsims,4);

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
      
      % store the final value of each 
      finalVals(sim,:) = y(end,:);
end

%change back to sensitivity analysis folder
cd(curdir)

% call the compute stats function to analyze the results
computeStats(finalVals);
