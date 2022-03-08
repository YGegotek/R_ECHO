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