#-----------------------------
# Load packages, constants and functions
#-----------------------------
pacman::p_load("tidyverse", "sf", "RODBC", "lubridate")

source("Directories.R")
source("Functions.R")
source("Constants.R")

# load STONE shape files: 538 catchments (ha), and merge with stone plot numbers
Catchment <- read_csv(CSV_Catchment, show_col_types = FALSE) %>%
  rename(ID = 1, Water_Body = 2, Area_Catchment = 3)

# Prepare fundamental data frame
Catchment_Time <- tibble(ID = rep(1:NoC, each = length(YoI) * 12), Year = rep(rep(YoI, each = 12), NoC), Month = rep(1:12, NoC * length(YoI)))

# Catchment ID vs Stone plot number, with plot area
Catchment_Plot <- as.data.frame(read_delim(TXT_Catchment_Plot, show_col_types = FALSE)) %>%
  rename(ID = 1, Plot = 2, Area_Plot = 3)
###############################################################################################################################
# Agriculture and nature
###############################################################################################################################
# load STONE output data, years of interest
# P(kg/m2/decade), N(kg/m2/decade))
UA <- read_csv(CSV_Stone, show_col_types = FALSE)
#------------------------------------------------------------------------------------------------------------------
# N (kg)
# Monthly
for (i in Nutrients) {
  Emission_Monthly <- UA %>%
    select(Plot, Year, Month, i) %>%
    group_by(Plot, Year, Month) %>%
    rename(Emission = i) %>%
    summarise(Emission = sum(Emission, na.rm = TRUE), .groups = "drop") %>%
    right_join(Catchment_Plot, by = "Plot") %>%
    mutate(Emission = Area_Plot * Emission) %>%
    group_by(ID, Year, Month) %>%
    summarise(Emission = sum(Emission, na.rm = TRUE), .groups = "drop")
  Emission_Monthly <- left_join(Catchment_Time, Emission_Monthly, by = c("ID", "Year", "Month")) %>%
    replace(is.na(.), 0.0)
  write.csv(Emission_Monthly, file = paste0("../Results/UA_", i,"_Monthly.csv"), row.names = FALSE)

  Emission_Yearly <- Emission_Monthly %>%
    group_by(ID, Year) %>%
    summarise(Emission = sum(Emission, na.rm = TRUE), .groups = "drop")
  write.csv(Emission_Yearly, file = paste0("../Results/UA_", i,"_Yearly.csv"), row.names = FALSE)
}
###############################################################################################################################
# Emission from Emission Registration (ER) for open water, kg
#--------------------------------------------------------------------------------------------
# load Catchment-ER matching file (538 catchments overlay with gaf90)
Catchment_ER <- read_csv(CSV_Catchment_ER, show_col_types = FALSE)
# load Catchment-RWZI matching file
RWZI_Catchment_AI <- read_csv(CSV_RWZI_Catchment, show_col_types = FALSE)
# Load ER emissions
ER <- read_csv(CSV_ER, show_col_types = FALSE)

for (i in Nutrients) {
  # RWZI
  Emission_Yearly <- filter(ER, Stofcode == i, Group == "RWZI") %>%
    left_join(RWZI_Catchment_AI, by = "AI_code") %>%
    drop_na() %>%
    group_by(ID, Year) %>%
    summarise(Emission = sum(Emission, na.rm = TRUE), .groups = "drop") %>%
    spread(Year, Emission) %>%
    pivot_longer(cols = -1, names_to ="Year", values_to = "Emission") %>%
    group_by(ID) %>%
    mutate(Emission = ifelse(is.na(Emission), mean(Emission, na.rm = TRUE), Emission))
  write.csv(Emission_Yearly, file = paste0("../Results/RWZI_", i, "_Yearly.csv"), row.names = FALSE)

  Emission_Yearly$Year <- as.numeric(Emission_Yearly$Year)
  Emission_Monthly <- mutate(Emission_Yearly, Emission = Emission/12)
  Emission_Monthly <- left_join(Catchment_Time, Emission_Monthly, by = c("ID", "Year")) %>%
    replace(is.na(.), 0.0)
  write.csv(Emission_Monthly, file = paste0("../Results/RWZI_", i, "_Monthly.csv"), row.names = FALSE)

  # Other sources
  for (j in Sources){
    Emission_Yearly <- filter(ER, Stofcode == i, Group == j, !is.na(Emission)) %>%
      left_join(Catchment_ER,  by = "AI_code") %>%
      group_by(ID, Year) %>%
      summarise(Emission = sum(Emission, na.rm = TRUE), .groups = "drop") %>%
      spread(Year, Emission) %>%
      pivot_longer(cols = -1, names_to ="Year", values_to = "Emission") %>%
      group_by(ID) %>%
      mutate(Emission = ifelse(is.na(Emission), mean(Emission, na.rm = TRUE), Emission))
    write.csv(Emission_Yearly, file = paste0("../Results/", j, "_", i, "_Yearly.csv"), row.names = FALSE)

    Emission_Yearly$Year <- as.numeric(Emission_Yearly$Year)
    Emission_Monthly <- mutate(Emission_Yearly, Emission = Emission/12)
    Emission_Monthly <- left_join(Catchment_Time, Emission_Monthly, by = c("ID", "Year")) %>%
      replace(is.na(.), 0.0)
    write.csv(Emission_Monthly, file = paste0("../Results/", j, "_", i, "_Monthly.csv"), row.names = FALSE)
  }
}
######################################################################################################################
# Retention
Retention_UA_N <- read_csv(CSV_Retention_UA_N, show_col_types = FALSE)
Retention_UA_P <- read_csv(CSV_Retention_UA_P, show_col_types = FALSE)
Retention_ER_N <- read_csv(CSV_Retention_ER_N, show_col_types = FALSE)
Retention_ER_P <- read_csv(CSV_Retention_ER_P, show_col_types = FALSE)
#------------------------------------------------------------------------------------------------------------------------
# Catchment routing
Routing_538 <- as.data.frame(read_delim(TXT_Routing_STONE, show_col_types = FALSE)) %>%
  rename("ID" = "FROM") #from id, to 1, weight 1, to 2, weight 2, to 3, weight 3

for (i in Nutrients) {
  for (j in Sources_Routing) {
    Retention <- read_csv(paste0("../Retention/Retention_", if_else(j == "UA", "UA", "ER"), "_", i, ".csv"), show_col_types = FALSE)
    Nutrient <- read_csv(paste0("../Results/", j, "_", i, "_Monthly.csv"), show_col_types = FALSE) %>%
      left_join(Retention, by = "ID") %>%
      mutate(Ret_Absolute = case_when(Month %in% 4:9 ~ Ret_Absolute_Summer, TRUE ~ Ret_Absolute_Winter),
             Ret_Fraction = case_when(Month %in% 4:9 ~ Ret_Fraction_Summer, TRUE ~ Ret_Fraction_Winter)) %>%
      select(ID, Year, Month, Emission, Ret_Absolute, Ret_Fraction)

    Routing_Nutrient <- Routing_catchment(Routing_538, Nutrient)

    write.csv(Routing_Nutrient, file = paste0("../Results/Routing_", j, "_", i, "_Monthly.csv"), row.names = FALSE)
  }
}
######################################################################################################################
Routing_BL3_N_Monthly <- read_csv(CSV_Inlet_Big_N, show_col_types = FALSE)
Routing_BL3_P_Monthly <- read_csv(CSV_Inlet_Big_P, show_col_types = FALSE)
#------------------------------------------------------------------------------------------------------------------------
# routing to the north sea
Routing_Sea <- read_csv(CSV_Routing_Sea, show_col_types = FALSE)

for (i in Nutrients) {
  for (j in Sources_Routing_Sea) {
    Nutrient <- read_csv(paste0("../Results/Routing_", j, "_", i, "_Monthly.csv"), show_col_types = FALSE)
    Noordzee <- Routing_river(Routing_Sea, Nutrient)

    write.csv(Noordzee, file = paste0("../Results/North_Sea_", j, "_", i, "_Monthly.csv"), row.names = FALSE)
  }
}
#--------------------------------------------