function duplicate_package(sourceDir, destDir, originalPrefix, main_functions)
% DUPLICATE_PACKAGE Duplicates a MATLAB package and specified main functions
%
% Inputs:
%   sourceDir      - Source directory containing the original MATLAB files
%   destDir        - Destination directory for duplicated files
%   originalPrefix - Prefix to be added to package and function names
%   main_functions - Optional cell array of main folder function names to duplicate

    if nargin < 4
        main_functions = {};
    end

    % Find all +package folders
    packageDirs = dir(fullfile(sourceDir, '**', '+*'));
    packageDirs = packageDirs([packageDirs.isdir]);

    % Handle package folders
    for i = 1:length(packageDirs)
        pkgPath = fullfile(packageDirs(i).folder, packageDirs(i).name);
        pkgName = erase(packageDirs(i).name, '+');
        newPkgName = strcat("+", originalPrefix, pkgName);

        destPath = fullfile(destDir, newPkgName);
        if ~exist(destPath, 'dir')
            mkdir(destPath);
        end

        % Copy all .m files
        mFiles = dir(fullfile(pkgPath, '*.m'));
        for f = 1:length(mFiles)
            copyfile(fullfile(pkgPath, mFiles(f).name), destPath);
        end
    end

    % Handle specified main folder functions
    mainCount = 0;
    for i = 1:length(main_functions)
        srcFile = fullfile(sourceDir, [main_functions{i}, '.m']);
        if exist(srcFile, 'file')
            newName = originalPrefix + main_functions{i} + '.m';
            copyfile(srcFile, fullfile(destDir, newName));
            mainCount = mainCount + 1;
        end
    end

    fprintf('Copied %i packages and %i main functions to %s.\n', ...
            length(packageDirs), mainCount, destDir);
end
