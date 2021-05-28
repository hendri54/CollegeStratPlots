using CollegeStratBase, CollegeStratPlots
using Test

csp = CollegeStratPlots;

function fig_test_setup(figName)
    fPath = joinpath(CollegeStratBase.test_dir(), figName);
    notesPath = csp.fig_notes_path(fPath);
    isfile(fPath)  &&  rm(fPath);
    isfile(notesPath)  &&  rm(notesPath);

    plot_defaults();
    return fPath, notesPath
end


function fig_save_test()
    @testset "Save figure" begin
        fPath, notesPath = fig_test_setup("fig_save_test.pdf");
        p = csp.test_bar_graph();

        fNotes = ["This is a test figure.", "With figure notes"];
        figsave(p, fPath; figNotes = fNotes);
        @test isfile(fPath)
        @test isfile(notesPath)
    end
end

function grouped_bar_test()
    @testset "Grouped bar graph" begin
        fPath, notesPath = fig_test_setup("grouped_bar_test.pdf");
        nr = 5; nc = 6;
        dataM = (1:nr) .+ (1 : nc)';
        p = grouped_bar_graph(string.(1:nr), dataM);
        figsave(p, fPath; figNotes = ["Notes"]);
        @test isfile(fPath)
        @test isfile(notesPath)
    end
end


function histogram_test()
    @testset "Histogram" begin
        fPath, notesPath = fig_test_setup("histogram_test.pdf");
        p = histogram_plot(LinRange(-3.0, 4.0, 1000); xlabel = "x")
        figsave(p, fPath);
        @test isfile(fPath);
    end
end

function subplot_test()
    @testset "Subplots" begin
        nPlots = 3;
        pV = Vector{Any}(undef, nPlots);
        for ip = 1 : nPlots
            pV[ip] = csp.test_bar_graph();
        end
        p = sub_plots(pV; link = :all);
        fPath, notesPath = fig_test_setup("subplots_test.pdf");
        figsave(p, fPath);
    end
end


function line_plot_test()
    @testset "Line plot" begin
        fPath, notesPath = fig_test_setup("line_plot_test.pdf");
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, 4)';
        p = line_plot(xV, yM; xlabel = "x");
        figsave(p, fPath);
        @test isfile(fPath);

        fPath2, _ = fig_test_setup("add_line_test.pdf");
        yV = xV .+ 0.5;
        p = line_plot(xV, yV; ylabel = "y");
        add_line!(p, xV, yV .+ 1.0);
        figsave(p, fPath2);
        @test isfile(fPath2);
    end
end


@testset "CollegeStratPlots.jl" begin
    fig_save_test();
    grouped_bar_test();
    line_plot_test();
    subplot_test();
    histogram_test();
end

# ------------------