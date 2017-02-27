function y = ramp_func(t, t_start, t_end)
%{
========================================
Created by: Chris Cadonic
For: Mitochondrial Model
========================================
This is a ramp function created for introducing a 
gradually increasing amount of FCCP into the system.

This ramp function will take in a t value, and check
whether it exists on the ramp range defined by
[t_start, t_end]. It will then introduce a linear
gradation on this ramp range where y = [0, 1].
%}

n = size(t,2);
y = zeros(1, n);

for i=1:1:n
    if (t(i) >= t_start) && (t(i) <= t_end)
        y(i) = (t(i) - t_start)/(t_end - t_start);
    else
        y(i) = 1;
    end
end