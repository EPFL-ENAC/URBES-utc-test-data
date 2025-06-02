function signature = extract_function_signature(filepath)
    % Read file content
    lines = readlines(filepath);

    % Find the first non-comment line that contains function declaration
    for i = 1:length(lines)
        line = strtrim(lines{i});
        % Skip empty lines and comment lines
        if isempty(line) || startsWith(line, '%')
            continue;
        end
        % If we find a function declaration, process it
        if startsWith(line, 'function')
            % Remove ... line continuations and merge lines
            sig = line;
            while i < length(lines) && (endsWith(strtrim(lines{i}), '...') || endsWith(strtrim(lines{i}), '....'))
                i = i + 1;
                nextLine = strtrim(lines{i});
                % Remove all trailing dots and spaces
                sig = regexprep(sig, '[.\s]+$', '');
                sig = [sig ' ' nextLine];
            end

            % Clean up the signature
            sig = regexprep(sig, '%.*$', '');  % Remove end-of-line comments
            signature = strtrim(sig);
            return;
        end
    end

    signature = '';
end
