report.html: code/04_render_report.R report.Rmd output/table_one.rds output/model.png \
output/regression_table.rds output/table_row_names.rds output/anova_table.rds
	Rscript code/04_render_report.R

data/data_clean.rds data/data_bsl.rds: code/00_clean_data.R data/cv19_on_sdoh_240930.xlsx
	Rscript code/00_clean_data.R

output/table_one.rds: code/01_make_table1.R data/data_bsl.rds
	Rscript code/01_make_table1.R

output/means.rds output/regression_table.rds output/table_row_names.rds output/anova_table.rds: \
code/02_model.R data/data_clean.rds
	Rscript code/02_model.R

output/model.png: code/03_visualization.R output/means.rds
	Rscript code/03_visualization.R

.PHONY: clean
clean:
	rm -f data/*.rds output/*.rds output/*.png *.html