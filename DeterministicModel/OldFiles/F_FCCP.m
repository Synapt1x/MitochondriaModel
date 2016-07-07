function v = F_FCCP(Hn,Hp,parameters,varargin)
%Form of F for FCCP allowing protons to move back into matrix

%If there is an additional parameter called into F_FCCP, in varargin, then
%fccp has been injected

% Note that by convention, if v < 0, then protons are moving outward, from
% Hn to Hp.

    if ~isempty(varargin) %If call is for FCCP injection
        v = parameters.Dh * ((Hp - Hn) + Hp * log(Hp/Hn));
    else %If no FCCP has been injected, then FCCP activity is 0
        v = 0;
    end
end