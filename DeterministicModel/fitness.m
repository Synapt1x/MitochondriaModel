function F = fitness(X,extPar) %This function evaluates the
%fitness for the input solving agent

parameters=extPar.parameters;
params=extPar.parameters.params;
f=fields(X);
f(strcmpi(f,'info'))=[];

for n=length(X):-1:1
        if isAbortEval(extPar.status)
                F=[];
                break
        end
        
        for i=1:length(f)
                params.(f{i})=X(n).(f{i});
        end
        
        %call ode to solve the system of equations for this solver
        [t, y] = solver(parameters,params);
        
        %for fitting O2
        evaluations = y(:,2); %evaluated data for o2
        realo2Data = parameters.realo2Data; %use actual o2 data
        
        %evaluate using a least-squares
        F(1,n) = sum((realo2Data-evaluations).^2)/numel(realo2Data);
        pause(0.001);
        
end
