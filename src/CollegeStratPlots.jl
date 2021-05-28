module CollegeStratPlots

using DocStringExtensions, StatsBase
using Plots, Plots.PlotMeasures, StatsPlots
using FilesLH
using CollegeStratBase

export plot_settings, plot_setting, plot_defaults, subplot_layout
export blank_plot, sub_plots, histogram_plot, scatter_plot, contour_plot
export bar_graph, grouped_bar_graph
export line_plot, add_line!, add_title!, plot_text
export figsave

include("plot_settings.jl");
include("saving.jl");
include("bar_graphs.jl");


"""
	$(SIGNATURES)

Make a legend (which is a Matrix) from a vector of strings.
"""
make_legend(v) = reshape(v, 1, length(v));


"""
	$(SIGNATURES)

Make layout for subplots of `nPlots` equally sized plots.
"""
function subplot_layout(nPlots)
    if iseven(nPlots)
        nRows = round(Int, nPlots / 2);
        nCols = round(Int, 2);
    elseif nPlots == 3
        nRows = 1;
        nCols = nPlots;
    else
        error("Not implemented for $nPlots");
    end
    @assert (nRows * nCols) == nPlots  "Adding up fails: $nRows, $nCols"
    return nRows, nCols
end

"""
	$(SIGNATURES)

Render a set of plots as subplots.
"""
function sub_plots(pV; kwargs...)
    p = plot(pV...; kwargs...);
    return p
end

add_title!(p, titleStr; kwargs...) = title!(p, titleStr; kwargs...);

plot_text(lbl, sz, pos) = Plots.text(lbl, sz, pos);

# """
# 	$(SIGNATURES)

# Write table by [gpa, parental].
# """
# function table_by_gpa_parental(io,  data_gpM :: Matrix;  digits = 3)
#     ng, np = size(data_gpM);
#     if eltype(data_gpM) <: Number
#         data_gpM = string.(round.(data_gpM, digits = digits));
#     end
#     pretty_table(io,  hcat(gpa_labels(ng), data_gpM),  vcat(" ", parental_labels(np)));
#     return nothing;
# end


# # Grouped bar graph. Groups are dropouts and graduates.
# function plot_by_qual_grad(x_qgM, yStr :: AbstractString, fPath :: AbstractString)
#     # nq = size(x_qgM, 1);
#     p = grouped_bar_graph(["Dropouts", "Graduates"], x_qgM'; 
#         leg = :none, ylabel = yStr);

#     !isempty(fPath)  &&  figsave(p, fPath; dataM = x_qgM);
#     return p
# end




"""
	$(SIGNATURES)

Line graph. Simple wrapper around `plot`.
"""
function line_plot(xV, yM; kwargs ...)
    p = plot(xV, yM; kwargs...);
    return p
end

function line_plot(yM; kwargs ...)
    p = plot(yM; kwargs...);
    return p
end


"""
	$(SIGNATURES)

Add line to a plot.
"""
function add_line!(p, x, y; kwargs...)
    plot!(p, x, y; kwargs...);
end


"""
	$(SIGNATURES)

Scatter plot.
"""
function scatter_plot(x, y; kwargs...)
    p = scatter(x, y; kwargs...);
    return p
end


function histogram_plot(dataV; kwargs...)
    h = fit(Histogram, dataV);  # ++++++ where?
    p = plot(h; kwargs...)
    return p
end

function contour_plot(x, y, z; kwargs...)
    p = contour(x, y, z; kwargs...);
    return p
end


"""
	$(SIGNATURES)

Blank plot with options.
"""
blank_plot(; kwargs...) = plot(; kwargs...);

end
