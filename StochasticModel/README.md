#Stochastic Model

## Folders and Branches
This folder houses the stochastic model created for my masters project. The development of this model was heavily assisted
by Ella Thomson. The explicit folder contains the functions used for the explicit tau leaping procedure. The adaptive folder contains the functions used for the adaptive tau leaping procedure (which alternates between explicit and implicit tau leaping). The adaptive folder also contains the procedures used in the biological experiments and for matlab programming. The most up to date branch is ChangeConstants1. Previous versions are in the master branch. 

## Functions
The main program file is SSATestAdaptiveV2.m. 

genRj.m is the function containing a list of parameters and constants for the four mitochondrial reactions. All changes should be made to the constants list (since the parameters were optimized for the deterministic model). 

InitializeParametersMito.m allows the user to change the initial amounts of each species. This function also defines the initial time for the reaction (should be kept at 0) and the change of state vectors for each reaction, which are stored in a matrix. All of the following values are returned to the main program. 

evalCrit.m is used to define the percentage of the initial amount of a species required for that species to be deemed critical. The value should be in the range of 0.5-5%. 

amountChanges.m and amountChangesDouble.m update the amount of each species present after a time change of tau prime or tau double prime, respectively. 

genMeanVar.m calculates and returns an estimate for tau prime, using the explicit method. ImplicitTau.m generates and returns an estimate for tau prime, using the implicit method. 

genTauTwo.m generates and returns an explicit estimate for tau double prime. 

TauAndJGen.m generates a time leap and selects a reactin for each SSA Step.

StepsMeanVarMito.m generates moving averages for plotting and returns the variances for each species amount. 

## User Guide
Open the program SSAAdaptiveV2.m. Set a maximum time for each simulation and the maximum number of simulations by defining the variables max_rx and num_sims. Also set times for oligo_time, fccp_time and rot_aa_time, which must be less than max_rx. These variables indicate the time at which the specified substance is added. For example if oligo_time is 10 seconds, all times less than 10 seconds wil be in the basal state. For each state of the reaction the vector named active needs to be defined to identify which reactions are active in that time period. A 1 indicates that the reaction is active, and a 0 indicates that the reaction is inactive. The if statement to define these vectors begins on line 48. 

Open InitializeParametersMito.m. Define an initial amount of each species using the variable list starting with red_amt. The initial species concentrations should be in the range of 10^17. Identify the number of species and number of reactions using the variables num_rx and num_species. The change of state vector is stored in the variable V. Each row represents one reaction and each column represents one species. Negative numbers mean that the species is a reactant in the reaction (consumed), positive numbers mean that the species is a product of the reaction (produced) and a zero means that the species is not invoved in the reaction (no change in species amount). The initial reaction time is stored in the variable time, and should be kept at 0. 

Open evalCrit.m. Define a percentage required for criticality by changing the nc variable value. The percentage should be defined using decimal form (ex 0.01 is 1%). The range for criticality should be between 0.5-5%. 

Open genRjMito.m. Change the propensity functions (ajs) for each reaction. These are stored in the vector ajs. The parameters in the propensity functions are defined in this function and should be determined through an optimization method. The parameters should be scaled using dimensional analysis. There is also a list of constants (one for each aj), which the user can define. 

To format the plots, change the list of species names in the cells titles and Ylabs. mean_xs_num should also be divided by a constant (in the range of 10^14) to reduce the scale of the y axis for plotting. The subplots in the for loop beginning n line 160 should have enough rows and columns (4 and 2 respectively) to plot each species. The organization and number of rows/columns can be changed on line 261. To format the printing for variances, change the list of species names in the cell varsTitles. If only one simulation is being run, the code for plotting variances should be commented out. 
