library(tidyverse)
library(scales)
library(hrbrthemes)
library(readxl)

source('./src/loaddata.R')
source('./src/functions.R')

all_years <- load_cls_size_data()

public_only <- all_years %>% filter_public()

# Create dataframes
k3.all_public <- public_only %>% filter_k_3() %>% summarize_cls_sizes_by_yr()
k3.metro <- public_only %>% filter_k_3() %>% filter_metro() %>% summarize_cls_sizes_by_yr()
k3.nonmetro <- public_only %>% filter_k_3() %>% filter(is_metro == FALSE) %>% summarize_cls_sizes_by_yr()
hs.core.metro <- public_only %>% filter_metro() %>% filter_hs() %>% filter(IsCore == TRUE) %>% summarize_cls_sizes_by_yr()

# Calculate maximums so that all plots can use the same axis
k3_poplims <- c(0,k3.metro %>% ungroup() %>% .$proportion_in_bin %>% max())

# Generate plots
plot.k3.all_public <- plot_heatmap(k3.all_public, "Alberta K-3 Class Sizes, All School Boards", pop_lims=k3_poplims)
plot.k3.metro <- plot_heatmap(k3.metro, "Alberta K-3 Class Sizes, Metro School Boards", pop_lims=k3_poplims)
plot.k3.nonmetro <- plot_heatmap(k3.nonmetro, "Alberta K-3 Class Sizes, Non-Metro School Boards", pop_lims=k3_poplims)
plot.hs.core.metro <- plot_heatmap(hs.core.metro,
                                   "Alberta 10-12 Class Sizes, Core Subjects, Metro School Boards",
                                   ylims=c(20,45),
                                   acol_recommendation=27
                                   )

# Show the plots
print(plot.k3.all_public)
print(plot.k3.metro)
print(plot.k3.nonmetro)
print(plot.hs.core.metro)

# Save plots
save_heatmap("images/k3_allpublic.png", plot.k3.all_public)
save_heatmap("images/k3_metro.png", plot.k3.metro)
save_heatmap("images/k3_nonmetro.png", plot.k3.nonmetro)
save_heatmap("images/hs_core_metro.png", plot.hs.core.metro)

