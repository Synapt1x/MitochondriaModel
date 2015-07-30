function [Rjs, aj, a_0] = genRjMito (X0, V, nc, numRxns, active)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates Ls values for each reaction in order to determine whether the
% reaction is critical. If there are critical reactions, the function
% outputs a variable that tells the main program to call the tau generation
% function for critical reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the minimum value of lj for rj to be considered a critical reaction. This
% can be a whole number between 2-20. It's usually equal to 10


species1 = abs(X0(1)); % cytcred
species2 = abs(X0(2)); % O2
species3 = abs(X0(3)); % HN+
species4 = abs(X0(4)); % Hp
species5 = abs(X0(5)); % NADH2
species6 = abs(X0(6)); % NAD+
species7 = abs(X0(7)); % Cytcox
species8 = abs(X0(8)); % H20

% parameters list

vmax = 6.02*(10^14)*2*2.1236;
k1 = 100.1019;
km= 101.2983;
p1=2*6.02*(10^14)*10.8150;
p2=99.3193;
p3=2*6.02*(10^14)*7.5784*(10^-4);
f0= 2*6.02*(10^14)*95.3875;
p4=0.1885;

c1=10^-3;
c2=10^-2;
c3=10^-35;
c4=10^-4;

% find ajs for each reaction and store in a vector. These need to be
% changes based on the reactions defined in initializeParameters. Each aj
% is the partial derivative of that reaction

ajs = abs([c1*(f0)*species3/species4,...
     (c2*(vmax*species2)/((km*(1+(k1/species1)))+species2))*(species3/species4),...
     (c3*species4*((p1*(species4/(species3)))/((species4/(species3))+p2+(p3/(species3))))),...
     (c4*p4*((species4-species3)+(species4*log(species4/(species3)))))]);
aj = ajs.*active; % remove inactive reactions 

a_0 = sum(aj); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check_elements is used to keep track of which elements in the matrix v
% will need to be check to determine whether they are critical. If an aj is
% negative the entire row for that reaction will be zeroed. If Vij is
% positive, then the one element will be zeroed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ljs = zeros(1,4); % define a blank vector to store Lj for each reaction

% If Rj for a reaction is 1, it means that that reaction is critical. If Rj
% is 0 for a reaction, it means that that reaction is not critical. Rj will
% be an input to other functions
Rjs = zeros(1,4); % define a blank vector to store Rj for each reaction

check_rxns = aj>0; % Only reactions with positive ajs will be checked
%check_elements = V <0; % Only species that are reactants will be checked

for check = 1:numRxns % loop that generates an Lj for each reaction 
    if check_rxns(check) ==1 % check if aj for reaction is positive
        %check_els = check_elements(check, :); % row of which elements to check
        Vls = V(check, :); % extract the V values for the reaction
        check_els = find(Vls<0);
        XL = X0(check_els); % get the current amounts of each species
        VL = Vls(check_els); % determines which species are reactants
        possLs = min(XL./VL); 
        Ljs(check) = abs(possLs);
    else
        Ljs(check) = nc+1; % if aj is not positive, reaction is not critical
    end
end

% a reaction is critical if its Lj value is less than a predetermined
% amount. This amount is calculated in the genCrit function, based on the
% initial amount of each species, but can be changed. 

Rjs = single(Ljs < nc); 


