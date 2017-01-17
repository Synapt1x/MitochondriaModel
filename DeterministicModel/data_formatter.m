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

[realo2(:,1), realo2(:,2), allTimes] = deal(allData(:,1), allData(:,2), allData(:,3));

% old gradient method for determining OCR
realOCR = zeros(size(realo2));

for i=1:1:2
    for j=1:1:numel(realo2(:,i))-1
        realOCR(j, i) = (realo2(j+1,i)-realo2(j,i))/(allTimes(j+1)-allTimes(j));
    end
end
realOCR(end,1) = realOCR(end-1,1);
realOCR(end,2) = realOCR(end-1,2);

realOCR = realOCR * -1000;

%%% For using OCR from Oxygraph %%%
%{
%extract all times and all oxygen concentration readings
allData = xlsread(filename,'Sheet1','M342:Q705');
allData(1,:)=[]; %delete t=0 time point

%store the times, o2 and ocr data separately
[realo2(:,1), realo2(:,2), allTimes, realOCR(:,1), realOCR(:,2)] = ...
    deal(allData(:,1), allData(:,2), allData(:,3), allData(:,4), allData(:,5));
%}