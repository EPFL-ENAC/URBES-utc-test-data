%FUNCTION_SIGNATURE%
% Wrapper for logging I/O to %ORIGINAL_FUNC%
    persistent loggedFunctions
    if isempty(loggedFunctions)
        loggedFunctions = containers.Map();
    end
    if isKey(loggedFunctions, '%FUNC_NAME%')
        return;
    end
    loggedFunctions('%FUNC_NAME%') = true;

    save('data/inputs/%FUNC_NAME%');
    %OUTPUTS% = %FUNC_CALL%;
    save('data/outputs/%FUNC_NAME%');
end
