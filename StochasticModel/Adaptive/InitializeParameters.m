function [time, times, X0, X, num_rx, V, num_species] = InitializeParameters()

%{
Initializes the chemical reaction problem by defining an initial time, 
initial quantities of each reactant and the reaction rates of each 
chemical reaction. 
%}

time = 0; % initial time is 0 seconds

times = [0]; % start a vector to hold all times 

X0 = [400 400 400 400 400 400 400 400]; % initial amounts of each reactant stored in a vector

X = X0; % used to store amounts of species at all time pts for one sim

num_rx = 4; % the number of different chemical reactions

% [cytcred O2 HN HP NADH2 NAD+ Cytcox H20]
V = [4 0 -12 12 -1 1 -4 0; -4 -1 -8 4 0 0 4 2; 0 0 1 -1 0 0 0 0; 0 0 1 -1 0 0 0 0]; % v values for all reactions

num_species = 8; % the number of species involved in all reactions
