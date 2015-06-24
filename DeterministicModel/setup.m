function parameters = setup
%instantiate the values for each variable in the system
%this parameter set is for the decoupled system, and thus only maintain
%parameter values for complex IV

%import the real data
parameters.allData = data_formatter;
parameters.realData = parameters.allData{2,2}; %all o2 data
parameters.realOCR = -parameters.allData{2,3}; %all ocr data

%parameter values
parameters.Vmax =2825.4; %bounds: [0.1 1E4]
parameters.K1 = 1495; %bounds: [0.1 1E4]
parameters.Km = 2096.1; %bounds: [0.1 1E4]
parameters.p1 = 40.5013; %bounds: [1 1E4]
parameters.p2 = 1477.4; %bounds: [1 1E4]
parameters.p3 = 1.415e-5; %bounds: [1E-6 1]
parameters.f0 = 1.1797; %bounds: [1 1E4]
parameters.Dh = 2.4025e-7; %bounds: [1E-6 1]

%initial conditions
parameters.Cytcox = 100;
parameters.Cytcred = 40;
parameters.O2 = parameters.realData(1);
parameters.Hn = 40;
parameters.Hp = 1;

%parameters for defining the IV of the region of interest
%all the time points for integration from allData
parameters.timePoints = parameters.allData{2,1}';
%correct the time units to seconds
parameters.timePoints=parameters.timePoints*60;

%define the time boundaries between conditions
oligoTime = min(find(parameters.timePoints>(18.57*60)));
fccpTime = min(find(parameters.timePoints>(20.13*60)));
inhibitTime = min(find(parameters.timePoints>(28.1*60)));

%define the arrays holding the time points for each section
parameters.baselineTimes = parameters.timePoints(1:oligoTime); 
parameters.oligoTimes = parameters.timePoints(oligoTime:fccpTime); 
parameters.FCCPTimes = parameters.timePoints(fccpTime:inhibitTime);
parameters.inhibitTimes = parameters.timePoints(inhibitTime:end);

parameters.initialConditions = [parameters.Cytcred,parameters.O2, ...
    parameters.Hn,parameters.Hp]; %Initial Vs

%titles and labels for the output graphs
[parameters.title{1:6}] = deal(['Reduced cytochrome c concentration over'...
    ' time'],'Oxygen concentration over time', ...
    'Oxygen consumption rate over time', ...
    'Matrix proton concentration over time',...
    'Intermembrane space proton concentration over time',...
    'Total proton concentration over time');
[parameters.ylab{1:6}] = deal('Cyt c_{red} (mmol)', ...
    'O_2 (mmol)','OCR (mmol/sec)','H_N (mmol)',['delta '...
    'H_N (mmol/sec)'],'H_{total} (mmol)');
parameters.xlab = 'Time (sec)';