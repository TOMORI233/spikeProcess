function trialAll = selectSpikes(spikeTimeAll, trialAll, window)
    % Unit: ms
    trialAll = addfield(trialAll, "spike", arrayfun(@(x) spikeTimeAll(spikeTimeAll >= x + window(1) & spikeTimeAll <= x + window(2)) - x, [trialAll.onset]', "UniformOutput", false));
end