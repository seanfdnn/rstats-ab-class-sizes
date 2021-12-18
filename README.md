# Alberta Class Size Plotting
This R-code plots Alberta class sizes from 2004 to 2018 from the Government of Alberta Class Size Information System.

# Using
To use: 
* Download each Excel file from the [Government of Alberta](https://open.alberta.ca/opendata/class-size-by-school-year-jurisdiction-and-grade-alberta) an place in the `./data/` directory.
* Convert any `.xlsb` files to `.xlsx` manually, using Excel (Open -> Save As...)
* If you don't already have the following packages installed in R, install them:
```
install.packages(c("tidyverse","scales","hrbrthemes","readxl"))
```
* In R:
```
setwd('path/to/this/repo/')
source('./src/main.R')
```

# Rendered Plots
![Alberta K-3 Class Sizes, All School Boards](images/k3_allpublic.png?raw=true)
![Alberta K-3 Class Sizes, Metro School Boards](images/k3_metro.png?raw=true)
![Alberta K-3 Class Sizes, Non-Metro School Boards](images/k3_nonmetro.png?raw=true)
![Alberta 10-12 Class Sizes, Core Subjects, Metro School Boards](images/hs_core_metro.png?raw=true)