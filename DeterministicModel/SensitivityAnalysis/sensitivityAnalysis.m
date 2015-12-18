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
numsims = 1E4;
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

disp('Differentiating equations and finding sensitivity coefficients...')

%define arrays containing all funcs and all params
funcs = [dr,do,domega,drho];
params = [f0Vmax,f0Km,Vmax,K1,Km,p1,p2,p3,t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);

% normalize the equations by multiplying by reciprocal ratios, e.g.
%dr/df0Vmax is normalized by multiplying by f0Vmax/r
normalizingFactors = [f0Vmax/r, f0Km/r, Vmax/r, Km/r, K1/r,p1/r,p2/r,p3/r,t/r; ...
      f0Vmax/o, f0Km/o, Vmax/o, Km/o, K1/o,p1/o,p2/o,p3/o,t/o; ...
      f0Vmax/omega, f0Km/omega, Vmax/omega, Km/omega, K1/omega,p1/omega, ...
            p2/omega,p3/omega,t/omega; ...
      f0Vmax/rho, f0Km/rho, Vmax/rho, Km/rho, K1/rho,p1/rho,p2/rho,p3/rho,t/rho];
equations = num2cell(jacobianMatrix.*normalizingFactors);
% equations = num2cell(jacobianMatrix);

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(numsims,numel(params));
lhs = bsxfun(@plus,lb,bsxfun(@times,lhsRaw,(ub-lb))); %rescale to fit within bounds
lhsCell = num2cell(lhs); %convert to cell matrix

disp('Generating equations using latin hypercube sampling...');

% create equation label matrix
sensitivityOutput.outputLabels = {'dr/df0Vmax', 'dr/df0Km', 'dr/dVmax', 'dr/dKm', ...
      'dr/dK1', 'dr/dp1','dr/dp2','dr/dp3','dr/dt';'do/df0Vmax', 'do/df0Km', 'do/dVmax', ...
      'do/dKm', 'do/dK1', 'do/dp1','do/dp2','do/dp3','do/dt';'domega/df0Vmax',  ...
      'domega/df0Km', 'domega/dVmax', 'domega/dKm', 'domega/dK1', ...
      'domega/dp1', 'domega/dp2','domega/dp3','domega/dt'};

% create boxplot label matrix
labels = {'Equilibrium Value of Cytochrome C Reduced', ...
      'Equilibrium Value of Oxygen', 'Equilibrium Value of Matrix Protons', ...
      'Equilibrium Value of IMS Protons', 'Sensitivity Coefficient Values for dr/dt', ...
      'Sensitivity Coefficient Values for do/dt',...
      'Sensitivity Coefficient Values for domega/dt',...
      'Sensitivity Coefficient Values for drho/dt'};

% create file names for saving to png files
filenames = {'cytc','oxygen','matrixprotons','imsprotons','drdt','dodt','domegadt','drhodt'};
fullFilename = '';

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

% store value matrix in a regular matrix outside of struc
dataMatrix = sensitivityOutput.finalVals;

%% Compute statistics
% firstly compute the mean and variance of each value
meanVals = mean(dataMatrix,1);
deviationVals = std(dataMatrix,0,1);
varianceVals = deviationVals.^2;

% create box plots, one for each substrate in simulation and one for each
% equation provided for the sensitivity analysis
for substrate=1:8
      if substrate < 5 % check if it's just for the simulation model
            figure(substrate);
            
            % create a formatted boxplot for this column
            formatBoxplot(dataMatrix(:,substrate),labels{substrate}, ...
                  'Final Oxygen Concentration (nmol/mL)');
            
      else % if 5,6,7,8 then draw a group of boxplots for an equation
            figure(substrate);
            
            % create a formatted boxplot for the given equations
            % sensitivity coefficients
            formatBoxplot(dataMatrix(:,9*substrate-40:9*substrate-32),...
                  labels{substrate},'Sensitivity Coefficient Value');
      end
      fullFilename = [curdir,'/Images/',date,filenames{substrate},'-Boxplot'];
            
      % save the boxplot figure to a fig file and a png file
      savefig(fullFilename);
      print(fullFilename,'-dpng');
end