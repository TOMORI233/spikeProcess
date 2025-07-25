function varargout = plotFRA(trialAll, window)
    narginchk(1, 2);

    if nargin < 2
        window = [0, 300]; % ms
    end

    Fig = figure("WindowState", "maximized");
    
    freq = unique([trialAll.freq])';
    att = unique([trialAll.att])';

    windowBase = [-100, 0]; % ms
    windowOnset = [0, 150]; % ms
    fr = nan(length(att), length(freq));

    for fIndex = 1:length(freq)
        for aIndex = 1:length(att)
            idx = [trialAll.freq] == freq(fIndex) & [trialAll.att] == att(aIndex);
            if any(idx)
                spikes = {trialAll(idx).spike}';
                nTrial = length(spikes);
                ax = mSubplot(Fig, length(att), length(freq), (aIndex - 1) * length(freq) + fIndex, "shape", "fill", "padding_bottom", 0.5, "padding_right", 0.05);
                rasterData.X = spikes;
                rasterData.color = "r";
                mRaster(ax, rasterData, 10);
                set(ax, "Box", "on");
                if aIndex ~= length(att) || fIndex ~= 1
                    set(ax, "XTickLabels", '');
                else
                    xticks(ax, window);
                end
                set(ax, "YTickLabels", '');
                xlim(window);
                ylim([0, nTrial + 1]);
                ax.TickLength = [0, 0];
                if fIndex == 1
                    text(ax, -diff(window) / 5, (nTrial + 1) / 2, num2str(max(att) - att(aIndex)), "HorizontalAlignment", "right");
                end
                if aIndex == 1
                    title(ax, num2str(freq(fIndex)));
                end
                
                spikes = cat(1, spikes{:});
                spikes1 = spikes(spikes >= windowBase(1) & spikes <= windowBase(2));
                spikes2 = spikes(spikes >= windowOnset(1) & spikes <= windowOnset(2));
                % fr(aIndex, fIndex) = (numel(spikes2) - numel(spikes1)) / (window(2) - window(1)) * 1000 / nTrial; % Hz
                fr(aIndex, fIndex) = numel(spikes2) / (window(2) - window(1)) * 1000 / nTrial; % Hz
            end
        end
    end

    ax = mSubplot(Fig, 1, 1, 1, "shape", "fill", "padding_top", 0.52, "padding_right", 0.05);
    imagesc(ax, fr);
    set(ax, "XLimitMethod", "tight");
    set(ax, "YLimitMethod", "tight");
    colormap(ax, "jet");
    mColorbar(ax, "Location", "eastoutside");
    ax.TickLength = [0, 0];
    set(ax, "XTickLabels", '');
    yticks(ax, 1:length(att));
    yticklabels(ax, num2str(max(att) - att(:)));

    if nargout == 1
        varargout{1} = Fig;
    end

    return;
end