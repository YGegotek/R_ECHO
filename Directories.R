# Title: Directories.R
# Objective: organise all the paths to files
# Created by: Yanjiao
# Created on: 10/19/202111:28 AM
####################################################
# STONE 538 catchments shape file
Shp_Catchment_Stone <- "../Shape/STONE/538_stroomgebieden.shp"
CSV_Catchment <- "../Shape/STONE/Catchment.csv"
# couple Stone ID with the catchments
TXT_Catchment_Plot <- "../Shape/STONE/Catchment_Plot.txt"
####################################################
# Routing scheme
# Routing among catchments
TXT_Routing_STONE <- "../Shape/STONE/Routing_STONE_per_id.txt"
# Routing to the sea, for catchments that directly discharge to the north sea
TXT_To_Sea_Direct <- "../Routing/stroomgebieden_die_direct_lozen_op_Noordzee.txt"
# Routing to the sea, for catchments that routing via rivers to the north sea
CSV_To_Sea_InDirect <- "../Routing/afstand_stroomgebieden_naar_Noordzee.csv"
####################################################
# STONE output, for calculating overland flow and ground water flow from nature and agriculture area
# Plot, Datum, OppAfv, Afv, Oppnhafv, Nhafv, Oppniafv, Niafv, Oppnoafv, Noafv, Oppppafv, PPafv, Opppoafv, Poafv
CSV_Stone_All <- "../Stone/Stone_*.csv"
CSV_Stone <- "../Stone/Stone.csv"
CSV_Stone_2016_2017 <- "../Stone/Stone_2016_2017.csv"
CSV_Stone_2019 <- "../LWKM/LWKM_2019.csv"
CSV_Stone_2027B <- "../LWKM/LWKM_2027_Climate_B.csv"
CSV_Stone_2027C <- "../LWKM/LWKM_2027_Climate_C.csv"

# Kwel, ground water seepage, output of STONE
CSV_Stone_Kwel_Flux <- "../Stone/PlotkenSTONE_1981_2010.csv"
CSV_Stone_Kwel_Concentration <- "../Stone/botnut.csv"
####################################################
# Soil and land type information
TXT_Soil <- "../Retention/gebiedskenmerken.txt"
####################################################
# Emission registration
# couple catchment number with emission registration shape file gaf90
CSV_ER <- "../Shape/ER/Catchment_ER.csv"
# couple EMK code with emission source groups
CSV_EMK <- "../Emission_registration/ER/EMK_Group.csv"

# emission data
TXT_ER_All <- "../Emission_registration/txt/ER_*.csv"
ACCDB_ER_All <- "../Emission_registration/ACCDB/ER*.accdb"

CSV_ER_N <- "../Emission_registration/ER/ER_N.csv"
CSV_ER_P <- "../Emission_registration/ER/ER_P.csv"
CSV_IN_N_Yearly <- "../Emission_registration/ER/IN_N_Yearly.csv"
CSV_IN_P_Yearly <- "../Emission_registration/ER/IN_P_Yearly.csv"
# RWZI
CSV_RWZI_Catchment <- "../Emission_registration/ER/RWZI_AI_ID.csv"
#-------------------------------------------------------------------------------------
# 9. Incoming (foreign rivers 3) and Discharge (4)
# big rivers
CSV_In_Out_Q <-  "../Inlet/In_Out_Q.csv"
CSV_In_Out_NP <-  "../Inlet/In_Out_NP.csv"
# small streams
CSV_Catchment_buitenland <-  "../Inlet/Catchment_Inlet_Small.csv"
CSV_IN_buitenland <- "../Inlet/IN_buitenland.csv"

CSV_IN_buitenland_Q_mean <- "../Inlet/IN_buitenland_Q_mean.csv"
CSV_IN_buitenland_N_mean <- "../Inlet/IN_buitenland_N_mean.csv"
CSV_IN_buitenland_N_mean2 <- "../Inlet/IN_buitenland_N_mean2.csv"
CSV_IN_buitenland_P_mean <- "../Inlet/IN_buitenland_P_mean.csv"
CSV_IN_buitenland_P_mean2 <- "../Inlet/IN_buitenland_P_mean2.csv"
#
# # Observations
# CSV_Observations_Q <- "../Observation/Observationsdischarge.csv"
# CSV_Observations_N <- "../Observation/ObservationsN_total.csv"
# CSV_Observations_P <- "../Observation/ObservationsP_total.csv"