library(tidyverse)
library(tidytext)


# read data ---------------------------------------------------------------

# ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/

dat <- read_delim("content/post/_data/variant_summary.txt", delim = "\t")


# analuze phenotypes ------------------------------------------------------


tst <- 
  dat %>% 
  # pull(PhenotypeList) %>% 
  # word(sep = c(fixed(" "),
  #              fixed(",")))
  unnest_tokens(word, PhenotypeList) 
  
ws <-   
  tst %>% count(word) %>%
  arrange(desc(n)) #%>% View()

ws %>%  
  filter(word == "behavior")

ws %>%  
  filter(word == "attention")

dat %>% 
  filter(PhenotypeList %>% str_detect("behavior")) %>% 
  select(PhenotypeList, GeneID, Name) %>% 
  distinct() %>% 
  View()

dat %>% 
  filter(PhenotypeList %>% str_detect("aggressive")) %>% 
  select(PhenotypeList, GeneID) %>% 
  distinct() %>% 
  View()

dat %>% 
  filter(PhenotypeList %>% str_detect("attention")) %>% 
  select(PhenotypeList, GeneID) %>% 
  distinct() %>% 
  View()


dat %>% 
  filter(PhenotypeList %>% str_detect("social")) %>% 
  select(PhenotypeList, GeneID) %>% 
  distinct() %>% 
  View()

dat %>% 
  filter(PhenotypeList %>% str_detect("addiction")) %>% 
  select(PhenotypeList, GeneID) %>% 
  distinct() %>% 
  View()
