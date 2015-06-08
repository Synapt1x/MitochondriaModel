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
    tic
    [t y] = ode45(@decoupled_derivative_system,parameters.time_points, ...
        parameters.initial_conditions,[],parameters);
    toc
    
    evaluations = y(:,2); %evaluated data for o2
    evaluatedOCR = -F_kinetic(y(7,1),y(7,2),y(7,3),parameters);%evaluated data for OCR
    
    realo2Data = parameters.realData(:,end); %replicate actual o2 data
    realOCR = parameters.realOCR(:,end); %replicate actual OCR measurement
    
    F([1,2],n) = [sum((realo2Data-evaluations).^2);(realOCR-evaluatedOCR)^2]; %evaluate using a least-squares
end