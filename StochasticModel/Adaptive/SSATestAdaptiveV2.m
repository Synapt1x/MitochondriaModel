function SSATestAdaptiveV2
tic

%{
Programmed by: Ella Thomson
Tracks the changes in amounts of three chemical reactants involved in
three chemical reactions. The reactions occur at randomly distributed
times. The program plots the quantities of all three substances vs time.
It produces two plots; one figure with each substance on its own plot,
and one figure with all three substances on the same plot.
%}

% user chooses how many simulations to run
num_sims = 1;

% user chooses the maximum time for each simulation
max_rx = 10;

% interval used for plotting means and calculating variance 
interval = 0.01 * max_rx;
tau_prime = 0;

all_values = [];

%disp('Current Simulation Number')


% define time intervals for the various substrates. Befre oligo time, thre
% is basal respiration
oligo_time = max_rx/4; % oligomycin is added at oligo time
fccp_time = 2*(max_rx/4); % FCCP is added at fccp time
rot_aa_time = 3*(max_rx/4);  % rotenone and antimycin a are addedat rot aa time


for n = 1:num_sims % loop through all simulations. Plot after each sim
    
    count = 0; % start each simulation with reaction time = 0
    
    % call intialize parameters to define ititial time and concentrations
    [time, times, X0, X, num_rx, V, num_species] = InitializeParametersMito ();
    
    
    % nc is the maximum amount of a reactant before reaction is critical
    nc = evalCrit(X0);
    
    while count <=max_rx; % loop through tau steps until max time is reached
        
        disp(count)
        if count<oligo_time % determines which reactions are active in the time interval
            vv = [1 1 1 0];
        elseif count<fccp_time
            vv=[1 1 0 0];
        elseif count<rot_aa_time
            vv = [1 1 0 1];
        else
            vv = [0 1 0 1];
        end
        
        % identify all critical reactions
        [Rjs, aj, a_0] = genRjMito (X(end,:), V,nc, num_rx, vv);
        
        % epsilon value for each species
        [eis, gis] = genEisMito (0.05, V, X, num_species, num_rx);
        
        % generate explicit tau `
        [tau_prime] = genMeanVar (Rjs, V, X0, eis, gis, tau_prime, aj, a_0, num_species);
        
        % generate implicit tau
        [impTau] = ImplicitTau(Rjs, V, aj, num_species, X0, gis);
        
        
        
        % check for stiffness of the system (if stiff, choose implicit tau)
        if impTau > 100*tau_prime
            tau_one = impTau;
            implicit = 1;
        else
            tau_one = tau_prime;
            implicit = 0;
        end
        
        
        
        
        % comparison for the bound of tau
        compare = abs(5 * (1/a_0));
        
        if abs(tau_one) < compare % check for tau estimate meeting minimum criteria
            % generate 100 individual SSA steps
            ssaSteps=1;
            
            while ssaSteps <= 5 % loop through a limited number of SSA steps
                if count <=(max_rx-0.5) % check to ensure max time is not being reached
                    [tau, j] = TauAndJGen (aj);
                    time = time + abs(tau); % find new time by adding tau to previous time
                    if time >max_rx
                        time=max_rx+0.1;
                    end
                    times = [times time]; % add new time to list of times
                    Vj = V(j,:); % retrieve V values for the selected reaction
                    X0 = X0 + Vj; % get new X0 value
                    % if species amount is less than 0, correct it
                    b = find(X0<0);
                    X0(b) = 0;
                    X = [X; X0]; % store all X values in a matrix
                    %if time <= max_rx
                    count = time;
                    ssaSteps = ssaSteps+1;
                    
                else
                    % do nothing
                    count = max_rx+0.1;
                    ssaSteps=6;
                end
            end
            
            
            
        else
            % generate a second estimate for tau
            [tau_two] = genTauTwo(aj, Rjs, tau_one);
            if tau_two <= 1e-8
                tau_two = (10^12)* tau_two;
            end
            if tau_two > 1
                tau_two = tau_two/1000;
            end
            if tau_one < 10^-6
            tau_one = tau_one * (10^12);
            end
            pos_neg_count = -1;
           % while (pos_neg_count <0)
                
                % generate changes to species amounts from reactions during tau
                if abs(tau_one) < tau_two
                    tau = abs(tau_one);
                    % amount each species changes if tau is tau one
                    if (implicit == 1) % using implicit formula
                        [X0] = amountChanges(X0, aj, V, num_rx, tau, Rjs);
                       % [X0] = ImplicitXX(X, V, X0, tau, num_rx);
                        time = time + tau; % find new time by adding tau to previous time
                    else % using explicit formula
                        [X0] = amountChanges(X0, aj, V, num_rx, tau, Rjs);
                    end
                    
                    time = time+tau;
                    if time > max_rx % ensure time does not reach maximum time
                        time = max_rx +0.1;
                    end
                    times = [times time]; % add new time to list of times
                    X = [X; X0]; % store all X values in a matrix
                    prev = count;
                    count = time; % increment number of reactions
                    
                    
                    
                    
                    
                    
                else
                    tau = abs(tau_two);
                    % amount each species changes if tau is tau double prime
                    % (only one critical reaction can occur)
                    if (implicit ==1) % calculations for implicit
                        [X0] = amountChangesDouble(X0, aj, V, tau, Rjs, num_rx);
                        %[X0] = ImplicitXX(X, V, X0, tau, num_rx);
                    else % calculations for explicit
                        [X0] = amountChangesDouble(X0, aj, V, tau, Rjs, num_rx);
                    end
                    time = time + tau; % find new time by adding tau to previous time
                    % if time is greater than the max time, correct it
                    if time > max_rx
                        time = max_rx+0.1;
                    end
                    times = [times time]; % add new time to list of times
                    % if species amount is less than 0, correct it
                    %b = find(X0<0);
                    %X0(b) = 0;
                    X = [X; X0]; % store all X values in a matrix
                    count = time; % increment number of reactions
                end
                
        end
    
        
    end
    
    
    
    
    % all species amounts for one simulation
    XX = transpose(X);
    
    
    % store all times and species amounts for one simulations
    all_values_sim = [times; XX];
    all_values = [all_values all_values_sim];
    
    %disp(all_values_sim)
    
    % store all times and species amounts for all simulations
    all_value_sim = [];
    
    % print the current simulation number (can be removed)
    
    %disp(n)
    
end


topcol = all_values(1,:);
col = find(isnan(topcol));
all_values(:,col)=[];


% put all times and corresponding species amounts in ascending order
[~,I]=sort(all_values(1,:));
B=all_values(:,I);

times_average = B(1,:); % extract row with all times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculations and plotting for moving average (mean) with number of points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[mean_xs_num, variances_xs_num, times_plot_num, st_dev_pos, st_dev_neg] = StepsMeanVarMito(times_average,...
    num_species, B);

lena = length(times_plot_num);
lenb= length(mean_xs_num(1,:));

if lena~=lenb
    num_to_add = lenb-lena;
    for nn = 1:num_to_add
        times_plot_num(lena+nn) = times_plot_num(lena+nn-1) +0.01;
    end
end

mean_xs_num = (mean_xs_num/(6.02*(10^14)));
st_dev_pos = st_dev_pos/(6.02*(10^14));
st_dev_neg = st_dev_neg/(6.02*(10^14));
figure(1)

disp(mean_xs_num)
colours = {'b', 'g', 'c', 'r', 'm', 'b', 'g', 'c'};
titles = {'Cyt C Red', 'O2', 'HN', 'HP', 'NADH2', 'NAD+', 'Cyt C Ox', 'H2O'};
Ylabs = {'Cyt C Red', 'O2', 'HN', 'HP', 'NADH2', 'NAD+', 'Cyt C OX', 'H2O'};

for pl = 1:num_species
    subplot(4,2,pl)
    %plot(times_plot_num, st_dev_pos(pl,:), colours{pl}) % plots all points from all simulations
    %hold on
    plot(times_plot_num, mean_xs_num(pl,:), 'k', 'LineWidth', 3) % plots mean point in each steps interval
    %hold on
    %plot(times_plot_num, st_dev_neg(pl,:), colours{pl})
    %hold on
    title(titles{pl})
    xlabel('Time')
    ylabel(Ylabs{pl})
    axis([0 inf 0 inf])
    hold on
end

%varsTitles ={'Cyt C Red Variance', 'O2 Variance', 'HN Variance', 'HP Variance', ...
   % 'NADH2 Variance', 'NAD+ Variance', 'Cyt C Ox Variance', 'H2O Variance'};

%for varct = 1:num_species
  %  disp(varsTitles{varct})
   % disp(mean(variances_xs_num(varct,:)))
%end

toc
