#Stochastic Model

## Folders and Branches
This folder houses the stochastic model created for my masters project. The development of this model was heavily assisted
by Ella Thomson.

The explicit folder contains the functions used for the explicit tau leaping procedure.

The adaptive folder contains the functions used for the adaptive tau leaping procedure (which alternates between explicit and implicit tau leaping). This folder also contains the procedures used in the biological experiments and for matlab programming. 

The most up to date branch is ChangeConstants1

## Functions
The main program file is SSATestAdaptiveV2.m. genRj is the function containing a list of parameters and constants for the four mitochondrial reactions. All changes should be made to th constants list (since the parameters were optimized for the deterministic model). 


