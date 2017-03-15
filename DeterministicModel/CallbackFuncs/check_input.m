function cytcred = check_input(input,currTot)
% Check that a valid cytochrome c reduced value was entered

if ~isnumeric(input)
    msgbox('Not a valid number. Please enter a number.','Not a number');
else
    if input > currTot
        waitfor(msgbox(['Please enter a number less than the ', ...
            'total amount of Cytochrome C (i.e., less than ', ...
            num2str(currTot),').'], 'Cytochrome C reduced level too high'));
        cytcred = 0;
    else
        cytcred = input;
    end
end