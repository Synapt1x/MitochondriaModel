function testEquations()
    %{
    Created by: Chris Cadonic
    ========================================
    This function houses a unit test for testing equations to make sure 
    that the model equations output match manually computed output for 
    certain sets of input conditions.
    %}

%% Initialization

[parameters, data, models] = setup(); %run the setup function which creates the
%structure storing all variables necessary
%for the model (found in 'setup.m')

test_cases = [];

%% Test case 1
% Test validitiy for inputs t and y
test_one = struct();


