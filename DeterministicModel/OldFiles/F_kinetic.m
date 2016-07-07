function v = F_kinetic(s_1,s_2,Hn,parameters)
%This function handles calculating the activity of the relevant complex

    v = ((parameters.Vmax*s_2)./(parameters.Km.*...
        (1+(parameters.K1))+s_2)).*Hn;
    
end