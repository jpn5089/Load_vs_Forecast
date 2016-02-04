library(ggplot2)
library(tidyr)
library(scales)
library(pander)
library(dplyr)
library(lubridate)

x <- read.csv("T:/scheduling/power/load forecasting/zzz monthly load report/CM/InRetail_vs_load.csv") %>%
  select(zone = Zone, date = FlowDate, fcast = forecast, actual_load, hour) %>%
  #  mutate(hour = as.numeric(hour)) %>%
  mutate(date = ymd_hms(date),
         mw_error = fcast - actual_load,
         zero_line = 0,
         error_pct = ((fcast - actual_load)/actual_load)*100,
         pct_celing = 5,
         pct_floor = -5) %>%
  gather(variable, value, -date, -zone, -hour) %>%
  mutate(group2 = ifelse(variable %in% c("mw_error","zero_line"), "mw_error",
                         ifelse(variable %in% c("error_pct","pct_floor","pct_celing"),'pct_error',"data")))


data <- x %>%
  filter(date >= ymd("2016-01-25")) %>%
#  filter(month(date) == 10) %>%
# filter(zone %in% c("PECO", "FE_Penelec", "FE_PNPW", "APS_WP"))
#  filter(zone %in% c("AEP_OH", "Dayton", "Duke_OH", "DQE", "MetEd"))
# filter(zone == "FE_OH")
  filter(zone == "PPL")
  
#  filter(hour %in% c(8:23))

mape <- data %>%
  filter(variable == "error_pct") %>%
  group_by(zone) %>%
  summarize(mape = mean(abs(value)))

pandoc.table(mape)



ggplot(data, aes(x = date, y = value, col = variable, group = variable)) +
  geom_line() +
  scale_color_manual(values = c("black", "red", "blue", "black", "purple","dark green", "green"))+
  facet_grid(group2 ~ zone, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



