function F = fitness(X,extPar) %This function evaluates the
%fitness for the input solving agent

parameters=extPar.parameters;
f=fields(X);
f(strcmpi(f,'info'))=[];

pause(0.0001);

for n=length(X):-1:1
    if isAbortEval(extPar.status)
        F=[];
        break
    end
    
    for i=1:length(f)
        parameters.(f{i})=X(n).(f{i});
    end
    
    %call ode to solve the system of equations for this solver
    [t, y] = solver(parameters);
    
    evaluations = y(:,2); %evaluated data for o2
    evaluatedOCRs = ocrCalc(y,parameters);%evaluated data for OCR
    
    realo2Data = parameters.realo2Data; %use actual o2 data
    realOCR = parameters.realOCR; %use actual OCR measurement
    
    %evaluate using a least-squares
    F([1,2],n) = [sum((realo2Data-evaluations).^2);sum(realOCR-evaluatedOCRs).^2];
end