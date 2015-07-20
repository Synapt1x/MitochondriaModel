function [mean_xs_num, variances_xs_num, times_plot_num, st_dev_pos, st_dev_neg] = StepsMeanVarMito(times_average, num_species, B)

%{
Calculates the means and variances for all species. Uses intervals dependent on step size (2.5% of the total number of steps) 
Returns the means and variances in matrixes. 
%}

total_num = length(times_average); % find the total number of points
int_num = ceil(0.0025 * total_num); % each inerval is 10% of the total number of points

% vector which defines the indexes for all intervals 
mean_points = 1:int_num:total_num;

% store the times at the above indexes (these will be used as the time
% points for each interval
times_plot_num = times_average(mean_points);

% the number of intervals to be used for mean calculation (steps)
num_pts_size = length(mean_points);

% blank vector to store amounts at each step interval
mean_xs_num = zeros(num_species, num_pts_size);
for xx = 1:num_species-1
    mean_xs_num(xx,1) = B(xx+1, 1);
end
%mean_xs_num(2,1) = x2_average(1);
%mean_xs_num(4,1) = z_average(1); 
%mean_xs_num(5,1) = q_average(1);

% vector to store the current count of the for loop below 
ints_num = [1];
count_num = 1;

% vector to store interval variances for x1 for step intervals
variances_xs_num = zeros(num_species, num_pts_size);

st_dev_pos = zeros(num_species, num_pts_size);
st_dev_neg = zeros(num_species, num_pts_size);

for ints = int_num:int_num:total_num-1 % generates mean and variance for each interval
    count_num = count_num+1; % increment the counter (started at 1)
    ints_num = [ints_num ints];% add th current interval to the list
    
    vector = [];
    for test= 0:num_species-1
        count = test+1;
        temp_par = B(count, ints_num(count_num-1):ints_num(count_num));
        vector= [vector mean(temp_par)];
        %disp('show new')
        %disp(vector)
    end
    %disp(vector)
    mean_xs_num(:,count_num) = vector;
    amt_between = length(mean_xs_num(1,:));
    
    
    
    % calculations for variances
    % the overall variance in each interval is the sum of all variances in
    % that interval. The variances for x1, x2, y and z are calculated
    % separately
    vec_var = [];
    for truev = 1:num_species
        temp_store = sum(((B(truev,count_num) - mean_xs_num(truev,count_num)).^2)./amt_between);
        vec_var = [vec_var temp_store];
    end
    variances_xs_num(:,count_num) = vec_var;
    
    
    
    for st=1:num_species
        st_dev_pos(st, count_num) = mean_xs_num(st, count_num) + sqrt(variances_xs_num(1,count_num));
        st_dev_neg(st, count_num) = mean_xs_num(st, count_num) - sqrt(variances_xs_num(1,count_num));
    end
    
   
end

st_dev_pos(:,1) = st_dev_pos(:,2);
st_dev_neg(:,1) = st_dev_neg(:,2); 
