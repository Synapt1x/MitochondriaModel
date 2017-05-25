function dydt = inhibitSystem_MP(t,y,params)
%{
Created by: Chris Cadonic
========================================
This function maintains all the inhibited system derivatives
relevant to the mitochondrial model.

This set of equations is pertinent to the operation of
the membrane potential (MP) mitochondrial model
developed by myself.

%}

%input all our variables into the state variable y
cytcred = y(1);
O2 = y(2);
psi = y(3);

%{
To decouple the system, complexes I-III activity is instead
approximated by ((parameters.Vmax.*(cytcdiff))./ ...
(parameters.Km+(cytcdiff))).*(Hn./Hp)*(Hn./Hp)

Given this, conservation occurs between NADH and NAD, Succ and
Fum, Q and QH2. Since ((parameters.Vmax.*(cytcdiff))./ ...
(parameters.Km+(cytcdiff))).*(Hn./Hp)*(Hn./Hp) approximates BOTH forward
and reverse we get consumption and production of each
component in these pairs as equivalent. Thus the other substrates
do not change in concentration, and we have their time derivatives
equal to 0.

For the baseline conditions, these are the full equations (without
FCCP terms in dy(3) and dy(4))
Both cytochrome c reduced and omega have been reduced to order
1 due to the constraint that cyt c delivers electrons one at a time

Also, to incorporate all sections of the data, time points will dictate
the set of equations used for the model. From the data file: oligo
is injected at t = 18.6 m, FCCP starts injection at t = 20.17 m, and
rot/AA start injection at t = 28.13 m.
%}
scale = exp((-psi * 96485.33289)/(293 * 8.314459848));

%% Evaluate each mito-complex function
f_4 = ((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*scale; % complex IV
f_6 = params.p_fccp * psi; % FCCP

%% Solve equation system

dydt(1) = -2 * f_4; %dcytcred
dydt(2) = -0.5 * f_4; %dO2
dydt(3) =  -2 * f_4 + f_6; %dHn

dydt=dydt'; %correct vector orientation

end