library(ggplot2)


# Read means
here::i_am('code/03_visualization.R')
means <- readRDS(file = here::here('output/means.rds'))


# Visualization
p <- ggplot(means, aes(x = Wave_fct, y = lsmean, ymin = lower.CL, ymax = upper.CL, color = factor(iso_fct))) +
  geom_point(position = position_dodge(width = 0.3)) +
  geom_errorbar(position = position_dodge(width = 0.3), width = 0.2) +
  geom_line(aes(group = factor(iso_fct)), position = position_dodge(width = 0.3)) +
  labs(x = "Pandemic Period", y = "Stress Score", color = "Social Isolation") +
  scale_x_discrete(labels = c("Pre", "Early", "Late", "Post")) +
  scale_color_manual(values = c("#F8766D", "#7CAE00", "#00BFC4"), labels = c("Normal", "Mild", "Moderate & Severe")) +
  theme_bw() +
  theme(legend.position = "bottom")


# Save ggplot
ggsave(here::here('output/model.png'), plot = p, device = 'png', width = 6, height = 6, units = "in", dpi = 300)



