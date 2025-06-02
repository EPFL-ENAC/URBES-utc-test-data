function log_inputs(funcName, inputs)
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
