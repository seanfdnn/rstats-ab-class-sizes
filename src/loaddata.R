# This R script defines functions for loading class size data

load_cls_size_data <- function() {
  read_parquet('./data/class_sizes.parquet')
}