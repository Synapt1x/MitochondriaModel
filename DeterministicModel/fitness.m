function F = fitness(X,extPar) %This function evaluates the
%fitness for the input solving agent

parameters=extPar.parameters;
f=fields(X);
f(strcmpi(f,'info'))=[];

for n=length(X):-1:1
    if isAbortEval(extPar.status)
        F=[];
        break
    end
    
    for i=1:length(f)
        parameters.(f{i})=X(n).(f{i});
    end
        
    %call ode to solve the system of equations for this solver
    [t, y] = ode23t(@decoupled_derivative_system,parameters.time_points, ...
        parameters.initial_conditions,[],parameters);
    
    evaluations = y(:,2); %evaluated data for o2
    evaluatedOCR = -mean(((parameters.Vmax.*y(:,2))./(parameters.Km.*...
        (1+(parameters.K1./y(1)))+y(:,2))).*y(:,3));%evaluated data for OCR
    
    realo2Data = parameters.realData(:,end); %use actual o2 data
    realOCR = parameters.realOCR(:,end); %use actual OCR measurement
    
    %evaluate using a least-squares
    F([1,2],n) = [sum((realo2Data-evaluations).^2);(realOCR-evaluatedOCR)^2];
end