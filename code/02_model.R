library(car)
library(lsmeans)
library(nlme)


# Read data
here::i_am('code/02_model.R')
data <- readRDS(file = here::here('data/data_clean.rds'))


# Linear mixed effects model
fit <- lme(StressScore ~ iso_fct * Wave_fct + Gender + age_fct + slaq_fct + bild_fct + PovertyRatio + insur_fct, random = ~ 1 | GSK_Recno, data = data)
means <- data.frame(lsmeans(fit, specs = c("iso_fct", "Wave_fct"), rg.limit = 15000))


# Regression table
regression_table <- data.frame(coef(summary(fit)))[, c(1, 2, 5)]


# Type 3 ANOVA
anova_table <- Anova(fit, type = "III")


# Table row names
regression_table_row_names <- c(
  "intercept", "social isolation: mild", "social isolation: moderate/severe",
  "time: early pandemic", "time: late pandemic", "time: post pandemic",
  "gender: female", "age: group 2", "age: group 3", "age: group 4",
  "SLAQ: moderate", "SLAQ: severe", "BILD: moderate", "BILD: severe",
  "poverty: 100%-200%", "poverty: 200%-400%", "poverty: above 400%",
  "insurance: private", "insurance: medicare/medicaid",
  "mild isolation & early pandemic", "moderate/severe isolation & early pandemic",
  "mild isolation & late pandemic", "moderate/severe isolation & late pandemic",
  "mild isolation & post pandemic", "moderate/severe isolation & post pandemic"
)
anova_table_row_names <- c(
  "intercept", "social isolation", "time", "gender", "age",
  "SLAQ", "BILD", "poverty", "insurance", "social isolation * time"
)
table_row_names <- list(
  regression = regression_table_row_names,
  anova = anova_table_row_names
)


# Save tables
saveRDS(means, file = here::here('output/means.rds'))
saveRDS(regression_table, file = here::here('output/regression_table.rds'))
saveRDS(table_row_names, file = here::here('output/table_row_names.rds'))
saveRDS(anova_table, file = here::here('output/anova_table.rds'))



