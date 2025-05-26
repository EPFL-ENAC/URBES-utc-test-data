function duplicate_package(sourceDir, destDir, originalPrefix)
    % Find all +package folders
    packageDirs = dir(fullfile(sourceDir, '**', '+*'));
    packageDirs = packageDirs([packageDirs.isdir]);

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

    disp(strcat('Copied ', num2str(length(packageDirs)), ' packages to ', destDir));
end
