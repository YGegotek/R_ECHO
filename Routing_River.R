# River routing to the north sea
#--------------------------------------------------------------------------------------------------------
# Direct into the north sea
Routing_Sea_Direct <- as.data.frame(read_delim(TXT_To_Sea_Direct, show_col_types = FALSE)) %>%
  mutate(Distance = 0.0, Percent = 1.0) %>%
  rename("Into" = "Noordzee", "Name" = "NAAM") %>%
  select(ID, Name, Into, Distance, Percent)
#--------------------------------------------------------------------------------------------------------
# Indirect into the north sea, in meter
Routing_Sea_InDirect <- as.data.frame(read_csv(CSV_To_Sea_InDirect, show_col_types = FALSE)) %>%
  pivot_longer(5:12, names_to = "Into", values_to = "Distance") %>%
  mutate(Percent = case_when(NAAM == "Maas" & Into == "Haringvliet" ~ 0.29,
                             NAAM == "Maas" & Into == "Nieuwe Waterweg" ~ 0.68,
                             NAAM == "Maas" & Into == "Noordzeekanaal" ~ 0.03,
                             NAAM == "Schelde" & Into == "Oosterschelde" ~ 0.5,
                             NAAM == "Schelde" & Into == "Westerschelde" ~ 0.5,
                             NAAM == "Rijn West" & Into == "Haringvliet" ~ 0.29,
                             NAAM == "Rijn West" & Into == "Nieuwe Waterweg" ~ 0.68,
                             NAAM == "Rijn West" & Into == "Noordzeekanaal" ~ 0.03,
                             NAAM == "Rijn Oost" & Into == "IJsselmeer" ~ 1.0,
                             NAAM == "Rijn Noord" & Into == "Waddenzee West" ~ 1.0,
                             NAAM == "Eems" & Into == "Waddenzee Oost" ~ 1.0)) %>%
  drop_na() %>%
  rename("Name" = "NAAM") %>%
  select(ID, Name, Into, Distance, Percent)
# All
Routing_Sea <- bind_rows(Routing_Sea_Direct, Routing_Sea_InDirect) %>%
  mutate(Release_Fra_N = exp(- K_N * Distance / (V_stream * 24 * 60 * 60)),
         Release_Fra_P = exp(- K_P * Distance / (V_stream * 24 * 60 * 60)),
         Ret_Extra = case_when(Into == "IJsselmeer" ~ 0.5,
                               Into %in% c("Haringvliet", "Westerschelde", "Oosterschelde") ~ 0.9,
                               TRUE ~ 1.0)) %>% # proportional to travel time, extra retention for Ijselmeer en Estuaria
  mutate(Release_Fra_P = Release_Fra_P * Ret_Extra) %>%
  mutate(Release_Fra_P = ifelse(Release_Fra_P < 0.1, 0.1, Release_Fra_P), Release_Fra_N = ifelse(Release_Fra_N < 0.1, 0.1, Release_Fra_N))  # afkappen zodat retentie nooit groter is dan 90%

write.csv(Routing_Sea, file = "../Routing/Routing_Sea.csv", row.names = FALSE)