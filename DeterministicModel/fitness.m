function F = fitness(X,extPar) %This function evaluates the
%fitness for the input solving agent

%% Fitness setup
parameters=extPar.parameters;
data=extPar.data;
params=extPar.parameters.expParams;
f=fields(X);
f(strcmpi(f,'info'))=[];

%% Determines if objective will be fitting ctrl data or 3xTg data
data_types = {'CtrlO2', 'AlzO2'};

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
        parameters.cytcred = params.cytcred;
        parameters.cytcox = params.cytcox;
        parameters.cytctot = parameters.cytcred + parameters.cytcox;
        parameters.Hn = params.omega;
        parameters.Hp = params.rho;
        parameters.O2 = params.oxygen;
        params.cytctot = params.cytcred + params.cytcox;
        
        %call ode to solve the system of equations for this solver
        [~, y] = solver(parameters, params, data);
        
        %for fitting O2
        evaluations = y(:,2); %evaluated data for o2
        realo2Data = data.(data_types{parameters.data_fitting}); %exp o2 data
        
        F(1,n) = sum((realo2Data-evaluations).^2)/numel(realo2Data);
        pause(0.001);
        
end
