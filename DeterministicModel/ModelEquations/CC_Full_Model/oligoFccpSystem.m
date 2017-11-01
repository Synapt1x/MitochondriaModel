function dydt = oligoFccpSystem(t,y,params)
%{
Created by: Chris Cadonic
========================================
This function maintains all the baseline derivatives
relevant to my masters project.

%}

% step for injecting AA/rotenone inhibiting cyt c production
%if t >= params.inhibit_t
%    y(1) = 0;

%input all our variables into the state variable y
cytcred = y(1);
O2 = y(2);
Hn = y(3);
Hp = y(4);

% if any([cytcred < 0, O2 < 0, Hn < 0, Hp < 0])
%     error('Negative concentration.')
% end

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
        /(Hp+params.fV_K.*Hn+params.fV_Km)); % ATP Synthase or complex V
f_leak = params.p_alpha * (sqrt((Hp.^3) ./ Hn) - sqrt((Hn.^3) ./ Hp)); % leak

% step for oligomycin injection
step_oligo = 1 - heaviside(t - params.oligo_t);

% steps for gradual FCCP injection
step_1 = params.amp_1 * (heaviside(t - params.fccp_25_t) ...
    - heaviside(t - params.fccp_50_t));
step_2 = params.amp_2 * (heaviside(t - params.fccp_50_t) ...
    - heaviside(t - params.fccp_75_t));
step_3 = params.amp_3 * (heaviside(t - params.fccp_75_t) ...
    - heaviside(t - params.fccp_100_t));
step_4 = params.amp_4 * heaviside(t - params.fccp_100_t);

%% Solve equation system

dydt(1) = 2 * f_0 - 2 * f_4; %dCytcred
dydt(2) = -0.5 * f_4; %dO2
dydt(3) = -6 * f_0 - 4 * f_4 + step_oligo * f_5 ...
    + (step_1 + step_2 + step_3 + step_4) * (1 + params.p_fccp) * f_leak; %dHn
dydt(4) = 8 * f_0 + 2 * f_4 - step_oligo * f_5 ...
    - (step_1 + step_2 + step_3 + step_4) * (1 + params.p_fccp) * f_leak; %dHp

dydt=dydt'; %correct vector orientation

end