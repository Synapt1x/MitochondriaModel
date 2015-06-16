function parameters = setup
%instantiate the values for each variable in the system
%this parameter set is for the decoupled system, and thus only maintain
%parameter values for complex IV

%import the real data
parameters.allData = data_formatter;
parameters.realData = parameters.allData{2,2}(2:(end-1),1:size(...
    parameters.allData{2,2},2)-1:end); %baseline o2 data from interval 1
parameters.realOCR = -parameters.allData{3,2}(:,end); %baseline ocr data from interval 1

%convert time points from minutes to seconds
parameters.realData(:,1) = parameters.realData(:,1)*60;

%parameter values
parameters.Vmax = 0.1; %bounds: [0.1 1E4]
parameters.K1 = 0.1; %bounds: [0.1 1E4]
parameters.Km = 0.1; %bounds: [0.1 1E4]
parameters.p1 = 17.7405; %bounds: [1 1E4]
parameters.p2 = 1284.6859; %bounds: [1 1E4]
parameters.p3 = 1.447E-6; %bounds: [1E-6 1]
parameters.f0 = 1E-4; %bounds: [1 1E4]
parameters.Dh = 3.2097E-6; %bounds: [1E-6 1]

%initial conditions
parameters.Cytcox = 100;
parameters.Cytcred = 40;
parameters.O2 = parameters.realData(1,2);
parameters.Hn = 40;
parameters.Hp = 1;

%parameters for defining the IV of the region of interest
parameters.time_points = parameters.realData(:,1)'; %all the time points for integration;
parameters.initial_conditions = [parameters.Cytcred,parameters.O2, ...
    parameters.Hn,parameters.Hp]; %Initial Vs

%parameter values for the stochastic simulation
parameters.s_j = [1 -4 0 0; 0 -1 0 0; -6 -8 1 1; 8 4 -1 -1]; 

%titles and labels for the output graphs
[parameters.title{1:7}] = deal(['Reduced cytochrome c concentration over'...
    ' time'],'Change in reduced cytochrome c concentration over time',...
    'Oxygen concentration over time','Oxygen consumption rate over time'...
    ,'Matrix proton concentration over time',...
    'Intermembrane space proton concentration over time',...
    'Total proton concentration over time');
[parameters.ylab{1:7}] = deal('Cyt c_{red} (mmol)',['delta Cyt c_{red} '...
    '(mmol/sec)'],'O2 (mmol)','OCR (mmol/sec)','H_N (mmol)',['delta '...
    'H_N (mmol/sec)'],'H_total (mmol)');
parameters.xlab = 'Time (sec)';