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

    % Convert NaN and Inf to strings in top-level fields
    fields = fieldnames(inputs);
    for i = 1:numel(fields)
        val = inputs.(fields{i});
        if isnumeric(val) && isscalar(val)
            if isnan(val)
                inputs.(fields{i}) = 'NaN';
            elseif isinf(val)
                inputs.(fields{i}) = 'Inf';
                if val < 0
                    inputs.(fields{i}) = '-Inf';
                end
            end
        end
    end

    % Encode to JSON
    if verLessThan('matlab', '9.11')
        jsonStr = jsonencode(inputs);
    else
        jsonStr = jsonencode(inputs, 'PrettyPrint', true);
    end

    % Write file
    filename = fullfile('data/inputs', [funcName '.json']);
    fid = fopen(filename, 'w');
    fwrite(fid, jsonStr, 'char');
    fclose(fid);
end
