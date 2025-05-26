function generate_wrappers(sourceDir, destDir, originalPrefix)
    % Find all .m files in original simulation package dirs
    mFiles = dir(fullfile(sourceDir, '**', '+*/**/*.m'));

    for k = 1:length(mFiles)
        fullPath = fullfile(mFiles(k).folder, mFiles(k).name);
        [~, funcName, ext] = fileparts(mFiles(k).name);
        if ~strcmp(ext, '.m'), continue; end

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

        % Write wrapper
        fid = fopen(wrapperPath, 'w');
        fprintf(fid, 'function varargout = %s(varargin)\n', funcName);
        fprintf(fid, '%% Wrapper for logging I/O to %s\n', fqOriginalFunc);
        fprintf(fid, '    log_inputs(''%s'', varargin);\n', fqFuncName);
        fprintf(fid, '    [varargout{1:nargout}] = %s(varargin{:});\n', fqOriginalFunc);
        fprintf(fid, '    log_outputs(''%s'', varargout);\n', fqFuncName);
        fprintf(fid, 'end\n');
        fclose(fid);
    end

    fprintf('Generated %i wrappers.\n', length(mFiles));
end
