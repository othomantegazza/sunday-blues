library(tidyverse)
library(eurostat)
library(lubridate)
library(ggforce)
library(svglite)

# get data ----------------------------------------------------------------


data_file <- "content/post/_data/eu_agristructure.Rdata"

if(!file.exists(data_file)) {
  
  toc <- get_eurostat_toc()
  
  tabs <- c(ef_kvaareg = "ef_kvaareg", # area binned by holding size?
            ef_lflegaa = "ef_lflegaa", # workforce
            ef_lfwtime = "ef_lfwtime", # workforce?
            demo_r_d3area = "demo_r_d3area",
            ef_oluft = "ef_oluft")
  
  # all administrative levels 
  dfs <- 
    tabs %>% 
    map(~ get_eurostat(.) %>% 
          mutate_if(.predicate = is.factor, as.character)) %>% 
    map(~label_eurostat(., fix_duplicated = T))
  
  # only countries
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

# workforce vs agricultural hacres ------------------------------------------
n_holds <- 
  # dfs$ef_kvaareg %>% 
  dfs_countries$ef_kvaareg %>%
  filter(indic_ef %in% c("ha: Utilised agricultural area",                      
                         "AWU: Total: Labour force directly employed by the holding"),
         legtype == "Total") %>% 
  spread(key = "indic_ef", value = "values") %>% 
  janitor::clean_names() %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) 

# comet plot of worker per ha ---------------------------------------------

# draft the comet, you need median of previous year
# or mean maybe better?
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

point_col <- "#B63A82"

p <- 
  to_comet %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) %>% 
  ggplot(aes(x = ha,
             y = workers)) +
  geom_link(aes(xend = med_ha,
                yend = med_workers,
                alpha = ..index..,
                size = ..index..),
            colour = point_col) +
  geom_point(size = 1.7, colour = point_col) +
  ggrepel::geom_text_repel(aes(label = geo),
                           size = 3,
                           colour = "grey20",
                           nudge_y = -.03) +
  # geom_text(data = . %>% 
  #             filter(workers > 400000),
  #           aes(label = geo)) +
  scale_y_log10() +
  scale_x_log10() +
  scale_alpha_continuous(range = c(1, .1), guide = FALSE) +
  scale_size_continuous(range = c(3, .1), guide = FALSE) +
  theme_bw() +
  labs(x = "Cultivated Area",
       y = "Number of Agricultural Workers",
       caption = str_wrap("The points are 2013 measurements, the trails are 
                          the median of 2005, 2007 and 2010 measurements.",
                          width = 120) %>% 
         paste("~ Data from Eurostat", sep = "\n"))

# small checks
n_holds %>% 
  filter(geo == "Poland",
         agrarea == "Total")


# Save plot ---------------------------------------------------------------

svglite(file = "content/post/_plots/28-04-2019-workers-per-ha.svg")
p %>% print()
dev.off()


# Workforce vs number of holds --------------------------------------------

holds_ws <- 
  # dfs$ef_kvaareg %>% 
  dfs_countries$ef_kvaareg %>%
  filter(indic_ef %in% c("hold: Total number of holdings",                      
                         "AWU: Total: Labour force directly employed by the holding"),
         legtype == "Total") %>% 
  spread(key = "indic_ef", value = "values") %>% 
  janitor::clean_names() %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) 

# comet plot of worker per holding ---------------------------------------------

# draft the comet, you need median of previous year
# or mean maybe better?
comet_holds_ws <- 
  holds_ws %>% 
  filter(agrarea == "Total") %>%
  rename(n_holds = "hold_total_number_of_holdings",
         workers = "awu_total_labour_force_directly_employed_by_the_holding")


comet_holds_ws_med <-
  comet_holds_ws %>% 
  filter(year(time) < 2013) %>% 
  group_by(geo) %>% 
  summarise(med_holds = median(n_holds),
            med_workers = median(workers)) 

comet_holds_ws <- 
  comet_holds_ws %>%
  filter(year(time) == 2013) %>% 
  full_join(comet_holds_ws_med)

p2 <- 
  comet_holds_ws %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) %>% 
  ggplot(aes(x = n_holds,
             y = workers)) +
  geom_link(aes(xend = med_holds,
                yend = med_workers,
                alpha = ..index..,
                size = ..index..),
            colour = point_col) +
  geom_point(size = 1.7, colour = point_col) +
  ggrepel::geom_text_repel(aes(label = geo),
                           size = 3,
                           colour = "grey20",
                           nudge_y = -.03) +
  # geom_text(data = . %>% 
  #             filter(workers > 400000),
  #           aes(label = geo)) +
  scale_y_log10() +
  scale_x_log10() +
  scale_alpha_continuous(range = c(1, .1), guide = FALSE) +
  scale_size_continuous(range = c(3, .1), guide = FALSE) +
  theme_bw() +
  labs(x = "Number of Agricultural Holdings",
       y = "Number of Agricultural Workers",
       caption = str_wrap("The points are 2013 measurements, the trails are 
                          the median of 2005, 2007 and 2010 measurements.",
                          width = 120) %>% 
         paste("~ Data from Eurostat", sep = "\n"))

svglite(file = "content/post/_plots/28-04-2019-workers-per-holds.svg")
p2 %>% print()
dev.off()

# Euro standard Output vs workers ---------------------------------

ws_euros <- 
  # dfs$ef_kvaareg %>% 
  dfs_countries$ef_kvaareg %>%
  filter(indic_ef %in% c("Euro: Standard output (SO)",                      
                         "AWU: Total: Labour force directly employed by the holding"),
         legtype == "Total") %>% 
  spread(key = "indic_ef", value = "values") %>% 
  janitor::clean_names() %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) 

# comet plot of worker per holding ---------------------------------------------

# draft the comet, you need median of previous year
# or mean maybe better?
comet_ws_euros <- 
  ws_euros %>% 
  filter(agrarea == "Total") %>%
  rename(euro_soutput = "euro_standard_output_so",
         workers = "awu_total_labour_force_directly_employed_by_the_holding")


comet_ws_euros_med <-
  comet_ws_euros %>% 
  filter(year(time) < 2013) %>% 
  group_by(geo) %>% 
  summarise(med_euro_soutput = median(euro_soutput),
            med_workers = median(workers)) 

comet_ws_euros <- 
  comet_ws_euros %>%
  filter(year(time) == 2013) %>% 
  full_join(comet_ws_euros_med)

p3 <- 
  comet_ws_euros %>% 
  mutate(geo = geo %>% str_remove_all("\\(until 1990 former territory of the FRG\\)")) %>% 
  ggplot(aes(x = workers,
             y = euro_soutput)) +
  geom_link(aes(xend = med_workers,
                yend = med_euro_soutput,
                alpha = ..index..,
                size = ..index..),
            colour = point_col) +
  geom_point(size = 1.7, colour = point_col) +
  ggrepel::geom_text_repel(aes(label = geo),
                           size = 3,
                           colour = "grey20",
                           nudge_y = -.03) +
  # geom_text(data = . %>% 
  #             filter(workers > 400000),
  #           aes(label = geo)) +
  scale_y_log10() +
  scale_x_log10() +
  scale_alpha_continuous(range = c(1, .1), guide = FALSE) +
  scale_size_continuous(range = c(3, .1), guide = FALSE) +
  theme_bw() +
  labs(x = "Number of Agricultural Workers",
       y = "Standard Output [EUR]",
       caption = str_wrap("The points are 2013 measurements, the trails are 
                          the median of 2005, 2007 and 2010 measurements.",
                          width = 120) %>% 
         paste("~ Data from Eurostat", sep = "\n"))

svglite(file = "content/post/_plots/28-04-2019-output-vs-workers.svg")
p3 %>% print()
dev.off()
