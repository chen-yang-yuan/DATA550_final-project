This repository carries the course project of __DATA 550: Data Science Toolkit (Fall 2024)__ at Emory University.

# Organizational structure

The main project folder contains several subfolders including `data`, `code`, `output`, and `report`.

* `data` folder carries both raw and cleaned data.

* `code` folder carries all codes for analysis.
    * `00_clean_data.R`: data cleaning
    * `01_make_table1.R`: makes demographic table
    * `02_model.R`: statistical modeling
    * `03_visualization.R`: displays fitted model in a figure
    * `04_render_report.R`: renders the final report

* `output` folder carries all intermediate outputs, stored as `.rds` and `.png` files.

* `report` folder carries the final compiled `report.html`. The report contains the following sections:
    * Introduction to the study
    * Descriptive analysis, where the demographic table is displayed
    * Regression analysis, where the model fitting results are presented as figures and tables
    * Findings and conclusions

Additionally, the main project folder includes `report.Rmd`, a Dockerfile, and a Makefile.

# Synchronize the package repository

To synchronize the package repository, navigate to the main project folder and run `make install` in the Rstudio terminal. This is a shortcut to running `renv::restore()`, which restores the package library.

# Build a Docker image

To build a Docker image from scratch that can be used to create the fully reproducible report, navigate to the main project folder and run `docker build -t chenyangyuan/project_image .` in the Rstudio terminal.

An image built from the Dockerfile has been uploaded to DockerHub: https://hub.docker.com/repository/docker/chenyangyuan/project_image/general.

Building the Docker image locally is __NOT__ required in this project, as the Makefile references the image on DockerHub.

# Run the Docker image and build the report

A make rule for `docker run` has been included in the Makefile. To run the automated version of the image and build the report, navigate to the main project folder and run `make report/report.html` in the Rstudio terminal. This command will generate the report inside the container (`project/report/`). As the container writes the output to the mounted volume (`report/`), the compiled report will eventually be available on the local machine.

In summary:
* The `Makefile` contains a rule that mounts the local `report` directory to the container.
* The report is generated and directly available in the local `report` folder.

Please note:
* Do not simply run `make` as the `make report/report.html` command is not on the top of the Makefile.
* The report can only be built on a __Mac__ system.