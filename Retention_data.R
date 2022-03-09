
# Retention
# U&A
Soil <- as.data.frame(read_delim(TXT_Soil, show_col_types = FALSE))

Retention_UA_N <- Soil %>%
  mutate(Ret_Absolute_Summer = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_summer_incl_ha * 10 * N_Ret_Klei_Summer_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_summer_incl_ha * 10 * N_Ret_Veen_Summer_gNm2,
                                         TRUE ~ 1e100),
         Ret_Absolute_Winter = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_winter_incl_ha * 10 * N_Ret_Klei_Winter_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_winter_incl_ha * 10 * N_Ret_Veen_Winter_gNm2,
                                         TRUE ~ 1e100),
         Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ N_b_Summer, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.9,
                                         TRUE ~ 0.5),
         Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ N_b_Winter, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.9,
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)

write.csv(Retention_UA_N, file = "../Retention/Retention_UA_N.csv", row.names = FALSE)

Retention_UA_P <- Soil %>%
  mutate(Ret_Absolute_Summer = 1e100,
         Ret_Absolute_Winter = 1e100,
         Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ P_b_Summer, 0.9),
                                         TRUE ~ 0.5),
         Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ P_b_Winter, 0.9),
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)

write.csv(Retention_UA_P, file = "../Retention/Retention_UA_p.csv", row.names = FALSE)
#-------------------------------------------------------------------------------------------------------
# retention fraction overige
Retention_ER_N <- Soil %>%
  mutate(Ret_Absolute_Summer = 1e100,
         Ret_Absolute_Winter = 1e100,
         Ret_Fraction_Summer = case_when(TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.0,
                                         TRUE ~ 0.2),
         Ret_Fraction_Winter = case_when(TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.0,
                                         TRUE ~ 0.2)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)
write.csv(Retention_ER_N, file = "../Retention/Retention_ER_N.csv", row.names = FALSE)
Retention_ER_P <- Soil %>%
  mutate(Ret_Absolute_Summer = 1e100,
         Ret_Absolute_Winter = 1e100,
         Ret_Fraction_Summer = 0.2,
         Ret_Fraction_Winter = 0.2) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)
write.csv(Retention_ER_P, file = "../Retention/Retention_ER_P.csv", row.names = FALSE)
#------------------------------------------------------------------------------------------------------------------------