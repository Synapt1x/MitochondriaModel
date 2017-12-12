function analyzeResults(OptimalSolutions)
%{
Created by: Chris Cadonic
========================================
As per code generation suggestions in the Qubist manual, this function
can be called by Ferret after analysis to 'automatically post-process'
results. 
In this function, OptimalSolutions is loaded and then it will be saved to
the 'Solutions' folder in the format "Date-OptimalSolutions.mat".
This structure will then be analyzed in the code below to look for the
global best, which will be stored in the variable result. 
%}

%% Initialize vars

% number of general solutions
size_sols = size(OptimalSolutions.X, 2);

%initialize storage variables
bestFit = OptimalSolutions.F(:,1).*inf;
bestSet = struct();
errs = struct();
means = struct();
stds = struct();
all_params = [];
F = Inf(1, size_sols);

top_ten = round(size_sols * 0.10);

[parameters, data, models] = setup;

%% Loop over OptimalSolutions to find Best

% To loop over entire optimal set:
for n=1:size_sols % Number of columns = number of solutions.
    
    %first use bsxfun to check 'greater than' for all elements of bestFit
    %vs. OptimalSolutions.F
    params = OptimalSolutions.X_struct(n);
    F(n)=get_F(params, parameters, data, models);
    
    all_params = [all_params; params];
    
    if F(n) < bestFit + 1E-9
        bestFit = F(n);
        bestSet = OptimalSolutions.X_struct(n);
    end
end

[sorted_F, idx] = sort(F);
top_F_idx = idx(1:top_ten);
top_params = all_params(top_F_idx);

fields = fieldnames(top_params);

for i = 1:numel(fields) - 1
    fieldname = fields{i};
    field_vals = [top_params.(fieldname)];
    stds.(fieldname) = std(field_vals);
    errs.(fieldname) = stds.(fieldname) / sqrt(length(field_vals));
    means.(fieldname) = mean(field_vals);
end

%% Save files to Solutions folder

folder = fileparts(which(mfilename)); %get the current folder
cd([folder '/Solutions']); %change to Solutions folder
todayDate = date; %get the run date

%save the Best solution to the Solutions folder
resultsname = [todayDate '-BestResults'];
save(resultsname,'bestSet','bestFit', 'errs', 'stds', 'means');

%display a message indicating the files will be saved
disp(['Saving output files to ' folder '/Solutions.']);

cd(folder); %change back to original folder