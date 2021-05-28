# Return a Dict with plot settings. Easier to modify than a bunch of constants.
# - tickSize governs sizes of various fonts
function plot_settings()
    return Dict([
        :barLineWidth => 0,  # does not affect error bars
        :lineAlpha => nothing,  # for bar graphs
        :subPlotMargin => 3.0mm,
        :tickSize => 6,
        :markerStrokeWidth => 2,  # affects error bars
        :showScalarDev => true  # Show scalar deviations in plots?
    ])
end

bar_defaults() = Dict([
    :leg => :none,
    :xlabel => "",
    :ylabel => "",
    :margin => plot_setting(:subPlotMargin),
    :lw => 0
]);

grouped_bar_defaults() = Dict([
    :bar_position => :dodge,
    :leg => :bottomright,  
    :labels => data_model_labels(),  
    :markerstrokewidth => plot_setting(:markerStrokeWidth),
    :markerstrokecolor => :black, 
    :linecolor => :black,
    :lw => 0
]);


"""
	$(SIGNATURES)

Retrieve a named plot setting.

# Example
```
plot_setting(:tickSize) == 7
```
"""
function plot_setting(sName :: Symbol)
    ps = plot_settings();
    @assert haskey(ps, sName)  "$sName not found."
    return ps[sName]
end


function plot_defaults()
    ps = plot_settings();
    # Backend
    gr();
    # theme(:wong);
    theme(:sand);
    # guidefont: x and y axis labels
    fontColor = :match;
    tickSize = ps[:tickSize];
    tickFont = (tickSize, fontColor);
    default(linewidth = 2, xtickfont = tickFont, ytickfont = tickFont,
        titlefontsize = tickSize + 2, legendfont = (tickSize, fontColor), 
        guidefont = (tickSize, fontColor));
end


# ----------