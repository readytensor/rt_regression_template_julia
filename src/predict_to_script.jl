import LazyJSON

function notebook_to_script(ipynb_filename::String, jl_filename::String)
    # Read the file content
    file_content = read(ipynb_filename, String)

    # Lazily parse the Jupyter notebook
    data = LazyJSON.parse(file_content)

    # Open the output Julia script file for writing
    open(jl_filename, "w") do f
        for cell in data["cells"]
            if cell["cell_type"] == "code"
                write(f, "#= Start of Cell =#\n")
                write(f, join(cell["source"], "\n"))
                write(f, "\n#= End of Cell =#\n\n")
            end
        end
    end
end

notebook_to_script("predict.ipynb", "predict.jl")
