function F = fitness(X,extPar) %This function evaluates the
%fitness for the input solving agent

%% Fitness setup
parameters=extPar.parameters;
params=extPar.parameters.expParams;
f=fields(X);
f(strcmpi(f,'info'))=[];

%% Determines if objective will be fitting ctrl data or 3xTg data
data_fitting = 1; % Set to 1 for ctrl data, set to 2 for 3xTg data

%% Main fitness loop
for n=length(X):-1:1
        if isAbortEval(extPar.status)
                F=[];
                break
        end
        
        for i=1:length(f)
                params.(f{i})=X(n).(f{i});
        end
        
        %update all the parameteres necessary
        parameters.Cytcred = params.cytcred;
        parameters.Cytcox = params.cytcox;
        parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;
        parameters.Hn = params.omega;
        parameters.Hp = params.rho;
        parameters.O2 = params.oxygen;
        params.Cytctot = params.cytcred + params.cytcox;
        
        warning off
        %call ode to solve the system of equations for this solver
        [t, y] = solver(parameters,params);
        warning on
        
        %for fitting O2
        evaluations = y(:,2); %evaluated data for o2
        realo2Data = parameters.realo2Data(:,data_fitting); %use actual o2 data
        
        try
            %evaluate using a least-squares
            F(1,n) = sum((realo2Data-evaluations).^2)/numel(realo2Data);
            pause(0.001);
        catch
            F(1,n) = 1E6;
        end
        
end
