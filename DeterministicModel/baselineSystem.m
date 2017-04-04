function dy = baselineSystem(t,y,params)
%{
Created by: Chris Cadonic
========================================
This function maintains all the baseline derivatives
relevant to my masters project.

%}

%input all our variables into the state variable y
cytcred = y(1);
O2 = y(2);
Hn = y(3);
Hp = y(4);

%check if any concentrations are negative; if so, then throw an error
if any([cytcred, O2, Hn, Hp] < 0 + 1E-9)
    error('Negative concentrations');
end

%{
To decouple the system, complexes I-III activity is instead
approximated by ((parameters.Vmax.*(cytcdiff))./ ...
(parameters.Km+(cytcdiff))).*(Hn./Hp)

Given this, conservation occurs between NADH and NAD, Succ and
Fum, Q and QH2. Since ((parameters.Vmax.*(cytcdiff))./ ..
(parameters.Km+(cytcdiff))).*(Hn./Hp) approximates BOTH 
forward and reverse we get consumption and production of each
component in these pairs as equivalent. Thus the other substrates
do not change in concentration, and we have their time derivatives
equal to 0.

For the baseline conditions, these are the full equations (without
FCCP terms in dy(3) and dy(4))
Both cytochrome c reduced and omega have been reduced to order
1 due to the constraint that cyt c delivers electrons one at a time

Also, to incorporate all sections of the data, time points will dictate
the set of equations used for the model. 
%}
cytcdiff = params.cytctot - cytcred;

%% Evaluate each mito-complex function
f_0 = ((params.f0_Vmax*(cytcdiff))/(params.f0_Km+(cytcdiff))) ...
        *(Hn./Hp); % complexes I-III
f_4 = ((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*(Hn./Hp); % complex IV
f_5 = ((params.fV_Vmax.*Hp) ...
        /(Hp+params.fV_K.*Hn+params.fV_Km)).*Hp; % ATP Synthase or complex V

%% Solve equation system

dy(1) = 2 * f_0 - 2 * f_4; %dCytcred
dy(2) = -0.5 * f_4; %dO2
dy(3) = -6 * f_0 - 4 * f_4 + f_5; %dHn
dy(4) = 8 * f_0 + 2 * f_4 - f_5; %dHp

dy=dy'; %correct vector orientation

end