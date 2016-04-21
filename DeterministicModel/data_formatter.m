function [allTimes,realo2,realOCR,errors] = data_formatter
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
filename = fullfile(path_folder, '/Data/oxygraphData.xlsx');

%% Extract Oxygraph Data

%extract all times and all oxygen concentration readings
allData = xlsread(filename,'Sheet1','M520:P829');
allData(1,:)=[]; %delete t=0 time point

%store the times, o2 and ocr data separately
[allTimes,realo2,errors] = deal(allData(:,1),allData(:,2),allData(:,4));

realOCR = -gradient(realo2);