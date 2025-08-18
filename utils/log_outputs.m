function log_outputs(funcName, outputs)
% LOG_OUTPUTS Logs function outputs to a MAT file
%
% outputs:
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

    % Convert NaN and Inf to strings in top-level fields
    fields = fieldnames(outputs);
    for i = 1:numel(fields)
        val = outputs.(fields{i});
        if isnumeric(val) && isscalar(val)
            if isnan(val)
                outputs.(fields{i}) = 'NaN';
            elseif isinf(val)
                outputs.(fields{i}) = 'Inf';
                if val < 0
                    outputs.(fields{i}) = '-Inf';
                end
            end
        end
    end

    % Encode to JSON
    if verLessThan('matlab', '9.11')
        jsonStr = jsonencode(outputs);
    else
        jsonStr = jsonencode(outputs, 'PrettyPrint', true);
    end

    % Write file
    filename = fullfile('data/outputs', [funcName '.json']);
    fid = fopen(filename, 'w');
    fwrite(fid, jsonStr, 'char');
    fclose(fid);
end
