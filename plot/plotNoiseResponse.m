function varargout = plotNoiseResponse(trialAll, window)
narginchk(1, 2);

if nargin < 2
    window = [-100, 500];
end

Fig = figure("WindowState", "normal");
ax1 = mu.subplot(Fig, 1, 1, 1, [1/2, 2/3], "alignment", "center-top");
rasterData.X = {trialAll.spike}';
mu.rasterplot(ax1, rasterData, 20);
ylim([0, length(rasterData.X) + 1]);
xticklabels(ax1, '');
yticklabels(ax1, '');

ax2 = mu.subplot(Fig, 1, 1, 1, [1/2, 1/3], "alignment", "center-bottom");
[psth, edges] = mu_calPSTH(trialAll, window, 10, 5);
plot(ax2, edges, psth, "Color", "k", "LineWidth", 2);
xlabel(ax2, "Time from noise onset (ms)");
ylabel(ax2, "Firing rate (Hz)");

mu.scaleAxes(Fig, "x", window);
mu.addLines(Fig, struct("X", 0));

latency = mu_calLatency(trialAll, [0, 300], [-100, 0]);
if ~isempty(latency)
    mu.addLines(Fig, struct("X", latency, "color", "r"));
    title(ax1, ['Latency for onset response: ', num2str(latency), ' ms']);
else
    title(ax1, 'No significant onset response found');
end

if nargout == 1
    varargout{1} = Fig;
end

return;
end