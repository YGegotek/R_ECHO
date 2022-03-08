# organize data from emission registration
# N total (303), P total (302), in kg

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
ER_DB <- lapply(Sys.glob(ACCDB_ER_All), ReadDB) %>%
  bind_rows() %>%
  filter(GOF_CODE %in% c(302, 303))

ER_DB$EMK_CODE <- str_replace(ER_DB$EMK_CODE, "^0", "")

ER_DB <- left_join(ER_DB, EMK_Source, by = c("EMK_CODE"="EMKCODE")) %>%
  select(Year = EMISSIEJAAR, Stofcode = GOF_CODE, AI_code = GAF_AI_CODE, Emission = EMISSIE, Group)
#---------------------------------------------------------------------------------
# bind two sources of data
ER <- bind_rows(ER_TXT, ER_DB)

ER_N <- ER %>%
  filter(Stofcode == 303) %>%
  group_by(Year, AI_code, Group) %>%
  summarise(across(Emission, sum), .groups = "drop")
ER_N$Year <- as.numeric(ER_N$Year)
ER_P <- ER %>%
  filter(Stofcode == 302) %>%
  group_by(Year, AI_code, Group) %>%
  summarise(across(Emission, sum), .groups = "drop")
ER_P$Year <- as.numeric(ER_P$Year)
#---------------------------------------------------------------------------------
write.csv(ER_N, file = "../Emission_registration/ER/ER_N.csv", row.names = FALSE)
write.csv(ER_P, file = "../Emission_registration/ER/ER_P.csv", row.names = FALSE)
#---------------------------------------------------------------------------------