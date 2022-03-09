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

# Catchment routing
Routing_catchment <- function(Routing, Nutrient){
  for (Level in 1:7) # loop from the smallest river to large ones
  {
    Nutrient <- mutate(Nutrient, Retention = Ret_Fraction * Emission) %>%
      mutate(Retention = if_else(Retention < Ret_Absolute, Retention, Ret_Absolute), Out = Emission - Retention)

    Upper <- filter(Routing, !ID %in% c(TO_1, TO_2, TO_3)) # does not receive water from other catchment
    for (i in 1:nrow(Upper))
    {
      from <- filter(Nutrient, ID == Upper[i,1]) # from
      to_1 <- filter(Nutrient, ID == Upper[i, 2]) %>%
        mutate(Emission = from$Out * Upper[i, 3]) %>%
        select(ID, Year, Month, Emission)
      to_1 <- left_join(Catchment_Time, to_1, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Nutrient <- mutate(Nutrient, Emission = Emission + to_1$Emission)

      if (!is.na(Upper[i,4]))
      {
        to_2 <- filter(Nutrient, ID == Upper[i, 4]) %>%
          mutate(Emission = from$Out * Upper[i,5]) %>%
          select(ID, Year, Month, Emission)
        to_2 <- left_join(Catchment_Time, to_2, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Nutrient <- mutate(Nutrient, Emission = Emission + to_2$Emission)

        if (!is.na(Upper[i,6]))
        {
          to_3 <- filter(Nutrient, ID == Upper[i, 6]) %>%
            mutate(Emission = from$Out * Upper[i,7]) %>%
            select(ID, Year, Month, Emission)
          to_3 <- left_join(Catchment_Time, to_3, by = c("ID", "Year", "Month")) %>%
            replace(is.na(.), 0.0)
          Nutrient <- mutate(Nutrient, Emission = Emission + to_3$Emission)
        }
      }
    }
    Routing <- setdiff(Routing, Upper)
  }
  return(Nutrient)
}