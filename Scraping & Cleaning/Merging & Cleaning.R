library(dplyr)
library(stringr)

data<-read.csv("Data/data_scraped_976_obs.csv", stringsAsFactors = F)
data_UNDP<-readxl::read_excel("Data/ObjectData18.xlsx")

data_UNDP<-filter(data_UNDP, objectType=="Hotel")
data_UNDP$link<-paste("https://www.tripadvisor.com/", data_UNDP$link, sep="")

###############################################################################
####################### Part 1 ################################################
###############################################################################

data[,5:11]<-apply(data[,5:11], 2, factor, labels = c("0", "1")) #turning the variables into dummies
data$Review_Count<-as.numeric(str_remove_all(data$Review_Count, "[review]+s{0,}"))
data$Price_AMD<-as.numeric(str_remove_all(data$Price, "[AMD+\\s]|[:punct:]"))
data$Price<-NULL
#data[is.na(data$Price_AMD)=="TRUE", "Price_AMD"]<-round(mean(data$Price_AMD, na.rm = T), 0)
data$Price_USD<-round(data$Price_AMD/486, 0) #turning the price into USD
# Note: Exchange rate as of 3.31.2019


merged_data<-merge(data, data_UNDP, by=c("name", "link"))
#write.csv(merged_data, "merged_data.csv", row.names = F)

###############################################################################
####################### Part 2 ################################################
###############################################################################

head(merged_data$scoreDistribution)
no_reviews<-str_extract_all(merged_data$scoreDistribution, "\\[]", simplify = T)
excellent<-str_extract_all(merged_data$scoreDistribution, "\\[+[0-9]{1,}", simplify = T)
good<-str_extract_all(merged_data$scoreDistribution, "\\[+[0-9]{1,}+\\,+\\s+[0-9]{1,}", simplify = T)
average<-str_extract_all(merged_data$scoreDistribution, "\\[+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}", simplify = T)
poor<-str_extract_all(merged_data$scoreDistribution, "\\[+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}", simplify = T)
terrible<-str_extract_all(merged_data$scoreDistribution, "\\[+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}+\\,+\\s+[0-9]{1,}", simplify = T)