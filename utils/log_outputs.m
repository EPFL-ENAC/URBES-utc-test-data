function log_outputs(funcName, outputs)
% LOG_OUTPUTS Logs function outputs to a MAT file
%
% Inputs:
%   funcName - Name of the function being logged
%   outputs  - Structure containing the function's output arguments
%
% The function saves outputs to data/outputs/<funcName>.mat
% Each function's outputs are logged only once per session using a persistent Map
    persistent loggedFunctions
    if isempty(loggedFunctions)
        loggedFunctions = containers.Map();
    end
    if isKey(loggedFunctions, funcName)
        return;
    end
    loggedFunctions(funcName) = true;

    filename = fullfile('data/outputs', [funcName '.mat']);
    save(filename, '-struct', 'outputs');
end
