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
  .data %>% filter(GradeGroup_id == 4)
}

summarize_student_pop <- function (.data, key) {
  .data %>% group_by(nbr_students) %>% count() %>% arrange(nbr_students) %>% mutate(num_students_in_bin = nbr_students * n) %>% mutate(proportion_in_bin = num_students_in_bin / sum(.$num_students_in_bin))
}

# Creates a grouping by year and summarizes
summarize_cls_sizes_by_yr <- function(.data) {
  .data %>% group_by(sch_yr) %>% group_modify(summarize_student_pop)
}

### Plots
plot_heatmap <- function(.data, title, ylims=c(9,31), pop_lims=NULL, acol_recommendation=17) {
  
  pop_mean = .data %>% mutate(pop_mean = nbr_students * proportion_in_bin) %>% group_by(sch_yr) %>% summarise(pop_mean = sum(pop_mean))
  
  ggplot(.data, aes(sch_yr, nbr_students)) + 
    geom_tile(aes(fill = proportion_in_bin)) +
    scale_fill_viridis_c(option="B", labels=scales::percent_format(accuracy=1), limits=pop_lims) +  
    guides(fill=guide_colorbar(title="Proportion of Student Pop. (%)")) +
    scale_y_continuous(limits = ylims, expand = c(0, 0)) +
    geom_line(data=pop_mean, aes(x=sch_yr, y=pop_mean, group=1, color="Pop. Mean"), size=1.4) +
    geom_hline(aes(yintercept=acol_recommendation, color="ACOL Recommendation"), size=1.4) +
    scale_color_manual(name=NULL, values=c(ft_cols$red, ft_cols$white)) +
    theme_ft_rc(
      grid=FALSE
      ) + 
    labs(title = title,
         x = "Year", 
         y = "Class Size", 
         caption="Created by: @SeanDunn10\nData Source: Alberta Class Size Information System") +
    theme(plot.margin = margin(10,10,10,10),
          plot.title.position="plot",
          plot.caption.position = "plot",
          legend.position="top")
}

save_heatmap <- function(filepath, plot) {
  ggsave(filepath, plot, width=8, height=6)
}