library(cardx)
library(dplyr)
library(gtsummary)


# Read baseline data
here::i_am('code/01_make_table1.R')
data_bsl <- readRDS(file = here::here('data/data_bsl.rds'))


# Make table 1
table_one <- data_bsl %>%
  ungroup() %>%
  select("iso_fct", "Gender", "AgeAtSurvey", "age_fct", "SLAQscore", "slaq_fct", "BILDscore",  "bild_fct", "PovertyRatio", "insur_fct", "stress_fct") %>%
  tbl_summary(by = iso_fct, 
              label = list(
                Gender ~ "Gender",
                AgeAtSurvey ~ "Age",
                age_fct ~ "Age Group",
                SLAQscore ~ "SLAQ Score",
                slaq_fct ~ "SLAQ Group",
                BILDscore ~ "BILD Score",
                bild_fct ~ "BILD Group",
                PovertyRatio ~ "Poverty Ratio",
                insur_fct ~ "Insurance Type",
                stress_fct ~ "Stress Group"
              ),
              statistic = list(
                all_categorical() ~ "{n} ({p}%)",
                all_continuous() ~ "{mean} ({sd})"
              ),
              digits = list(
                all_categorical() ~ c(0, 1),
                all_continuous() ~ c(1, 1)
              )) %>%
  add_overall() %>%
  add_p()


# Save table 1
saveRDS(table_one, file = here::here('output/table_one.rds'))



