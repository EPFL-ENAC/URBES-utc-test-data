addpath('utils')

duplicate_package('utc/UTC_Model', "wrapped", "utc_");
generate_wrappers('utc/UTC_Model', 'wrapped', 'utc_')