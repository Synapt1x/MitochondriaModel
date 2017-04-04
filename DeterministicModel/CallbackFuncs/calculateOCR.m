function ocr = calculateOCR(handles,cytcred,O2,Hn,Hp,type)
% short function for calculating ocr from o2 data

% check whether this calculation is for control or experimental parameters
if strcmp(type,'control')
    params = handles.ctrlParams;
else
    params = handles.expParams;
end

ocr = -0.5 * ((params.fIV_Vmax*O2)./(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))'+O2)).*(Hn./Hp);