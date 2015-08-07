function [allTimes,realo2,realOCR,specData] = data_formatter
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

specfile = fullfile(path_folder,'/Data/SpecData.xlsx');

%% Extract Oxygraph Data

%extract all times and all oxygen concentration readings
allData = xlsread(filename,'Sheet1','M520:O829');
allData(1,:)=[]; %delete t=0 time point

%store the times, o2 and ocr data separately
[allTimes,realo2] = deal(allData(:,1),allData(:,2));

realOCR = -gradient(realo2);

%% Extract Spec Data

%store all sheet names in a cell
sheets = {'Trial1-June25','Trial1-July8','Trial1-July15','Trial2-June25','Trial2-July8',....
    'Trial2-July15','Trial3-June25','Trial3-July8','Trial3-July15'};

%store the times; measurements are 10 seconds apart
dataMatrix = linspace(0,120,13)';

%loop through all sheets and store the data
for sheet = 1:numel(sheets)
    dataMatrix(:,sheet+1) = xlsread(specfile,sheets{sheet},'B2:B14');
end

%return the times and the average of all measurements
specData=[dataMatrix(:,1) mean(dataMatrix(:,2:end),2)];