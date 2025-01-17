#-----------------------------
# Load packages, constants and functions
#-----------------------------
pacman::p_load("tidyverse", "lubridate", "sf", "RODBC")

source("Directories.R")
source("Functions.R")
source("Constants.R")

# load STONE shape files: 538 catchments (ha), and merge with stone plot numbers
Catchment_538 <- as.data.frame(ReadShape(Shp_Catchment_Stone)) %>%
  select(ID, AQUAREIN, oppha) %>%
  rename("Water_body" = "AQUAREIN", "Area_Catchment" = "oppha") #%>% # ha

#Catchment ID vs Stone plot number, with area
Catchment_Plot <- as.data.frame(read_delim(TXT_LWKM_Catchment, show_col_types = FALSE)) %>%
  rename (Area_Plot = Area)

# load STONE output data, years of interest
# P(kg/m2/decade), N(kg/m2/decade))
Stone_2019 <- read_csv(CSV_Stone_2019, col_types = list(col_integer(), col_date(), rep(col_double(), 12))) %>%
  separate(Datum, into = c("Year", "Month", "Day"), sep = "-") %>%
  mutate(Q = OppAfv + Afv, N = (Oppnhafv +  Nhafv + Oppniafv + Niafv + Oppnoafv + Noafv), P = (Oppppafv + PPafv + Opppoafv + Poafv))

Stone_2019$Year <- as.numeric(Stone_2019$Year)
Stone_2019$Month <- as.numeric(Stone_2019$Month)
Catchment_Time <- tibble(ID = rep(1:538, each = 12), Year = rep(rep(2019, each = 12), 538), Month = rep(1:12, 538))
Stone_N_Monthly_2019 <- Stone_2019 %>%
  select(Plot, Year, Month, N) %>%
  group_by(Plot, Year, Month) %>%
  summarise(N = sum(N, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(N = Area_Plot * N) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_N = sum(N, na.rm = TRUE), .groups = "drop")
Stone_N_Monthly_2019 <- left_join(Catchment_Time, Stone_N_Monthly_2019, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_N_Monthly_2019, file = "../Results/Stone_N_Monthly_2019.csv")
#-------------------------
# Yearly
Stone_N_Yearly_2019 <- Stone_N_Monthly_2019 %>%
  group_by(ID, Year) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")
write.csv(Stone_N_Yearly_2019, file = "../Results/Stone_N_Yearly_2019.csv")
#--------------------------------------------------------------------------------
# P (kg)
# Monthly
Stone_P_Monthly_2019 <- Stone_2019 %>%
  select(Plot, Year, Month, P) %>%
  group_by(Plot, Year, Month) %>%
  summarise(P = sum(P, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(P = Area_Plot * P) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_P = sum(P, na.rm = TRUE), .groups = "drop")
Stone_P_Monthly_2019 <- left_join(Catchment_Time, Stone_P_Monthly_2019, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_P_Monthly_2019, file = "../Results/Stone_P_Monthly_2019.csv")
#-------------------------
# Yearly
Stone_P_Yearly_2019 <- Stone_P_Monthly_2019 %>%
  group_by(ID, Year) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")
write.csv(Stone_P_Yearly_2019, file = "../Results/Stone_P_Yearly_2019.csv")
#----------------------------------------------------------------------------------------------------------------
Stone_2027B <- read_csv(CSV_Stone_2027B, col_types = list(col_integer(), col_date(), rep(col_double(), 12))) %>%
  separate(Datum, into = c("Year", "Month", "Day"), sep = "-") %>%
  mutate(Q = OppAfv + Afv, N = (Oppnhafv +  Nhafv + Oppniafv + Niafv + Oppnoafv + Noafv), P = (Oppppafv + PPafv + Opppoafv + Poafv))

Stone_2027B$Year <- as.numeric(Stone_2027B$Year)
Stone_2027B$Month <- as.numeric(Stone_2027B$Month)
Catchment_Time <- tibble(ID = rep(1:538, each = 12), Year = rep(rep(2027, each = 12), 538), Month = rep(1:12, 538))
Stone_N_Monthly_2027B <- Stone_2027B %>%
  select(Plot, Year, Month, N) %>%
  group_by(Plot, Year, Month) %>%
  summarise(N = sum(N, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(N = Area_Plot * N) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_N = sum(N, na.rm = TRUE), .groups = "drop")
Stone_N_Monthly_2027B <- left_join(Catchment_Time, Stone_N_Monthly_2027B, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_N_Monthly_2027B, file = "../Results/Stone_N_Monthly_2027B.csv")
#-------------------------
# Yearly
Stone_N_Yearly_2027B <- Stone_N_Monthly_2027B %>%
  group_by(ID, Year) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")
write.csv(Stone_N_Yearly_2027B, file = "../Results/Stone_N_Yearly_2027B.csv")
#--------------------------------------------------------------------------------
# P (kg)
# Monthly
Stone_P_Monthly_2027B <- Stone_2027B %>%
  select(Plot, Year, Month, P) %>%
  group_by(Plot, Year, Month) %>%
  summarise(P = sum(P, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(P = Area_Plot * P) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_P = sum(P, na.rm = TRUE), .groups = "drop")
Stone_P_Monthly_2027B <- left_join(Catchment_Time, Stone_P_Monthly_2027B, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_P_Monthly_2027B, file = "../Results/Stone_P_Monthly_2027B.csv")
#-------------------------
# Yearly
Stone_P_Yearly_2027B <- Stone_P_Monthly_2027B %>%
  group_by(ID, Year) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")
write.csv(Stone_P_Yearly_2027B, file = "../Results/Stone_P_Yearly_2027B.csv")
#----------------------------------------------------------------------------------------------------------------
Stone_2027C <- read_csv(CSV_Stone_2027C, col_types = list(col_integer(), col_date(), rep(col_double(), 12))) %>%
  separate(Datum, into = c("Year", "Month", "Day"), sep = "-") %>%
  mutate(Q = OppAfv + Afv, N = (Oppnhafv +  Nhafv + Oppniafv + Niafv + Oppnoafv + Noafv), P = (Oppppafv + PPafv + Opppoafv + Poafv))

Stone_2027C$Year <- as.numeric(Stone_2027C$Year)
Stone_2027C$Month <- as.numeric(Stone_2027C$Month)

Stone_N_Monthly_2027C <- Stone_2027C %>%
  select(Plot, Year, Month, N) %>%
  group_by(Plot, Year, Month) %>%
  summarise(N = sum(N, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(N = Area_Plot * N) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_N = sum(N, na.rm = TRUE), .groups = "drop")
Stone_N_Monthly_2027C <- left_join(Catchment_Time, Stone_N_Monthly_2027C, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_N_Monthly_2027C, file = "../Results/Stone_N_Monthly_2027C.csv")
#-------------------------
# Yearly
Stone_N_Yearly_2027C <- Stone_N_Monthly_2027C %>%
  group_by(ID, Year) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")
write.csv(Stone_N_Yearly_2027C, file = "../Results/Stone_N_Yearly_2027C.csv")
#--------------------------------------------------------------------------------
# P (kg)
# Monthly
Stone_P_Monthly_2027C <- Stone_2027C %>%
  select(Plot, Year, Month, P) %>%
  group_by(Plot, Year, Month) %>%
  summarise(P = sum(P, na.rm = TRUE), .groups = "drop") %>%
  right_join(Catchment_Plot, by = "Plot") %>%
  mutate(P = Area_Plot * P) %>%
  group_by(ID, Year, Month) %>%
  summarise(Stone_P = sum(P, na.rm = TRUE), .groups = "drop")
Stone_P_Monthly_2027C <- left_join(Catchment_Time, Stone_P_Monthly_2027C, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0)
write.csv(Stone_P_Monthly_2027C, file = "../Results/Stone_P_Monthly_2027C.csv")
#-------------------------
# Yearly
Stone_P_Yearly_2027C <- Stone_P_Monthly_2027C %>%
  group_by(ID, Year) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")
write.csv(Stone_P_Yearly_2027C, file = "../Results/Stone_P_Yearly_2027C.csv")
#------------------------------------------------------------------------------------------------------------------------
Soil <- as.data.frame(read_delim(TXT_Soil, show_col_types = FALSE))

Retention_UA_N <- Soil %>%
  mutate(Ret_Absolute_Summer = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_summer_incl_ha * 10 * N_Ret_Klei_Summer_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_summer_incl_ha * 10 * N_Ret_Veen_Summer_gNm2,
                                         TRUE ~ 1e100)) %>%
  mutate(Ret_Absolute_Winter = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_winter_incl_ha * 10 * N_Ret_Klei_Winter_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_winter_incl_ha * 10 * N_Ret_Veen_Winter_gNm2,
                                         TRUE ~ 1e100)) %>%
  mutate(Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ N_b_Summer, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.9,
                                         TRUE ~ 0.5)) %>%
  mutate(Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ N_b_Winter, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.9,
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)

Retention_UA_P <- Soil %>%
  mutate(Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ P_b_Summer, 0.9),
                                         TRUE ~ 0.5)) %>%
  mutate(Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ P_b_Winter, 0.9),
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Fraction_Summer, Ret_Fraction_Winter)
#-------------------------------------------------------------------------------------------------------
# retention fraction overige
Retention_Fra_ER_N <- Soil %>%
  mutate(Ret_Fraction = case_when(TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.0, TRUE ~ 0.2)) %>%
  select(ID,Ret_Fraction)

Retention_Fra_ER_P <- Soil %>%
  mutate(Ret_Fraction = 0.2) %>%
  select(ID,Ret_Fraction)
#------------------------------------------------------------------------------------------------------------------------
# Catchment routing
Routing_538 <- as.data.frame(read_delim(TXT_Routing_STONE, show_col_types = FALSE)) %>%
  rename("ID" = "FROM") #from id, to 1, weight 1, to 2, weight 2, to 3, weight 3
#------------------------------------
# UA, retention soil specific
Routing_Stone_N_2019 <- Stone_N_Monthly_2019 %>%
  left_join(Retention_UA_N, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_N = Stone_N,
            Ret_Absolute = case_when(Month %in% 4:9 ~ Ret_Absolute_Summer, TRUE ~ Ret_Absolute_Winter),
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))

Nutrient <- Stone_P_Monthly_2019 %>%
  left_join(Retention_UA_P, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_P = Stone_P,
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))
#------------------------------------
Routing_Stone_N_2027B <- Stone_N_Monthly_2027B %>%
  left_join(Retention_UA_N, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_N = Stone_N,
            Ret_Absolute = case_when(Month %in% 4:9 ~ Ret_Absolute_Summer, TRUE ~ Ret_Absolute_Winter),
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))

Routing_Stone_P_2027B <- Stone_P_Monthly_2027B %>%
  left_join(Retention_UA_P, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_P = Stone_P,
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))
#------------------------------------
Routing_Stone_N_2027C <- Stone_N_Monthly_2027C %>%
  left_join(Retention_UA_N, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_N = Stone_N,
            Ret_Absolute = case_when(Month %in% 4:9 ~ Ret_Absolute_Summer, TRUE ~ Ret_Absolute_Winter),
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))

Routing_Stone_P_2027C <- Stone_P_Monthly_2027C %>%
  left_join(Retention_UA_P, by = "ID") %>%
  transmute(ID = ID, Year = Year, Month = Month, Stone_P = Stone_P,
            Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter))
#------------------------------------
#------------------------------------
# loop begins here
Routing <- Routing_538
for (Level in 1:7) # loop from the smallest river to large ones
{
  Routing_Stone_N_2019 <- mutate(Routing_Stone_N_2019, Ret_Stone_N = Stone_N * Ret_Fraction) %>%
    mutate(Ret_Stone_N = if_else(Ret_Stone_N < Ret_Absolute, Ret_Stone_N, Ret_Absolute), Afwenteling = Stone_N - Ret_Stone_N)
  Nutrient <- mutate(Nutrient, Ret_Stone_P = Stone_P * Ret_Fraction, Afwenteling = Stone_P - Ret_Stone_P)

  Upper <- filter(Routing, !ID %in% c(TO_1, TO_2, TO_3)) # does not receive water from other catchment
  for (i in 1:nrow(Upper))
  {
    # Stone N
    N_Stone_from <- filter(Routing_Stone_N_2019, ID == Upper[i,1]) # from
    N_Stone_to_1 <- filter(Routing_Stone_N_2019, ID == Upper[i,2]) %>%
      mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_N)
    N_Stone_to_1 <- left_join(Catchment_Time, N_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Routing_Stone_N_2019 <- mutate(Routing_Stone_N_2019, Stone_N = Stone_N + N_Stone_to_1$Stone_N)

    # Stone P
    P_Stone_from <- filter(Nutrient, ID == Upper[i, 1]) # from
    P_Stone_to_1 <- filter(Nutrient, ID == Upper[i, 2]) %>%
      mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_P)
    P_Stone_to_1 <- left_join(Catchment_Time, P_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Nutrient <- mutate(Nutrient, Stone_P = Stone_P + P_Stone_to_1$Stone_P)

    if (!is.na(Upper[i,4]))
    {
      # Stone N
      N_Stone_to_2 <- filter(Routing_Stone_N_2019, ID == Upper[i,4]) %>%
        mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_N)
      N_Stone_to_2 <- left_join(Catchment_Time, N_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Routing_Stone_N_2019 <- mutate(Routing_Stone_N_2019, Stone_N = Stone_N + N_Stone_to_2$Stone_N)

      # Stone P
      P_Stone_to_2 <- filter(Nutrient, ID == Upper[i, 4]) %>%
        mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_P)
      P_Stone_to_2 <- left_join(Catchment_Time, P_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Nutrient <- mutate(Nutrient, Stone_P = Stone_P + P_Stone_to_2$Stone_P)

      if (!is.na(Upper[i,6]))
      {
        # Stone N
        N_Stone_to_3 <- filter(Routing_Stone_N_2019, ID == Upper[i,6]) %>%
          mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_N)
        N_Stone_to_3 <- left_join(Catchment_Time, N_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Routing_Stone_N_2019 <- mutate(Routing_Stone_N_2019, Stone_N = Stone_N + N_Stone_to_3$Stone_N)


        # Stone P
        P_Stone_to_3 <- filter(Nutrient, ID == Upper[i, 6]) %>%
          mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_P)
        P_Stone_to_3 <- left_join(Catchment_Time, P_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Nutrient <- mutate(Nutrient, Stone_P = Stone_P + P_Stone_to_3$Stone_P)
             }
    }
  }
  Routing <- setdiff(Routing, Upper)
}
# Catchment routing results, total retention and afwenteling from each catchment (including received from upper streams), stopped by 305 (total amount of N/P discharged into 305 is already calculated)
write.csv(Routing_Stone_N_2019, file = "../Results/Routing_Stone_N_2019.csv")
write.csv(Nutrient, file = "../Results/Routing_Stone_P_2019.csv")
#-------------------------------------------------------------------------------------------------
#------------------------------------
# loop begins here
Routing <- Routing_538
for (Level in 1:7) # loop from the smallest river to large ones
{
  Routing_Stone_N_2027B <- mutate(Routing_Stone_N_2027B, Ret_Stone_N = Stone_N * Ret_Fraction) %>%
    mutate(Ret_Stone_N = if_else(Ret_Stone_N < Ret_Absolute, Ret_Stone_N, Ret_Absolute), Afwenteling = Stone_N - Ret_Stone_N)
  Routing_Stone_P_2027B <- mutate(Routing_Stone_P_2027B, Ret_Stone_P = Stone_P * Ret_Fraction, Afwenteling = Stone_P - Ret_Stone_P)

  Upper <- filter(Routing, !ID %in% c(TO_1, TO_2, TO_3)) # does not receive water from other catchment
  for (i in 1:nrow(Upper))
  {
    # Stone N
    N_Stone_from <- filter(Routing_Stone_N_2027B, ID == Upper[i,1]) # from
    N_Stone_to_1 <- filter(Routing_Stone_N_2027B, ID == Upper[i,2]) %>%
      mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_N)
    N_Stone_to_1 <- left_join(Catchment_Time, N_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Routing_Stone_N_2027B <- mutate(Routing_Stone_N_2027B, Stone_N = Stone_N + N_Stone_to_1$Stone_N)

    # Stone P
    P_Stone_from <- filter(Routing_Stone_P_2027B, ID == Upper[i,1]) # from
    P_Stone_to_1 <- filter(Routing_Stone_P_2027B, ID == Upper[i,2]) %>%
      mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_P)
    P_Stone_to_1 <- left_join(Catchment_Time, P_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Routing_Stone_P_2027B <- mutate(Routing_Stone_P_2027B, Stone_P = Stone_P + P_Stone_to_1$Stone_P)

    if (!is.na(Upper[i,4]))
    {
      # Stone N
      N_Stone_to_2 <- filter(Routing_Stone_N_2027B, ID == Upper[i,4]) %>%
        mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_N)
      N_Stone_to_2 <- left_join(Catchment_Time, N_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Routing_Stone_N_2027B <- mutate(Routing_Stone_N_2027B, Stone_N = Stone_N + N_Stone_to_2$Stone_N)

      # Stone P
      P_Stone_to_2 <- filter(Routing_Stone_P_2027B, ID == Upper[i,4]) %>%
        mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_P)
      P_Stone_to_2 <- left_join(Catchment_Time, P_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Routing_Stone_P_2027B <- mutate(Routing_Stone_P_2027B, Stone_P = Stone_P + P_Stone_to_2$Stone_P)

      if (!is.na(Upper[i,6]))
      {
        # Stone N
        N_Stone_to_3 <- filter(Routing_Stone_N_2027B, ID == Upper[i,6]) %>%
          mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_N)
        N_Stone_to_3 <- left_join(Catchment_Time, N_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Routing_Stone_N_2027B <- mutate(Routing_Stone_N_2027B, Stone_N = Stone_N + N_Stone_to_3$Stone_N)


        # Stone P
        P_Stone_to_3 <- filter(Routing_Stone_P_2027B, ID == Upper[i,6]) %>%
          mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_P)
        P_Stone_to_3 <- left_join(Catchment_Time, P_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Routing_Stone_P_2027B <- mutate(Routing_Stone_P_2027B, Stone_P = Stone_P + P_Stone_to_3$Stone_P)
      }
    }
  }
  Routing <- setdiff(Routing, Upper)
}
# Catchment routing results, total retention and afwenteling from each catchment (including received from upper streams), stopped by 305 (total amount of N/P discharged into 305 is already calculated)
write.csv(Routing_Stone_N_2027B, file = "../Results/Routing_Stone_N_2027B.csv")
write.csv(Routing_Stone_P_2027B, file = "../Results/Routing_Stone_P_2027B.csv")

#------------------------------------
# loop begins here
Routing <- Routing_538
for (Level in 1:7) # loop from the smallest river to large ones
{
  Routing_Stone_N_2027C <- mutate(Routing_Stone_N_2027C, Ret_Stone_N = Stone_N * Ret_Fraction) %>%
    mutate(Ret_Stone_N = if_else(Ret_Stone_N < Ret_Absolute, Ret_Stone_N, Ret_Absolute), Afwenteling = Stone_N - Ret_Stone_N)
  Routing_Stone_P_2027C <- mutate(Routing_Stone_P_2027C, Ret_Stone_P = Stone_P * Ret_Fraction, Afwenteling = Stone_P - Ret_Stone_P)

  Upper <- filter(Routing, !ID %in% c(TO_1, TO_2, TO_3)) # does not receive water from other catchment
  for (i in 1:nrow(Upper))
  {
    # Stone N
    N_Stone_from <- filter(Routing_Stone_N_2027C, ID == Upper[i,1]) # from
    N_Stone_to_1 <- filter(Routing_Stone_N_2027C, ID == Upper[i,2]) %>%
      mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_N)
    N_Stone_to_1 <- left_join(Catchment_Time, N_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Routing_Stone_N_2027C <- mutate(Routing_Stone_N_2027C, Stone_N = Stone_N + N_Stone_to_1$Stone_N)

    # Stone P
    P_Stone_from <- filter(Routing_Stone_P_2027C, ID == Upper[i,1]) # from
    P_Stone_to_1 <- filter(Routing_Stone_P_2027C, ID == Upper[i,2]) %>%
      mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,3]) %>%
      select(ID, Year, Month, Stone_P)
    P_Stone_to_1 <- left_join(Catchment_Time, P_Stone_to_1, by = c("ID", "Year", "Month")) %>%
      replace(is.na(.), 0.0)
    Routing_Stone_P_2027C <- mutate(Routing_Stone_P_2027C, Stone_P = Stone_P + P_Stone_to_1$Stone_P)

    if (!is.na(Upper[i,4]))
    {
      # Stone N
      N_Stone_to_2 <- filter(Routing_Stone_N_2027C, ID == Upper[i,4]) %>%
        mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_N)
      N_Stone_to_2 <- left_join(Catchment_Time, N_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Routing_Stone_N_2027C <- mutate(Routing_Stone_N_2027C, Stone_N = Stone_N + N_Stone_to_2$Stone_N)

      # Stone P
      P_Stone_to_2 <- filter(Routing_Stone_P_2027C, ID == Upper[i,4]) %>%
        mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,5]) %>%
        select(ID, Year, Month, Stone_P)
      P_Stone_to_2 <- left_join(Catchment_Time, P_Stone_to_2, by = c("ID", "Year", "Month")) %>%
        replace(is.na(.), 0.0)
      Routing_Stone_P_2027C <- mutate(Routing_Stone_P_2027C, Stone_P = Stone_P + P_Stone_to_2$Stone_P)

      if (!is.na(Upper[i,6]))
      {
        # Stone N
        N_Stone_to_3 <- filter(Routing_Stone_N_2027C, ID == Upper[i,6]) %>%
          mutate(Stone_N = N_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_N)
        N_Stone_to_3 <- left_join(Catchment_Time, N_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Routing_Stone_N_2027C <- mutate(Routing_Stone_N_2027C, Stone_N = Stone_N + N_Stone_to_3$Stone_N)


        # Stone P
        P_Stone_to_3 <- filter(Routing_Stone_P_2027C, ID == Upper[i,6]) %>%
          mutate(Stone_P = P_Stone_from$Afwenteling * Upper[i,7]) %>%
          select(ID, Year, Month, Stone_P)
        P_Stone_to_3 <- left_join(Catchment_Time, P_Stone_to_3, by = c("ID", "Year", "Month")) %>%
          replace(is.na(.), 0.0)
        Routing_Stone_P_2027C <- mutate(Routing_Stone_P_2027C, Stone_P = Stone_P + P_Stone_to_3$Stone_P)
      }
    }
  }
  Routing <- setdiff(Routing, Upper)
}
# Catchment routing results, total retention and afwenteling from each catchment (including received from upper streams), stopped by 305 (total amount of N/P discharged into 305 is already calculated)
write.csv(Routing_Stone_N_2027C, file = "../Results/Routing_Stone_N_2027C.csv")
write.csv(Routing_Stone_P_2027C, file = "../Results/Routing_Stone_P_2027C.csv")

#-------------------------------------------------------------------------------------------------
# routing to the north sea
# direct into the north sea
Routing_Sea_Direct <- as.data.frame(read_delim(TXT_To_Sea_Direct, show_col_types = FALSE)) %>%
  mutate(Distance = 0.0, Percent = 1.0) %>%
  rename("Into" = "Noordzee", "Name" = "NAAM") %>%
  select(ID, Name, Into, Distance, Percent)

# indirect into the north sea, in meter
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
# ----------------------------------------------------------
# Prepare data for river routing
# Stone N
Noordzee_Stone_N_2019 <- select(Routing_Stone_N_2019, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

N_WenO <- filter(Noordzee_Stone_N_2019, Into == "Wester- en Oosterschelde")
N_W <- mutate(N_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
N_O <- mutate(N_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_N_2019 <- Noordzee_Stone_N_2019 %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(N_W, N_O)
Noordzee_Stone_N_2019 <- Noordzee_Stone_N_2019 %>%
  mutate(Stone_N = Percent * Release_Fra_N * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_N_2019, file = "../Results/Noordzee_Stone_N_2019.csv")
# -------------------------------------
# Stone P
Noordzee_Stone_P_2019 <- select(Nutrient, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

P_WenO <- filter(Noordzee_Stone_P_2019, Into == "Wester- en Oosterschelde")
P_W <- mutate(P_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
P_O <- mutate(P_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_P_2019 <- Noordzee_Stone_P_2019 %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(P_W, P_O)
Noordzee_Stone_P_2019 <- Noordzee_Stone_P_2019 %>%
  mutate(Stone_P = Percent * Release_Fra_P * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_P_2019, file = "../Results/Noordzee_Stone_P_2019.csv")
# -------------------------------------
# Prepare data for river routing
# Stone N
Noordzee_Stone_N_2027B <- select(Routing_Stone_N_2027B, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

N_WenO <- filter(Noordzee_Stone_N_2027B, Into == "Wester- en Oosterschelde")
N_W <- mutate(N_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
N_O <- mutate(N_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_N_2027B <- Noordzee_Stone_N_2027B %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(N_W, N_O)
Noordzee_Stone_N_2027B <- Noordzee_Stone_N_2027B %>%
  mutate(Stone_N = Percent * Release_Fra_N * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_N_2027B, file = "../Results/Noordzee_Stone_N_2027B.csv")
# -------------------------------------
# Stone P
Noordzee_Stone_P_2027B <- select(Routing_Stone_P_2027B, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

P_WenO <- filter(Noordzee_Stone_P_2027B, Into == "Wester- en Oosterschelde")
P_W <- mutate(P_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
P_O <- mutate(P_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_P_2027B <- Noordzee_Stone_P_2027B %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(P_W, P_O)
Noordzee_Stone_P_2027B <- Noordzee_Stone_P_2027B %>%
  mutate(Stone_P = Percent * Release_Fra_P * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_P_2027B, file = "../Results/Noordzee_Stone_P_2027B.csv")
# -------------------------------------
# Prepare data for river routing
# Stone N
Noordzee_Stone_N_2027C <- select(Routing_Stone_N_2027C, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

N_WenO <- filter(Noordzee_Stone_N_2027C, Into == "Wester- en Oosterschelde")
N_W <- mutate(N_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
N_O <- mutate(N_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_N_2027C <- Noordzee_Stone_N_2027C %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(N_W, N_O)
Noordzee_Stone_N_2027C <- Noordzee_Stone_N_2027C %>%
  mutate(Stone_N = Percent * Release_Fra_N * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_N_2027C, file = "../Results/Noordzee_Stone_N_2027C.csv")
# -------------------------------------
# Stone P
Noordzee_Stone_P_2027C <- select(Routing_Stone_P_2027C, ID, Year, Month, Afwenteling) %>%
  inner_join(Routing_Sea, by = "ID")

P_WenO <- filter(Noordzee_Stone_P_2027C, Into == "Wester- en Oosterschelde")
P_W <- mutate(P_WenO, Afwenteling = 0.7 * Afwenteling, Into = "Westerschelde")
P_O <- mutate(P_WenO, Afwenteling = 0.3 * Afwenteling, Into = "Oosterschelde")

Noordzee_Stone_P_2027C <- Noordzee_Stone_P_2027C %>%
  filter(!Into %in% c("Wester- en Oosterschelde", "**Duitsland")) %>%
  bind_rows(P_W, P_O)
Noordzee_Stone_P_2027C <- Noordzee_Stone_P_2027C %>%
  mutate(Stone_P = Percent * Release_Fra_P * Afwenteling) %>%
  group_by(Year, Month, Into) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop")

write.csv(Noordzee_Stone_P_2027C, file = "../Results/Noordzee_Stone_P_2027C.csv")
# -------------------------------------
Noordzee_Stone_N_2019 <- Noordzee_Stone_N_2019 %>%
  spread(Into, Stone_N)
write.csv(Noordzee_Stone_N_2019, "../Results/Yearly/Noordzee_Stone_N_2019.csv")

Noordzee_Stone_P_2019 <- Noordzee_Stone_P_2019 %>%
  spread(Into, Stone_P)
write.csv(Noordzee_Stone_P_2019, "../Results/Yearly/Noordzee_Stone_P_2019.csv")

Noordzee_Stone_N_2027B <- Noordzee_Stone_N_2027B %>%
  spread(Into, Stone_N)
write.csv(Noordzee_Stone_N_2027B, "../Results/Yearly/Noordzee_Stone_N_2027B.csv")

Noordzee_Stone_P_2027B <- Noordzee_Stone_P_2027B %>%
  spread(Into, Stone_P)
write.csv(Noordzee_Stone_P_2027B, "../Results/Yearly/Noordzee_Stone_P_2027B.csv")

Noordzee_Stone_N_2027C <- Noordzee_Stone_N_2027C %>%
  spread(Into, Stone_N)
write.csv(Noordzee_Stone_N_2027C, "../Results/Yearly/Noordzee_Stone_N_2027C.csv")

Noordzee_Stone_P_2027C <- Noordzee_Stone_P_2027C %>%
  spread(Into, Stone_P)
write.csv(Noordzee_Stone_P_2027C, "../Results/Yearly/Noordzee_Stone_P_2027C.csv")

Ret_Stone_N_Yearly_2019 <- Routing_Stone_N_2019 %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_N = sum(Ret_Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_N)
write.csv(Ret_Stone_N_Yearly_2019, "../Results/Yearly/Ret_Stone_N_Yearly_2019.csv")

Ret_Stone_P_Yearly_2019 <- Nutrient %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_P = sum(Ret_Stone_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_P)
write.csv(Ret_Stone_P_Yearly_2019, "../Results/Yearly/Ret_Stone_P_Yearly_2019.csv")

Ret_Stone_N_Yearly_2027B <- Routing_Stone_N_2027B %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_N = sum(Ret_Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_N)
write.csv(Ret_Stone_N_Yearly_2027B, "../Results/Yearly/Ret_Stone_N_Yearly_2027B.csv")

Ret_Stone_P_Yearly_2027B <- Routing_Stone_P_2027B %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_P = sum(Ret_Stone_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_P)
write.csv(Ret_Stone_P_Yearly_2027B, "../Results/Yearly/Ret_Stone_P_Yearly_2027B.csv")

Ret_Stone_N_Yearly_2027C <- Routing_Stone_N_2027C %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_N = sum(Ret_Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_N)
write.csv(Ret_Stone_N_Yearly_2027C, "../Results/Yearly/Ret_Stone_N_Yearly_2027C.csv")

Ret_Stone_P_Yearly_2027C <- Routing_Stone_P_2027C %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_P = sum(Ret_Stone_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_P)
write.csv(Ret_Stone_P_Yearly_2027C, "../Results/Yearly/Ret_Stone_P_Yearly_2027C.csv")