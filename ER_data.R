# organize data from emission registration
# N total (303), P total (302), in kg
pacman::p_load("tidyverse", "lubridate")

# EMK code and its source group
EMK_Source <- read.csv(CSV_EMK)
#---------------------------------------------------------------------------------
# delievered in TXT format, saved in csv. Note: check the spelling, olie etc.
ER_TXT <- lapply(Sys.glob(TXT_ER_All), read.csv) %>%
  bind_rows() %>%
  select(EMISSIEJAAR, STOFCODE, EMKCODE, AI_CODE_NAAR, EMISSIE_KG) %>%
  left_join(EMK_Source, by = "EMKCODE") %>%
  select(Year = EMISSIEJAAR, Stofcode = STOFCODE, AI_code = AI_CODE_NAAR, Emission = EMISSIE_KG, Group)
#---------------------------------------------------------------------------------
# access format, the EMK code has an extra 0 at the beginning
ER_DB <- lapply(Sys.glob(ACCDB_ER_All), read.csv) %>%
  bind_rows() %>%
  filter(GOF_CODE %in% c(302, 303))

ER_DB$EMK_CODE <- str_replace(ER_DB$EMK_CODE, "^0", "")

ER_DB <- left_join(ER_DB, EMK_Source, by = c("EMK_CODE"="EMKCODE")) %>%
  select(Year = 1, Stofcode = GOF_CODE, AI_code = GAF_AI_CODE, Emission = EMISSIE, Group)
#---------------------------------------------------------------------------------
# bind two sources of data
ER <- bind_rows(ER_TXT, ER_DB) %>%
  group_by(Year, Stofcode, AI_code, Group) %>%
  summarise(across(Emission, sum), .groups = "drop") %>%
  spread(Stofcode, Emission) %>%
  pivot_longer(cols = 4:5, names_to ="Stofcode", values_to = "Emission") %>%
  spread(Group, Emission) %>%
  pivot_longer(cols = 4:10, names_to ="Group", values_to = "Emission") %>%
  group_by(Stofcode, AI_code, Group) %>%
  mutate(Emission = ifelse(is.na(Emission), mean(Emission, na.rm = TRUE), Emission)) %>%
  mutate(Emission = ifelse(Emission == "NaN",0.0, Emission),
         Stofcode = case_when(Stofcode == 303 ~ "N", Stofcode == 302 ~ "P"))
ER$Year <- as.numeric(ER$Year)
#---------------------------------------------------------------------------------
write.csv(ER, file = "../Emission_registration/ER/ER.csv", row.names = FALSE)
#---------------------------------------------------------------------------------