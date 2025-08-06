function varargout = plotRaster(trialAll, window)
    Fig = figure("WindowState", "normal");
    ax1 = mu.subplot(Fig, 1, 1, 1, [1/2, 2/3], "alignment", "center-top");
    rasterData.X = {trialAll.spike}';
    mu.rasterplot(ax1, rasterData, 20);
    ylim([0, length(rasterData.X) + 1]);
    xticklabels(ax1, '');
    yticklabels(ax1, '');

    ax2 = mu.subplot(Fig, 1, 1, 1, [1/2, 1/3], "alignment", "center-bottom");
    [psth, edges] = calPSTH(trialAll, window, 10, 5);
    plot(ax2, edges, psth, "Color", "k", "LineWidth", 2);
    xlabel(ax2, "Time from trial onset (ms)");
    ylabel(ax2, "Firing rate (Hz)");

    mu.scaleAxes(Fig, "x", window);
    mu.addLines(Fig, struct("X", 0));

    if nargout == 1
        varargout{1} = Fig;
    end

    return;
end