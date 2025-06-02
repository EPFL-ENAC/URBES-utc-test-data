function [Ofc,Oss,Owp,Ohy] = Soil_parametersII(ms,Osat,L,Pe,Ks,O33,nVG,alpVG,Kfc,Pss,Pwp,Phy,Ohy,SPAR)
% Wrapper for logging I/O to utc_soil_functions.Soil_parametersII
    w = whos;
    inputs = struct();
    for a = 1:length(w)
        inputs.(w(a).name) = eval(w(a).name);
    end
    log_inputs('soil_functions.Soil_parametersII', inputs);
    if nargin == 14
        [Ofc,Oss,Owp,Ohy] = utc_soil_functions.Soil_parametersII(ms,Osat,L,Pe,Ks,O33,nVG,alpVG,Kfc,Pss,Pwp,Phy,Ohy,SPAR);
    elseif nargin == 12
        [Ofc,Oss,Owp,Ohy] = utc_soil_functions.Soil_parametersII(ms,Osat,L,Pe,Ks,O33,nVG,alpVG,Kfc,Pss,Pwp,Phy);
    end

    w = whos;
    outputs = struct();
    for a = 1:length(w)
        outputs.(w(a).name) = eval(w(a).name);
    end
    log_outputs('soil_functions.Soil_parametersII', outputs);
end
