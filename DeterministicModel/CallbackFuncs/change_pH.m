function [hObject, handles] = change_pH(hObject, handles)

getHpconc = 0;
oldHp = 0;
newHp = 0;
getVal = str2double(get(hObject,'String'));

if isnan(getVal) %if not, throw error box and reset value
    msgbox('Please input a valid number.','Not a number');
    
    %get the concentration value for resetting the edit box
    getHpconc = getfield(handles.parameters,'Hp');
    
    oldHp = -log10(getHpconc *1E-6);
    
    set(hObject,'String',oldHp);
else %if so, then update the model with new value
    %Hp from the given pH
    if (getVal > 0) && (getVal < 14)
        newHp = (10^-getVal) * 1E6;
        handles.parameters = setfield(handles.parameters,'Hp',newHp);
    else
        %throw error box
        waitfor(msgbox('Not a valid pH.','Invalid pH'));
        
        %get the concentration value for resetting the edit box
        getHpconc = getfield(handles.parameters,'Hp');
        
        oldHp = -log10(getHpconc *1E-6);
        set(hObject,'String',oldHp);
    end
end