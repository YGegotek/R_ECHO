# Title: TODO
# Objective: TODO
# Created by: Yanjiao
# Created on: 12/21/20212:50 PM

NP3 <- read_csv("../Inlet/NP3.csv", show_col_types = FALSE) %>%
  separate(Date, into = c("Day", "Month", "Year"), sep = "-") %>%
  drop_na()

NP3$Mesaurement <- str_replace(NP3$Mesaurement,"^,", "0.")
NP3$Mesaurement <- as.numeric(str_replace(NP3$Mesaurement,",", "."))

NP3 <- mutate(NP3, Mesaurement = replace(Mesaurement, Mesaurement 1000, "NA"))

write.csv(NP3, file = "../Inlet/Masssluitnew.csv")
#----------------------------------------------------------------------------------------------
RWZI_Catchment <- read_csv("../Emission_registration/RWZI/RWZI_Catchment.csv", show_col_types = FALSE) %>%
  rename(NAAM = RWZI)
RWZI_Catchment$NAAM <-  str_to_lower(RWZI_Catchment$NAAM, locale = "en")

ER_2015_channel <- odbcConnectAccess2007(ACCDB_ER_2015)
ER_RWZI_2015 <- sqlQuery(ER_2015_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2015")
odbcCloseAll()

RWZI_2015_N <- ER_RWZI_2015 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
  select(NAAM, TNO_CODE)
RWZI_2015_N$NAAM <- str_remove(RWZI_2015_N$NAAM, "RWZI ")
RWZI_2015_N$NAAM <- str_remove(RWZI_2015_N$NAAM, "AWZI ")
RWZI_2015_N$NAAM <- str_to_lower(RWZI_2015_N$NAAM, locale = "en")

ER_2016_channel <- odbcConnectAccess2007(ACCDB_ER_2016)
ER_RWZI_2016 <- sqlQuery(ER_2016_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2016")
odbcCloseAll()

RWZI_2016_N <- ER_RWZI_2016 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
  select(NAAM, TNO_CODE)
RWZI_2016_N$NAAM <- str_remove(RWZI_2016_N$NAAM, "RWZI ")
RWZI_2016_N$NAAM <- str_remove(RWZI_2016_N$NAAM, "AWZI ")
RWZI_2016_N$NAAM <- str_to_lower(RWZI_2016_N$NAAM, locale = "en")

ER_2018_channel <- odbcConnectAccess2007(ACCDB_ER_2018)
ER_RWZI_2018 <- sqlQuery(ER_2018_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2018")
odbcCloseAll()

RWZI_2018_N <- ER_RWZI_2018 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
  select(NAAM, TNO_CODE)
RWZI_2018_N$NAAM <- str_remove(RWZI_2018_N$NAAM, "RWZI ")
RWZI_2018_N$NAAM <- str_remove(RWZI_2018_N$NAAM, "AWZI ")
RWZI_2018_N$NAAM <- str_to_lower(RWZI_2018_N$NAAM, locale = "en")

ER_2019_channel <- odbcConnectAccess2007(ACCDB_ER_2019)
ER_RWZI_2019 <- sqlQuery(ER_2019_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2019")
odbcCloseAll()

RWZI_2019_N <- ER_RWZI_2019 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
  select(NAAM, TNO_CODE)
RWZI_2019_N$NAAM <- str_remove(RWZI_2019_N$NAAM, "RWZI ")
RWZI_2019_N$NAAM <- str_remove(RWZI_2019_N$NAAM, "AWZI ")
RWZI_2019_N$NAAM <- str_to_lower(RWZI_2019_N$NAAM, locale = "en")

RWZI_all <- full_join(RWZI_Catchment, RWZI_2015_N, by = "NAAM") %>%
  full_join(RWZI_2016_N, by = "NAAM") %>%
  full_join(RWZI_2018_N, by = "NAAM") %>%
  full_join(RWZI_2019_N, by = "NAAM")

write.csv(RWZI_all, file = "../Emission_registration//RWZI/RWZI_TNO_ID_new.csv")

#------------------------------------------------------------------------------------------------------------------
RWZI_2010_P <- ER_2010_P %>%
   filter(Group == "RWZI")

RWZI_2010_P <- add_row(RWZI_2010_P, filter(RWZI_2010_P, AI_code %in% c(1414, 2068, 2980)))

RWZI_2010_P[237,2]=14141
RWZI_2010_P[238,2]=20681
RWZI_2010_P[239,2]=29801
RWZI_2010_P[237,4]=RWZI_2010_P[237,4]*0.25
RWZI_2010_P[238,4]=RWZI_2010_P[238,4]*0.54
RWZI_2010_P[239,4]=RWZI_2010_P[239,4]*0.3
RWZI_2010_P[211,4]=RWZI_2010_P[211,4]*0.7
RWZI_2010_P[139,4]=RWZI_2010_P[139,4]*0.46
RWZI_2010_P[82,4]=RWZI_2010_P[82,4]*0.75

write.csv(RWZI_2010_P, file = "../Emission_registration/RWZI_2010_P.csv")
#--------------------------------------------------------------------------------------

RWZI_Catchment <- read_csv("../Emission_registration/RWZI_AI_code_ID.csv", show_col_types = FALSE)

RWZI_2010_N <- read_csv(CSV_RWZI_2010_N, show_col_types = FALSE)

RWZI_2010_N <- left_join(RWZI_2010_N, select(RWZI_Catchment, ID, AI_code), by = "AI_code") %>%
  select(Year, ID, Emission) %>%
  group_by(Year, ID) %>%
  summarise(across(Emission, sum), .groups = "drop")

write.csv(RWZI_2010_N, file = "../Emission_registration/RWZI_2010_N_check.csv")
#--------------------------------------------------------------------------------------
RWZI_2010_P <- read_csv(CSV_RWZI_2010_P, show_col_types = FALSE)  %>%
  rename(P2010 = Emission) %>%
  select(AI_code, P2010)
RWZI_2011_P <- read_csv(CSV_RWZI_2011_P, show_col_types = FALSE)  %>%
  rename(P2011 = Emission) %>%
  select(AI_code, P2011)
RWZI_2012_P <- read_csv(CSV_RWZI_2012_P, show_col_types = FALSE)  %>%
  rename(P2012 = Emission) %>%
  select(AI_code, P2012)
RWZI_2013_P <- read_csv(CSV_RWZI_2013_P, show_col_types = FALSE)  %>%
  rename(P2013 = Emission) %>%
  select(AI_code, P2013)
RWZI_2014_P <- read_csv(CSV_RWZI_2014_P, show_col_types = FALSE)  %>%
  rename(P2014 = Emission) %>%
  select(AI_code, P2014)
RWZI_2017_P <- read_csv(CSV_RWZI_2017_P, show_col_types = FALSE)  %>%
  rename(P2017 = Emission) %>%
  select(AI_code, P2017)

RWZI_P <- RWZI_2010_P %>%
  full_join(RWZI_2011_P, by = "AI_code") %>%
  full_join(RWZI_2012_P, by = "AI_code") %>%
  full_join(RWZI_2013_P, by = "AI_code") %>%
  full_join(RWZI_2014_P, by = "AI_code") %>%
  full_join(RWZI_2017_P, by = "AI_code")

write.csv(RWZI_P, file = "../Emission_registration/RWZI/RWZI_P.csv")
#--------------------------------------------------------------------------------------------------------------------------
ER_2015_channel <- odbcConnectAccess2007(ACCDB_ER_2015)
ER_RWZI_2015 <- sqlQuery(ER_2015_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2015")
odbcCloseAll()

RWZI_2015_N <- ER_RWZI_2015 %>%
     filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
     select(TNO_CODE, EMISSIE)%>%
     rename(N2015 = EMISSIE)

ER_2016_channel <- odbcConnectAccess2007(ACCDB_ER_2016)
ER_RWZI_2016 <- sqlQuery(ER_2016_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2016")
odbcCloseAll()

RWZI_2016_N <- ER_RWZI_2016 %>%
   filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
   select(TNO_CODE, EMISSIE)%>%
   rename(N2016 = EMISSIE)
ER_2018_channel <- odbcConnectAccess2007(ACCDB_ER_2018)
ER_RWZI_2018 <- sqlQuery(ER_2018_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2018")
odbcCloseAll()

RWZI_2018_N <- ER_RWZI_2018 %>%
   filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
   select(TNO_CODE, EMISSIE)%>%
   rename(N2018 = EMISSIE)
ER_2019_channel <- odbcConnectAccess2007(ACCDB_ER_2019)
ER_RWZI_2019 <- sqlQuery(ER_2019_channel, "SELECT TNO_CODE, NAAM, GAF_90_AI_CODE, GOF_CODE, EMISSIE   FROM belasting_individueel_compleet_2019")
odbcCloseAll()

RWZI_2019_N <- ER_RWZI_2019 %>%
   filter(str_detect(NAAM, "WZI"), GOF_CODE == 303) %>%
   select(TNO_CODE, EMISSIE)%>%
   rename(N2019 = EMISSIE)

RWZI_N_ACCDB <- RWZI_2015_N %>%
  full_join(RWZI_2016_N, by = "TNO_CODE") %>%
  full_join(RWZI_2018_N, by = "TNO_CODE") %>%
  full_join(RWZI_2019_N, by = "TNO_CODE")

write.csv(RWZI_N_ACCDB, file = "../Emission_registration/RWZI/RWZI_N_ACCDB.csv")

RWZI_2015_P <- ER_RWZI_2015 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 302) %>%
  select(TNO_CODE, EMISSIE)%>%
  rename(P2015 = EMISSIE)


RWZI_2016_P <- ER_RWZI_2016 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 302) %>%
  select(TNO_CODE, EMISSIE)%>%
  rename(P2016 = EMISSIE)

RWZI_2018_P <- ER_RWZI_2018 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 302) %>%
  select(TNO_CODE, EMISSIE)%>%
  rename(P2018 = EMISSIE)

RWZI_2019_P <- ER_RWZI_2019 %>%
  filter(str_detect(NAAM, "WZI"), GOF_CODE == 302) %>%
  select(TNO_CODE, EMISSIE)%>%
  rename(P2019 = EMISSIE)

RWZI_P_ACCDB <- RWZI_2015_P %>%
  full_join(RWZI_2016_P, by = "TNO_CODE") %>%
  full_join(RWZI_2018_P, by = "TNO_CODE") %>%
  full_join(RWZI_2019_P, by = "TNO_CODE")

write.csv(RWZI_P_ACCDB, file = "../Emission_registration/RWZI/RWZI_P_ACCDB.csv")

RWZI_Catchment_AI <- read_csv(CSV_RWZI_Catchment_TXT, show_col_types = FALSE)
RWZI_Catchment_TNO_ACCDB <- read_csv(CSV_RWZI_Catchment_ACCDB, show_col_types = FALSE)


RWZI_N_ER <- filter(ER_N, Group == "RWZI", !is.na(Emission)) %>%
  left_join(RWZI_Catchment_AI, by = "AI_code") %>%
  spread(Year, Emission) %>%
  group_by(ID) %>%
  summarise(across(-(1:5), sum, na.rm = TRUE), .groups = "drop")
write.csv(RWZI_N_ER, file = "../Results/RWZI_N_ER1.csv")
#----------------------------------------------------------------------
RWZI_N_TXT <- read_csv(CSV_RWZI_N_TXT, show_col_types = FALSE)

RWZI_N_TXT <- RWZI_Catchment_AI %>%
  select(ID, AI_code) %>%
  full_join(RWZI_N_TXT, by = "AI_code") %>%
  group_by(ID) %>%
  summarise(across(-(1), sum, na.rm = TRUE), .groups = "drop")
#----------------------------------------------------------------------
RWZI_P_TXT <- read_csv(CSV_RWZI_P_TXT, show_col_types = FALSE)

RWZI_P_TXT <- RWZI_Catchment_AI %>%
  select(ID, AI_code) %>%
  full_join(RWZI_P_TXT, by = "AI_code") %>%
  group_by(ID) %>%
  summarise(across(-(1), sum, na.rm = TRUE), .groups = "drop")
#----------------------------------------------------------------------
RWZI_N_ACCDB <- read_csv(CSV_RWZI_N_ACCDB, show_col_types = FALSE)

RWZI_N_ACCDB <- RWZI_Catchment_TNO_ACCDB %>%
  select(ID, TNO_CODE) %>%
  full_join(RWZI_N_ACCDB, by = "TNO_CODE") %>%
  group_by(ID) %>%
  summarise(across(-1, sum, na.rm = TRUE), .groups = "drop")
#----------------------------------------------------------------------
RWZI_P_ACCDB <- read_csv(CSV_RWZI_P_ACCDB, show_col_types = FALSE)

RWZI_P_ACCDB <- RWZI_Catchment_TNO_ACCDB %>%
  select(ID, TNO_CODE) %>%
  full_join(RWZI_P_ACCDB, by = "TNO_CODE") %>%
  group_by(ID) %>%
  summarise(across(-1, sum, na.rm = TRUE), .groups = "drop")

RWZI_N <- full_join(RWZI_N_TXT, RWZI_N_ACCDB, by = "ID")
RWZI_N <- RWZI_N[, order(colnames(RWZI_N))]

RWZI_P <- full_join(RWZI_P_TXT, RWZI_P_ACCDB, by = "ID")
RWZI_P <- RWZI_P[, order(colnames(RWZI_P))]

write.csv(RWZI_N, file = "../Results/RWZI_N.csv")
write.csv(RWZI_P, file = "../Results/RWZI_P.csv")

#----------------------------------------------------------------------------
CSV_IN_buitenland <- "../Inlet/IN_buitenland.csv"

IN_buitenland <- read_csv(CSV_IN_buitenland, show_col_types = FALSE)
IN_buitenland$observation <- na_if(IN_buitenland$observation, -999.0)

IN_buitenland_N_mean <- IN_buitenland %>%
  filter(property == "N_total", location_code %in% Catchment_buitenland_2$kwaliteit) %>%
  separate(date_start, into = c("Month", "Day", "Year"), sep = "/") %>%
  mutate(N = observation * 1000 /12) %>%
  select(location_code, Year, N)
write.csv(IN_buitenland_N_mean, "../Inlet/IN_buitenland_N_mean3.csv")

  summarise(N = mean(observation, na.rm = TRUE), .groups = "drop") %>%
  spread(location_code, N)

# Calculate mean inlet Q per location, per month (m3/s)
IN_buitenland_Q_mean <- IN_buitenland %>%
  filter(property == "discharge", location_code %in% Catchment_buitenland$debiet) %>%
  separate(date_start, into = c("Month", "Day", "Year"), sep = "/") %>%
  group_by(location_code, Year, Month) %>%
  summarise(Q = mean(observation, na.rm = TRUE), .groups = "drop") %>%
  spread(location_code, Q)

Q5253 <- select(IN_buitenland_Q_mean, 1:2, 11:12)
write.csv(Q5253, "../Inlet/Q5253.csv")

IN_buitenland_N_mean <- IN_buitenland %>%
  filter(property == "N_total", location_code %in% Catchment_buitenland$kwaliteit) %>%
  separate(date_start, into = c("Month", "Day", "Year"), sep = "/") %>%
  group_by(location_code, Year, Month) %>%
  summarise(N = mean(observation, na.rm = TRUE), .groups = "drop") %>%
  spread(location_code, N)

write.csv(IN_buitenland_N_mean, "../Inlet/IN_buitenland_N_mean.csv")

IN_buitenland_P_mean <- IN_buitenland %>%
  filter(property == "P_total", location_code %in% Catchment_buitenland$kwaliteit) %>%
  separate(date_start, into = c("Month", "Day", "Year"), sep = "/") %>%
  group_by(location_code, Year, Month) %>%
  summarise(P = mean(observation, na.rm = TRUE), .groups = "drop") %>%
  spread(location_code, P)

write.csv(IN_buitenland_P_mean, "../Inlet/IN_buitenland_P_mean.csv")

IN_buitenland_P_mean <- IN_buitenland %>%
  filter(property == "P_total", location_code %in% Catchment_buitenland_2$kwaliteit) %>%
  separate(date_start, into = c("Month", "Day", "Year"), sep = "/") %>%
  mutate(P = observation * 1000 /12) %>%
  select(location_code, Year, P)
write.csv(IN_buitenland_P_mean, "../Inlet/IN_buitenland_P_mean2.csv")

IN_buitenland_Q_mean$Days <- days_in_month(as.Date(paste(IN_buitenland_Q_mean$Year, Inlet_Q_mean$Month,"01", sep = "-")))
IN_buitenland_Q_mean <- mutate(IN_buitenland_Q_mean, Discharge = Q * Days * 86400) #in m3/month


IN_buitenland_P_Monthly2 <- read_csv(CSV_IN_buitenland_P_mean2, show_col_types = FALSE) %>%
  filter(Year %in% YoI) %>%
  left_join(Catchment_buitenland_2, by = c("location_code" = "kwaliteit")) %>%
  group_by(ID, Year)  %>%
  summarise(BL_P = sum(P, na.rm = TRUE), .groups = "drop")
write.csv(IN_buitenland_P_Monthly2, "../Inlet/IN_buitenland_P_mean_raw.csv")
IN_buitenland_P_Monthly3 <- IN_buitenland_P_Monthly2 %>%
  group_by(ID)  %>%
  summarise(BL_P = mean(BL_P, na.rm = TRUE), .groups = "drop")


IN_buitenland_N_Monthly2 <- left_join(Catchment_Time, IN_buitenland_N_Monthly2, by = c("ID", "Year"))  %>% #kg/month
  left_join(IN_buitenland_N_Monthly3, by = "ID")

#----------------------------------------------------------------------------
Stone_N_Yearly <- Stone_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Stone_N)
write.csv(Stone_N_Yearly, "../Results/Yearly/Stone_N_Yearly.csv")

Stone_P_Yearly <- Stone_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(Stone_P = sum(Stone_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Stone_P)
write.csv(Stone_P_Yearly, "../Results/Yearly/Stone_P_Yearly.csv")

DW_N_Yearly <- DW_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(DW_N = sum(DW_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, DW_N)
write.csv(DW_N_Yearly, "../Results/Yearly/DW_N_Yearly.csv")

DW_P_Yearly <- DW_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(DW_P = sum(DW_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, DW_P)
write.csv(DW_P_Yearly, "../Results/Yearly/DW_P_Yearly.csv")


IN_N_Yearly <- IN_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(IN_N = sum(IN_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, IN_N)
write.csv(IN_N_Yearly, "../Results/Yearly/IN_N_Yearly.csv")

IN_P_Yearly <- IN_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(IN_P = sum(IN_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, IN_P)
write.csv(IN_P_Yearly, "../Results/Yearly/IN_P_Yearly.csv")

OR_N_Yearly <- OR_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(OR_N = sum(OR_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, OR_N)
write.csv(OR_N_Yearly, "../Results/Yearly/OR_N_Yearly.csv")

OR_P_Yearly <- OR_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(OR_P = sum(OR_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, OR_P)
write.csv(OR_P_Yearly, "../Results/Yearly/OR_P_Yearly.csv")

LO_N_Yearly <- LO_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(LO_N = sum(LO_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, LO_N)
write.csv(LO_N_Yearly, "../Results/Yearly/LO_N_Yearly.csv")

LO_P_Yearly <- LO_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(LO_P = sum(LO_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, LO_P)
write.csv(LO_P_Yearly, "../Results/Yearly/LO_P_Yearly.csv")

RWZI_N_Yearly <- RWZI_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(RWZI_N = sum(RWZI_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, RWZI_N)
write.csv(RWZI_N_Yearly, "../Results/Yearly/RWZI_N_Yearly.csv")

RWZI_P_Yearly <- RWZI_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(RWZI_P = sum(RWZI_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, RWZI_P)
write.csv(RWZI_P_Yearly, "../Results/Yearly/RWZI_P_Yearly.csv")

IN_Buitenland_N_Yearly <- IN_buitenland_N_Monthly %>%
  group_by(ID, Year) %>%
  summarise(BL_N = sum(BL_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, BL_N)
write.csv(IN_Buitenland_N_Yearly, "../Results/Yearly/BL_Small_N_Yearly.csv")

IN_Buitenland_P_Yearly <- IN_buitenland_P_Monthly %>%
  group_by(ID, Year) %>%
  summarise(BL_P = sum(BL_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, BL_P)
write.csv(IN_Buitenland_P_Yearly, "../Results/Yearly/BL_Small_P_Yearly.csv")

Inlet_N_Yearly <- Inlet_N_Monthly %>%
  group_by(Location, Year) %>%
  summarise(BL_N = sum(Inlet_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, BL_N)
write.csv(Inlet_N_Yearly, "../Results/Yearly/BL_Big_N_Yearly.csv")

Inlet_P_Yearly <- Inlet_P_Monthly %>%
  group_by(Location, Year) %>%
  summarise(BL_P = sum(Inlet_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, BL_P)
write.csv(Inlet_P_Yearly, "../Results/Yearly/BL_Big_P_Yearly.csv")

Ret_Stone_N_Yearly <- Routing_Stone_N %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_N = sum(Ret_Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_N)
write.csv(Ret_Stone_N_Yearly, "../Results/Yearly/Ret_Stone_N_Yearly.csv")

Ret_Stone_N_Yearly <- Routing_Stone_N %>%
  group_by(ID, Year) %>%
  summarise(Stone_N = sum(Stone_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Stone_N)
write.csv(Ret_Stone_N_Yearly, "../Results/Yearly/Ret_Stone_N_Yearly1.csv")


Ret_Stone_P_Yearly <- Routing_Stone_P %>%
  group_by(ID, Year) %>%
  summarise(Ret_Stone_P = sum(Ret_Stone_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_Stone_P)
write.csv(Ret_Stone_P_Yearly, "../Results/Yearly/Ret_Stone_P_Yearly.csv")

Ret_ER_N_Yearly <- Routing_ER_N %>%
  group_by(ID, Year) %>%
  summarise(Ret_ER_N = sum(Ret_ER_N, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_ER_N)
write.csv(Ret_ER_N_Yearly, "../Results/Yearly/Ret_ER_N_Yearly.csv")

Ret_ER_P_Yearly <- Routing_ER_P %>%
  group_by(ID, Year) %>%
  summarise(Ret_ER_P = sum(Ret_ER_P, na.rm = TRUE), .groups = "drop") %>%
  spread(Year, Ret_ER_P)
write.csv(Ret_ER_P_Yearly, "../Results/Yearly/Ret_ER_P_Yearly.csv")

Noordzee_BL_N <- Noordzee_BL_N %>%
  spread(Into, BL_N)
write.csv(Noordzee_BL_N, "../Results/Yearly/Noordzee_BL_Big_N.csv")

Noordzee_BL_P <- Noordzee_BL_P %>%
  spread(Into, BL_P)
write.csv(Noordzee_BL_P, "../Results/Yearly/Noordzee_BL_Big_P.csv")

Noordzee_Inlet_N <- Noordzee_Inlet_N %>%
  spread(Into, Inlet_N)
write.csv(Noordzee_Inlet_N, "../Results/Yearly/Noordzee_BL_Small_N.csv")

Noordzee_Inlet_P <- Noordzee_Inlet_P %>%
  spread(Into, Inlet_P)
write.csv(Noordzee_Inlet_P, "../Results/Yearly/Noordzee_BL_Small_P.csv")

Noordzee_DW_N <- Noordzee_DW_N %>%
  spread(Into, DW_N)
write.csv(Noordzee_DW_N, "../Results/Yearly/Noordzee_DW_N.csv")

Noordzee_DW_P <- Noordzee_DW_P %>%
  spread(Into, DW_P)
write.csv(Noordzee_DW_P, "../Results/Yearly/Noordzee_DW_P.csv")

Noordzee_IN_N <- Noordzee_IN_N %>%
  spread(Into, IN_N)
write.csv(Noordzee_IN_N, "../Results/Yearly/Noordzee_IN_N.csv")

Noordzee_IN_P <- Noordzee_IN_P %>%
  spread(Into, IN_P)
write.csv(Noordzee_IN_P, "../Results/Yearly/Noordzee_IN_P.csv")

Noordzee_LO_N <- Noordzee_LO_N %>%
  spread(Into, LO_N)
write.csv(Noordzee_LO_N, "../Results/Yearly/Noordzee_LO_N.csv")

Noordzee_LO_P <- Noordzee_LO_P %>%
  spread(Into, LO_P)
write.csv(Noordzee_LO_P, "../Results/Yearly/Noordzee_LO_P.csv")

Noordzee_OR_N <- Noordzee_OR_N %>%
  spread(Into, OR_N)
write.csv(Noordzee_OR_N, "../Results/Yearly/Noordzee_OR_N.csv")

Noordzee_OR_P <- Noordzee_OR_P %>%
  spread(Into, OR_P)
write.csv(Noordzee_OR_P, "../Results/Yearly/Noordzee_OR_P.csv")

Noordzee_RWZI_N <- Noordzee_RWZI_N %>%
  spread(Into, RWZI_N)
write.csv(Noordzee_RWZI_N, "../Results/Yearly/Noordzee_RWZI_N.csv")

Noordzee_RWZI_P <- Noordzee_RWZI_P %>%
  spread(Into, RWZI_P)
write.csv(Noordzee_RWZI_P, "../Results/Yearly/Noordzee_RWZI_P.csv")

Noordzee_Stone_N <- Noordzee_Stone_N %>%
  spread(Into, Stone_N)
write.csv(Noordzee_Stone_N, "../Results/Yearly/Noordzee_Stone_N.csv")

Noordzee_Stone_P <- Noordzee_Stone_P %>%
  spread(Into, Stone_P)
write.csv(Noordzee_Stone_P, "../Results/Yearly/Noordzee_Stone_P.csv")