function v = F_Synthase(Hn,Hp,parameters,varargin)
%Form of F for the proton channel activity of ATP Synthase

% If there is an additional parameter called into F_Synthase, in varargin, 
% then ATP Synthase has been inhibited.

% Note that smaller values of v occur when Hn > Hp, meaning that movement
% back into the matrix is much slower since there is a lot of protons
% already in the matrix.

    if ~isempty(varargin) %If call is for ATP Synthase inhibition
        v = 0;
    else %default is for regular ATP Synthase activity
        v = ((parameters.p1*(Hp/Hn))/((Hp/Hn)+parameters.p2+...
            (parameters.p3/Hn)))*Hp;
    end
end