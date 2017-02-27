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

%initialize storage variables
bestFit = OptimalSolutions.F(:,1).*inf;
bestSet = struct();
F = Inf(1, size(OptimalSolutions.X,2));

parameters = setup;

%% Loop over OptimalSolutions to find Best

% To loop over entire optimal set:
for n=1:size(OptimalSolutions.X, 2) % Number of columns = number of solutions.
    
    %first use bsxfun to check 'greater than' for all elements of bestFit
    %vs. OptimalSolutions.F
    F(n)=get_F(OptimalSolutions.X_struct(n), parameters);
    
    if F(n) < bestFit + 1E-9
        bestFit = F(n);
        bestSet = OptimalSolutions.X_struct(n);
    end        
end

%% Save files to Solutions folder

folder = fileparts(which(mfilename)); %get the current folder
cd([folder '/Solutions']); %change to Solutions folder
todayDate = date; %get the run date

%save the Best solution to the Solutions folder
resultsname = [todayDate '-BestResults'];
save(resultsname,'bestSet','bestFit');

%display a message indicating the files will be saved
disp(['Saving output files to ' folder '/Solutions.']);

cd(folder); %change back to original folder