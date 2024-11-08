library(dplyr)
library(readxl)


# Read raw data
here::i_am('code/00_clean_data.R')
data <- read_excel(here::here('data/cv19_on_sdoh_240930.xlsx'))


# Time period
data$TestDt <- as.Date(data$TestDt)
data$Wave_fct <- ifelse(data$TestDt < as.Date("2020-01-31"), "pre",
                        ifelse(data$TestDt < as.Date("2021-09-19"), "early",
                               ifelse(data$TestDt < as.Date("2023-05-11"), "late",
                                      ifelse(data$TestDt < Sys.Date(), "post", "NA"))))
data <- data[data$Wave_fct != "NA", ]
data$Wave_fct <- factor(data$Wave_fct,
                        levels = c("pre", "early", "late", "post"),
                        labels = c("pre pandemic", "early pandemic", "late pandemic", "post pandemic"))


# Gender
data$Gender <- factor(data$Gender, levels = c(1, 2), labels = c("Male", "Female"))


# SLAQ score
data <- data %>%
  group_by(Wave_fct) %>%
  mutate(SLAQscore = ifelse(is.na(SLAQscore), round(median(SLAQscore, na.rm = T)), SLAQscore))


# Poverty ratio
data <- data %>%
  group_by(Wave_fct) %>%
  mutate(PovertyRatio = ifelse(is.na(PovertyRatio), round(median(PovertyRatio, na.rm = T)), PovertyRatio))
data$PovertyRatio <- factor(data$PovertyRatio, levels = c(1, 2, 3, 4), labels = c("Below 100%", "100%-200%", "200%-400%", "Above 400%"))


# Insurance type
insurance <- c()
for (i in data$InsurType){
  if (is.na(i) == T){
    insurance <- c(insurance, NA)
  }else{
    type <- as.numeric(strsplit(i, split = ")")[[1]][1])
    insurance <- c(insurance, type)
  }
}
data$insur_fct <- insurance
data <- data %>%
  group_by(Wave_fct) %>%
  mutate(insur_fct = ifelse(is.na(insur_fct), round(median(insur_fct, na.rm = T)), insur_fct))
data$insur_fct <- factor(data$insur_fct, levels = c(1, 2, 3, 4, 5), labels = c("No Insurance", "Private", "Medicare/aid", "Medicare/aid", "Medicare/aid"))


# Stress score
data <- data %>%
  group_by(Wave_fct) %>%
  mutate(StressScore := ifelse(is.na(StressScore), median(StressScore, na.rm = TRUE), StressScore))


# Baseline data
data_bsl <- data %>%
  group_by(GSK_Recno) %>%
  arrange(Wave) %>%
  filter(row_number() == 1)
data_bsl <- data_bsl[data_bsl$Wave_fct == "pre pandemic", ]


# Baseline social isolation
data_bsl <- data_bsl %>%
  group_by(Wave_fct) %>%
  mutate(SocialIsolation6a_TScore = ifelse(is.na(SocialIsolation6a_TScore), round(median(SocialIsolation6a_TScore, na.rm = T)), SocialIsolation6a_TScore))
iso_quartiles <- c(0, 55, 60, Inf)
data_bsl$iso_fct <- cut(data_bsl$SocialIsolation6a_TScore, breaks = iso_quartiles, labels = c("Normal", "Mild", "Moderate & Severe"), include.lowest = TRUE)


# Baseline age
age_quartiles <- quantile(data_bsl$AgeAtSurvey, probs = seq(0, 1, 0.25))
data_bsl$age_fct <- cut(data_bsl$AgeAtSurvey, breaks = age_quartiles, labels = c("Age_g1", "Age_g2", "Age_g3", "Age_g4"), include.lowest = TRUE)


# Baseline SLAQ score
slaq_quartiles <- c(0, 10, 16, Inf)
data_bsl$slaq_fct <- cut(data_bsl$SLAQscore, breaks = slaq_quartiles, labels = c("Mild", "Moderate", "Severe"), include.lowest = TRUE)


# Baseline BILD score
bild_quartiles <- c(-Inf, 0, 2, Inf)
data_bsl$bild_fct <- cut(data_bsl$BILDscore, breaks = bild_quartiles, labels = c("No damage", "Mild damage", "Severe damage"), include.lowest = TRUE)


# Baseline poverty status
data_bsl$poverty_bsl <- ifelse(data_bsl$PovertyRatio %in% c("Below 100%", "100%-200%"), "high_poverty", "low_poverty")


# Baseline stress score
stress_quartiles <- c(0, 13, 26, Inf)
data_bsl$stress_fct <- cut(data_bsl$StressScore, breaks = stress_quartiles, labels = c("Low", "Moderate", "High"), include.lowest = TRUE)


# Merge baseline variables
data_bsl2 <- data_bsl[c("GSK_Recno", "iso_fct", "age_fct", "slaq_fct", "bild_fct", "poverty_bsl")]
data <- merge(data, data_bsl2, by = "GSK_Recno")


# Save cleaned data and baseline data
saveRDS(data, file = here::here('data/data_clean.rds'))
saveRDS(data_bsl, file = here::here('data/data_bsl.rds'))



