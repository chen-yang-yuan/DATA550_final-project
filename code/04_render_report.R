library(rmarkdown)

here::i_am('code/04_render_report.R')
render(here::here("report.Rmd"), output_file = "report.html")