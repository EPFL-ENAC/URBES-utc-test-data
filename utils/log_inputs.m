function log_inputs(funcName, inputs)
    filename = fullfile('data/inputs', [funcName '.mat']);
    save(filename, 'inputs');
end
