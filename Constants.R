# Title: TODO
# Objective: TODO
# Created by: Yanjiao
# Created on: 10/19/202111:28 AM
#-----------------------------
# Sources
#-----------------------------
Nutrients <- c("N", "P")
Sources_ER <- c("IN", "LO", "OR", "DW")
Sources_Routing <- c("IN", "LO", "OR", "DW", "BL", "RWZI", "UA")
Sources_Routing_Sea <- c("IN", "LO", "OR", "DW", "BL", "RWZI", "UA", "BL3")
#-----------------------------
# Period of interest
#-----------------------------
FIRST_YEAR_OI <- 2010
LAST_YEAR_OI  <- 2019
YoI <- FIRST_YEAR_OI:LAST_YEAR_OI
#-----------------------------
# Number of catchment
#-----------------------------
NoC <- 538
#-----------------------------
# City green
#-----------------------------
# Duck_N <- 0.36
# Dog_N <- 0.40
# Leaf_N <- 2.75
#
# Duck_P <- 0.25
# Dog_P <- 0.25
# Leaf_P <- 0.24
# #-----------------------------
# Retention rate
#-----------------------------

# STAP 3: Uit- en afspoeling: bepaal retentie
#    Gebiedstype        Grondsoort      N                         P
#    -Polder            a)veen          Abs. ret. obv %OpenWater  Rel. ret. 50%
#                       b)klei          Abs. ret. obv %OpenWater  Rel. ret. 50%
#                       c)zand          Rel. ret. 50%             Rel. ret. 50%
#    -Overgangsgebieden	-               Rel. ret. 50%             Rel. ret. 50%
#    -Vrij afwaterend   -               Rel. ret. obv Qspec       Rel. ret. obv Qspec

# Coefficienten voor bepaling retentiefractie vrij afwaterende gebieden (retentie_fractie = a*SR^b , waarbij SR=specific runoff=Q_gebiedseigen / OpenWater_oppervlak)
N_a_Winter <-  0.1153
N_b_Winter <- -0.2025
N_a_Summer <-  0.0462
N_b_Summer <- -0.5277
P_a_Winter <-  0.0017
P_b_Winter <- -1.1449
P_a_Summer <-  0.0065
P_b_Summer <- -0.8884

# Stikstofretentie voor klei- en veenpolders
N_Ret_Klei_Winter_gNm2 <-  5.0
N_Ret_Klei_Summer_gNm2 <- 11.8
N_Ret_Veen_Winter_gNm2 <-  1.0
N_Ret_Veen_Summer_gNm2 <-  4.4

# gemiddelde stroomsnelheid van rijkswateren [m/s]  (zo varieert de gemiddelde stroomsnelheid van de Rijn tussen de 0.5 en 1.5 m/s)
V_stream <- 0.5
K_N <- 0.05
K_P <- 0.09

# Foreign inlet location
Inlet_location_Q <- c("EIJSDGS", "LOBH", "SCHAARVODDL")
Inlet_location_NP <- c("EIJSDPTN", "LOBPTN", "SCHAARVODDL")