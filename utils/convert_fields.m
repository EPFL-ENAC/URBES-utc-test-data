function data = convert_fields(data)
    % Helper function to recursively convert NaN and Inf values to strings
    if isstruct(data)
        fields = fieldnames(data);
        for k = 1:numel(fields)
            data.(fields{k}) = convert_fields(data.(fields{k}));
        end
    elseif isnumeric(data) && isscalar(data)
        if isnan(data)
            data = 'NaN';
        elseif isinf(data)
            if data > 0
                data = 'Inf';
            else
                data = '-Inf';
            end
        end
    end
end
