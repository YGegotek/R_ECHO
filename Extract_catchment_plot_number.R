pacman::p_load("raster", "rgdal", "sp", "stars")
pacman::p_load("tidyverse", "lubridate", "sf", "RODBC")

# rasterize catchments vectors first in QGIS, then read in as data frame
Catchment_538 <- read_stars("../Shape/LWKM/Catchment_small.tif")
LWKM <- read_stars("../Shape/LWKM/HRU_LWKM12.asc")

Catchment_538 <- as.data.frame(Catchment_538)
LWKM <- as.data.frame(LWKM)

Catchment_Plot <- inner_join(Catchment_538, LWKM, by = c("x", "y"))
Catchment_Plot <- rename(Catchment_Plot,  "ID" = "Catchment_small.tif", "Plot" = "HRU_LWKM12.asc")
Catchment_Plot <- Catchment_Plot %>%
  drop_na() %>%
  group_by(ID, Plot) %>%
  count() %>%
  mutate(Area = n * 250*250)


Catchment_Plot <- Catchment_Plot %>%
  drop_na() %>%
  group_by(ID, Plot) %>%
  summarise(Area = sum(Area), .groups = "drop")

write.table(Catchment_Plot,"../Shape/LWKM/Catchment_Plot.txt",sep="\t",row.names=FALSE)

  #st_set_crs(Stone, st_crs(Catchment_538))
st_set_crs(LWKM, st_crs(Catchment_538))

ggplot() +
  geom_stars(data = LWKM) +
  scale_fill_viridis_c() +
  geom_sf(data = Catchment_538, alpha = 0)

#Stone_cropped <- st_intersects(st_set_crs(Stone, st_crs(Catchment_538)), Catchment_538)
LWKM_cropped <- st_intersects(st_set_crs(LWKM, st_crs(Catchment_538)), Catchment_538)

# Stone_cropped <- as.data.frame(Stone_cropped)
LWKM_cropped <- as.data.frame(LWKM_cropped)


Test <- rasterize(Catchment_538, LWKM, fun='last', filename="../Shape/STONE/Catchment_538_raster", getCover=TRUE)

Catchment_Plot <- raster::extract(x = LWKM, y = Catchment_538, buffer= 0, method = 'simple', df = TRUE)

write.table(Catchment_Plot,"../Shape/STONE/Catchment_Plot_overlay.txt",sep="\t",row.names=FALSE)

Catchment_Plot <- as.data.frame(read_delim("../Shape/STONE/Catchment_Plot_overlay.txt", show_col_types = FALSE))

Catchment_Plot <- Catchment_Plot %>%
  group_by(ID, Plot) %>%
  count() %>%
  mutate(Area = n * 250*250)

Catchment_Plot <- Catchment_Plot %>%
  drop_na() %>%
  group_by(ID, Plot) %>%
  summarise(Area = sum(Area), .groups = "drop")

# Catchment_Plot <- Catchment_Plot %>%
# group_by(ID) %>%
# summarise(Area = sum(Area), .groups = "drop")


write.table(Catchment_Plot,"../Shape/STONE/Catchment_Plot.txt",sep="\t",row.names=FALSE)


