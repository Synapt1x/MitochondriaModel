function [allTimes,realo2,realOCR] = data_formatter
%{
Created by: Chris Cadonic
========================================
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
filename = fullfile(path_folder, '/Data/3xoxygraphData.xlsx');

%% Extract Oxygraph Data

%extract all times and all oxygen concentration readings
allData = xlsread(filename,'Sheet1','M342:O705');
allData(1,:)=[]; %delete t=0 time point

%store the times, o2 and ocr data separately
[realo2(:,1), realo2(:,2), allTimes] = deal(allData(:,1), allData(:,2), allData(:,3));

realOCR(:,1) = -gradient(realo2(:,1));
realOCR(:,2) = -gradient(realo2(:,2));