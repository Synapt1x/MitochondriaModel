#Stochastic Model

## Folders and Branches
This folder houses the stochastic model created for my masters project. The development of this model was heavily assisted
by Ella Thomson.

The explicit folder contains the functions used for the explicit tau leaping procedure.

The adaptive folder contains the functions used for the adaptive tau leaping procedure (which alternates between explicit and implicit tau leaping). This folder also contains the procedures used in the biological experiments and for matlab programming. 

The most up to date branch is ChangeConstants1

## Functions
The main program file is SSATestAdaptiveV2.m. 

genRj.m is the function containing a list of parameters and constants for the four mitochondrial reactions. All changes should be made to th constants list (since the parameters were optimized for the deterministic model). 

InitializeParametersMito.m allows the user to change the initial amounts of each species. This function also defines the initial time for the reaction (should be kept at 0) and the change of state vectors for each reaction, which are stored in a matrix. All of the following values are returned to the main program. 

evalCrit.m is used to define the percentage of the initial amount of a species required for that species to be deemed critical. The value should be in the range of 0.5-5%. 

amountChanges.m and amountChangesDouble.m update the amount of each species present after a time change of tau prime or tau double prime, respectively. 

genMeanVar.m calculates and returns an estimate for tau prime, using the explicit method. ImplicitTau.m generates and returns an estimate for tau prime, using the implicit method. 

genTauDoublePrime.m generates and returns an explicit estimate for tau double prime. 

TauAndJGen.m generates a time leap and selects a reactin for each SSA Step.

## User Guide
Open the program SSAAdaptiveV2.m. Set a maximum time for each simulation and the maximum number of simulations by defining the variables max_rx and num_sims. Also set times for oligo_time, fccp_time and rot_aa_time, which must be less than max_rx. These variables indicate the time at which the specified substance is added. For example if oligo_time is 10 seconds, all times less than 10 seconds wil be in the basal state. For each state of the reaction the vector named active needs to be defined to identify which reactions are active in that time period. A 1 indicates that the reaction is active, and a 0 indicates that the reaction is inactive. The if statement to define these vectors begins on line 48. 

Open InitializeParametersMito.m. Define an initial amount of each species using the variable list starting with red_amt. Identify the number of species and number of reactions using the variables num_rx and num_species. The change of state vector is stored in the variable V. Each row represents one reaction and each column represents 1 species. 

Open evalCrit.m. Define a percentage required for criticality by changing the nc variable value. The percentage should be defined using decimal form (ex 0.01 is 1%). 

Open genRjMito.m. Change the propensity functions (ajs) for each reaction. These are stored in the vector ajs. The parameters in the propensity functions are defined in this function and should be determined through an optimization method. There is also a list of consants (one for each aj) which the user can define. 
