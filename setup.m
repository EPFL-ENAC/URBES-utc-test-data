addpath('utils')

% Read excluded functions from file
fid = fopen('excluded_functions.txt', 'r');
excluded_functions = textscan(fid, '%s');
fclose(fid);
excluded_functions = excluded_functions{1};

main_functions = {...
    'EB_WB_canyon', 'EB_WB_roof', 'EBSolver_canyon', 'EBSolver_roof', ...
    'EBSolver_UrbanClimateBuildingEnergyModel', 'EnergyBalanceCheck', ...
    'fSolver_Tot', 'PlanAreaEnergyBalanceCalculation', 'UrbanClimateVariables', ...
    'WaterBalanceComponents'
};

duplicate_package('utc/UTC_Model', "wrapped", "utc_", main_functions);
generate_wrappers('utc/UTC_Model', 'wrapped', 'utc_', excluded_functions, main_functions);
