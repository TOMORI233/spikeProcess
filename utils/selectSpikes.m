function trialAll = selectSpikes(spikeTimeAll, trialAll, window)
    % [spikeTimeAll] can be a vector of spike times or a matrix of [spike,cluster]
    % Unit: ms

    if isvector(spikeTimeAll)
        spikeTimeAll = spikeTimeAll(:);
        spike = arrayfun(@(x) spikeTimeAll(spikeTimeAll(:, 1) >= x + window(1) & spikeTimeAll(:, 1) <= x + window(2), 1) - x, [trialAll.onset]', "UniformOutput", false);
        trialAll = addfield(trialAll, "spike", spike);
    else
        idx = arrayfun(@(x) spikeTimeAll(:, 1) >= x + window(1) & spikeTimeAll(:, 1) <= x + window(2), [trialAll.onset]', "UniformOutput", false);
        spike = arrayfun(@(x) spikeTimeAll(spikeTimeAll(:, 1) >= x + window(1) & spikeTimeAll(:, 1) <= x + window(2), 1) - x, [trialAll.onset]', "UniformOutput", false);
        trialAll = addfield(trialAll, "spike", cellfun(@(x, y) [x, spikeTimeAll(y, 2)], spike, idx, "UniformOutput", false));
    end
    
    return;
end