function [data, convert_to_P] = data_formatter(varargin)
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

%initialize empty struc for housing all data
data = struct();

%store the folder in which the model is stored
path_folder = fileparts(which(mfilename));

%file names holding the oxygraph o2 data and Seahorse ocr data
filename = fullfile(path_folder, '/Data/3xoxygraphData.xlsx');

% conversion factor for converting [C] to pressure
if ~isempty(varargin)
    convert_to_P = 10E-9 * 293 * 62.364;
else
    convert_to_P = 1;
end

%% Extract Oxygraph Data

%extract all times and all oxygen concentration readings
[~,fieldNames] = xlsread(filename, 'Sheet1', 'M1:R1');
[allData, timePoints] = xlsread(filename,'Sheet1','M2:R705');

injection_fields = {'t_0_i', 'oligo_i', 'f_25_i', 'f_50_i', 'f_75_i', ...
    'f_100_i', 'inhibit_i'};
injection_times = {'t_0', 'oligo_t', 'fccp_25_t', 'fccp_50_t', 'fccp_75_t', ...
    'fccp_100_t', 'inhibit_t'};
search_phrases = {'Start Time','oligomycin','F_25','F_50','F_75', ...
    'F_100','Inhibit'};

%determine initial time point
data.(injection_fields{1}) = find(~cellfun('isempty', ...
    strfind(timePoints,search_phrases{1})));

%insert all data into the data structure
for i=1:numel(fieldNames)-1
    data.(fieldNames{i}) = allData(data.t_0_i:end,i);
end

%determine all of the time points for injection
for timepoint=2:numel(search_phrases)
    data.(injection_fields{timepoint}) = find(~cellfun('isempty', ...
        strfind(timePoints, search_phrases{timepoint}))) - data.t_0_i;
    data.(injection_times{timepoint}) =  ...
        data.Time(data.(injection_fields{timepoint}));
end

%store an array of times for each experimental condition
timepoints_fields = {'baseline_times', 'oligo_fccp_times', 'inhibit_times'};
times = [0, data.oligo_i, data.inhibit_i, numel(data.Time)];
for i=1:numel(times)-1
    t_i = times(i);
    t_end = times(i+1);
    data.(timepoints_fields{i}) = data.Time(t_i + 1:t_end);
end

%% Calculate OCR based on O2 data from loaded Oxygraph data
o2_handles = {'CtrlO2', 'AlzO2'};
ocr_handles = {'CtrlOCR', 'AlzOCR'};

% process O2 data to convert to pressure if needed
data.CtrlO2 = data.CtrlO2 * convert_to_P;
data.AlzO2 = data.AlzO2 * convert_to_P;

%calculate OCR for each ctrl and Alz condition separately
for type=1:2
    ocr_calc = [0];
    for j=1:1:numel(data.(o2_handles{type}))-1
        ocr_calc(j+1) = (data.(o2_handles{type})(j+1) ...
            - data.(o2_handles{type})(j)) / (data.Time(j+1) - data.Time(j));
    end
    data.(ocr_handles{type}) = ocr_calc' * 1000;
end

%calculate the max possible error
data.max_error = [(sum(data.CtrlO2.^2))/numel(data.CtrlO2), ...
    (sum(data.AlzO2.^2))/numel(data.AlzO2)];