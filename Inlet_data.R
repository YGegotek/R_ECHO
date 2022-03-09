# Inlet and Discharge Q, m3/s
In_Out_let_Q <- read_csv(CSV_In_Out_Q, show_col_types = FALSE)
#------------------------------
# Inlet Q
Inlet_Q_Monthly <- In_Out_let_Q %>%
  filter(Location %in% Inlet_location_Q, Year %in% YoI) %>%
  group_by(Location, Year, Month) %>%
  summarise(Q = mean(Q, na.rm = TRUE), .groups = "drop") %>%
  mutate(Days = days_in_month(as.Date(paste(Year, Month,"01", sep = "-"))), Discharge = Q * Days * 86400) %>%
  select(Location, Year, Month, Discharge)
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# N,P, mg/l
In_Out_NP <- read_csv(CSV_In_Out_NP, show_col_types = FALSE)
#------------------------------
# Incoming N
Inlet_N_Monthly <- In_Out_NP %>%
  select(Location, Day, Month, Year, Parameter, Measurement) %>%
  filter(Parameter %in% c("stikstof Kjeldahl", "nitraat", "nitriet"), Location %in% Inlet_location_NP, Year %in% YoI) %>%
  spread(Parameter, Measurement) %>%
  rename(NO2 = "nitriet", NO3 = "nitraat", NKj = "stikstof Kjeldahl") %>%
  group_by(Location, Year, Month) %>%
  summarise(across(c(NO2, NO3, NKj), mean, na.rm = TRUE), .groups = "drop") %>%
  mutate(Inlet_N = 0.001 * (NKj + NO3 + NO2) * Inlet_Q_Monthly$Discharge) %>%
  select(Location, Year, Month, Inlet_N)

Inlet_Lobptn1 <- filter(Inlet_N_Monthly, Location == "LOBPTN") %>%
  mutate(Location = "LOBPTN1", Inlet_N = Inlet_N * 0.15)
Inlet_Lobptn2 <- filter(Inlet_N_Monthly, Location == "LOBPTN") %>%
  mutate(Location = "LOBPTN2", Inlet_N = Inlet_N * 0.85)
Inlet_N_Monthly <- filter(Inlet_N_Monthly, !Location == "LOBPTN") %>%
  bind_rows(Inlet_Lobptn1, Inlet_Lobptn2) %>%
  mutate(ID = case_when(Location ==  "LOBPTN1" ~ 1002,
                        Location ==  "LOBPTN2" ~ 1004,
                        Location ==  "EIJSDPTN" ~ 1001,
                        Location ==  "SCHAARVODDL" ~ 1003))
write.csv(Inlet_N_Monthly, file = "../Results/Inlet_BigRivers_N_Monthly.csv", row.names = FALSE)

Inlet_N_Yearly <- Inlet_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(Inlet_N = sum(Inlet_N, na.rm = TRUE), .groups = "drop")
write.csv(Inlet_N_Yearly, file = "../Results/Inlet_BigRivers_N_Yearly.csv", row.names = FALSE)
#------------------------------
# Incoming P
Inlet_P_Monthly <- In_Out_NP %>%
  select(Location, Day, Month, Year, Parameter, Measurement) %>%
  filter(Parameter == "fosfor totaal", Location %in% c("EIJSDPTN", "LOBPTN", "SCHAARVODDL"), Year %in% YoI) %>%
  group_by(Location, Year, Month) %>%
  summarise(Inlet_P = mean(Measurement, na.rm = TRUE), .groups = "drop") %>%
  mutate(Inlet_P = 0.001 * Inlet_P * Inlet_Q_Monthly$Discharge) %>%
  select(Location, Year, Month, Inlet_P)
write.csv(Inlet_P_Monthly, file = "../Results/Inlet_BigRivers_P_Monthly.csv", row.names = FALSE)

Inlet_Lobptn1 <- filter(Inlet_P_Monthly, Location == "LOBPTN") %>%
  mutate(Location = "LOBPTN1", Inlet_P = Inlet_P * 0.15)
Inlet_Lobptn2 <- filter(Inlet_P_Monthly, Location == "LOBPTN") %>%
  mutate(Location = "LOBPTN2", Inlet_P = Inlet_P * 0.85)
Inlet_P_Monthly <- filter(Inlet_P_Monthly, !Location == "LOBPTN") %>%
  bind_rows(Inlet_Lobptn1, Inlet_Lobptn2) %>%
  mutate(ID = case_when(Location ==  "LOBPTN1" ~ 1002,
                        Location ==  "LOBPTN2" ~ 1004,
                        Location ==  "EIJSDPTN" ~ 1001,
                        Location ==  "SCHAARVODDL" ~ 1003))
write.csv(Inlet_P_Monthly, file = "../Results/Inlet_BigRivers_P_Monthly.csv", row.names = FALSE)

Inlet_P_Yearly <- Inlet_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(Inlet_P = sum(Inlet_P, na.rm = TRUE), .groups = "drop")
write.csv(Inlet_P_Yearly, file = "../Results/Inlet_BigRivers_P_Yearly.csv", row.names = FALSE)
# ---------------------------------------------------------------------------------------------------------------------
# small streams from neibouring countries
# ---------------------------------------------------------------------------------------------------------------------
Catchment_buitenland <- read_csv(CSV_Catchment_buitenland, show_col_types = FALSE) %>%
  filter(str_detect(inlaat, "Buitenland"), !str_detect(debiet, "op basis van vrachtbepaling")) %>%
  select(ID, debiet, kwaliteit)

IN_buitenland_Q_Monthly <- read_csv(CSV_IN_buitenland_Q_mean, show_col_types = FALSE) %>%
  filter(Year %in% YoI) %>%
  pivot_longer(cols = 3:37, names_to ="debiet", values_to = "Q") %>%
  mutate(Q = days_in_month(as.Date(paste(Year, Month,"01", sep = "-"))) * 86400 * Q) %>%
  left_join(Catchment_buitenland, by = "debiet")
#  select(ID, Year, Month, Q)
#-------------------------------------------------------------------------------------
# N
# data as concentration
IN_buitenland_N_Monthly <- read_csv(CSV_IN_buitenland_N_mean, show_col_types = FALSE) %>%
  filter(Year %in% YoI)%>%
  pivot_longer(cols = 3:37, names_to = "kwaliteit", values_to = "BL_N") %>%
  left_join(IN_buitenland_Q_Monthly, by = c("Year", "Month", "kwaliteit")) %>%
  drop_na() %>%
  mutate(BL_N = BL_N * Q * 0.001) %>%
  group_by(ID, Year, Month) %>%
  summarise(BL_N = sum(BL_N, na.rm = TRUE), .groups = "drop")

# data as yearly N/P, divided by 12 to get monthly
IN_buitenland_N_Monthly2 <- read_csv(CSV_IN_buitenland_N_mean2, show_col_types = FALSE)
IN_buitenland_N_Monthly2 <- left_join(Catchment_Time, IN_buitenland_N_Monthly2, by = c("ID", "Year")) %>%
  replace(is.na(.), 0.0)

IN_buitenland_N_Monthly <- left_join(Catchment_Time, IN_buitenland_N_Monthly, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0) %>%
  mutate(BL_N = BL_N + IN_buitenland_N_Monthly2$BL_N)
write.csv(IN_buitenland_N_Monthly, file = "../Results/Inlet_SmallRivers_N_Monthly.csv", row.names = FALSE)

IN_buitenland_N_Yearly <- IN_buitenland_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(BL_N = sum(BL_N, na.rm = TRUE), .groups = "drop")
write.csv(IN_buitenland_N_Yearly, file = "../Results/Inlet_SmallRivers_N_Yearly.csv", row.names = FALSE)
#-------------------------------------------------------------------------------------
# P
# data as concentration
IN_buitenland_P_Monthly <- read_csv(CSV_IN_buitenland_P_mean, show_col_types = FALSE) %>%
  filter(Year %in% YoI)%>%
  pivot_longer(cols = 3:37, names_to ="kwaliteit", values_to = "BL_P") %>%
  left_join(IN_buitenland_Q_Monthly, by = c("Year", "Month", "kwaliteit")) %>%
  drop_na() %>%
  mutate(BL_P = BL_P * Q * 0.001) %>%
  group_by(ID, Year, Month) %>%
  summarise(BL_P = sum(BL_P, na.rm = TRUE), .groups = "drop")

# data as yearly N/P, divided by 12 to get monthly
IN_buitenland_P_Monthly2 <- read_csv(CSV_IN_buitenland_P_mean2, show_col_types = FALSE)
IN_buitenland_P_Monthly2 <- left_join(Catchment_Time, IN_buitenland_P_Monthly2, by = c("ID", "Year")) %>%
  replace(is.na(.), 0.0)

IN_buitenland_P_Monthly <- left_join(Catchment_Time, IN_buitenland_P_Monthly, by = c("ID", "Year", "Month")) %>%
  replace(is.na(.), 0.0) %>%
  mutate(BL_P = BL_P + IN_buitenland_P_Monthly2$BL_P)
write.csv(IN_buitenland_P_Monthly, file = "../Results/Inlet_SmallRivers_P_Monthly.csv", row.names = FALSE)

IN_buitenland_P_Yearly <- IN_buitenland_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(BL_P = sum(BL_P, na.rm = TRUE), .groups = "drop")
write.csv(IN_buitenland_P_Yearly, file = "../Results/Inlet_SmallRivers_P_Yearly.csv", row.names = FALSE)