addpath('utils')
addpath('utc/UTC_Model')
addpath(genpath('wrapped'))

if ~exist('data/inputs', 'dir')
    mkdir("data/inputs")
end
if ~exist('data/outputs', 'dir')
    mkdir("data/outputs")
end
if ~exist('+data_functions', 'dir')
    mkdir("+data_functions")
end
if ~exist(fullfile('+data_functions, ViewFactor_ZH.mat'), 'file')
    copyfile(fullfile('utc/UTC_Model/+data_functions', 'ViewFactor_ZH.mat'), '+data_functions/ViewFactor_ZH.mat')
end

load(fullfile('utc/UTC_Model/+data_functions/', 'ForcingData_ZH2010.mat'));
MeteoDataZH_h = MeteoDataZH_h(1:2, :);
save(fullfile('+data_functions', 'ForcingData_ZH2010.mat'), 'MeteoDataZH_h');

original_dir = pwd;

ComputationZurich

close all
