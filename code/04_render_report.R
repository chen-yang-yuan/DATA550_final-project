library(rmarkdown)

here::i_am('code/04_render_report.R')
render(here::here("report.Rmd"), output_file = here::here("report/report.html"))