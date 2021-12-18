# Each Excel file from the Class Size Information System must be downloaded
# from the Government of Alberta and placed in the `/data` directory
# All files must be in .XLSX (not .XLSB) format, so some files may need to 
# be manually converted in Excel first (presently, only the 2018 file needs
# to be converted)
# https://open.alberta.ca/opendata/class-size-by-school-year-jurisdiction-and-grade-alberta

all_years <- Sys.glob("./data/csis*.xlsx") %>% lapply(read_excel) %>% bind_rows

# Apply data types
all_years <- all_years %>% mutate(nbr_students = as.numeric(nbr_students))
all_years <- all_years %>% mutate(IsCore = as.logical(IsCore))

# Add the column if its a metro school or not
# CCSD, ECSD, CBE, EPSB
metro_auth_cds <- c(3030, 3020, 4010, '0110')
all_years <- all_years %>% mutate(is_metro = auth_cd %in% metro_auth_cds)