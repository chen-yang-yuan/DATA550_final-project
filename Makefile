# Docker Hub username and image name
DOCKERHUB_NAME = chenyangyuan
IMAGE_TAG = project_image

# Define Docker run command with specific volume mounts
DOCKER_RUN = docker run \
	-v "$$(pwd)/data":/project/data \
	-v "$$(pwd)/code":/project/code \
	-v "$$(pwd)/output":/project/output \
	-v "$$(pwd)/report":/project/report \
	$(DOCKERHUB_NAME)/$(IMAGE_TAG)

# Data cleaning steps
data/data_clean.rds data/data_bsl.rds: code/00_clean_data.R data/cv19_on_sdoh_240930.xlsx
	mkdir -p data
	$(DOCKER_RUN) Rscript code/00_clean_data.R

# Table generation step depends on cleaned data
output/table_one.rds: code/01_make_table1.R data/data_bsl.rds
	mkdir -p output
	$(DOCKER_RUN) Rscript code/01_make_table1.R

# Modeling step depends on cleaned data
output/means.rds output/regression_table.rds output/table_row_names.rds output/anova_table.rds: \
code/02_model.R data/data_clean.rds
	mkdir -p output
	$(DOCKER_RUN) Rscript code/02_model.R

# Visualization step depends on modeling results
output/model.png: code/03_visualization.R output/means.rds
	mkdir -p output
	$(DOCKER_RUN) Rscript code/03_visualization.R

# Final report depends on all the intermediate outputs
report/report.html: code/04_render_report.R report.Rmd output/table_one.rds output/model.png \
output/regression_table.rds output/table_row_names.rds output/anova_table.rds
	mkdir -p report
	$(DOCKER_RUN) Rscript code/04_render_report.R

# Clean up generated files
.PHONY: clean
clean:
	rm -f data/*.rds output/*.rds output/*.png report/*.html

# Install dependencies in a Docker container
.PHONY: install
install:
	docker run --rm \
		-v "$$(pwd)/renv":/project/renv \
		-v "$$(pwd)/renv.lock":/project/renv.lock \
		-v "$$(pwd)/.Rprofile":/project/.Rprofile \
		$(DOCKERHUB_NAME)/$(IMAGE_TAG) \
		Rscript -e "renv::restore(prompt = FALSE)"

.PHONY: generate_report
generate_report:
	$(DOCKER_RUN) Rscript code/04_render_report.R