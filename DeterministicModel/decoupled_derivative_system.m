function dy = decoupled_derivative_system(t,y,parameters)
%This function maintains all the derivatives relevant to the project
    
    %input all our variables into the state variable y
    Cytcred = y(1);
    O2 = y(2);
    Hn = y(3);
    Hp = y(4);
    
    %To decouple the system, complexes I-III activity is instead
    %approximated by parameters.f0
    
    %Given this, conservation occurs between NADH and NAD, Succ and Fum,
    %Q and QH2. Since parameters.f0 approximates BOTH forward and reverse we get 
    %consumption and production of each component in these pairs as
    %equivalent. Thus the other 1substrates do not change in concentration,
    %and we have their time derivatives equal to 0.
    
    %For the baseline conditions, these are the full equations (without
    %FCCP terms in dy(3) and dy(4))
    %Both cytochrome c reduced and omega have been reduced to order 1 due
    %to the constraint that cyt c delivers electrons one at a time
    dy(1) = 2*parameters.f0 - 4*((parameters.Vmax*O2)./(parameters.Km.*(1+(Cytcred/parameters.K1))+O2)).*Hn; %dCytcred
    dy(2) = -((parameters.Vmax*O2)./((Cytcred/parameters.Km).*(1+(parameters.K1))+O2)).*Hn; %dO2
    dy(3) = -6*parameters.f0 - 8*((parameters.Vmax*O2)./(parameters.Km.*(1+(Cytcred/parameters.K1))+O2)).*Hn ...
       + ((parameters.p1*(Hp/Hn))/((Hp/Hn)+parameters.p2+(parameters.p3/Hn)))*Hp; %dHn
    dy(4) = 8*parameters.f0 + 4*((parameters.Vmax*O2)./(parameters.Km.*(1+(Cytcred/parameters.K1))+O2)).*Hn ...
        - ((parameters.p1*(Hp/Hn))/((Hp/Hn)+parameters.p2+(parameters.p3/Hn)))*Hp; %dHp
    
    dy=dy'; %correct vector orientation
    
end