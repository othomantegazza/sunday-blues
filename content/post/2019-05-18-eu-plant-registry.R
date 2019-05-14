library(tidyverse)
library(readxl)
# library(eurostat)
library(lubridate)
# library(ggforce)
library(svglite)

# get data ----------------------------------------------------------------

fruit_url <- paste0("https://ec.europa.eu/food/sites/food/files/plant/docs/",
                    "plant-variety-catalogues_frumatis-eu-list.xlsx?")

fruit_path <- "content/post/_data/eu_fruit_registry.Rdata"

if(!file.exists(fruit_path)) {
  temp <- tempfile()
  download.file(fruit_url, temp)
  
  fruits_2016 <-
    read_excel(path = temp, sheet = 1, skip = 1) %>% 
    janitor::clean_names()
  
  fruits_2017 <-
    read_excel(path = temp, sheet = 2, skip = 1) %>% 
    janitor::clean_names() %>% 
    mutate(end_registration_validity = end_registration_validity %>% as.numeric())
  

  save(fruits_2016, fruits_2017, file = fruit_path)
} else {
  load(fruit_path)
}


# wrangle -----------------------------------------------------------------

fruits <- 
  bind_rows(fruits_2016, fruits_2017) %>% 
  filter(!is.na(species_name)) %>% 
  distinct()

# setdiff(names(fruits_2016), names(fruits_2017))

# names(fruits_2017)[!names(fruits_2017) %in% names(fruits_2016)]

# useless
fruits %>% pull(breeder_reference) %>% table() %>% sort(decreasing = TRUE) %>% head()


names(fruits)
# 
# [1] "member_states"                "genus_name"                   "species_name"                
# [4] "species_code"                 "species_common_name"          "synonym_common_name"         
# [7] "variety_denomination"         "synonym_variety_denomination" "variety_denomination_status" 
# [10] "description"                  "breeder_reference"            "application"                 
# [13] "status"                       "registration_code"            "ms_reference_1"              
# [16] "ms_reference_2"               "ms_reference_3"               "registration_date"           
# [19] "registration_renewal_date"    "end_registration_validity"    "plant_variety_right"         
# [22] "varietal_group"               "propagation_mode"             "rootstock_variety"           
# [25] "genetically_modified_variety" "breeder"                      "applicant"                   
# [28] "title_holder"                 "national_agent"               "maintainer"                  
# [31] "new_denomination_if_rejected" "rootstock_information"        "comments_and_remarks"        
# [34] "common_name_in_english"       "application_date"             "arrival_date"                
# [37] "registration_granting_date"   "material_marketing_category" 

fruits %>% pull(breeder) %>% table() %>% sort(decreasing = TRUE) %>% head()

fruits %>% pull(applicant) %>% table() %>% sort(decreasing = TRUE) %>%  head()

fruits %>% pull(title_holder) %>% table() %>% sort(decreasing = TRUE) %>%  head()
