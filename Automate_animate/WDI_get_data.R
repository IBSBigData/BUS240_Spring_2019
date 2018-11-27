# WDI_get_data
##################3
# demonstrate reproducible data intake from WDI
# uses package 'WDI' which must be installed
library(WDI)
library(ggplot2)
library(dplyr)


le <- "SP.DYN.LE00.IN"
gdppc <- "NY.GDP.PCAP.KD"

ind <- c(le, gdppc)

newdata <- WDI(country="all", indicator = ind, start = 2000, 
              end = 2017, extra = TRUE)
glimpse(newdata)

# remove country groupings
newdata$longitude[newdata$longitude==""] <- NA
countries <- filter(newdata, !is.na(longitude))  # drop aggregate groups

# graph most recent data
data2016 <- filter(countries, year==2016)
p <- ggplot(data2016, aes(x=log10(NY.GDP.PCAP.KD), y=SP.DYN.LE00.IN)) + 
     geom_point() 
p + labs(title ="Life Expectancy v Log(GDP per capita), 2016")
