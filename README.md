This repository carries the course project of __DATA 550: Data Science Toolkit (Fall 2024)__ at Emory University.

# Organizational structure

The main project folder contains several subfolders including `data`, `code`, and `output`.

* `data` folder carries both raw and cleaned data.

* `code` folder carries all codes for analysis.
    * `00_clean_data.R`: data cleaning
    * `01_make_table1.R`: makes demographic table
    * `02_model.R`: statistical modeling
    * `03_visualization.R`: displays fitted model in a figure
    * `04_render_report.R`: renders the final report

* `output` folder carries all intermediate outputs, stored as `.rds` and `.png` files.

Additionally, the main project folder includes `report.Rmd` and its output `report.html`, as well as a Makefile specifying the rule for building the report.

# How to generate the report

The report contains the following sections:

* Introduction to the study

* Descriptive analysis, where the demographic table is displayed

* Regression analysis, where the model fitting results are presented as figures and tables

* Findings and conclusions

To generate the report, navigate to the main project folder and simply run `make` in the terminal. This command will sequentially clean the data, perform the analysis, and render the final report.

# How to synchronize the package repository

To synchronize the package repository, navigate to the main project folder and run `make install` in the terminal. This is a shortcut to running `renv::restore()`, which restores the package library.