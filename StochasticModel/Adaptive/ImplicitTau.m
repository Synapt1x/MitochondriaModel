function impTau = ImplicitTau(Rjs, V, aj, num_species, X0, gis)
V(V>0) = 0; % zero out all product species
V((Rjs>0), :) = 0; % zero out all critical reactions

means = zeros(1, num_species);
vars = zeros(1, num_species);
epsilon = 0.03;

for (ii = 1: num_species)
    vcol = V(:, ii); % retrieve V values for one species
    vrow = transpose(vcol);
    tempMean = vrow .* aj; % find mean for one species
    tempVar = tempMean .* vrow; % find variance for one species
    means(ii) = sum(tempMean); % store mean for one species in a vector
    vars(ii) = sum(tempVar);  % store variance for one spcies in a vector
end

X0(means==0)=0;
topTerms = (epsilon*X0 ./ gis);
topTerm = max(topTerms);

indexes = find(topTerms==topTerm);
index = indexes(1);
    
% Calculations for the first term
topFirst = topTerm;
bottomFirst = abs(means(index));
firstTerm = topFirst / bottomFirst;

% Calculations for the second term
topSecond = topTerm^2;
bottomSecond = (vars(index))^2;
secondTerm = topSecond / bottomSecond;

bothTerms = [firstTerm secondTerm];

impTau = min(bothTerms); % implicit estimate for tau



    
