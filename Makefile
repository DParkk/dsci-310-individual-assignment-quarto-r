# Authors: Jordan Bourak & Tiffany Timbers
# Date: 2021-11-22
.PHONY: all clean

# Run the entire process; remember to separate code changes into individual rules
all: 
	make clean
	make index.html

# Create index.html by copying the required dependencies
index.html: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	reports/qmd_example.html \
	reports/qmd_example.pdf
	cp reports/qmd_example.html docs/index.html  # Copy HTML to docs directory

# Generate figures and data for the report using source/generate_figures.R
# This will execute if any of the output files are missing or if source/generate_figures.R is more recent than the output files
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# Render Quarto report to HTML format
reports/qmd_example.html: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to html

# Render Quarto report to PDF format
reports/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf

# Clean up generated files, including the results directory and report files
clean:
	rm -rf results
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files 
	rm -rf docs/*
