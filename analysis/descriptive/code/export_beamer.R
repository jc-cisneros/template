#######################
### export_beamer.R ###
#######################

# Load the required packages
library(tools)
library(stringr)

main <- function() {
    # Define the directory where your images are stored
    image_directory <- "output"
    image_files <- list.files(image_directory, pattern = "\\.png$", full.names = TRUE)

    # Start of the LaTeX document
    latex_content <- "\\documentclass{beamer}\n"
    latex_content <- paste0(latex_content, "\\usetheme{Madrid}\n")
    latex_content <- paste0(latex_content, "\\usepackage{graphicx}\n")
    latex_content <- paste0(latex_content, "\\title{Descriptive Plots Summary}\n")
    latex_content <- paste0(latex_content, "\\date{\\today}\n")
    latex_content <- paste0(latex_content, "\\begin{document}\n")
    latex_content <- paste0(latex_content, "\\frame{\\titlepage}\n")

    # Add a frame for each image file
    for (image in image_files) {
        image_path <- basename(file_path_sans_ext(image))
        slide_title <- gsub("_", " ", image_path)
        slide_title <- stringr::str_to_title(slide_title)
        latex_content <- paste0(latex_content, "\\begin{frame}{", slide_title, "}\n")
        latex_content <- paste0(latex_content, "\\begin{center}\n")
        latex_content <- paste0(latex_content, "\\includegraphics[width = 8cm, height = 7cm]{", image_path, "}\n")
        latex_content <- paste0(latex_content, "\\end{center}\n")
        latex_content <- paste0(latex_content, "\\end{frame}\n\n")
    }

    # End of the LaTeX document
    latex_content <- paste0(latex_content, "\\end{document}")

    # Write to a .tex file
    tex_file_path <- file.path(image_directory, "descriptive_plots.tex")
    writeLines(latex_content, tex_file_path)

    print("LaTeX Beamer presentation successfully created!")

    # Compile the LaTeX file into a PDF
    compile_pdf <- function(tex_file) {
        tryCatch({
            system2("pdflatex", c("-interaction=nonstopmode", tex_file), stdout = TRUE, stderr = TRUE)
            print("PDF successfully created!")
        }, error = function(e) {
            print("An error occurred while creating the PDF.")
        })
    }

    # Run the PDF compilation function
    setwd(image_directory)
    compile_pdf("descriptive_plots.tex")
}

# Run the main function
main()