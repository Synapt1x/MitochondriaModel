function tau_double_prime = genTauDoublePrime (aj, Rj)
inds = find(Rj); % find all critical reactions (ones in the vector)
aco = sum(aj(inds)); % sum the ajs for all crticial reactions

mean_dis = -1/ aco; % mean distribution for exponential variate distribution

tau_double_prime = mean_dis * log(rand); % generate a tau double prime 
