function dy = oligoSystem(t,y,params)
%{
Created by: Chris Cadonic
========================================
This function maintains all the oligomycin derivatives
relevant to my masters project.

%}

%input all our variables into the state variable y
cytcred = y(1);
O2 = y(2);
Hn = y(3);
Hp = y(4);

%{
To decouple the system, complexes I-III activity is instead
approximated by ((parameters.Vmax.*(cytcdiff))./ ...
(parameters.Km+(cytcdiff))).*(Hn./Hp)

Given this, conservation occurs between NADH and NAD, Succ and
Fum, Q and QH2. Since ((parameters.Vmax.*(cytcdiff))./ ...
(parameters.Km+(cytcdiff))).*(Hn./Hp) approximates BOTH
forward and reverse we get consumption and production of each
component in these pairs as equivalent. Thus the other substrates
do not change in concentration, and we have their time derivatives
equal to 0.

For the oligomycin conditions, these are the full equations (without
FCCP terms in dy(3) and dy(4)) and without ATP Synthase equations
Both cytochrome c reduced and omega have been reduced to order
1 due to the constraint that cyt c delivers electrons one at a time

Also, to incorporate all sections of the data, time points will dictate
the set of equations used for the model. From the data file: oligo
is injected at t = 18.6 m, FCCP starts injection at t = 20.17 m, and
rot/AA start injection at t = 28.13 m.
%}
cytcdiff = params.cytctot - cytcred;

dy(1) = 2*((params.f0_Vmax*(cytcdiff))/(params.f0_Km+(cytcdiff))) ...
        *(Hn./Hp) - 2*((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*(Hn/Hp); %dcytcred
dy(2) = -0.5*((params.fIV_Vmax*O2)/(params.fIV_Km*(1+(params.fIV_K ...
        /cytcred))+O2))*(Hn/Hp); %dO2
dy(3) = -6*((params.f0_Vmax*(cytcdiff))/(params.f0_Km+(cytcdiff))) ...
        *(Hn./Hp) - 4*((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*(Hn/Hp) ...
        + (0.25*exp(-params.alpha*(t - params.fccp_25_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_50_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_75_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_100_t))) ...
        * params.Dh * ((Hp - Hn) + Hp * log(Hp/Hn));%dHn
dy(4) = 8*((params.f0_Vmax*(cytcdiff))/(params.f0_Km+(cytcdiff))) ...
        *(Hn./Hp) + 2*((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*(Hn/Hp) ...
        - (0.25*exp(-params.alpha*(t - params.fccp_25_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_50_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_75_t)) ...
        + 0.25*exp(-params.alpha*(t - params.fccp_100_t))) ...
        * params.Dh * ((Hp - Hn) + Hp * log(Hp/Hn)); %dHp

dy=dy'; %correct vector orientation

end