function varargout = plotRaster(trialAll, window)
    Fig = figure("WindowState", "normal");
    ax1 = mSubplot(Fig, 1, 1, 1, [1/2, 2/3], "alignment", "top-center");
    rasterData.X = {trialAll.spike}';
    mRaster(ax1, rasterData, 20);
    ylim([0, length(rasterData.X) + 1]);
    xticklabels(ax1, '');
    yticklabels(ax1, '');

    ax2 = mSubplot(Fig, 1, 1, 1, [1/2, 1/3], "alignment", "bottom-center");
    [psth, edges] = calPSTH(trialAll, window, 10, 5);
    plot(ax2, edges, psth, "Color", "k", "LineWidth", 2);
    xlabel(ax2, "Time from trial onset (ms)");
    ylabel(ax2, "Firing rate (Hz)");

    scaleAxes(Fig, "x", window);
    addLines2Axes(Fig, struct("X", 0));

    if nargout == 1
        varargout{1} = Fig;
    end

    return;
end