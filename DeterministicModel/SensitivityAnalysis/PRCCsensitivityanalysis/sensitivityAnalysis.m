function sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function houses code for using symbolic variables to represent
functions in my deterministic model. This function will be essential
to conducting sensitivity analysis for my mitochondrial model by finding
the Jacobian of the set of equations in my model. This will be done
using the symbolic functions for each equation in my model as
carried out below.
This will be carrying out sensitivty analysis for the baseline system.
%}

%% Create LHS sampling and Sensitivity Coefficients

%%%%%%%%%%%%%%%%%%%%%%%% define parameters for run %%%%%%%%%%%%%%%%%%%%%%%%

numsims = 1E3;
max_t = 1E3;
% lower bounds for params
lb = [1E5, 1, ... %f0
    1E6, 1E5, 1E5, ... %fIV
    1E5, 100, 1E5, ... %fV
    1E3, 1E3, 0.05, 1E-3, 1E-3, 1E-3, 1E-3, 0.05];
    % last row: r0, ox0, leak, amp1-4, attenuate
% upper bounds for params
ub = [1E6, 50, ... %f0
    1E7, 1E6, 1E6, ... %fIV
    1E6, 5E2, 1E6, ... %fV
    5E3, 5E3, 1.0, 5E-3, 5E-3, 5E-3, 5E-3, 1.0];
    % last row: r0, ox0, leak, amp1-4, attenuate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear cmd history for clarity
clc

% store the current directory and move up to acquire model information
curdir = fileparts(which(mfilename));
cd(['..',filesep,'..']);

% acquire initial setup data for the model
[all_params, data, models] = setup;
params = all_params.ctrlParams;

cd(curdir);

% Add export_fig function to path for boxplot figures
% cd(['..' ,filesep, '..']);
% addpath([pwd,'/AdditionalFuncs']);
% cd('SensitivityAnalysis');

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho t f0_Vmax f0_Km fIV_Vmax fIV_K fIV_Km fV_Vmax ...
    fV_K fV_Km r0 ox0 p_leak amp_1 amp_2 amp_3 amp_4 r_attenuate;
parameters = [f0_Vmax, f0_Km, fIV_Vmax, fIV_K, fIV_Km, fV_Vmax, ...
    fV_K, fV_Km, r0, ox0, p_leak, amp_1, amp_2, amp_3, amp_4, r_attenuate];
% state variables
r = params.cytcred;
o = 171.0549;
omega = all_params.Hn;
rho = all_params.Hp;

%Initialize output parameters
sensitivityOutput.equations = [];
[sensitivityOutput.outputLabels, sensitivityOutput.outputVals] ...
    = deal({});

%define cytcdiff
cytcdiff = ox0 - r;

%% Solve equation system
disp('Differentiating equations and finding sensitivity coefficients...')

%% Solve equation system
%% =================== FULL SYSTEM ONLINE ==================== %%
f_0 = ((f0_Vmax*(cytcdiff))/(f0_Km+(cytcdiff))) ...
        *(omega./rho); % complexes I-III
f_4 = ((fIV_Vmax*o)/(fIV_Km*(1 ...
        +(fIV_K/r))+o))*(omega./rho); % complex IV
f_5 = ((fV_Vmax.*rho)/(rho+fV_K.*omega+fV_Km)); % ATP Synthase
f_leak = p_leak * (sqrt((rho.^3) ./ omega) ...
    - sqrt((omega.^3) ./ rho)); % leak

% step for oligomycin injection
step_oligo = 1 - heaviside(t - params.oligo_t);

% steps for gradual FCCP injection
step_1 = amp_1 * (heaviside(t - params.fccp_25_t) ...
    - heaviside(t - params.fccp_50_t));
step_2 = amp_2 * (heaviside(t - params.fccp_50_t) ...
    - heaviside(t - params.fccp_75_t));
step_3 = amp_3 * (heaviside(t - params.fccp_75_t) ...
    - heaviside(t - params.fccp_100_t));
step_4 = amp_4 * heaviside(t - params.fccp_100_t);

% step for injecting AA/rotenone
step_inhibit = 1 - heaviside(t - params.inhibit_t);

%% Solve equation system

dr = 2 * step_inhibit * f_0 - 2 * f_4; %dCytcred
do = -0.5 * f_4; %dO2
domega = -6 * step_inhibit * f_0 - 4 * f_4 + step_oligo * f_5 ...
    + (1 + (step_1 + step_2 + step_3 + step_4) * params.p_fccp) * f_leak; %dHn
drho = 8 * step_inhibit * f_0 + 2 * f_4 - step_oligo * f_5 ...
    - (1 + (step_1 + step_2 + step_3 + step_4) * params.p_fccp) * f_leak;

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(numsims, numel(parameters));
lhs = bsxfun(@plus, lb, bsxfun(@times, lhsRaw, (ub-lb))); % rescale
lhsCell = num2cell(lhs);  % convert to cell matrix



%% OLD============================================================ %%

%{
%define arrays containing all funcs and all params
funcs = [dr,do,domega,drho];
parameters = [f0_Vmax, f0_Km, fIV_Vmax, fIV_K, fIV_Km, fV_Vmax, fV_K, ...
    fV_Km, cytcred, cytcox, p_alpha, p_fccp, t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,parameters);

% normalize the equations by multiplying by reciprocal ratios, e.g.
%dr/df0_Vmax is normalized by multiplying by f0_Vmax/r
normalizingFactors = [parameters./r; parameters./o; parameters./omega; ...
    parameters./rho];
equations = num2cell(jacobianMatrix.*normalizingFactors);
% equations = num2cell(jacobianMatrix); % non normalized

disp('Generating equations using latin hypercube sampling...');

% create the sampling pool using latin hypercube sampling
lhsRaw = lhsdesign(numsims,numel(parameters));
lhs = bsxfun(@plus,lb,bsxfun(@times,lhsRaw,(ub-lb))); %rescale to fit within bounds
lhsCell = num2cell(lhs); %convert to cell matrix

% create equation label matrix
sensitivityOutput.outputLabels = {
    'dr/df0_Vmax', 'dr/df0_Km', 'dr/dfIV_Vmax', 'dr/dfIV_K', ...
    'dr/dfIV_Km', 'dr/dfV_Vmax','dr/dfV_K', 'dr/dfV_Km', ...
    'dr/dcytcred', 'dr/dcytcox', 'dr/dp_alpha', 'dr/dp_fccp', 'dr/dt'; ...
    'do/df0_Vmax', 'do/df0_Km', 'do/dfIV_Vmax', 'do/dfIV_K', ...
    'do/dfIV_Km', 'do/dfV_Vmax','do/dfV_K','do/dfV_Km', ...
    'do/dcytcred', 'do/dcytcox', 'do/dp_alpha', 'dr/dp_fccp', 'do/dt'; ...
    'domega/df0_Vmax', 'domega/df0_Km', 'domega/dfIV_Vmax', 'domega/dfV_K', ...
    'domega/dfIV_Km', 'domega/dfV_Vmax', 'domega/dfV_K','domega/dfV_Km', ...
    'domega/dcytcred', 'domega/dcytcox', 'domega/dp_alpha', ...
    'domega/dp_fccp', 'domega/dt'; ...
    'drho/df0_Vmax', 'drho/df0_Km', 'drho/dfIV_Vmax', 'drho/dfIV_K', ...
    'drho/dfIV_Km', 'drho/dfV_Vmax', 'drho/dfV_K', 'drho/fV_Km', ...
    'drho/dcytcred', 'drho/dcytcox', 'drho/dp_alpha', 'drho/dp_fccp', ...
    'drho/dt'}';

% create boxplot label matrix
modelLabels = {'Cyt c red', 'Oxygen', 'Hn', 'Hp'};
sensitivityLabels = repmat({'Sensitivity Coefficient Value'},1,4);
titles = {'Final Concentrations for Each State Variable', ...
    'Sensitivity Coefficients for dr', ...
    'Sensitivity Coefficients for do', ...
    'Sensitivity Coefficients for domega', ...
    'Sensitivity Coefficients for drho'};

% create file names for saving to png files
filenames = {'Statevar_concentrations', 'drSensitivities', ...
    'doSensitivities', 'domegaSensitivities', 'drhoSensitivities'};
fullFilename = '';

% convert from symbolic notation and store in structure
sensitivityOutput.equations = vpa(equations);

%% Apply LHS sampling and carry out statistics on results

% move up to the main model
cd(['..',filesep,'..']);
addpath(genpath([params.curdir, filesep, 'ModelEquations']));

% acquire params for the properties of the model
params.timePoints = linspace(0.1,max_t,1E3);
sensitivityOutput.finalVals = [];

disp('Simulating the model and keeping final values of long-time runs...');

for sim=1:numsims
    % convert to cell array to distribute to params
    tempLhs = num2cell(lhs(sim,:));
    [params.ctrlParams.f0_Vmax,params.ctrlParams.f0_Km, ...
        params.ctrlParams.fIV_Vmax,params.ctrlParams.fIV_K, ...
        params.ctrlParams.fIV_Km,params.ctrlParams.fV_Vmax, ...
        params.ctrlParams.fV_K,params.ctrlParams.fV_Km, ...
        params.ctrlParams.cytcred, params.ctrlParams.cytcox, ...
        params.ctrlParams.p_alpha, params.ctrlParams.p_fccp, ...
        params.ctrlParams.t] = tempLhs{:};
    
    % simulate the system using ode23t
    [~,y] = ode23t(@baselineSystem, params.timePoints, ...
        [params.cytcred,params.O2,params.Hn, params.Hp], ...
        [],params.ctrlParams);
    
    % store the final value(s)s of each simulation
    sensitivityOutput.finalVals(sim,1:4) = mean(y(end-round(numel(y)*0.1):end,:));
    
    % also use the lhs values to find the values for each
    % sensitivity coefficient
    [f0_Vmax, f0_Km, fIV_Vmax, fIV_K, fIV_Km, fV_Vmax, fV_K, fV_Km, ...
        cytcred, cytcox, p_alpha, p_fccp, t] = deal(lhsCell{sim,:}); %set values
    
    for eqNum=1:numel(equations) % evaluate each equation with this value set
        sensitivityOutput.finalVals(sim,eqNum+4) = subs(equations{eqNum});
    end
end

%change back to sensitivity analysis folder
cd(curdir)

% store value matrix in a regular matrix outside of struc
dataMatrix = sensitivityOutput.finalVals;

%% Compute statistics
% create box plots, one for each substrate in simulation and one for each
% equation provided for the sensitivity analysis
first_fig = figure(1);

formatBoxplot(dataMatrix(:, 1:4), modelLabels, ...
    'Final Concentration (nmol/mL)', ...
    titles{1});

fullFilename = [curdir, filesep, 'Images', filesep, date, filenames{1}];

% save the boxplot figures to a fig file and a png file
savefig(fullFilename)
saveas(first_fig, fullFilename, 'png');

for figurenum=2:5
    curfig = figure(figurenum);
        
    small_range = [13*(figurenum-2) + 1:13*(figurenum-2) + 13];
    data_range = small_range + 4;

    % create a formatted boxplot for this column
    formatBoxplot(dataMatrix(:, data_range), ...
        {sensitivityOutput.outputLabels{small_range}}, ...
        sensitivityLabels{figurenum}, titles{figurenum});

    fullFilename = [curdir,'/Images/',date,filenames{figurenum},'-Boxplot'];
    
    % turn off figures from popping up
    set(gcf,'Visible','Off');
    
    % save the boxplot figure to a fig file and a png file
    savefig(fullFilename);
    saveas(curfig, fullFilename, 'png');
    
    close all;
end
%}