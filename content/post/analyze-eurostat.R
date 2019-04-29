library(tidyverse)
library(eurostat)

toc <- get_eurostat_toc()

data_file <- "content/post/_data/eu_agristructure.Rdata"

if(!file.exists(data_file)) {
  tabs <- c(ef_kvaareg = "ef_kvaareg", # area binned by holding size?
            ef_lflegaa = "ef_lflegaa", # workforce
            ef_lfwtime = "ef_lfwtime", # workforce?
            demo_r_d3area = "demo_r_d3area",
            ef_oluft = "ef_oluft")
  
  dfs <- 
    tabs %>% 
    map(~ get_eurostat(.) %>% 
          mutate_if(.predicate = is.factor, as.character)) %>% 
    map(~label_eurostat(., fix_duplicated = T))
  
  save(dfs, file = data_file)
} else {
  load(data_file)
}

# kvaareg - agricultural area?
dfs$demo_r_d3area %>% View() 
  