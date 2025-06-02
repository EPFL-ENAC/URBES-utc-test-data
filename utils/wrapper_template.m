%FUNCTION_SIGNATURE%
% Wrapper for logging I/O to %ORIGINAL_FUNC%
    w = whos;
    inputs = struct();
    for a = 1:length(w)
        inputs.(w(a).name) = eval(w(a).name);
    end
    log_inputs('%FUNC_NAME%', inputs);

    %FUNC_CALL%;
    
    w = whos;
    outputs = struct();
    for a = 1:length(w)
        outputs.(w(a).name) = eval(w(a).name);
    end
    log_outputs('%FUNC_NAME%', outputs);
end
