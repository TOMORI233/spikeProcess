function out = selectSpikes(sortdata, trialAllOrtEvt, window)
% Efficient & vectorized spike extraction within relative window for each event time
% INPUT:
%   sortdata:       [N x 2] array [spikeTime, cluster] or [N x 1] vector of spike times
%   trialAllOrtEvt: [trialAll] (with field 'onset' representing [tEvt]) 
%                   or [tEvt] ([M x 1] or [1 x M] vector of event times)
%   window:         [1 x 2] window relative to [tEvt]
% OUTPUT:
%   out: If the second input is [trialAll], returns trialAll with extra field 'spike'.
%        If the second input is [tEvt], returns {M x 1} cell array of [spikeTime - t(i), cluster] 
%        when [sortdata] is [N x 2] array, or returns {M x 1} cell array of [spikeTime - t(i)] 
%        when [sortdata] is [N x 1] vector.
% NOTE:
%   Make sure all inputs are in the same unit (e.g., ms).

% Check if spikeTimes are ascending
if any(diff(sortdata(:, 1)) < 0)
    error('selectSpike:sortdataNotAscend', ...
          'The first column of sortdata (spike times) must be in ascending order.');
end

% Vectorized spike selection aligned to tEvt
spikeTimes = sortdata(:, 1);
hasClusterInfo = size(spikeTimes, 2) > 1;
if hasClusterInfo
    clusters = sortdata(:, 2);
end

switch class(trialAllOrtEvt)
    case 'struct'
        % as trialAll
        if isfield(trialAllOrtEvt, "onset")
            tEvt = [trialAllOrtEvt.onset]';
        else
            error("Input [trialAll] should contain field 'onset'.");
        end
    case {'single', 'double'}
        % as event times
        tEvt = trialAllOrtEvt(:);
    otherwise
        error("Invalid input");
end
numelEvt = numel(tEvt);

% Compute start/end of windows
winStart = tEvt + window(1);
winEnd   = tEvt + window(2);

% Use histcounts to find which window each spike belongs to
edges = sort([winStart; winEnd]); % 2*M edges
[~, ~, binIdx] = histcounts(spikeTimes, [-Inf; edges; Inf]);

% Only keep spikes that fall **inside some window** (binIdx even)
isInWindow = mod(binIdx,2)==0 & binIdx>0 & binIdx<=2*numelEvt;
binIdx = binIdx(isInWindow);
spikeTimesIn = spikeTimes(isInWindow);
if hasClusterInfo
    clustersIn = clusters(isInWindow);
end

% Map binIdx to t index
trialIdx = binIdx/2;  % now always <= M

% Align spike times
alignedSpikes = spikeTimesIn - tEvt(trialIdx);

% Group by trial
if hasClusterInfo
    spikesOut = accumarray(trialIdx, (1:numel(alignedSpikes))', [numelEvt, 1], ...
                           @(ix) {[alignedSpikes(ix), clustersIn(ix)]}, {zeros(0, 2)});
else
    spikesOut = accumarray(trialIdx, (1:numel(alignedSpikes))', [numelEvt, 1], ...
                           @(ix) {alignedSpikes(ix)}, {zeros(0, 1)});
end

if isstruct(trialAllOrtEvt)
    out = mu.addfield(trialAllOrtEvt, "spike", spikesOut);
else
    out = spikesOut;
end

return;
end
