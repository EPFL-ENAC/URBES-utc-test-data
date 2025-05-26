function log_outputs(funcName, outputs)
    filename = fullfile('data/outputs', [funcName '.mat']);
    save(filename, 'outputs');
end
