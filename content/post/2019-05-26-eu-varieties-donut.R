library(tidyverse)
library(eurostat)
library(lubridate)
library(grid)
library(forcats)

# colours
violet <- "#70308F"
purple <- "#AA2255"

# Wheat -------------------------------------------------------------------

# Triticum Aestivum

wheat1 <- read_csv2("content/post/_data/wheat-1.csv")
wheat2 <- read_csv2("content/post/_data/wheat-2.csv") 

wheat <- 
  bind_rows(wheat1, wheat2) %>% 
  distinct() %>% 
  janitor::clean_names() %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               applicant %>% str_detect("Limagrain") ~ "Limagrain",
                               TRUE ~ applicant))

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
  scale_colour_manual(values = c("#99999966", purple)) +
  scale_size_continuous(guide = guide_legend(override.aes = list(colour = purple))) +
  coord_flip() +
  labs(x = "",
       y = "",
       colour = "Applicant",
       caption = "Data from cpvo.europa.eu, on 25-05-2019") +
  # guides(colour = guide_legend(title.position = "top"),
  #        size = guide_legend(title.position = "top")) +
  theme_minimal(base_family = "courier",
                base_size = 15) +
  theme(legend.position = "top",
        legend.text = element_text(colour = "grey20"),
        legend.title = element_text(colour = "grey20"),
        legend.background = element_rect(size = 0,
                                         fill = "grey96"),
        plot.caption = element_text(size = 10, colour = purple))

p_wheat

svglite::svglite(file = "static/_plots/2019-05-26-wheat-lite.svg",
                 height = 6,
                 width = 10.42,
                 pointsize = 1)
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



# rapeseed -------------------------------------------------------------------

rapeseed <-  
  read_csv2("content/post/_data/rapeseed.csv") %>% 
  janitor::clean_names() %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               applicant %>% str_detect("Limagrain") ~ "Limagrain",
                               applicant %>% str_detect("Syngenta") ~ "Syngenta",
                               applicant %>% str_detect("Monsanto") ~ "Monsanto",
                               applicant %>% str_detect("Saatveredelung") ~ "DVS",
                               applicant %>% str_detect("Norddeutsche Pflanzenzucht") ~ "NPZ",
                               TRUE ~ applicant)) 

rapeseed %>%
  filter(status == "Active application") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n))

rapeseed %>%
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) #%>% View()

rapeseed %>% 
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  add_count() %>% 
  ggplot(aes(x = n)) + 
  geom_histogram()

# durum wheat -----------------------------------------------------------------

durum <-  
  read_csv2("content/post/_data/durum.csv") %>% 
  janitor::clean_names() %>% 
  mutate(applicant = case_when(applicant %>% str_detect("KWS") ~ "KWS",
                               applicant %>% str_detect("Limagrain") ~ "Limagrain",
                               applicant %>% str_detect("Donau GmbH") ~ "Donau",
                               applicant %>% str_detect("Pioneer") ~ "Pioneer",
                               applicant %>% str_detect("Syngenta") ~ "Syngenta",
                               applicant %>% str_detect("Monsanto") ~ "Monsanto",
                               applicant %>% str_detect("Saatveredelung") ~ "DVS",
                               applicant %>% str_detect("Norddeutsche Pflanzenzucht") ~ "NPZ",
                               TRUE ~ applicant)) 


durum %>%
  filter(status == "Active application") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n))

durum %>%
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  count() %>% 
  arrange(desc(n)) # %>% View()

durum %>% 
  filter(status == "Granted") %>% 
  group_by(applicant) %>% 
  add_count() %>% 
  ggplot(aes(x = n)) + 
  geom_histogram()



# Function plot donut ----------------------------------------------------

prepare_donut <- function(dat) {
  
  # name of dataset as plot lable
  plot_lab <- 
    enexpr(dat) %>% deparse()
  
  # select applicant with 
  top_applicant <- 
    dat %>%
    filter(status == "Granted") %>% 
    group_by(applicant) %>% 
    count() %>% 
    ungroup() %>% 
    top_n(n = 5, wt = n) %>% 
    pull(applicant)
  
  # prepare for plot
  dat_donut <- 
    dat %>%
    filter(status == "Granted") %>% 
    group_by(applicant) %>% 
    add_count() %>%
    ungroup() %>% 
    mutate(applicant = case_when(applicant %in% top_applicant ~ applicant,
                                 TRUE ~ "Others")) %>% 
    distinct(applicant, n) %>% 
    group_by(applicant) %>% 
    summarize(n = sum(n)) %>%
    mutate(crop = 1,
           applicant_short = str_split_fixed(string = applicant, pattern = " ", n = 2)[,1])
}

plot_donut <- function(dat,
                       colors_in = color_plasma,
                       fill_in = fill_plasma) {
  plot_name <- dat$crop_name %>% unique()
  
  p <- 
    dat %>% 
    ggplot(aes(x = crop,
               fill = applicant_short,
               y = n,
               colour = applicant_short)) +
    geom_bar(stat = "identity",
             colour = "white",
             size = 1.2) +
    geom_text(aes(x = crop + 1,
                  label = paste(applicant_short, n, sep = "\n")),
              position = position_stack(vjust = .5),
              hjust = .5, 
              size = 2.4,
              family = "sans") +
    annotate(geom = "text", label = plot_name,
             x = -.4, y = 0,
             colour = "grey30",
             size = 2.6, family = "sans") +
    colors_in +
    fill_in +
    guides(colour = FALSE,
           fill = FALSE) +
    coord_polar(theta = "y", start = -(1/3)*pi) +
    lims(x = c(-.4, 2)) +
    theme_void()
  p
}

d_in <- list(Wheat = wheat,
             Barley = barley,
             Rapeseed = rapeseed,
             Durum = durum) %>% 
  map_df(prepare_donut, .id = "crop_name") %>% 
  mutate(applicant_short = applicant_short %>% as.factor(),
         # "Other" as first level,
         # To make the plot look nicer
         applicant_short = applicant_short %>% 
           {fct_shift(., n = which(levels(.) == "Others") - 1)})


# standard palette --------------------------------------------------------


plasma_in <- viridis::plasma(13, end = .8)

color_plasma <- scale_color_manual(values = set_names(x = plasma_in,
                                                      nm = d_in$applicant_short %>%
                                                        levels()))

fill_plasma <- scale_fill_manual(values = set_names(x = plasma_in,
                                                    nm = d_in$applicant_short %>%
                                                      levels()))


p_list <- 
  d_in %>% 
  split(.$crop_name) %>% 
  map(plot_donut)



# save donuts -------------------------------------------------------------

grid_donut <- function(p, x, y) {
  print(p,
        vp = viewport(x = x,
                      y = .5,
                      width = .245))
  return(NULL)
}

svglite::svglite("static/_plots/2019-05-26-registered-crops.svg", 
                 height = 2.2,
                 width = 10.42,
                 pointsize = 1)
grid.newpage()
tibble(p = p_list,
       x = seq(.15, .85, length.out = 4)) %>% 
  pmap(grid_donut)
dev.off()
