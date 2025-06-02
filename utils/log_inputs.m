function log_inputs(funcName, inputs)
% LOG_INPUTS Logs function inputs to a MAT file
%
% Inputs:
%   funcName - Name of the function being logged
%   inputs   - Structure containing the function's input arguments
%
% The function saves inputs to data/inputs/<funcName>.mat
% Each function's inputs are logged only once per session using a persistent Map

    persistent loggedFunctions
    if isempty(loggedFunctions)
        loggedFunctions = containers.Map();
    end
    if isKey(loggedFunctions, funcName)
        return;
    end
    loggedFunctions(funcName) = true;

    filename = fullfile('data/inputs', [funcName '.mat']);
    save(filename, '-struct', 'inputs');
end
