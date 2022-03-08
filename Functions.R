# Title: TODO
# Objective: TODO
# Created by: Yanjiao
# Created on: 10/19/202111:29 AM

# read shapefiles: cleans the shapefile and fixes potential inaccuraries
ReadShape <- .  %>%
  st_read() %>%
  st_make_valid() %>%
  st_transform(crs=28992) %>%
  st_set_precision(units::set_units(10, nm))

# read data from microsoft database and convert into R data frame
ReadDB <- function(x) {
  ER_channel <- odbcConnectAccess2007(x)
  y <- sqlQuery(ER_channel,"SELECT EMISSIEJAAR, GOF_CODE, EMK_CODE, GAF_AI_CODE, EMISSIE FROM Belasting_Echo")
  odbcCloseAll()
  return(y)
}