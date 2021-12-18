### Filters
# Filter function to return only public, catholic and francophone school boards (no charters)
filter_public <- function(.data) {
  .data %>% filter(grepl("Society", auth_nm, fixed=TRUE) == FALSE) %>% filter(!auth_cd %in% c(6019,6020,6017,'0224'))
}

# Filter function to return only the metro school boards (YYC and YEG)
filter_metro <- function(.data) {
  .data %>% filter(is_metro == TRUE)
}

# Filter function to return only Grade K-3, but only one subject (since K-3 are same class sizes)
filter_k_3 <- function(.data) {
  .data %>% filter(GradeGroup_id == 1) %>% filter(subject_nm %in% c("Language Arts English/French", "English/French Language Arts"))
}

# Filter function to return only high school (Gr 10-12)
filter_hs <- function(.data) {
  .data %>% filter(GradeGroup_id == 1)
}

summarize_student_pop <- function (.data, key) {
  .data %>% group_by(nbr_students) %>% count() %>% arrange(nbr_students) %>% mutate(num_students_in_bin = nbr_students * n) %>% mutate(proportion_in_bin = num_students_in_bin / sum(.$num_students_in_bin))
}

# Creates a grouping by year and summarizes
summarize_cls_sizes_by_yr <- function(.data) {
  .data %>% group_by(sch_yr) %>% group_modify(summarize_student_pop)
}

### Plots
plot_heatmap <- function(.data, title) {
  ggplot(.data, aes(sch_yr, nbr_students)) + geom_tile(aes(fill = proportion_in_bin)) +
    scale_fill_viridis_c(option="B", na.value="black", labels=scales::percent_format(accuracy=1), limits=c(0,0.127)) +  
    guides(fill=guide_legend(title="Proportion of Student Population (%)")) +
    ylim(9,31) +
    geom_text(data=.data %>% filter(sch_yr == 2006), label="ACOL Recommendation", y=17, color="white", hjust="left", vjust="top", nudge_x=0.2) +
    geom_hline(yintercept=17, color="white") +
    theme_ft_rc() + 
    labs(title = title,
         x = "Year", y = "Class Size", caption="Created by: @SeanDunn10\nData Source: Alberta Class Size Information System") +
    theme(plot.margin = margin(10,10,10,10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), plot.title.position="plot", plot.caption.position = "plot", legend.position="top")
}

plot_heatmap_hs <- function(.data, title) {
  ggplot(.data, aes(sch_yr, nbr_students)) + geom_tile(aes(fill = proportion_in_bin)) +
    scale_fill_viridis_c(option="B", na.value="black", labels=scales::percent_format(accuracy=1), limits=c(0,0.11)) +  
    guides(fill=guide_legend(title="Proportion of Student Population (%)")) +
    ylim(19,41) +
    theme_ft_rc() + 
    labs(title = title,
         x = "Year", y = "Class Size", caption="Created by: @SeanDunn10\nData Source: Alberta Class Size Information System") +
    theme(plot.margin = margin(10,10,10,10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), plot.title.position="plot", plot.caption.position = "plot", legend.position="top")
}

save_heatmap <- function(filepath, plot) {
  ggsave(filepath, plot, width=8, height=4.5)
}