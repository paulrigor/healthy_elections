################################################################3
###############333 Philadelphia Polling Place CleanR ###########
######################################################################
library(foreign)
library(stringi)
library(stringr)
setwd("F:/MEDSL/healthy_elections/PA")
list.files()
pa2016polls <- read.csv("2016_Primary_Polling_Places_sheet.csv")
View(pa2016polls)
pa2016polls$full_addr <- paste0(str_to_upper(pa2016polls$Address), sep=" ", "PHILADELPHIA, PA")

pa2020polls <- read_xlsx("Polling_Places_by_Zone2020.xlsx")
pa2020polls$full_addr <- paste0(str_to_upper(pa2020polls$ADDRESS), sep=" ", "PHILADELPHIA, PA")
length(unique(pa2020polls$full_addr))
length(unique(pa2016polls$full_addr))


pa2016polls_col <- pa2016polls[!duplicated(pa2016polls$full_addr), ]
nrow(pa2020polls)
View(pa2020polls)
write.csv(pa2020polls, "phillie2020poll_addrs.csv",row.names = F)
write.csv(pa2016polls, "phillie2016poll_addrs.csv",row.names = F)
write.csv(pa2016polls_col, "phillie2016poll_addrs_unique.csv",row.names = F)

