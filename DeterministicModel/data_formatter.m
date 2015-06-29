function [timePoints,realo2,realOCR] = data_formatter
%{
Created by: Chris Cadonic
=====================================================
This function reads the excel data files and formats them into
vectors for use in the mitochondria model as calibration data.

This function reads an excel file in a folder called 'Data', found in
the location of this .m file. Data is read and then stored into a data
matrix, with corresponding labels.
%}

%% Read the files for O2 and OCR

%store the folder in which the model is stored
path_folder = fileparts(which(mfilename));

%file names holding the oxygraph o2 data and Seahorse ocr data
filenameo2 = fullfile(path_folder, '/Data/oxygraphData.xlsx');
filenameocr = fullfile(path_folder, '/Data/ocr_data.xlsx');
sheets = {'Nov 26', 'Dec 5', 'Dec 10', 'Dec 17'}; %name of sheets

len = numel(sheets); %number of sheets for looping through data

%% Extract Oxygraph O2

%extract all times and all oxygen concentration readings
all_data_o2 = xlsread(filenameo2,'Sheet1','M520:N829');

all_data_o2(1,:)=[]; %delete t=0 time point

%% Extract Seahorse OCR
for i=1:len %loop through and store all data into a data matrix
    all_data_ocr{i} = xlsread(filenameocr,sheets{i},'A42:U51');
end

%store the data into one matrix
data_matrix{1,1} = [all_data_ocr{1}, all_data_ocr{2}(:,2:end), ...
    all_data_ocr{3}(:,2:end), all_data_ocr{4}(:,2:end)];


%% Store the outputs from data_matrix

%store the time points corresponding to data
timePoints = all_data_o2(:,1);

%store the o2 concentration at each time point
realo2 = all_data_o2(:,2);

%store the average OCR for each segment
realOCR = mean(data_matrix{1,1}(:,2:end),2);
realOCR = [mean(realOCR(1:3)),mean(realOCR(4:6)), ...
    mean(realOCR(7:8)), mean(realOCR(9:end))]';