function ocr = calculateOCR(handles,type,varargin)
% short function for calculating ocr from o2 data

% determine what arguments are passed into the calculation 
if ~isempty(varargin)
    cytcred = varargin{1};
    O2 = varargin{2};
    if length(varargin) == 5
        Hn = varargin{3};
        Hp = varargin{4};
        t = varargin{5};
    elseif length(varargin) == 4
        psi = varargin{3};
    end
end

% check whether this calculation is for control or experimental parameters
if strcmp(type,'control')
    params = handles.ctrlParams;
else
    params = handles.expParams;
end

warning off
if strcmp(handles.selected_model.String, 'CC MP Model')
    scale = exp((-psi * 96485.33289)/(293 * 8.314459848));

    ocr = -((params.fIV_Vmax*O2)/(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred))+O2))*(Hn./Hp).* scale;
else
    ocr = -0.5 * ((params.fIV_Vmax*O2)./(params.fIV_Km*(1 ...
        +(params.fIV_K/cytcred)')+O2)).*(Hn./Hp);
    ocr = [0];
    for i=2:length(t)
        ocr = [ocr, (O2(i) - O2(i - 1))/(t(i) - t(i - 1))];
    end
end
warning on