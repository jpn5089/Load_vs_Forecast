library(ggplot2)
library(reshape2)
library(dplyr)
library(lubridate)
library(tidyr)



df_fcst <- read.csv("C:/Users/jnicola/Desktop/ZHF_2015.csv", header = TRUE, stringsAsFactors = FALSE) %>% 
  gather(variable, value, -Zone, -FlowDate) %>%
  mutate(variable = as.numeric(gsub("HE","",variable))) %>%
  mutate(FlowDate = mdy_hms(paste(FlowDate,variable,'0','0', sep = " "))) %>%
  select(Zone, FlowDate, forecast = value)

#df_fcst$DoW <- weekdays.POSIXt(df_fcst$FlowDate) 

df_load <- read.csv("C:/Users/jnicola/Desktop/Load_with_Losses.csv", header = TRUE, stringsAsFactors = FALSE) %>% 
  gather(variable, value, -Zone, -FlowDate) %>%
  mutate(variable = as.numeric(gsub("HE","",variable))) %>%
  mutate(FlowDate = mdy_hms(paste(FlowDate,variable,'0','0', sep = " "))) %>%
  select(Zone, FlowDate, actual_load = value)

#df_load$DoW <- weekdays.POSIXt(df_load$FlowDate)

both <- left_join(df_fcst,df_load) %>%
#  gather(type,value,-FlowDate,-Zone) %>%
#  filter(Zone == "DQE") %>%
  mutate(day = floor_date(FlowDate,unit = "day"),
         hour = hour(FlowDate), month = month(FlowDate)) 
#  filter(month == 12)
  
write.csv(both, file = "T:/Scheduling/Power/load forecasting/zzz monthly load report/CM/InRetail_vs_Load.csv", row.names = FALSE)  




