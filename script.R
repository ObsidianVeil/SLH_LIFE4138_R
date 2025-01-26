#load packages
library(dplyr)
library(ggplot2)

#set working directory
setwd(getSrcDirectory(function(){})[1])

#read in pumpkin file
pumpkins <- read.csv("pumpkins_3.csv")

#identify the heaviest pumpkin
arranged_pumpkins <- arrange(pumpkins, desc(weight_lbs)) #sorts the pumpkins by weight

heaviest_pumpkin <- arranged_pumpkins[1,] #pick heaviest pumpkin

cat("The heaviest pumpkin was", heaviest_pumpkin$id, "in the year", substr(heaviest_pumpkin$id, 1, 4), "which was a", heaviest_pumpkin$variety, ".\n", 
    "It was from", heaviest_pumpkin$city, "in place", heaviest_pumpkin$place, "and weighed", heaviest_pumpkin$weight_lbs, "lb")

#convert lb to kg
pumpkins$weight_kg <- pumpkins$weight_lbs/2.2046

#add weight class
pumpkins$weight_class <- ifelse(ntile(pumpkins$weight_kg, 3) == 1, "Light",
                          ifelse(ntile(pumpkins$weight_kg, 3) == 2, "Medium",
                            ifelse(ntile(pumpkins$weight_kg, 3) == 3, "Heavy", "ERROR")))

#plot the relationship between estimated weight and actual weight
est_vs_actual_weight <- ggplot(pumpkins, aes(x = est_weight/2.2046, y = weight_kg, colour = weight_class)) +
  geom_point() +
  theme_minimal() +
  labs(x = "Estimated weight (kg)", 
       y = "Actual weight (kg)", 
       title = "Relationship between estimated weight and actual weight of pumpkins") +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(fill = FALSE)

#save graph
ggsave(est_vs_actual_weight, filename = "estimated_vs_actual_weight.jpeg", device = "jpeg")

#filter by country == UK, Australia or Canada
pumpkins_filtered <- pumpkins[pumpkins$country %in% c("UK", "Australia", "Canada"), ] 

#export filtered pumpkins
write.csv(pumpkins_filtered, "pumpkins_filtered.csv")

#create means for each country and arrange in descending order

means <- arrange(aggregate(weight_kg ~ country, data = pumpkins_filtered, FUN = mean), desc(weight_kg))

cat("The country with the highest mean was", means$country[1], "with a mean of", substr(means$weight_kg[1], 1, 6), "kg")

#each variety of pumpkin in each country

means <- arrange(aggregate(weight_kg ~ country + variety, data = pumpkins_filtered, FUN = mean), weight_kg)

cat("The lowest mean weight was the", means$variety[1], "in", means$country[1])

#create a boxplot
jpg

pumpkin_weight_distribution_per_country <- ggplot(pumpkins_filtered, aes(x = country, y = weight_kg, fill = country)) +
  geom_boxplot() +
  theme_minimal() +
  labs(x = "Country", 
       y = "Pumpkin weights", 
       title = "Pumpkin weight distributions per country") +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(fill = FALSE) #remove legend: unnecessary

#save graph
ggsave(pumpkin_weight_distribution_per_country, filename = "pumpkin_weight_per_country.jpeg", device = "jpeg")

#add pumpkin variety
pumpkin_weight_variety_country_plot <- ggplot(pumpkins_filtered, aes(x = country, y = weight_kg, fill = country)) +
  geom_boxplot() +
  theme_minimal() +
  labs(x = "Country", 
       y = "Pumpkin weights", 
       title = "Pumpkin weight distributions per country") +
  theme(plot.title = element_text(hjust = 0.5)) + #centre title
  guides(fill = FALSE) + #remove legend: unnecessary
  facet_wrap(~ variety)

ggsave(pumpkin_weight_variety_country_plot, filename = "pumpkin_weight_per_country_per_Variety.jpeg", device = "jpeg")
