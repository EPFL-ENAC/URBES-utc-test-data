addpath('utils')

% Read excluded functions from file
fid = fopen('excluded_functions.txt', 'r');
excluded_functions = textscan(fid, '%s');
fclose(fid);
excluded_functions = excluded_functions{1};

duplicate_package('utc/UTC_Model', "wrapped", "utc_");
generate_wrappers('utc/UTC_Model', 'wrapped', 'utc_', excluded_functions)
