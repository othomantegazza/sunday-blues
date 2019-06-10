library(tidyverse)
library(eurostat)
library(lubridate)
library(grid)

# weekdays in english
Sys.setlocale("LC_TIME", "en_US.UTF8")

# colours
violet <- "#70308F"

# ggplot theme
theme_set(theme_minimal() + 
            theme(axis.title = element_text(hjust = 1, size = 10,
                                            colour = "grey10"),
                  plot.caption = element_text(colour = violet, 
                                              # colour = "grey10",
                                              size = 8))
)

# get crop codes ----------------------------------------------------------


# eustat_info <- 
  # search_eurostat("crop")


# ef_oluft
# Land use: number of farms and areas of different crops by type of farming (2-digit)	

# ef_oluaareg
# Land use: number of farms and areas of different crops by agricultural size of farm (UAA) and NUTS 2 regions	

ef_oluaareg_path <- "content/post/_data/ef_oluaareg.Rdata"

if(!file.exists(ef_oluaareg_path)) {
ef_oluaareg <- 
  get_eurostat("ef_oluaareg") 

save(ef_oluaareg, file = ef_oluaareg_path)
} else { 
  load(ef_oluaareg_path)
}

eu_crops <-
  ef_oluaareg %>% 
  # keep only countries 
  mutate_if(.predicate = is.factor, as.character) %>%
  filter(!str_detect(geo, pattern = "\\d")) %>% 
  # use descriptive labels
  label_eurostat(fix_duplicated = T) # %>% View()

save(eu_crops, file = "content/post/_data/ef_oluaareg2.Rdata")

eu_crops <- 
  eu_crops %>% 
# Small fix to countries
  filter(!geo %in% 	c("Nordrhein-Westfalen", "Rheinland-Pfalz",
                      "Saarland", "Sachsen", "Sachsen-Anhalt",
                      "Schleswig-Holstein", "Thüringen")) %>% 
  mutate(geo = case_when(geo %>% str_detect("Germany") ~ "Germany",
                         TRUE ~ geo)) %>%
  # pull(agrarea) %>% table()
  filter(agrarea == "Total") %>% 
  filter(time == max(time))

eu_crops %>% 
  group_by(indic_ef) %>%
  summarise(prod = sum(values, na.rm = T)) %>% 
  arrange(desc(prod)) %>% View
  # ggplot(aes(x = reorder(indic_ef, prod),
  #            y = prod)) +
  # geom_boxplot() +
  # coord_flip()


# Plot eu crop area -------------------------------------------------------

crops_in <- c("ha: Common wheat and spelt",
              "ha: Barley",
              "ha: Grain maize",
              "ha: Rape and turnip",
              # "ha: Green maize: Other green fodder: Fodder crops",
              "ha: Sunflower",
              "ha: Olive plantations - total",
              "ha: Oats",
              "ha: Vineyards - total",
              "ha: Rye",
              "ha: Durum wheat")

p_crops <- 
  eu_crops %>% 
  filter(indic_ef %in% crops_in) %>% 
  mutate(indic_ef = indic_ef %>% str_remove("ha: ")) %>% 
  ggplot(aes(x = reorder(indic_ef, values),
             y = values)) +
  geom_boxplot(colour = violet, fill = "grey95") +
  ggrepel::geom_text_repel(data = . %>% 
                             group_by(indic_ef) %>% 
                             filter(values == max(values)),
                           aes(label = geo),
                           size = 3,
                           nudge_x = -.3,
                           nudge_y = 4e+05,
                           colour = "grey30") +
  # scale_y_log10() +
  coord_flip() +
  labs(y = "Crop Area by Country [Ha]",
       x = "",
       caption = "Data from Eurostat") 

p_crops

ggsave(filename = "static/_plots/2019-05-26-main-crops.svg",
       width = 7.4,
       height = 3.7)
svglite::svglite("static/_plots/2019-05-26-main-crops.svg",
                 width = 7.4,
                 height = 3.7,
                 pointsize = 1)
p_crops %>% print()
dev.off()
