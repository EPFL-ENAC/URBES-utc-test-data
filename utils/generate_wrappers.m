function generate_wrappers(sourceDir, destDir, originalPrefix, excluded_functions)
% GENERATE_WRAPPERS Generates wrapper functions for a MATLAB package
%
% Inputs:
%   sourceDir         - Source directory containing the original MATLAB package files
%   destDir          - Destination directory for generated wrapper files
%   originalPrefix   - Prefix to be added to the original package name
%   excluded_functions - Optional cell array of function names to exclude (default: {})
%
% This function:
% 1. Finds all .m files in the source directory
% 2. Extracts function signatures from each file
% 3. Creates wrapper functions that redirect to the original functions
% 4. Maintains package structure (+pkg folders)
% 5. Adds tracing capabilities through the wrapper template

    if nargin < 4
        excluded_functions = {};
    end

    % Find all .m files in original simulation package dirs
    mFiles = dir(fullfile(sourceDir, '**', '+*/**/*.m'));

    % Load template
    templatePath = fullfile(fileparts(mfilename('fullpath')), 'wrapper_template.m');
    template = fileread(templatePath);

    for k = 1:length(mFiles)
        [~, funcName, ext] = fileparts(mFiles(k).name);
        if ~strcmp(ext, '.m'), continue; end

        % Skip excluded functions
        if ismember(funcName, excluded_functions)
            continue;
        end

        fullPath = fullfile(mFiles(k).folder, mFiles(k).name);

        % Extract function signature
        sig = extract_function_signature(fullPath);
        if isempty(sig)
            warning('Could not extract signature from %s', fullPath);
            continue;
        end

        % Parse signature parts
        parts = split(sig, '=');
        outputs = regexprep(string(parts(1)), 'function', '');
        equality = '=';
        if strcmp(outputs, '[]')
            outputs = '';
            equality = '';
        end
        inputs = string(regexp(sig, "(?<=\().*(?=\))", 'match'));

        % Extract relative path
        relPath = erase(fullPath, [sourceDir, filesep]);

        % Get package folder chain (+a/+b/+c)
        pkgFolders = regexp(relPath, '([+][^\\/]*)', 'match');
        if isempty(pkgFolders), continue; end

        % Original and wrapper package names
        pkgNames = erase(pkgFolders, '+');
        fqFuncName = strjoin([pkgNames, {funcName}], '.');
        fqOriginalFunc = strjoin([{[originalPrefix, pkgNames{1}]}, pkgNames(2:end), {funcName}], '.');

        % Build wrapper file path under traced/
        wrapperPkgPath = fullfile(destDir, fullfile(pkgFolders{:}));
        if ~exist(wrapperPkgPath, 'dir')
            mkdir(wrapperPkgPath);
        end
        wrapperPath = fullfile(wrapperPkgPath, [funcName, '.m']);

        fqCall = sprintf('%s %s %s(%s)', outputs, equality, fqOriginalFunc, regexprep(inputs, 'varargin(?!\{)', 'varargin{:}'));
        signature = sprintf('function %s %s %s(%s)', outputs, equality, funcName, inputs);

        % Create wrapper content from template
        content = template;
        content = strrep(content, '%FUNCTION_SIGNATURE%', signature);
        content = strrep(content, '%ORIGINAL_FUNC%', fqOriginalFunc);
        content = strrep(content, '%FUNC_NAME%', fqFuncName);
        content = strrep(content, '%FUNC_CALL%', fqCall);
        content = strrep(content, '%INPUTS%', inputs);

        % Write wrapper
        fid = fopen(wrapperPath, 'w');
        fprintf(fid, '%s', content);
        fclose(fid);
    end

    fprintf('Generated %i wrappers.\n', length(mFiles));
end
