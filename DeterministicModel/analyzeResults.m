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
global best, which will be stored in the global variable myResults. 
%}

%% Initialize vars

global myResults; %global variable for storing the best parameter set
global bestFit; %global variable for storing the best fit

[X,F(1),F(2)] = deal(inf); %initialize storage variables

%% Loop over OptimalSolutions to find Best

% To loop over entire optimal set:
for n=1:size(OptimalSolutions.X, 2) % Number of columns = number of solutions.
    if OptimalSolutions.F(1,n)<F(1) && OptimalSolutions.F(2,n)<F(2)
        X=OptimalSolutions.X(:,n);
        F=OptimalSolutions.F(:,n);
    end
end
myResults = X;
bestFit = F;

%% Save files to Solutions folder

folder = fileparts(which(mfilename)); %get the current folder
cd([folder '/Solutions']); %change to Solutions folder
todayDate = date; %get the run date

%save the optimal solutions to the Solutions folder
filename = [todayDate '-OptimalSolutions'];
save(filename, 'OptimalSolutions');

%save the Best solution to the Solutions folder
resultsname = [todayDate '-BestResults'];
save(resultsname,'myResults','bestFit');

%display a message indicating the files will be saved
disp(['Saving output files to ' folder '/Solutions.']);

cd(folder); %change back to original folder


