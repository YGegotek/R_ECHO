# Title: TODO
# Objective: TODO
# Created by: Yanjiao
# Created on: 1/12/202210:02 AM

# STAP 3: Uit- en afspoeling: bepaal retentie
#    Gebiedstype        Grondsoort      N                         P
#    -Polder            a)veen          Abs. ret. obv %OpenWater  Rel. ret. 50%
#                       b)klei          Abs. ret. obv %OpenWater  Rel. ret. 50%
#                       c)zand          Rel. ret. 50%             Rel. ret. 50%
#    -Overgangsgebieden	-               Rel. ret. 50%             Rel. ret. 50%
#    -Vrij afwaterend   -               Rel. ret. obv Qspec       Rel. ret. obv Qspec
# Coefficienten voor bepaling retentiefractie vrij afwaterende gebieden (retentie_fractie = a*SR^b , waarbij SR=specific runoff=Q_gebiedseigen / OpenWater_oppervlak)

Soil <- as.data.frame(read_delim(TXT_Soil, show_col_types = FALSE))

Retention_UA_N <- Soil %>%
  mutate(Ret_Absolute_Summer = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_summer_incl_ha * 10000 * N_Ret_Klei_Summer_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_summer_incl_ha * 10000 * N_Ret_Veen_Summer_gNm2,
                                         TRUE ~ 0.0)) %>%
  mutate(Ret_Absolute_Winter = case_when(TYPEAE == "polder" & Bodem =="Klei" ~ OW_winter_incl_ha * 10000 * N_Ret_Klei_Winter_gNm2,
                                         TYPEAE == "polder" & Bodem =="Veen" ~ OW_winter_incl_ha * 10000 * N_Ret_Veen_Winter_gNm2,
                                         TRUE ~ 0.0)) %>%
  mutate(Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ N_b_Summer, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.0,
                                         TRUE ~ 0.5)) %>%
  mutate(Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(N_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ N_b_Winter, 0.9),
                                         TYPEAE == "polder" & Bodem %in% c("Klei", "Veen") ~ 0.0,
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)

Retention_UA_P <- Soil %>%
  mutate(Ret_Absolute_Summer = 0.0) %>%
  mutate(Ret_Absolute_Winter = 0.0) %>%
  mutate(Ret_Fraction_Summer = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Summer * (AfvS_m3s / OW_summer_excl_ha) ^ P_b_Summer, 0.9),
                                         TRUE ~ 0.5)) %>%
  mutate(Ret_Fraction_Winter = case_when(TYPEAE == "vrij afwaterend" ~ pmin(P_a_Winter * (AfvS_m3s / OW_winter_excl_ha) ^ P_b_Winter, 0.9),
                                         TRUE ~ 0.5)) %>%
  select(ID, Ret_Absolute_Summer, Ret_Absolute_Winter, Ret_Fraction_Summer, Ret_Fraction_Winter)
#------------------------------------------------------------------------------------------------------
Routing_538 <- as.data.frame(read_delim(TXT_Routing_STONE, show_col_types = FALSE)) %>%
  rename("ID" = "FROM") #from id, to 1, weight 1, to 2, weight 2, to 3, weight 3
# Calculate the routing process
# N_Summer
# Stone UA
Routing <- Routing_538

Routing_UA_N_Summer <- Stone_N_Summer # self UA + from upper stream
Routing_UA_N_Winter <- Stone_N_Winter # self UA + from upper stream
Routing_UA_P_Summer <- Stone_P_Summer # self UA + from upper stream
Routing_UA_P_Winter <- Stone_P_Winter # self UA + from upper stream

Routing_EUA_N <- N_EUA # ER except UA
Routing_EUA_P <- P_EUA # ER except UA

for (Level in 1:7) # loop from the smallest river to large ones
{
  Ret_LN_N_Summer <- Retention_UA_N %>%
    select(ID, Ret_Fraction_Summer) %>%
    left_join(select(Routing_UA_N_Summer, -(2:4)), by = "ID")
  Ret_LN_N_Summer <- mutate(Ret_LN_N_Summer, Ret_Fraction_Summer * select(Ret_LN_N_Summer, (3:10)))

  Ret_LN_N_Winter <- Retention_UA_N %>%
    select(ID, Ret_Fraction_Winter) %>%
    left_join(select(Routing_UA_N_Winter, -(2:4)), by = "ID")
  Ret_LN_N_Winter <- mutate(Ret_LN_N_Winter, Ret_Fraction_Winter * select(Ret_LN_N_Winter, (3:10)))

  Ret_LN_P_Summer <- Retention_UA_P %>%
    select(ID, Ret_Fraction_Summer) %>%
    left_join(select(Routing_UA_P_Summer, -(2:4)), by = "ID")
  Ret_LN_P_Summer <- mutate(Ret_LN_P_Summer, Ret_Fraction_Summer * select(Ret_LN_P_Summer, (3:10)))

  Ret_LN_P_Winter <- Retention_UA_P %>%
    select(ID, Ret_Fraction_Winter) %>%
    left_join(select(Routing_UA_P_Winter, -(2:4)), by = "ID")
  Ret_LN_P_Winter <- mutate(Ret_LN_P_Winter, Ret_Fraction_Winter * select(Ret_LN_P_Winter, (3:10)))

  Ret_EUA_N <- mutate(Routing_EUA_N, 0.2 * select(Routing_EUA_N, -(1:3)))
  Ret_EUA_P <- mutate(Routing_EUA_P, 0.2 * select(Routing_EUA_P, -(1:3)))

  Upper <- filter(Routing, !ID %in% TO_1, !ID %in% TO_2, !ID %in% TO_3)
  for (i in 1:nrow(Upper))
  {
    Routing_UA_N_Summer[Upper[i,2], 5:12] <- Routing_UA_N_Summer[Upper[i,2], 5:12] + (Routing_UA_N_Summer[Upper[i,1], 5:12] - Ret_LN_N_Summer[Upper[i,1], 3:10]) * Upper[i,3]
    Routing_UA_N_Winter[Upper[i,2], 5:12] <- Routing_UA_N_Winter[Upper[i,2], 5:12] + (Routing_UA_N_Winter[Upper[i,1], 5:12] - Ret_LN_N_Winter[Upper[i,1], 3:10]) * Upper[i,3]
    Routing_UA_P_Summer[Upper[i,2], 5:12] <- Routing_UA_P_Summer[Upper[i,2], 5:12] + (Routing_UA_P_Summer[Upper[i,1], 5:12] - Ret_LN_P_Summer[Upper[i,1], 3:10]) * Upper[i,3]
    Routing_UA_P_Winter[Upper[i,2], 5:12] <- Routing_UA_P_Winter[Upper[i,2], 5:12] + (Routing_UA_P_Winter[Upper[i,1], 5:12] - Ret_LN_P_Winter[Upper[i,1], 3:10]) * Upper[i,3]

    Routing_EUA_N[Upper[i,2], 4:13] <- Routing_EUA_N[Upper[i,2], 4:13] + (Routing_EUA_N[Upper[i,1], 4:13] - Ret_EUA_N[Upper[i,1], 4:13]) * Upper[i,3]
    Routing_EUA_P[Upper[i,2], 4:13] <- Routing_EUA_P[Upper[i,2], 4:13] + (Routing_EUA_P[Upper[i,1], 4:13] - Ret_EUA_P[Upper[i,1], 4:13]) * Upper[i,3]

    if (!is.na(Upper[i,4]))
    {
      Routing_UA_N_Summer[Upper[i,4], 5:12] <- Routing_UA_N_Summer[Upper[i,4], 5:12] + (Routing_UA_N_Summer[Upper[i,1], 5:12] - Ret_LN_N_Summer[Upper[i,1], 3:10]) * Upper[i,5]
      Routing_UA_N_Winter[Upper[i,4], 5:12] <- Routing_UA_N_Winter[Upper[i,4], 5:12] + (Routing_UA_N_Winter[Upper[i,1], 5:12] - Ret_LN_N_Winter[Upper[i,1], 3:10]) * Upper[i,5]
      Routing_UA_P_Summer[Upper[i,4], 5:12] <- Routing_UA_P_Summer[Upper[i,4], 5:12] + (Routing_UA_P_Summer[Upper[i,1], 5:12] - Ret_LN_P_Summer[Upper[i,1], 3:10]) * Upper[i,5]
      Routing_UA_P_Winter[Upper[i,4], 5:12] <- Routing_UA_P_Winter[Upper[i,4], 5:12] + (Routing_UA_P_Winter[Upper[i,1], 5:12] - Ret_LN_P_Winter[Upper[i,1], 3:10]) * Upper[i,5]

      Routing_EUA_N[Upper[i,4], 4:13] <- Routing_EUA_N[Upper[i,4], 4:13] + (Routing_EUA_N[Upper[i,1], 4:13] - Ret_EUA_N[Upper[i,1], 4:13]) * Upper[i,5]
      Routing_EUA_P[Upper[i,4], 4:13] <- Routing_EUA_P[Upper[i,4], 4:13] + (Routing_EUA_P[Upper[i,1], 4:13] - Ret_EUA_P[Upper[i,1], 4:13]) * Upper[i,5]

      if (!is.na(Upper[i,6]))
      {
        Routing_UA_N_Summer[Upper[i,6], 5:12] <- Routing_UA_N_Summer[Upper[i,6], 5:12] + (Routing_UA_N_Summer[Upper[i,1], 5:12] - Ret_LN_N_Summer[Upper[i,1], 3:10]) * Upper[i,7]
        Routing_UA_N_Winter[Upper[i,6], 5:12] <- Routing_UA_N_Winter[Upper[i,6], 5:12] + (Routing_UA_N_Winter[Upper[i,1], 5:12] - Ret_LN_N_Winter[Upper[i,1], 3:10]) * Upper[i,7]
        Routing_UA_P_Summer[Upper[i,6], 5:12] <- Routing_UA_P_Summer[Upper[i,6], 5:12] + (Routing_UA_P_Summer[Upper[i,1], 5:12] - Ret_LN_P_Summer[Upper[i,1], 3:10]) * Upper[i,7]
        Routing_UA_P_Winter[Upper[i,6], 5:12] <- Routing_UA_P_Winter[Upper[i,6], 5:12] + (Routing_UA_P_Winter[Upper[i,1], 5:12] - Ret_LN_P_Winter[Upper[i,1], 3:10]) * Upper[i,7]

        Routing_EUA_N[Upper[i,6], 4:13] <- Routing_EUA_N[Upper[i,6], 4:13] + (Routing_EUA_N[Upper[i,1], 4:13] - Ret_EUA_N[Upper[i,1], 4:13]) * Upper[i,7]
        Routing_EUA_P[Upper[i,6], 4:13] <- Routing_EUA_P[Upper[i,6], 4:13] + (Routing_EUA_P[Upper[i,1], 4:13] - Ret_EUA_P[Upper[i,1], 4:13]) * Upper[i,7]
      }
    }
  }
  Routing <- setdiff(Routing, Upper)
}
Receive_LN_N_Summer <- Routing_UA_N_Summer %>%
  mutate(select(Routing_UA_N_Summer, -(1:4)) - select(Stone_N_Summer, -(1:4)))
Receive_LN_N_Winter <- Routing_UA_N_Winter %>%
  mutate(select(Routing_UA_N_Winter, -(1:4)) - select(Stone_N_Winter, -(1:4)))
Receive_LN_P_Summer <- Routing_UA_P_Summer %>%
  mutate(select(Routing_UA_P_Summer, -(1:4)) - select(Stone_P_Summer, -(1:4)))
Receive_LN_P_Winter <- Routing_UA_P_Winter %>%
  mutate(select(Routing_UA_P_Winter, -(1:4)) - select(Stone_P_Winter, -(1:4)))

Receive_EUA_N <- Routing_EUA_N %>%
  mutate(select(Routing_EUA_N, -(1:3)) - select(N_EUA, -(1:3)))
Receive_EUA_P <- Routing_EUA_P %>%
  mutate(select(Routing_EUA_P, -(1:3)) - select(P_EUA, -(1:3)))

Ret_LN_N_Summer <- Routing_UA_N_Summer %>%
  mutate(select(Routing_UA_N_Summer, -(1:4)) * Retention_UA_N$Ret_Fraction_Summer)
Ret_LN_N_Winter <- Routing_UA_N_Winter %>%
  mutate(select(Routing_UA_N_Winter, -(1:4)) * Retention_UA_N$Ret_Fraction_Winter)
Ret_LN_P_Summer <- Routing_UA_P_Summer %>%
  mutate(select(Routing_UA_P_Summer, -(1:4)) * Retention_UA_P$Ret_Fraction_Summer)
Ret_LN_P_Winter <- Routing_UA_P_Winter %>%
  mutate(select(Routing_UA_P_Winter, -(1:4)) * Retention_UA_P$Ret_Fraction_Winter)

Ret_EUA_N <- Routing_EUA_N %>%
  mutate(select(Routing_EUA_N, -(1:3)) * 0.2)
Ret_EUA_P <- Routing_EUA_P %>%
  mutate(select(Routing_EUA_P, -(1:3)) * 0.2)

Receive_LN_N_Yearly <- Receive_N_Summer %>%
  mutate(select(Receive_N_Summer, -(1:4)) + select(Receive_N_Winter, -(1:4)))
write.csv(Receive_LN_N_Yearly, file = "../Results/Receive_LN_N_Yearly.csv")

Receive_LN_P_Yearly <- Receive_P_Summer %>%
  mutate(select(Receive_P_Summer, -(1:4)) + select(Receive_P_Winter, -(1:4)))
write.csv(Receive_LN_P_Yearly, file = "../Results/Receive_LN_P_Yearly.csv")

Ret_LN_N_Yearly <- Ret_LN_N_Summer %>%
  mutate(select(Ret_LN_N_Summer, -(1:4)) + select(Ret_LN_N_Winter, -(1:4)))
# write.csv(Ret_LN_N_Yearly, file = "../Results/Ret_LN_N_Yearly.csv")

Ret_LN_P_Yearly <- Ret_LN_P_Summer %>%
  mutate(select(Ret_LN_P_Summer, -(1:4)) + select(Ret_LN_P_Winter, -(1:4)))
# write.csv(Ret_LN_P_Yearly, file = "../Results/Ret_LN_P_Yearly.csv")

Routing_UA_LN_N_Yearly <- Routing_UA_N_Summer %>%
  mutate(select(Routing_UA_N_Summer, -(1:4)) + select(Routing_UA_N_Winter, -(1:4)))
# write.csv(Routing_UA_LN_N_Yearly, file = "../Results/Routing_UA_LN_N_Yearly.csv")

Routing_UA_LN_P_Yearly <- Routing_UA_P_Summer %>%
  mutate(select(Routing_UA_P_Summer, -(1:4)) + select(Routing_UA_P_Winter, -(1:4)))
# write.csv(Routing_UA_LN_P_Yearly, file = "../Results/Routing_UA_LN_P_Yearly.csv")

Ret_N <- Ret_LN_N_Yearly  %>%
  mutate(select(Ret_LN_N_Yearly, -(1:4)) + select(Ret_EUA_N, -(1:3)))
Ret_P <- Ret_LN_P_Yearly  %>%
  mutate(select(Ret_LN_P_Yearly, -(1:4)) + select(Ret_EUA_P, -(1:3)))

write.csv(Ret_N, file = "../Results/Ret_N.csv")
write.csv(Ret_P, file = "../Results/Ret_P.csv")
