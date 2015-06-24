function tau_double_prime = genTauTwo (aj, Rj, varargin)
inds = find(Rj); % find all critical reactions (ones in the vector)
aco = sum(aj(inds)); % sum the ajs for all crticial reactions

if aco==0
    tau_double_prime = varargin+1;
else
    mean_dis = -1/ aco; % mean distribution for exponential variate distribution

    tau_double_prime = mean_dis * log(rand); % generate a tau double prime 
end