library(tidyverse)
library(eurostat)
library(lubridate)
library(ggforce)

# get data ----------------------------------------------------------------


data_file <- "content/post/_data/eu_agristructure.Rdata"

if(!file.exists(data_file)) {
  
  toc <- get_eurostat_toc()
  
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
  
  
  dfs_countries <- 
    tabs %>% 
    map(~ get_eurostat(.) %>% 
          mutate_if(.predicate = is.factor, as.character) %>% 
          # keep only countries
          filter(!str_detect(geo, pattern = "\\d")) %>% 
          label_eurostat() %>% #pull(geo) %>% unique()
          # Why are these still there?
          filter(!geo %in% 	c("Nordrhein-Westfalen", "Rheinland-Pfalz",
                              "Saarland", "Sachsen", "Sachsen-Anhalt",
                              "Schleswig-Holstein", "Thüringen")))
  save(dfs, dfs_countries, file = data_file)
} else {
  load(data_file)
}

# kvaareg - agricultural area?
dfs$demo_r_d3area %>% View() 


# how are these datasetts composed ----------------------------------------

# kvaareg - agricultural area? --------------------------------------------
dfs$ef_kvaareg

# type of holding?
dfs$ef_kvaareg$legtype %>% unique()

# measurement
# stores total number of holdings
dfs$ef_kvaareg$indic_ef %>% unique()


# labour workforce --------------------------------------------------------
dfs$ef_lflegaa

# very detailed
dfs$ef_lflegaa$indic_ef %>% unique()

# it includes 2010, which is a full census
dfs$ef_lflegaa$time %>% unique()


# plot total number of holdings --------------------------------------------
n_holds <- 
  dfs$ef_kvaareg %>% 
  filter(indic_ef %in% c("hold: Total number of holdings",                      
                         "AWU: Total: Labour force directly employed by the holding"),
         legtype == "Total") %>% 
  spread(key = "indic_ef", value = "values") %>% 
  janitor::clean_names()


# workforce vs number of holdings binned by hacres 
n_holds %>% 
  ggplot(aes(x = hold_total_number_of_holdings,
             y = awu_total_labour_force_directly_employed_by_the_holding)) +
  geom_point() +
  facet_grid(time ~ agrarea) +
  scale_y_log10() +
  scale_x_log10()

# workforce vs agricultural hacres ------------------------------------------
n_holds <- 
  dfs$ef_kvaareg %>% 
  filter(indic_ef %in% c("ha: Utilised agricultural area",                      
                         "AWU: Total: Labour force directly employed by the holding"),
         legtype == "Total") %>% 
  spread(key = "indic_ef", value = "values") %>% 
  janitor::clean_names()

n_holds %>% 
  filter(agrarea == "Total") %>% 
  ggplot(aes(x = ha_utilised_agricultural_area,
             y = awu_total_labour_force_directly_employed_by_the_holding)) +
  geom_point() +
  facet_grid(time ~ agrarea) +
  scale_y_log10() +
  scale_x_log10()

# meh, no way to separate states?
n_holds %>% 
  filter(agrarea == "Total") %>% 
  pull(geo) %>% unique()


# comet plot of worker per ha ---------------------------------------------

to_comet <- 
  n_holds %>% 
  filter(agrarea == "Total") %>%
  rename(ha = "ha_utilised_agricultural_area",
         workers = "awu_total_labour_force_directly_employed_by_the_holding")


to_comet_med <-
  to_comet %>% 
  filter(year(time) < 2013) %>% 
  group_by(geo) %>% 
  summarise(med_ha = median(ha),
            med_workers = median(workers)) 

to_comet <- 
  to_comet %>%
  filter(year(time) == 2013) %>% 
  full_join(to_comet_med)

to_comet %>% 
  ggplot(aes(x = ha,
             y = workers)) +
  geom_link(aes(xend = med_ha,
                yend = med_workers,
                alpha = ..index..,
                size = ..index..)) +
  geom_point(size = .3) +
  # geom_text(data = . %>% 
  #             filter(workers > 400000),
  #           aes(label = geo)) +
  scale_y_log10() +
  scale_x_log10() +
  scale_alpha_continuous(range = c(1, .1), guide = FALSE) +
  scale_size_continuous(range = c(1, .1), guide = FALSE) +
  theme_bw()

n_holds %>% 
  filter(geo == "Poland",
         agrarea == "Total")


# country codess ----------------------------------------------------------

dfs_countries %>% 
  
