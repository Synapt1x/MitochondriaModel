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
myResults = inf; 
bestFit = OptimalSolutions.F(:,1).*inf; 

%% Loop over OptimalSolutions to find Best

% To loop over entire optimal set:
for n=1:size(OptimalSolutions.X, 2) % Number of columns = number of solutions.
    
    %first use bsxfun to check 'greater than' for all elements of bestFit
    %vs. OptimalSolutions.F
    checkSize = bsxfun(@gt,bestFit,OptimalSolutions.F(:,n));
    
    if all(checkSize) %if current best is greater than optimal then replace bestFit
                              %all is used to check to see if all F-values are less than best
        myResults=OptimalSolutions.X(:,n);
        bestFit=OptimalSolutions.F(:,n);
        myResults = checkResult(myResults);
    end
end

%% Save files to Solutions folder

folder = fileparts(which(mfilename)); %get the current folder
cd([folder '/Solutions']); %change to Solutions folder
todayDate = date; %get the run date

%save the Best solution to the Solutions folder
resultsname = [todayDate '-BestResults'];
save(resultsname,'myResults','bestFit');

%display a message indicating the files will be saved
disp(['Saving output files to ' folder '/Solutions.']);

cd(folder); %change back to original folder

function trueResults = checkResult(myResults)
   
    %load baseline parameters and get all parameter names
    parameters = setup;
    parameterNames = fieldnames(parameters.ctrlParams);
    params = parameters.ctrlParams;
    
    %loop through each parameter
    for param=1:11
        name = parameterNames{param};
        params = setfield(params,name,myResults(param));
    end
    
    % update parameters using the values in params
    parameters.Cytcred = params.cytcred;
    parameters.Cytcox = params.cytcox;
    parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;
    parameters.Hn = params.omega;
    parameters.Hp = params.rho;
    parameters.O2 = params.oxygen;
    params.Cytctot = params.cytcred+params.cytcox;
    
    try
        %try to solve the model using this parameter set
        [t,y] = solver(parameters,params);
        trueResults = myResults;
    catch
        %if it's not good, then reset the myResults
        trueResults = inf;
    end    
