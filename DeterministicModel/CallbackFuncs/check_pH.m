function validity = check_pH(value)
% check that a valid pH value was entered

validity = true;
if (value < 0) || (value > 14)
    waitfor(msgbox('Not a valid pH.','Invalid pH'));
    validity = false;
end