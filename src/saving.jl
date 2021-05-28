## -------------  Saving figures

"""
    figsave(p, filePath)

Save a figure to a pdf file. `hdf5` figures also have their data saved to a separate file.

# Arguments
- io: If provided, display a short version of the file path there.
- `dataM`: If provided, write the data to a text file. A simple method of preserving underlying data. 
"""
function figsave(p, filePath :: String; 
    figNotes = nothing, io :: Union{Nothing, IO} = nothing,
    dataM = nothing)

    if !isempty(filePath)
        # If HDF5: save to file and reload with default backend
        # This does not work in Julia 1.3 (world age problems)
        # if isa(p, Plots.Plot{Plots.HDF5Backend})
        #     hdf5Path = make_hdf5_path(filePath);
        #     save_hdf5_plot(p, hdf5Path);
        #     # Make a rendered plot that can be saved to pdf
        #     gr();
        #     p = Plots.hdf5plot_read(hdf5Path);
        # end

		newPath = change_extension(filePath, ".pdf");
        fDir, fName = splitdir(newPath);
        if !isdir(fDir)
            mkpath(fDir);
        end
        savefig(p, newPath);
        # hdf5();
        if !isnothing(io)
            pathStr = fpath_to_show(filePath);
            println(io, "Saved figure:  $pathStr");
        end
        
        save_fig_notes(figNotes, filePath);
        save_fig_data(dataM, filePath);
	end
end

figsave(p, fDir :: String, fName :: String; figNotes = nothing) =
    figsave(p, joinpath(fDir, fName); figNotes = figNotes);


function fig_data_dir(fPath :: AbstractString)
    fDir, fName = splitdir(fPath);
    newDir = joinpath(fDir, "plot_data");
    isdir(newDir)  ||  mkpath(newDir);
    return newDir
end

function make_hdf5_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension(fName, ".hdf5"));
end

# Save a plot to an HDF5 file
function save_hdf5_plot(p, fPath :: AbstractString)
    fDir, _ = splitdir(fPath);
    isdir(fDir)  ||  mkpath(fDir);
    Plots.hdf5plot_write(p, fPath);
    return nothing
end

save_fig_notes(figNotes :: AbstractVector, fPath :: AbstractString) =
    save_text_file(fig_notes_path(fPath), figNotes);
save_fig_notes(figNotes :: AbstractString, fPath :: AbstractString) = 
    save_fig_notes([figNotes], fPath);
function save_fig_notes(figNotes :: Nothing, fPath) end

function fig_notes_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension(fName, ".txt"));
    return newPath
end

function save_fig_data(dataM, filePath :: AbstractString)
    newPath = fig_data_path(filePath);
    make_dir(newPath);
    if !isnothing(dataM)
        open(newPath, "w") do io
            println(io, dataM);
        end
    end
end

function fig_data_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension("data_" * fName, ".txt"));
    return newPath
end


# --------------