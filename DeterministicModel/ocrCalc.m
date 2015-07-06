function [avgOCRs,OCRs] = ocrCalc(y,parameters)
%{
Created by: Chris Cadonic
===================================================
This function calculates the average OCR value for each section in the
model's data. Average OCR values are then repeated using different lengths
as per parameters.numpoints calculated in the setup function.
%}

%calculate OCR values using input values
calcOCRs = -((parameters.Vmax.*y(:,2))./(parameters.Km.*...
    (1+(parameters.K1./y(1)))+y(:,2))).*y(:,3);

%calculate the average OCR in each segment; primarily used in optimization
avgOCRs = [mean(calcOCRs(1:parameters.oligoTime-1)), ...
    mean(calcOCRs(parameters.oligoTime:parameters.fccpTime-1)), ...
    mean(calcOCRs(parameters.fccpTime:parameters.inhibitTime-1)), ...
    mean(calcOCRs(parameters.inhibitTime:end))]';

%re-format the vector to only have average values at each point
%ensure that rude is added to the matlab path for access 
OCRs = rude(parameters.numpoints,avgOCRs)';