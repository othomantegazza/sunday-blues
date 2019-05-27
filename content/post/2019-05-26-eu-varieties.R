library(tidyverse)
library(eurostat)
library(lubridate)

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
  label_eurostat(fix_duplicated = T) %>%  #View()
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
  arrange(desc(prod)) %>% # View
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
              "ha: Olive plantations - total")

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
       height = 3.3)

# Wheat -------------------------------------------------------------------

# Triticum Aestivum

wheat1 <- read_csv2("content/post/_data/wheat-1.csv")
wheat2 <- read_csv2("content/post/_data/wheat-2.csv") 

wheat <- 
  bind_rows(wheat1, wheat2) %>% 
  distinct() %>% 
  janitor::clean_names()

wheat %>% 
  group_by(status) %>% 
  count() %>% 
  arrange(desc(n))

# 1 Granted             1036
# 2 Terminated           824
# 3 Withdrawn             93
# 4 Active application    86
# 5 Refused               19

wheat %>% 
  group_by(species) %>% 
  count() %>% 
  arrange(desc(n))


# active applications

wheat %>% 
  filter(status == "Active application") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) #%>% View()

# 1 Limagrain Europe S.A.                     10
# 2 Apsovsementi S.p.A.                        6
# 3 RAGT 2n S.A.S.                             6
# 4 Sina Isabel Strube                         6
# 5 Wiersum Plantbreeding B.V.                 6
# 6 Florimond Desprez Veuve & Fils S.A.S.      4
# 7 Nordsaat Saatzucht GmbH                    4
# 8 S.I.S. Società Italiana Sementi S.p.A.     4
# 9 Syngenta Participations AG                 4
# 10 KWS Momont Recherche S.A.R.L.             3

wheat %>% 
  filter(status == "Granted") %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               TRUE ~ applicant)) %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) %>% #View()
  write_csv(path = "content/post/_data/wheat-applicants.csv")


companies <- 
  read_csv("content/post/_data/wheat-applicants-aff.csv") %>% 
  select(-site)

p_wheat <- 
  wheat %>% 
  filter(status == "Granted") %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               TRUE ~ applicant)) %>% 
  left_join(companies) %>% 
  mutate(daym = `year<-`(application_date, 2018),
         year = year(application_date),
         private = case_when(private == "cooperative" ~ "Private",
                             private == "yes" ~ "Private",
                             private == "no" ~ "Public")) %>% #View()
  drop_na(private) %>% 
  ggplot(aes(x = year,
             y = daym,
             colour = private)) +
  geom_count() +
  # ggrepel::geom_text_repel(data = . %>% 
  #                            filter(private == "Public") %>% 
  #                            distinct(application_date, applicant,
  #                                     .keep_all = TRUE),
  #                          aes(label = applicant),
  #                          size = 2) +
  scale_x_reverse(minor_breaks = function(x) {round(x[1]):round(x[2])}) +
  scale_y_date(date_labels = "%b %d") +
  scale_colour_manual(values = c("#99999966", violet)) +
  scale_size_continuous(guide = guide_legend(override.aes = list(colour = violet))) +
  coord_flip() +
  labs(x = "",
       y = "",
       colour = "Applicant",
       caption = "Data from cpvo.europa.eu, on 25-05-2019") +
  # guides(colour = guide_legend(title.position = "top"),
  #        size = guide_legend(title.position = "top")) +
  theme(legend.position = "top",
        legend.text = element_text(size = 7,
                                   colour = "grey20"),
        legend.title = element_text(size = 9,
                                    colour = "grey20"),
        legend.background = element_rect(size = 0,
                                         fill = "grey96"))

p_wheat

svglite::svglite(file = "static/_plots/2019-05-26-wheat-lite.svg",
                 height = 8,
                 width = 6)
p_wheat %>% print()
dev.off()


# Wheat main breeder ------------------------------------------------------

# Applications
wheat %>% 
  filter(status == "Active application") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) #%>% View()

# in market

wheat %>% 
  filter(status == "Granted") %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               TRUE ~ applicant)) %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) 



# Donut plot --------------------------------------------------------------


wheat_donut <- 
  wheat %>% 
  filter(status == "Granted") %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               applicant %>% str_detect("Limagrain") ~ "Limagrain",
                               TRUE ~ applicant)) %>% 
  group_by(applicant) %>% 
  add_count() %>%
  ungroup() %>% 
  mutate(applicant = case_when(n < 50 ~ "Other",
                               TRUE ~ applicant)) %>% 
  distinct(applicant, n) %>% 
  group_by(applicant) %>% 
  summarize(n = sum(n)) %>%
  mutate(crop = 1,
         applicant_short = str_split_fixed(string = applicant, pattern = " ", n = 2)[,1])



wheat_donut %>% 
  ggplot(aes(x = crop,
             fill = applicant,
             y = n,
             colour = applicant)) +
  geom_bar(stat = "identity",
           colour = "white") +
  geom_text(aes(x = crop + 1,
                label = applicant_short),
            position = position_stack(vjust = .5),
            hjust = .5) +
  annotate(geom = "text", label = "Wheat",
           x = -.4, y = 0,
           colour = "grey30") +
  guides(colour = FALSE,
         fill = FALSE) +
  coord_polar(theta = "y") +
  lims(x = c(-.4, 2)) +
  theme_void()


# Barley ------------------------------------------------------------------

barley <- 
  read_csv2("content/post/_data/barley.csv") %>% 
  janitor::clean_names() %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               applicant %>% str_detect("Limagrain") ~ "Limagrain",
                               applicant %>% str_detect("Syngenta") ~ "Syngenta",
                               TRUE ~ applicant)) 

barley %>%
  filter(status == "Active application") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n))

barley %>%
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n))

barley %>% 
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  add_count() %>% 
  ggplot(aes(x = n)) + 
  geom_histogram()

top_barley <- 
  barley %>%
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  count() %>% 
  ungroup() %>% 
  top_n(n = 5, wt = n) %>% 
  pull(applicant)
  

# Barley Donut ------------------------------------------------------------

barley_donut <- 
  barley %>% 
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  add_count() %>%
  ungroup() %>% 
  mutate(applicant = case_when(applicant %in% top_barley ~ applicant,
                               TRUE ~ "Others")) %>% 
  distinct(applicant, n) %>% 
  group_by(applicant) %>% 
  summarize(n = sum(n)) %>%
  mutate(crop = 1,
         applicant_short = str_split_fixed(string = applicant, pattern = " ", n = 2)[,1])



barley_donut %>% 
  ggplot(aes(x = crop,
             fill = applicant,
             y = n,
             colour = applicant)) +
  geom_bar(stat = "identity",
           colour = "white") +
  geom_text(aes(x = crop + 1,
                label = applicant_short),
            position = position_stack(vjust = .5),
            hjust = .5) +
  annotate(geom = "text", label = "Barley",
           x = -.4, y = 0,
           colour = "grey30") +
  guides(colour = FALSE,
         fill = FALSE) +
  coord_polar(theta = "y") +
  lims(x = c(-.4, 2)) +
  theme_void()
