function data = convert_fields(data)
    % Helper function to recursively convert NaN and Inf values to strings
    if isstruct(data)
        fields = fieldnames(data);
        for k = 1:numel(fields)
            data.(fields{k}) = convert_fields(data.(fields{k}));
        end
    elseif isnumeric(data)
        % Convert each element that is NaN or Inf to string
        for i = 1:numel(data)
            if isnan(data(i))
                data(i) = NaN;  % Keep as NaN for JSON null conversion
            elseif isinf(data(i))
                if data(i) > 0
                    data(i) = realmax;  % Replace Inf with largest finite number
                else
                    data(i) = -realmax;  % Replace -Inf with smallest finite number
                end
            end
        end
    end
end
