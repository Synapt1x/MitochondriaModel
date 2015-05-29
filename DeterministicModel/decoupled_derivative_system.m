function dy = decoupled_derivative_system(t,y,parameters)
%This function maintains all the derivatives relevant to the project
    
    %input all our variables into the state variable y
    Cytcred = y(1);
    O2 = y(2);
    Hn = y(3);
    Hp = y(4);
    
    %To decouple the system, complexes I-III activity is instead
    %approximated by F_0(parameters)
    
    %Given this, conservation occurs between NADH and NAD, Succ and Fum,
    %Q and QH2. Since F_0(parameters) approximates BOTH forward and reverse we get 
    %consumption and production of each component in these pairs as
    %equivalent. Thus the other 1substrates do not change in concentration,
    %and we have their time derivatives equal to 0.
    
    dy(1) = 2*F_0(parameters) - 4*F_kinetic(Cytcred,O2,Hn,parameters); %dCytcred
    dy(2) = -F_kinetic(Cytcred,O2,Hn,parameters); %dO2
    dy(3) = -6*F_0(parameters) - 8*F_kinetic(Cytcred,O2,Hn,parameters) ...
       + F_Synthase(Hn,Hp,parameters) + F_FCCP(Hn,Hp,parameters); %dHn
    dy(4) = 8*F_0(parameters) + 4*F_kinetic(Cytcred,O2,Hn,parameters) ...
        - F_Synthase(Hn,Hp,parameters) - F_FCCP(Hn,Hp,parameters); %dHp
    
    dy=dy'; %correct vector orientation
    
end