function sensitivityOutput = sensitivityAnalysis()
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

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho f0vmax f0K vmax K1 Km p1 p2 p3 p4 t cytcdiff;
[equations, output] = deal({});
r = 0.1;
o = 171.0549;
omega = 100;
rho = 0.0398;

%Initialize output parameters
sensitivityOutput.equations = [];
[sensitivityOutput.outputLabels, output, ...
      sensitivityOutput.outputVals] = deal({});

%define cytcdiff
cytcdiff = 100.1 - r;

%Define each of the baseline equations from the mito model
dr = 2*((f0vmax*(cytcdiff))/(f0K+(cytcdiff))) ...
        *(omega./rho) - 2*((vmax*o)/(Km*(1 ...
        +(K1/r))+o))*(omega/rho); %dr
do = -0.5*((vmax*o)/(Km*(1+(K1/r))+o)) ...
      *(omega/rho); %do
domega = -6*((f0vmax*(cytcdiff))/(f0K+(cytcdiff))) ...
        *(omega./rho) - 2*((vmax*o)/(Km*(1 ...
        +(K1/r))+o))*(omega/rho) + ((p1 ...
        *(rho/omega))/((rho/omega)+p2 + (p3/omega)))*rho; %domega

%define arrays containing all funcs and all params
funcs = [dr,do,domega];
params = [f0vmax,f0K,vmax,K1,Km,p1,p2,p3,t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);

% create the sampling pool using latin hypercube sampling
lhs = lhsdesign(18,9);

disp('Generating equations using latin hypercube sampling...');

% loop over and apply lhs to each equation
for eq =1:numel(jacobianMatrix)
      % each parameter sensitivity is stored in jacobianMatrix
      equations{eq} = jacobianMatrix(eq); %store each equation
      
      lhsCell = num2cell(lhs); %convert to cell matrix
      for i=1:size(lhs,1)
            [f0vmax, f0K, vmax, K1, Km, p1, p2, p3, t] = deal(lhsCell{i,:});

            output{i,eq} = subs(jacobianMatrix(eq));
            output{i,eq} = double(output{i,eq});
      end
end

% create label matrix
sensitivityOutput.outputLabels = {'dr/df0vmax','do/df0vmax', ...
      'domega/df0vmax','dr/df0K','do/df0K','domega/df0K', 'dr/dvmax', ...
      'do/dvmax','domega/dvmax', 'dr/dK1','do/dK1','domega/dK1','dr/dKm', ...
      'do/dKm','domega/dKm', 'dr/dp1','do/dp1','domega/dp1', 'dr/dp2', ...
      'do/dp2','domega/dp2', 'dr/dp3','do/dp3','domega/dp3', 'dr/dt', ...
      'do/dt','domega/dt'};

% convert from symbolic notation and store in structure
sensitivityOutput.equations = vpa(equations);
sensitivityOutput.outputVals = cell2mat(output);