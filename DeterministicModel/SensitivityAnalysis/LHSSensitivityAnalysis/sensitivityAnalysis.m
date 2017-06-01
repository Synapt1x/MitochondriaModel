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

%%%%%%%%%%%%%%%%%%%%%%%% define parameters for run %%%%%%%%%%%%%%%%%%%%%%%%

numsims = 1E4;
% lower bounds for params
lb = [0.01, 0.01, 0.01, ... %fIV
    0.1, 0.1, 0.1, ... %fV
    0.01, 0.01, ... %f0
    1E-6, 0, 1E-6, 1E-6];
% upper bounds for params
ub = [10, 1E4, 1E4, ... %fIV
    1E4, 1E4, 1E4, ... %fV
    1E4, 1E41, ... %f0
    1E5, 1, 1E4, 1E4]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear cmd history for clarity
clc

% store the current directory and move up to acquire model information
curdir = fileparts(which(mfilename));
cd(['..',filesep,'..']);

% acquire initial setup data for the model
[params, data, models] = setup;

cd(curdir);

% Add export_fig function to path for boxplot figures
% cd(['..' ,filesep, '..']);
% addpath([pwd,'/AdditionalFuncs']);
% cd('SensitivityAnalysis');

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho f0_Vmax f0_Km fIV_Vmax fIV_K fIV_Km fV_Vmax ...
    fV_K fV_Km cytcred cytcox p_alpha t;
% state variables
r = params.cytcred;
o = 171.0549;
omega = params.Hn;
rho = params.Hp;

%Initialize output parameters
sensitivityOutput.equations = [];
[sensitivityOutput.outputLabels, sensitivityOutput.outputVals] ...
    = deal({});

%define cytcdiff
cytcdiff = cytcox - r;


%% Solve equation system
disp('Differentiating equations and finding sensitivity coefficients...')

dr = 2 * ((f0_Vmax*(cytcdiff))...
    /(f0_Km+(cytcdiff)))*(omega./rho) - 2 * ((fIV_Vmax*o)/(fIV_Km*(1 ...
    +(fIV_K/cytcred))+o))*(omega./rho); %dCytcred
do = -0.5 * ((fIV_Vmax*o)/(fIV_Km*(1+(fIV_K/cytcred))+o))*(omega./rho); %dO2
domega = -6 * ((f0_Vmax*(cytcdiff))...
    /(f0_Km+(cytcdiff)))*(omega./rho) - 4 * ((fIV_Vmax*o)/(fIV_Km*(1 ...
    +(fIV_K/cytcred))+o))*(omega./rho) ...
    +((fV_Vmax.*rho)/(rho+fV_K.*omega+fV_Km)).*rho; %dHn
drho = 8 * ((f0_Vmax*(cytcdiff))...
    /(f0_Km+(cytcdiff)))*(omega./rho) + 2 * ((fIV_Vmax*o)/(fIV_Km*(1 ...
    +(fIV_K/cytcred))+o))*(omega./rho) ...
    -((fV_Vmax.*rho)/(rho+fV_K.*omega+fV_Km)).*rho; %dHp

%define arrays containing all funcs and all params
funcs = [dr,do,domega,drho];
params = [f0_Vmax, f0_Km, fIV_Vmax, fIV_K, fIV_Km, fV_Vmax, fV_K, ...
    fV_Km, cytcred, cytcox, p_alpha, t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);

% normalize the equations by multiplying by reciprocal ratios, e.g.
%dr/df0_Vmax is normalized by multiplying by f0_Vmax/r
normalizingFactors = [params./r; params./o; params./omega; params./rho];
equations = num2cell(jacobianMatrix.*normalizingFactors);
% equations = num2cell(jacobianMatrix);

disp('Generating equations using latin hypercube sampling...');

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(numsims,numel(params));
lhs = bsxfun(@plus,lb,bsxfun(@times,lhsRaw,(ub-lb))); %rescale to fit within bounds
lhsCell = num2cell(lhs); %convert to cell matrix


% create equation label matrix
sensitivityOutput.outputLabels = {'dr/df0_Vmax', 'dr/df0_Km', 'dr/dVmax', 'dr/dKm', ...
    'dr/dK1', 'dr/dfV_Vmax','dr/dfV_K','dr/dfV_Km','dr/dt';'do/df0_Vmax', 'do/df0_Km', 'do/dVmax', ...
    'do/dKm', 'do/dK1', 'do/dfV_Vmax','do/dfV_K','do/dfV_Km','do/dt';'domega/df0_Vmax',  ...
    'domega/df0_Km', 'domega/dVmax', 'domega/dKm', 'domega/dK1', ...
    'domega/dfV_Vmax', 'domega/dfV_K','domega/dfV_Km','domega/dt'};

% create boxplot label matrix
labels = {'Equilibrium Value of Cytochrome C Reduced', ...
    'Equilibrium Value of Oxygen', 'Equilibrium Value of Matrix Protons', ...
    'Equilibrium Value of IMS Protons', 'Sensitivity Coefficient Value for dr/dt', ...
    'Sensitivity Coefficient Value for dr/dt', 'Sensitivity Coefficient Value for dr/dt',...
    'Sensitivity Coefficient Value for dr/dt', 'Sensitivity Coefficient Value for dr/dt',...
    'Sensitivity Coefficient Value for dr/dt', 'Sensitivity Coefficient Value for dr/dt',...
    'Sensitivity Coefficient Value for dr/dt', 'Sensitivity Coefficient Value for dr/dt',...
    'Sensitivity Coefficient Value for do/dt', 'Sensitivity Coefficient Value for do/dt',...
    'Sensitivity Coefficient Value for do/dt', 'Sensitivity Coefficient Value for do/dt',...
    'Sensitivity Coefficient Value for do/dt', 'Sensitivity Coefficient Value for do/dt',...
    'Sensitivity Coefficient Value for do/dt', 'Sensitivity Coefficient Value for do/dt',...
    'Sensitivity Coefficient Value for do/dt', 'Sensitivity Coefficient Value for domega/dt',...
    'Sensitivity Coefficient Value for domega/dt', 'Sensitivity Coefficient Value for domega/dt',...
    'Sensitivity Coefficient Value for domega/dt', 'Sensitivity Coefficient Value for domega/dt',...
    'Sensitivity Coefficient Value for domega/dt', 'Sensitivity Coefficient Value for domega/dt',...
    'Sensitivity Coefficient Value for domega/dt', 'Sensitivity Coefficient Value for domega/dt',...
    'Sensitivity Coefficient Value for drho/dt', 'Sensitivity Coefficient Value for drho/dt',...
    'Sensitivity Coefficient Value for drho/dt', 'Sensitivity Coefficient Value for drho/dt',...
    'Sensitivity Coefficient Value for drho/dt', 'Sensitivity Coefficient Value for drho/dt',...
    'Sensitivity Coefficient Value for drho/dt', 'Sensitivity Coefficient Value for drho/dt',...
    'Sensitivity Coefficient Value for drho/dt'};
modelLabels = {'Final Cytochrome c Reduced Concentration (nmol/mL)', ...
    'Final Oxygen Concentration (nmol/mL)', 'Final Matrix Proton Concentration (nmol/mL)', ...
    'Final IMS Proton Concentration (nmol/mL)'};
sensitivityLabels = repmat({'Sensitivity Coefficient Value'},1,36);
ylab = [modelLabels,sensitivityLabels];

% create file names for saving to png files
filenames = {'cytc','oxygen','matrixprotons','imsprotons',...
    'drdf0_Vmax', 'drdf0_Km', 'drdVmax', 'drdKm', ...
    'drdK1', 'drdfV_Vmax','drdfV_K','drdfV_Km','drdt','dodf0_Vmax', 'dodf0_Km', 'dodVmax', ...
    'dodKm', 'dodK1', 'dodfV_Vmax','dodfV_K','dodfV_Km','dodt','domegadf0_Vmax',  ...
    'domegadf0_Km', 'domegadVmax', 'domegadKm', 'domegadK1', ...
    'domegadfV_Vmax', 'domegadfV_K','domegadfV_Km','domegadt','drhodf0_Vmax',  ...
    'drhodf0_Km', 'drhodVmax', 'drhodKm', 'drhodK1', ...
    'drhodfV_Vmax', 'drhodfV_K','drhodfV_Km','drhodt'};
fullFilename = '';

% convert from symbolic notation and store in structure
sensitivityOutput.equations = vpa(equations);

%% Apply LHS sampling and carry out statistics on results

% move up one folder to the main model
curdir = fileparts(which(mfilename));
cd('..');

% acquire params for the properties of the model
params.timePoints = linspace(0.1,1E4,1E3);
sensitivityOutput.finalVals = [];

disp('Simulating the model and keeping final values of long-time runs...');

for sim=1:numsims
    % convert to cell array to distribute to params
    tempLhs = num2cell(lhs(sim,:));
    [params.ctrlParams.f0_Vmax,params.ctrlParams.f0_Km, ...
        params.ctrlParams.Vmax,params.ctrlParams.K1, ...
        params.ctrlParams.Km,params.ctrlParams.fV_Vmax, ...
        params.ctrlParams.fV_K,params.ctrlParams.fV_Km, ...
        params.ctrlParams.t] = tempLhs{:};
    
    % simulate the system using ode23t
    [~,y] = ode23t(@baselineSystem, params.timePoints, ...
        [params.Cytcred,params.O2,params.Hn, params.Hp], ...
        [],params.ctrlParams);
    
    % store the final value(s)s of each simulation
    sensitivityOutput.finalVals(sim,1:4) = mean(y(end-round(numel(y)*0.1):end,:));
    
    % also use the lhs values to find the values for each
    % sensitivity coefficient
    [f0_Vmax, f0_Km, Vmax, K1, Km, fV_Vmax, fV_K, fV_Km, t] = deal(lhsCell{sim,:}); %set values
    
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
for boxplotnum=1:40
    figure(boxplotnum);
    
    % next turn off figures from popping up
    set(gcf,'Visible','Off');
    
    % create a formatted boxplot for this column
    formatBoxplot(dataMatrix(:,boxplotnum),labels{boxplotnum}, ...
        ylab{boxplotnum});
    
    fullFilename = [curdir,'/Images/',date,filenames{boxplotnum},'-Boxplot'];
    
    % save the boxplot figure to a fig file and a png file
    export_fig(fullFilename);
end