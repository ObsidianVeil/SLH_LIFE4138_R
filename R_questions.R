#load libraries
library(tidyverse)

#Question 1
RJCharacters <- data.frame(
                Name = c("Romeo", "Juliet", "Tybalt", "Lady Capulet", "Mercutio"), #name of characters
                Age = c(16, 13, 17, 37, 15) #age of characters in same order as name
                )

#Question 2
my_vector <- seq(from = 1, to = 1000, by = 1)
my_matrix <- matrix(1:100, nrow = 10, ncol = 10)
my_dataframe <- data.frame(name = rep(c("a", "b"), each = 10), value = 21:40)
my_list <- list(my_vector, my_matrix, my_dataframe)

vector4 <- my_vector[4] #accessing the fourth element of the vector
col4row7 <- my_matrix[7, 4] #accessing the 4th column, row 7 of the matrix
nameframe <- my_dataframe$name[10] #accessing the 10th value of the name column
listaccess <- my_list[[1]][[5]] #accessing the 5th value of the first element in the list

#Question 3
