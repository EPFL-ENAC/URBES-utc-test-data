function generate_wrappers(sourceDir, destDir, originalPrefix)
    % Find all .m files in original simulation package dirs
    mFiles = dir(fullfile(sourceDir, '**', '+*/**/*.m'));

    % Load template
    templatePath = fullfile(fileparts(mfilename('fullpath')), 'wrapper_template.m');
    template = fileread(templatePath);

    for k = 1:length(mFiles)
        fullPath = fullfile(mFiles(k).folder, mFiles(k).name);
        [~, funcName, ext] = fileparts(mFiles(k).name);
        if ~strcmp(ext, '.m'), continue; end

        % Extract function signature
        sig = extract_function_signature(fullPath);
        if isempty(sig)
            warning('Could not extract signature from %s', fullPath);
            continue;
        end

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

        % Parse signature parts
        parts = split(sig, '=');
        outputs = regexprep(string(parts(1)), 'function', '');
        fn = string(parts(2));
        fn = strcat([originalPrefix, pkgNames{1}], '.', strtrim(fn));

        % Create wrapper content from template
        content = template;
        content = strrep(content, '%FUNCTION_SIGNATURE%', sig);
        content = strrep(content, '%ORIGINAL_FUNC%', fqOriginalFunc);
        content = strrep(content, '%FUNC_NAME%', fqFuncName);
        content = strrep(content, '%OUTPUTS%', outputs);
        content = strrep(content, '%FUNC_CALL%', fn);

        % Write wrapper
        fid = fopen(wrapperPath, 'w');
        fprintf(fid, '%s', content);
        fclose(fid);
    end

    fprintf('Generated %i wrappers.\n', length(mFiles));
end
