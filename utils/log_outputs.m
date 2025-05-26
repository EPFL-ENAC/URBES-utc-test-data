function log_outputs(funcName, outputs)
    persistent loggedFunctions
    if isempty(loggedFunctions)
        loggedFunctions = containers.Map();
    end
    if isKey(loggedFunctions, funcName)
        return;
    end
    loggedFunctions(funcName) = true;
    
    filename = fullfile('data/outputs', [funcName '.mat']);
    save(filename, 'outputs');
end
