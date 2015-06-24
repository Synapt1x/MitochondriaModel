function dy = inhibitSystem(t,y,parameters)
%This function maintains all the derivatives relevant to the project

%input all our variables into the state variable y
Cytcred = y(1);
O2 = y(2);
Hn = y(3);
Hp = y(4);

%{
To decouple the system, complexes I-III activity is instead
approximated by parameters.f0

Given this, conservation occurs between NADH and NAD, Succ and
Fum, Q and QH2. Since parameters.f0 approximates BOTH forward
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

dy(1) = 4*parameters.f0 - 4*((parameters.Vmax.*O2) ...
    ./(parameters.Km.*(1+(parameters.K1./Cytcred))+O2))...
    .*(Hn/Hp); %dCytcred
dy(2) = -((parameters.Vmax.*O2)./(parameters.Km.* ...
    (1+(parameters.K1./Cytcred))+O2)).*(Hn/Hp); %dO2
dy(3) =  8*((parameters.Vmax.*O2)./(parameters.Km.*(1 ...
    +(parameters.K1./Cytcred))+O2)).*(Hn/Hp) + parameters.Dh ...
    * ((Hp - Hn) + Hp * log(Hp/Hn)); %dHn
dy(4) = 4*((parameters.Vmax.*O2)./(parameters.Km.*(1 ...
    +(parameters.K1./Cytcred))+O2)).*(Hn/Hp) - parameters.Dh ...
    *((Hp - Hn) + Hp * log(Hp/Hn)); %dHp

dy=dy'; %correct vector orientation

end