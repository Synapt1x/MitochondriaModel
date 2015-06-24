function data_matrix = data_formatter
%{
This function reads the excel data files and formats them into 
vectors for use in the mitochondria model as calibration data.

This function reads an excel file in a folder called 'Data', found in 
the location of this .m file. Data is read and then stored into a data
matrix, with corresponding labels.
%==================================================%
%}

%store the folder in which the model is stored
path_folder = fileparts(which(mfilename));

%Find the data folder containing the data based on this .m file
filename = fullfile(path_folder, '/Data/oxygraphPracData.xlsx');

%Read the oxygraph data from the excel datafile
all_data_times = xlsread(filename,'Sheet1','A308:A844');
all_data_o2 = xlsread(filename,'Sheet1','G308:G844');
all_data_ocr = xlsread(filename,'Sheet1','H308:H844');

%Store the data into the data_matrix
[data_matrix{1,1:3}] = deal('times',...
    'Oxygen concentration over time','OCR over time');
[data_matrix{2,1:3}] = deal(all_data_times,all_data_o2,...
    all_data_ocr);