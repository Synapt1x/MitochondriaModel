function [data_matrix,firstintervals] = data_formatter
% This function reads the excel data files and formats them into vectors
% for use in the mitochondria model as calibration data.
%
% This function reads an excel file in a folder called 'Data', found in the
% location of this .m file. Data is read and then stored into a data
% matrix, with corresponding labels.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_folder = fileparts(which(mfilename)); %store the folder in which the model is stored

filename1 = fullfile(path_folder, '/Data/All_o2_data.xlsx'); %file name holding the o2 data
filename2 = fullfile(path_folder, '/Data/ocr_data.xlsx'); %file name holding the ocr data
sheets = {'Nov 26', 'Dec 5', 'Dec 10', 'Dec 17'}; %name of sheets
len = numel(sheets); %number of sheets for looping through data

for i=1:len %loop through and store all data into a data matrix
    all_data_o2{i} = xlsread(filename1,sheets{i},'A42:U181');
    all_data_ocr{i} = xlsread(filename2,sheets{i},'A42:U51');
end

%store labels for labelling each data matrix in the output cell structure
[data_matrix{1,1:11}] = deal('All data','Baseline Interval 1',...'
    'Baseline Interval 2','Baseline Interval 3','Oligo Interval 1',...
    'Oligo Interval 2','Oligo Interval 3','FCCP Interval 1',...
    'FCCP Interval 2','Inhibit Interval 1','Inhibit Interval 2');

%store the data into one matrix
data_matrix{2,1} = [all_data_o2{1}, all_data_o2{2}(:,2:end), ...
    all_data_o2{3}(:,2:end), all_data_o2{4}(:,2:end)];
data_matrix{3,1} = [all_data_ocr{1}, all_data_ocr{2}(:,2:end), ...
    all_data_ocr{3}(:,2:end), all_data_ocr{4}(:,2:end)];

%convert time units to seconds
data_matrix{2,1}(:,1) = data_matrix{2,1}(:,1)*60;
data_matrix{3,1}(:,1) = data_matrix{3,1}(:,1)*60;

%add a final column with an average of all the data
data_matrix{2,1} = [data_matrix{2,1}, mean(data_matrix{2,1}(:,2:end),2)];
data_matrix{3,1} = [data_matrix{3,1}, mean(data_matrix{3,1}(:,2:end),2)];

for j=2:11 %loop through the data and store them into all intervals
    data_matrix{2,j} = data_matrix{2,1}((j-1)*(1:14),:);
    data_matrix{3,j} = data_matrix{3,1}((j-1),:);
end

%store information about the first interval of each section only
[firstintervals{1,1},firstintervals{1,2},firstintervals{1,3}, ...
    firstintervals{1,4}] = deal(data_matrix{2,[2,5,8,10]}); %all o2
[firstintervals{2,1},firstintervals{2,2},firstintervals{2,3}, ...
    firstintervals{2,4}] = deal(data_matrix{3,[2,5,8,10]}); %all ocr

%extrapolate each interval using calcSection.m


%store the time points as seconds