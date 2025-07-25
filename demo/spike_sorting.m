ccc;

%% PATH
FraPATH = arrayfun(@(x) ['..\..\DATA\ISH20250425\Block-', num2str(x)], 1:6:30, "UniformOutput", false)';
NoisePATH = arrayfun(@(x) ['..\..\DATA\ISH20250425\Block-', num2str(x)], 2:6:30, "UniformOutput", false)';
PATH1 = arrayfun(@(x) ['..\..\DATA\ISH20250425\Block-', num2str(x)], 5:6:30, "UniformOutput", false)';
PATH2 = arrayfun(@(x) ['..\..\DATA\ISH20250425\Block-', num2str(x)], 6:6:30, "UniformOutput", false)';

%% Parameters
ch = 1;

%% Batch
for pIndex = 1:length(NoisePATH)
    % Noise
    dataNoise = TDTbin2mat(NoisePATH{pIndex});
    [trialAllNoise, ITI] = noiseProcessFcn(dataNoise.epocs);
    sortResNoise = mysort(dataNoise, ch, "reselect", "preview");
    window = [-100, ITI];
    trialAllNoise = selectSpikes(sortResNoise.spikeTimeAll(sortResNoise.clusterIdx == 1) * 1000, ...
                                 trialAllNoise, window);
    plotNoiseResponse(trialAllNoise);
    addTitle2Fig(['Neuron No. ', num2str(pIndex)]);

    % FRA
    dataFRA = TDTbin2mat(FraPATH{pIndex});
    [trialAllFRA, ITI] = fraProcessFcn(dataFRA.epocs);
    window = [-100, ITI];
    sortResFRA = templateMatching(dataFRA, sortResNoise, ch);
    trialAllFRA = selectSpikes(sortResFRA.spikeTimeAll(sortResFRA.clusterIdx == 1) * 1000, ...
                               trialAllFRA, window);
    plotFRA(trialAllFRA);
    addTitle2Fig(['Neuron No. ', num2str(pIndex)]);

    % TCI
    data1 = TDTbin2mat(PATH1{pIndex}); % seg-31
    data2 = TDTbin2mat(PATH2{pIndex}); % seg-63,125,250,500
    [trialAll1, ITI] = tciProcessFcn(data1.epocs);
    [trialAll2, ~] = tciProcessFcn(data2.epocs);
    window = [-100, ITI];
    sortRes1 = templateMatching(data1, sortResNoise, ch);
    sortRes2 = templateMatching(data2, sortResNoise, ch);
    trialAll1 = selectSpikes(sortRes1.spikeTimeAll(sortRes1.clusterIdx == 1) * 1000, ...
                             trialAll1, window);
    trialAll2 = selectSpikes(sortRes2.spikeTimeAll(sortRes2.clusterIdx == 1) * 1000, ...
                             trialAll2, window);

    for dIndex = 1:1
        seg = 500/2^(5 - dIndex); % ms
        tSeg = seg:seg:20000;
        tSeg = tSeg(tSeg > 1000)';
        temp = arrayfun(@(x) arrayfun(@(y) x.spike(x.spike >= y & x.spike < y + seg), tSeg, "UniformOutput", false), trialAll1, "UniformOutput", false);
        arrayfun(@(x) cat(1, temp{[trialAll1.order] == x}), unique([trialAll1.order])', "UniformOutput", false);
    end
    
end

