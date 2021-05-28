"""
	$(SIGNATURES)

Bar graph. Simple wrapper for `bar` that applies default settings.
`dataV` can be a matrix. But then series are plotted on top of each other. This usually does not make sense.
"""
# There is no way to not show an xlabel (setting it to `nothing` shows "nothing")
function bar_graph(groupLabelV, dataV; kwargs...)
    @assert size(dataV, 1) == size(groupLabelV, 1);
    args = merge(bar_defaults(), kwargs);
    p = bar(groupLabelV, dataV;  args...);
    return p
end

function test_bar_graph()
    dataM = (1:10) .+ range(1.0, 1.5, length = 4)';
    p = bar_graph(string.(1 : 10), dataM,
        labels = ["Line 1"], xlabel = "x label",
        ylabel = "y label", margin = plot_setting(:subPlotMargin),
        linealpha = plot_setting(:lineAlpha));
    return p
end


"""
	$(SIGNATURES)

Grouped bar graph. Rows of `dataM` are groups.
"""
function grouped_bar_graph(xStrV, dataM; kwargs...)
    @assert size(xStrV, 1) == size(dataM, 1)  "Size mismatch: $(size(xStrV)), $(size(dataM))";
    args = merge(grouped_bar_defaults(), kwargs);
    p = groupedbar(xStrV, dataM; args...);
    return p
end


# ---------------