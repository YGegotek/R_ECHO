# Created on: 3/1/202212:19 PM
Stone <- lapply(Sys.glob(CSV_Stone), read.csv) %>%
  bind_rows() %>%
  separate(Datum, into = c("Year", "Month", "Day"), sep = "-") %>%
  mutate(Q = OppAfv + Afv, N = (Oppnhafv +  Nhafv + Oppniafv + Niafv + Oppnoafv + Noafv), P = (Oppppafv + PPafv + Opppoafv + Poafv))
Stone$Month <- as.numeric(Stone$Month)
write.csv(Stone, file = "../Stone/Stone.csv", row.names = FALSE)
