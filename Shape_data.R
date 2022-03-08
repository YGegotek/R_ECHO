# Catchments information
Catchment <- as.data.frame(ReadShape(Shp_Catchment_Stone)) %>%
  select(ID, AQUAREIN, oppha) %>%
  rename("Water_body" = "AQUAREIN", "Area_Catchment" = "oppha") #%>% # ha
write.csv(Catchment, file = "../Shape/STONE/Catchment.csv", row.names = FALSE)