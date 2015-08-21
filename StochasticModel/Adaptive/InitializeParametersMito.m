function [time, times, X0, X, num_rx, V, num_species] = InitializeParametersMito()

%{
Initializes the chemical reaction problem by defining an initial time, 
initial quantities of each reactant and the reaction rates of each 
chemical reaction. 
%}

time = 0; % initial time is 0 seconds

times = [0]; % start a vector to hold all times 

red_amt = 1.204 * (10^17); % change back to 10^17
ox_amt = 1.204 * (10^17);
hp_amt = 1.204 * (10^17);
hn_amt = 1.204 * (10^18);
o2_amt = 2.0595 * (10^17)/2;

X0 = [red_amt o2_amt hn_amt hp_amt 1.204*(10^17) 1.204*(10^17) ox_amt 1.204*(10^17)]; % initial amounts of each reactant stored in a vector

X = X0; % used to store amounts of species at all time pts for one sim

num_rx = 4; % the number of different chemical reactions

%V=[2 0 -6 6 -1 1 -2 0;...
 %   -2 -0.5 -2 2 0 0 2 1;...
  %  0 0 1 -1 0 0 0 0;...
   % 0 0 1 -1 0 0 0 0]*(10^12);

% [cytcred O2 HN HP NADH2 NAD+ Cytcox H20]
V = [4 0 -12 12 -1 1 -4 0;...
    -4 -1 -8 4 0 0 4 2;...
    0 0 1 -1 0 0 0 0; ...
    0 0 1 -1 0 0 0 0]... 
    ...
   ...
    * ((10^12)); % v values for all reactions

V(1,:) = V(1,:)*(9.99995*(10^-1));
num_species = 8; % the number of species involved in all reactions
