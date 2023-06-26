prompt = inputdlg("Enter your prompt.", "ChatMPC Numerical Experiment 1");
if isempty(prompt)
    disp("Canceled.")
else
    run_intentextractor
    if strcmp(classname, "AL")
        mpcparameter.r_left = mpcparameter.r_left*0.8;
    end
    if strcmp(classname, "SL")
        mpcparameter.r_left = mpcparameter.r_left*1.25;
    end
    if strcmp(classname, "AR")
        mpcparameter.r_right = mpcparameter.r_right*0.8;
    end
    if strcmp(classname, "SR")
        mpcparameter.r_right = mpcparameter.r_left*1.25;
    end
end