##Overview
The Gillespie algorithm for stochastic simulation (SSA) was implemented using Matlab 2014a. The basic SSA program was initially
programmed, followed by explicit tau-leaping, and adaptive tau leaping. 

##Basic SSA Steps
#Overview
The basic SSA algorithm calculated a series of time steps (tau leaps), using poisson distributed random numbers. For each tau leap, one reaction is selected and the amounts of each species are update according to that reactions state change vector. 

#Initialization
The number of molecules of each species was initialized. The state change vector of each reaction was defined, with reactant species having a negative state change, and product species having a positive state change. The reaction constants and propensity functions for each reaction were also defined. A maximum time for the reaction was identified. 

#Monte Carlo Step
A poisson distributed random number was generated for each reaction. The random numbers were then used to generate a time leap (tau) estimate for each reaction. Tau was calculated as tau = 1/aj * log (1/rand). The reaction which generated the minimum tau value was selected. 

#Update
The selected tau was added to the previous time to generate a new time step. The species amounts were updated according to the propensity function of the reaction selected from the monte carlo step.

#Iteration
The monte carlo step and update werre repeated until the maximum time has been reached. 

